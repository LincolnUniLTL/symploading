## Import and clean RM metadata

**File:** _[sql/rm-metadata-import-clean.sql]()_ (run); CSV extract of legacy metadata prepared for Elements import

**Input:** CSV extract of legacy metadata prepared for Elements import

**Output:** rm_metadata table (new)

In this step, we import and do some cleanup on data that was exported from the legacy academic publications tracking system and prepared into CSV file to the specifications of an Elements metadata import file. Upload that file to your DSpace server.

We run SQL to create the table, import the CSV, and then there are some cleanup steps you may or may not need to perform:

* Our export came with lots of whitespace padding, so we trimmed it with an UPDATE statement.
* Our legacy system stored ISSNs and ISBNs (both kinds) alike in the one field. We run an UPDATE using regex to separate these into their correct fields.

|||||
:---- | :----: | ----:
[Previous](process-populate-links.md "Create and populate IR links table") | [up](process.md) | [Next](FIXME.md "DESCRIBEME")