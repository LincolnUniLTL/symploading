### Manipulate some data in the interim metadata table

**Files:** _[sql/metadata-clean.sql](sql/metadata-clean.sql)_ (run)

**Output:** ir_metadata table (updated)

These SQL statements can be executed to tweak and clean the ir_metadata table we created and populated [in the previous step](process-init-metadata.md "Create and populate an initial metadata holding table"). They are:

* Switch the keywords field to use semicolons as delimiters, as required by the load specifications. Other multivalue field types use commas, so that's how they've been scripted.
* Optionally, delete any records from DSpace without handles. We are using that as our criterion for "ghost" items. These seem to get left around in the database when, for example, a workflow is not completed.
* Optionally, depending on your policy, you may want to remove items from ir_metadata before a certain date. We decided on 1990, since this is as far back as our legacy system records go.
* If you only had one ISBN field, you'll want to split it into separate columns for holding ISBN-13 and ISBN-10 values. This is done with some rough regex magic.

> Note that you may want to clean up other kinds of DSpace items, like withdrawn or protected items. I don't know enough of the DSpace database semantics to be able to do this reliably. If you deleted every item without a handle, that may have already taken care of them.

|||||
:---- | :----: | ----:
[Previous](process-init-metadata.md "Create and populate an initial metadata holding table") | [up](process.md) | [Next](process-populate-persons.md "Create and populate IR persons table")