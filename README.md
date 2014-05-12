=======
symploading
======
Some tools and a process that helped us import DSpace institutional repository data into Symplectic Elements, and merge most duplicate titles from Research Master, an academic output tracking application.

There is going to be plenty to customise in these files, but hopefully it can save some pain.

_(It's named with a gerund instead of "symploader" (or "symploadr"!) because I want it to sound like a process more than a tool.)_

Our implementation
---------------------
This process makes use of the limited set of tools that were unambiguously available to us at the time we commenced the export. The main thing was they worked for us. We used XSLT, SQL, and some manual cleaning and performed some manual matching work on desktop with CSV files.

After some very important configuration, the first step is generating a bunch of SQL statements that will populate an export table from item metadata in DSpace. After running that, there is more SQL to execute to clean and tweak, and create initial versions of the other export tables required. Because our DSpace is not linked to contributors' institutional IDs, we make a rough match of author names to an export of staff names. Then we very roughly manually verify those matches.

_My first thought for a solution was (of course!) to write Perl scripts. However, difficulties getting through our NTLM proxy to install modules (XML, CSV etc.) with PPM made that impractical._

_There's a solution that might have worked more cleanly that I only considered after going too far down the track documented here. What if I had got an XML dump of DSpace metadata, then created and cleaned the CSV from that using XSLT? Outputting properly escaped CSV from XSLT might have been a challenge, however._

Assumptions
------------
This is a probably incomplete list of underlying assumptions in the process and code:

* **The `dc.type` element in DSpace holds its document type.**
* **There is only one instance of `dc.type` for each DSpace item.** That is a good situation if you think about it. This query will tell you if you need to clean up some types _(and optionally display their URL, uncomment and substitute the right field id, or else [install DHandle](http://gist.github.com/LincolnUniLTL/10611972) and call `DHandle(item_id)`)_:
```SQL
SELECT item_id, count(item_id) --, (SELECT ' ' || text_value FROM metadatavalue WHERE metadata_field_id=25 AND item_id=V.item_id) AS handle
	FROM metadatafieldregistry R, metadatavalue V 
	WHERE R.metadata_field_id = V.metadata_field_id 
	AND element like 'type'
	GROUP BY V.item_id
	HAVING count(item_id) > 1
	ORDER BY item_id
	;
```
* **Authors are excluded from _metadata.csv_ and listed in _persons.csv_ instead, but editors are not.** It would be more typical to include the editors field data in the _persons.csv_ file.
* **Crosswalks files have been completed.** These determine the mapping of fields for each publication type and you need to complete them eventually anyway, assuming you want to keep Elements and DSpace in sync. Also, before they can be completed, you will need to have completed your data modelling (fields for each publication type) within Elements.
* **Crosswalk mapping files contain only simple field-based mappings.** We didn't make use of the interesting syntax interpreted in the `@format-elements` attribute of the crosswalk files. You can however list a sequence of elements fields separated by comma (e.g. "journal,parent-title,series"). We will simply strip everything but the first of those.
* **DSpace publication types map to at most one Elements publication type.** Thankfully this was true for us because we can't write scripts that split a group without deterministic rules.

Supports subtypes


How to run it
--------------
If you accept our assumptions and think this can work for you, even with a little coercion, here's what to do.

**Requirements**

An **XSLT** processor. Xalan, Saxon, MSXML, xsltproc, whatever.

A client for **PostgresSQL**. I pasted and loaded commands into psql on the server. Some of the commands listed here are meta-commands, which I am not sure work in outher clients.

An **(S)FTP** client for transferring load files and SQL scripts.

**CSV editing** software. Preferably not Microsoft Excel when editing CSV. If staff working on manual data cleansing prefer Excel, export it for them in that format and then re-import. Watch for corruptions like stripping leading zeros and futzing date formats. If necessary, explicitly set each cell to be of _Text_ type in Excel. LibreOffice is pretty safe but maybe not as nice for editing CSV files.

**Understand load file specifications and requirements**

Basically we want to end up with three CSV files to load into Elements:

* **_metadata.csv_**. A few mandatory columns and then columns with headers that match your underlying field names. These will vary in each implementation, which is sourcing them from the crosswalk files works so well.
* **_persons.csv_**. Item IDs matched to person field values in a choice of parseable formats. Used here only for author names, not editors.
* **_links.csv_**. Item IDs matched again to persons, but this time only to those with institutional IDs and therefore user accounts. We only list the institutional ID here, no names.

> This explanation is too simplistic and it is best to consult the Symplectic specification document ("Symplectic Elements - Standard Elements Importer"). Moreover, the specifications may change.

**Finish your mappings**

As mentioned, mappings between DSpace and Elements fields direct the composition of the load. You probably already need to edit the mappings to make your synchronisation with _Repository Tools_ work. Just be grateful you don't have to maintain two sources.

The crosswalk files are copyrighted to Symplectic, so at best I can highlight the only part you need to worry about for this process. It's all within the `<crosswalks:mappings/>` element:

```XML
    <crosswalks:mappings for="dspace">
      <crosswalks:mapping dspace="dc.title" elements="title" />
      <crosswalks:mapping dspace="dc.relation.isPartOf" elements="journal,parent-title,series" /> <!-- as mentioned in Assumptions, only "journal" will be taken from this -->
      <crosswalks:mapping dspace="dc.contributor.author" elements="authors" /> <!-- as mentioned in Assumptions, this is treated as an exception because the data goes into the _persons.csv_ file -->
	  …
	</crosswalks:mappings>
```

**Create your load manifest**

If the crosswalk mapping files determine how the load is made up, the manifest directs it all on a publication type basis. This is a custom XML file created for this process. The XSLT transformation uses it to:

* determine which crosswalk file to consult for field mappings for each publication type
* match and assign an Elements publication type for all DSpace types
* optionally populate a "subtype" field in Elements based on other information in the record, or in simpler cases, just based on its DSpace type

An [example manifest file](xml/loads-manifest.xml) is included in this repository and can be used as a guide or basis.

Beneath the `<manifest/>` element is a series of **`<mapping/>` elements** you need to customise. Ensure there is one for each of the publication types you have set up in Elements.

* the `@location` attribute tells the transformation the location of relevant crosswalk file to load for field mapppings
* `@underlying` is the Elements publication type "underlying" or machine name
* `@subtype` is only required if you want to populate a subtype field for that publication type, and it contains the name of the target subtype field. [ FIXME: can it be placed on children?? ]

The `<mapping/>` element has one or more child **`<dspace/>` elements**, which you need to populate.

* The `@type` attribute tells the transformer the name of a DSpace publication type that can be loaded as the Elements publication type specified in the parent `<mapping/>` element's `@underlying` attribute. In the simplest cases, that's all you need.
* Use `@subtype-value` when you want items of that DSpace type to have a subtype field value based on the DSpace type alone. Populate `@subtype-value` with that value.
* Use `@subtype-source` when you want to determine your subtype value based on the contents of another DSpace field/element. Specify with this attribute, and use the fully qualified form of the element. _This propagates to child elements, but can also be specified against single child `<subtype/>` elements only if they need to differ. See below._

If required (i.e. you need to base subtypes on another DSpace field), you can create child **`<subtype/>` elements** under the `<dspace/>` elements.

* Create a `<subtype/>` element for every other field value that determines a subtype value.
* If the subtype is sourced from a field other than what you specified in the parent `<mapping/>` element, you can put another `@subtype-source` attribute here and that will override the parent's.
* The `@match` attribute is the value of the field specified in `@subtype-source` that you want to match against.
* Use a `@value` attribute to indicate the value you'd like to populate the subtype field with when its DSpace value for `@subtype-source` matches `@match`.

That's about it.

**Create and populate an initial metadata holding table**

**Files:** [_XML directory_](xml/) (configure and run); [_sql/metadata-load.REFERENCE.sql_]() (reference and verify)

**Output:** ir_metadata table (new)

When the crosswalk and load manifest files are in place, you need to run an XSLT transformation, which will give you SQL to execute against your DSpace database.

To run it, use your favourite XSLT processor, e.g.:

> `$ [xsl-processor] compile-sql.xsl loads-manifest.xml`

(Verify its output against the [bundled example reference SQL file](sql/metadata-load.REFERENCE.sql) if you wish.)

Save or copy the resulting SQL into a file or buffer and then run or load it in your PostgresSQL client. 

> If you use Visual Studio(TM) to run your XSLT, it seems to put some "interesting" chars at the top of the file which (at least our instance of) PostgresSQL finds offensive and chokes on. Eliminate that part of the file (_vi_ seems to work, or just `\edit` within psql).

For example, loading with the command-line psql client is done with this meta-command:
	
> `=> \i [file.sql]`

As the statements execute, you'll get errors trying to create fields that already exist. Ignore those. You might also get a warning about the first DROP TABLE statement if you haven't run it before. Ignore.

**Manipulate some data in the interim metadata table**

**Files:** _[sql/metadata-clean.sql]()_ (run)

**Output:** ir_metadata table (updated)

These SQL statements can be executed to tweak and clean the ir_metadata table we created and populated [in the previous step](FIXME). They are:

* Switch the keywords field to use semicolons as delimiters, as required by the load specifications. Other multivalue field types use commas, so that's how they've been scripted.
* Optionally, delete any records from DSpace without tiles. We are using that as our criterion for "ghost" items. These seem to get left around in the database when, for example, a workflow is not completed.
* Optionally, depending on your policy, you may want to remove items from ir_metadata before a certain date. We decided on 1990, since this is as far back as our legacy system records go.

> Note that you may want to clean up other kinds of DSpace items, like withdrawn or protected items. I don't know enough of the DSpace database semantics to be able to do this reliably.

**Create and populate IR persons table**

**Files:** _[sql/persons-load.sql]()_ (run)

**Output:** ir_persons table (new)

These are straightforward SQL statements to create and populate the table that holds person names. Specifically, as noted in [assumptions](FIXME), we only used this to store authors, not editors, which were exported in the _metadata.csv_ file.

Note that we drew author names from the `dc.contributor.author` element, whereas you might correctly source them from `dc.creator`.

The last SQL statement, which populates the table, records the authors' database ID order ("order-number" column), which DSpace appears to use to sort them correctly.

**Prepare matching names for links table**

**Files:** _[sql/links-prepare.sql]()_ (run); CSV extract of names and IDs; CSV export of name match candidates

**Input:** CSV extract of names and IDs

**Output:** CSV export of name match candidates

**Side effect:** ppl_names table (new, temporary)

**Create and populate IR links table**

**Files:** _[sql/links-load.sql]()_ (run); manually processed CSV matches

**Input:** manually processed CSV matches

**Output:** ir_links table (new)

Issues
----------
The Github repository master is:

<http://github.com/LincolnUniLTL/symploading/issues>

Because this documents a one-off process, we are unlikely to address issues. Please fork this if you want to adapt it. Feed your changes back via a pull request or whatever, if you think your changes are widely applicable to environments, not just yours.

The project's home is at <http://github.com/LincolnUniLTL/symploading> and some links in this README are relative to that.
