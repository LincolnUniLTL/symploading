## Assumptions

This is a probably incomplete list of underlying assumptions in the process and code:

* **The `dc.type` element in DSpace holds its document type.**
* **There is only one instance of `dc.type` for each DSpace item.** That is a good situation if you think about it. This query will tell you if you need to clean up some types _(and optionally display their URL, uncomment and substitute the right field id, or else [install DHandle](http://gist.github.com/LincolnUniLTL/10611972) and call `DHandle(item_id)`)_:
```SQL
SELECT item_id, count(item_id) --, (SELECT ' ' || text_value FROM metadatavalue WHERE metadata_field_id=25 AND item_id=V.item_id) AS handle
	FROM metadatafieldregistry R, metadatavalue V 
	WHERE R.metadata_field_id = V.metadata_field_id 
	AND element like 'type'
	GROUP BY V.item_id
	HAVING count(item_id) > 1
	ORDER BY item_id
	;
```
* **Authors are excluded from _metadata.csv_ and listed in _persons.csv_ instead, but editors are not.** It would be more typical to include the editors field data in the _persons.csv_ file.
* **Crosswalks files have been completed.** These determine the mapping of fields for each publication type and you need to complete them eventually anyway, assuming you want to keep Elements and DSpace in sync. Also, before they can be completed, you will need to have completed your data modelling (fields for each publication type) within Elements.
* **Crosswalk mapping files contain only simple field-based mappings.** We didn't make use of the interesting syntax interpreted in the `@format-elements` attribute of the crosswalk files. You can however list a sequence of elements fields separated by comma (e.g. "journal,parent-title,series"). We will simply strip everything but the first of those.
* **DSpace publication types map to at most one Elements publication type.** Thankfully this was true for us because we can't write scripts that split a group without deterministic rules.

Supports subtypes TODO * *

|||||
:---- | :----: | ----:
[Previous](overview.md "Our implementation") | [top](README.md) | [Next](requirements.md "Requirements")