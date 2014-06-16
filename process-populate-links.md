## Create and populate IR links table

**Files:** _[sql/links-load.sql](sql/links-load.sql)_ (run); manually processed CSV matches

**Input:** manually processed CSV matches

**Output:** ir_links table (new)

Upload the manually processed matches of names CSV file. This file should have an 'x' in the discard column for any definite non-matches.

Now we are simply running some SQL to:
* create a table for the publication-userid links
* import data into it from the CSV file
* discard columns we no longer need

[Previous](process-match-names.md "Prepare matching names for links table") | [up](process.md) | [Next](process-import-rm-metadata.md "Import and clean RM metadata") |
:---- | :----: | ----:
