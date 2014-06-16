### Create and populate an initial metadata holding table

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

|||||
:---- | :----: | ----:
[Previous](process-manifest.md "Create your load manifest") | [up](process.md) | [Next](process-massage-metadata.md "Manipulate some data in the interim metadata table")