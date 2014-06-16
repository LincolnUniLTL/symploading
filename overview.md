## Our implementation

This process makes use of the limited set of tools that were unambiguously available to us at the time we commenced the export. The main thing was they worked for us. We used XSLT, SQL, and some manual cleaning, and performed some manual matching work on desktop with CSV files.

After some very important configuration, the first step is [generating a bunch of SQL statements that will populate an export table from item metadata in DSpace](process-init-metadata.md). After running that, there is more SQL to execute to clean and tweak, and create initial versions of the other export tables required. Because our DSpace is not linked to contributors' institutional IDs, we make a rough match of author names to an export of staff names. Then we very roughly manually verify those matches.

* *TODO* *

| | | |
:---- | :---: | ----: 
|  | [top](README.md) | [Next](assumptions.md "Assumptions")