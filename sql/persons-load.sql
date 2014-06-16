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
	SELECT 'publication', item_id, 'authors', text_value, place
	FROM ir_metadata, metadatavalue
	WHERE id = item_id
	AND (id, metadata_value_id) IN (
		SELECT item_id, metadata_value_id
		FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
		WHERE R.metadata_field_id = V.metadata_field_id
		AND R.metadata_schema_id = S.metadata_schema_id
		AND ( short_id || '.' || element || '.' || qualifier ) ILIKE 'dc.contributor.author'
		);

-- (to clean up a previous mess: ) Create a list of incorrectly ranked items from initial version of this query using id order in a window:
/*
WITH rankings AS (
	SELECT item_id, text_value, rank() OVER (PARTITION BY item_id ORDER BY metadata_value_id) AS "rank", place
	FROM ir_metadata, metadatavalue
	WHERE id = item_id
	AND (id, metadata_value_id) IN (
		SELECT item_id, metadata_value_id
		FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
		WHERE R.metadata_field_id = V.metadata_field_id
		AND R.metadata_schema_id = S.metadata_schema_id
		AND ( short_id || '.' || element || '.' || qualifier ) ILIKE 'dc.contributor.author'
		)
)
-- SELECT COUNT(DISTINCT(item_id)) FROM rankings
SELECT * FROM rankings
	WHERE item_id IN (
		SELECT DISTINCT item_id
		FROM rankings
		WHERE "rank" != place
		)
	ORDER BY item_id, place;
*/