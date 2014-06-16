### Create your load manifest

If the crosswalk mapping files determine how the load is made up, the manifest directs it all on a publication type basis. This is a custom XML file created for this process. The XSLT transformation uses it to:

* determine which crosswalk file to consult for field mappings for each publication type
* match and assign an Elements publication type for all DSpace types
* optionally populate a "subtype" field in Elements based on other information in the record, or in simpler cases, just based on its DSpace type

An [example manifest file](xml/loads-manifest.xml) is included in this repository and can be used as a guide or basis.

Beneath the `<manifest/>` element is a series of **`<mapping/>` elements** you need to customise. Ensure there is one for each of the publication types you have set up in Elements.

* the `@location` attribute tells the transformation the location of relevant crosswalk file to load for field mapppings
* `@underlying` is the Elements publication type "underlying" or machine name
* `@subtype` is only required if you want to populate a subtype field for that publication type, and it contains the name of the target subtype field. [ FIXME: can it be placed on children?? ]

The `<mapping/>` element has one or more child **`<dspace/>` elements**, which you need to populate.

* The `@type` attribute tells the transformer the name of a DSpace publication type that can be loaded as the Elements publication type specified in the parent `<mapping/>` element's `@underlying` attribute. In the simplest cases, that's all you need.
* Use `@subtype-value` when you want items of that DSpace type to have a subtype field value based on the DSpace type alone. Populate `@subtype-value` with that value.
* Use `@subtype-source` when you want to determine your subtype value based on the contents of another DSpace field/element. Specify with this attribute, and use the fully qualified form of the element. _This propagates to child elements, but can also be specified against single child `<subtype/>` elements only if they need to differ. See below._

If required (i.e. you need to base subtypes on another DSpace field), you can create child **`<subtype/>` elements** under the `<dspace/>` elements.

* Create a `<subtype/>` element for every other field value that determines a subtype value.
* If the subtype is sourced from a field other than what you specified in the parent `<mapping/>` element, you can put another `@subtype-source` attribute here and that will override the parent's.
* The `@match` attribute is the value of the field specified in `@subtype-source` that you want to match against.
* Use a `@value` attribute to indicate the value you'd like to populate the subtype field with when its DSpace value for `@subtype-source` matches `@match`.

That's about it.

|||||
:---- | :----: | ----:
[Previous](process-mappings.md "Finish your mappings") | [up](process.md) | [Next](process-init-metadata.md "Create and populate an initial metadata holding table")