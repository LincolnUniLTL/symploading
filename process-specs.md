### Understand load file specifications and requirements

Basically we want to end up with three CSV files to load into Elements:

* **_metadata.csv_**. A few mandatory columns and then columns with headers that match your underlying field names. These will vary in each implementation, which is sourcing them from the crosswalk files works so well.
* **_persons.csv_**. Item IDs matched to person field values in a choice of parseable formats. Used here only for author names, not editors.
* **_links.csv_**. Item IDs matched again to persons, but this time only to those with institutional IDs and therefore user accounts. We only list the institutional ID here, no names.

> This explanation is too simplistic and it is best to consult the Symplectic specification document ("Symplectic Elements - Standard Elements Importer"). Moreover, the specifications may change.

[Previous](process.md "The process outlined") | [up](process.md) | [Next](process-mappings.md "Finish your mappings") |
:---- | :----: | ----:
