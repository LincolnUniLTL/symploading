-- ***************
-- Part of metadata export for Symplectic Elements
-- ***************

/* ******* Create and populate IR metadata table ********* */
/*
	Commands in this section are for reference and are not completely listed here.
	
	A transformation will generate large amounts of SQL based on the statements below.
	
	This is so that you can verify the output of that transformation against these 
	example statements.
	
*/
DROP TABLE ir_metadata;

CREATE TABLE ir_metadata (
	id integer CONSTRAINT ir_key PRIMARY KEY,
	category varchar(40),
	"type" varchar(50)
	);

ALTER TABLE ir_metadata
	ADD COLUMN "{{COLUMN}}" text;

-- Insert stub records for each type
INSERT INTO ir_metadata (id, category, "type")
	SELECT item_id, 'publication', '{{ETYPE}}'
	FROM metadatafieldregistry R, metadatavalue V
	WHERE R.metadata_field_id = V.metadata_field_id
		AND element LIKE 'type'
		AND text_value LIKE '{{DTYPE}}';

/* **** Superseded: for reference only
-- This one assumed a single metadata element only and is revised by the one below which concatenates multiple values for elements.
-- Retained for reference only, use statement below instead.
UPDATE ir_metadata
	SET {{FIELD}} = text_value
	FROM metadatavalue
	WHERE (ir_metadata.id, metadata_value_id) IN (
		SELECT item_id, metadata_value_id
		FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
		WHERE R.metadata_field_id = V.metadata_field_id
			AND R.metadata_schema_id = S.metadata_schema_id
			AND V.item_id in (
				select id
				from ir_metadata
				where "type" like '{{ETYPE}}'
				)
			AND ( short_id||'.'||element || CASE WHEN qualifier IS NULL THEN '' ELSE '.' || qualifier END ) ILIKE '{{QUALIFIED}}'
		)
	WHERE "type" LIKE '{{ETYPE}}';
*/

/*	This one improves on the statement above, it concatenates multiple values for elements
	Use this unless there is a way to discover the Elements field type. */
-- Populate from mapped field
UPDATE ir_metadata IR
	SET "{{FIELD}}" = nullif( array_to_string( array( SELECT text_value
	FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
	WHERE R.metadata_field_id = V.metadata_field_id
		AND R.metadata_schema_id = S.metadata_schema_id
		AND V.item_id IN (
			SELECT id
			FROM ir_metadata
			WHERE "type" LIKE '{{ETYPE}}'
			)
		AND ( short_id||'.'||element || CASE WHEN qualifier IS NULL THEN '' ELSE '.' || qualifier END ) ILIKE '{{QUALIFIED}}'
		AND V.item_id = IR.id
	), ', '
	), '')
	WHERE "type" LIKE '{{ETYPE}}';

-- Update for simple subtypes based on DSpace publication type: e.g. reports, conference material
ALTER TABLE ir_metadata
	ADD COLUMN "{{SUBTYPECOL}}" text;
	
UPDATE ir_metadata
	SET "{{SUBTYPECOL}}" = '{{SUBTYPEVAL}}'
	FROM metadatafieldregistry R, metadatavalue V
	WHERE R.metadata_field_id = V.metadata_field_id
	AND V.item_id = id
	AND element LIKE 'type'
    AND text_value LIKE '{{DTYPE}}'
	);

-- Update for subtypes based on other fields
UPDATE ir_metadata
	SET "{{SUBTYPECOL}}" = '{{SUBTYPEVAL}}'
	FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
	WHERE R.metadata_field_id = V.metadata_field_id
	AND R.metadata_schema_id = S.metadata_schema_id
	AND V.item_id = id
	AND ( short_id || '.' || element || CASE WHEN qualifier IS NULL THEN '' ELSE '.' || qualifier END ) LIKE '{{DSOURCE}}'
	AND text_value LIKE '{{DVALUE}}'
	AND V.item_id IN (
		SELECT item_id
		FROM metadatafieldregistry R, metadatavalue V
		WHERE R.metadata_field_id = V.metadata_field_id
		AND element LIKE 'type'
		AND text_value LIKE '{{DTYPE}}'
    );	
