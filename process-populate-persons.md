### Create and populate IR persons table

**Files:** _[sql/persons-load.sql]()_ (run)

**Output:** ir_persons table (new)

These are straightforward SQL statements to create and populate the table that holds person names. Specifically, as noted in [assumptions.md](assumptions), we only used this to store authors, not editors, which were exported in the _metadata.csv_ file.

Note that we drew author names from the `dc.contributor.author` element, whereas you might correctly source them from `dc.creator`.

The last SQL statement, which populates the table, records the authors' database ID order ("order-number" column), which DSpace appears to use to sort them correctly.

|||||
:---- | :----: | ----:
[Previous](process-massage-metadata.md "Manipulate some data in the interim metadata table") | [up](process.md) | [Next](process-match-names.md "Prepare matching names for links table")