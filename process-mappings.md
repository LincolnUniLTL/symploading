### Finish your mappings

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

|||||
:---- | :----: | ----:
[Previous](process-specs.md "Understand load file specifications and requirements") | [up](process.md) | [Next](process-manifest.md "Create your load manifest")