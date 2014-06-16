# symploading
Some tools and a process that helped us import DSpace institutional repository data into Symplectic Elements, and merge most duplicate titles from Research Master, an academic output tracking application.

There is going to be plenty to customise in these files, but hopefully it can save some pain.

## Contents
1. [Our implementation](overview.md)
1. [Assumptions](assumptions.md)
1. [Requirements](requirements.md)
1. [The process](process.md)
	* [Understand load file specifications and requirements](process-specs.md)
	* [Finish your mappings](process-mappings.md)
	* [Create your load manifest](process-manifest.md)
	* [Create and populate an initial metadata holding table](process-init-metadata.md)
	* [Manipulate some data in the interim metadata table](process-massage-metadata.md)
	* [Create and populate IR persons table](process-populate-persons.md)
	* [Prepare matching names for links table](process-match-names.md)
	* [Create and populate IR links table](process-populate-links.md)
	* [Import and clean RM metadata](process-import-rm-metadata.md)
	* Identify possible duplicate titles in metadata files - TODO
	* Process sorted metadata duplicates - TODO
	* Cleanup based on discard flag in duplicates file - TODO
	* combine 2 metadata files - TODO
	* bring in RM persons CSV file for rejigging columns, then export - TODO
	* export IR links file - TODO
1. [Appendage - notes, alternate paths](meta.md)

## Issues

The Github repository master is:

<http://github.com/LincolnUniLTL/symploading/issues>

Because this documents a one-off process, we are unlikely to address issues. Please fork this if you want to adapt it. Feed your changes back via a pull request or whatever, if you think your changes are widely applicable to environments, not just yours.

The project's home is at <http://github.com/LincolnUniLTL/symploading> and some links in this README are relative to that.
