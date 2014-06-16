### Prepare matching names for links table

**Files:** _[sql/links-prepare.sql](sql/links-prepare.sql)_ (run); CSV extract of names and IDs; CSV export of name match candidates

**Input:** CSV extract of names and IDs

**Output:** CSV export of name match candidates

**Side effect:** tmp_names table (new, temporary)

This step requires that we produce a list of publication IDs matched to participant ([assumptions.md](in our case only authors)) "institutional" IDs, which are identifiers used in your personnel system (which should have been initially imported as Elements userids).

So we create a table to hold matching data from the institutional personnel system. We upload a CSV export which mirrors that structure and bring it into the database.

Then we run a query which matches with our [process-populate-persons.md](ir_persons table we created earlier). We set this up to match on surname and first initial, so that we can match manually without too many misses.

We export the results of that query to a CSV file for manual match checking.

Someone needs to go through that file (using a printout and pen might be easier) and put an 'x' in the discard column where the match can't be the same person. Other columns have been provided to assist with the comparison task. If there is any doubt, it is better to retain the match and have your users disclaim the publication after import.

> Note that this step will be different but far more trivial and automatic if your institutional repository already stores institional personal IDs.

|||||
:---- | :----: | ----:
[Previous](process-populate-persons.md "Create and populate IR persons table") | [up](process.md) | [Next](process-populate-links.md "Create and populate IR links table")