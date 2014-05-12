-- ***************
-- Part of metadata export for Symplectic Elements
-- ***************

/* ******* Create and populate IR persons table ********* */

DROP TABLE ir_persons;

CREATE TABLE ir_persons (
	category text,
	id integer,
	"field-name" varchar(40),
	"full" text,
	"order-number" text,
	"full-list" text -- for compatibility with RM export
	);


-- Populate ir_persons (with authors only) in the order provided, taking them from the dc.contributor.author element (not dc.creator)
INSERT INTO ir_persons(category, id, "field-name", "full", "order-number")
	SELECT 'publication', item_id, 'authors', text_value, rank() OVER (PARTITION BY item_id ORDER BY metadata_value_id)
	FROM ir_metadata, metadatavalue
	WHERE ir_metadata.id = metadatavalue.item_id
	AND (ir_metadata.id, metadata_value_id) IN (
		SELECT item_id, metadata_value_id
		FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
		WHERE R.metadata_field_id = V.metadata_field_id
		AND R.metadata_schema_id = S.metadata_schema_id
		AND ( short_id || '.' || element || '.' || qualifier ) ILIKE 'dc.contributor.author'
		);
