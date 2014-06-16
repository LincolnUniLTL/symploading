-- ***************
-- Part of metadata export for Symplectic Elements
-- ***************

/* ***** Manual ir_metadata table cleanup steps following initial load from DSpace database ***** */

-- Fix keywords list, as semicolons are required for delimiters for this CSV "data type"
UPDATE ir_metadata IR
	SET keywords = array_to_string( array( SELECT text_value
		FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
		WHERE R.metadata_field_id = V.metadata_field_id
		AND R.metadata_schema_id = S.metadata_schema_id
		AND ( short_id || '.' || element ) ILIKE 'dc.subject'
		AND qualifier IS NULL -- added for our implementation because we don't want qualified dc.subject values in our keywords list
		AND V.item_id = IR.id
		), '; ')
	;

-- Remove "ghost" IR items with no title
DELETE 
	FROM ir_metadata
	WHERE title IS NULL;
		
-- Remove IR items dated before 1990; result of local policy decision
DELETE
	FROM ir_metadata
	WHERE "publication-date" < '1990'
	OR ( "publication-date" IS NULL AND "start-date" < '1990')
	OR ( "publication-date" IS NULL AND "start-date" IS NULL);

-- Split isbn-13 from isbn-10
ALTER TABLE ir_metadata
	ADD COLUMN "isbn-10" text;

UPDATE ir_metadata
	SET "isbn-13" = '',
		"isbn-10" = "isbn-13"
	WHERE btrim("isbn-13") != ''
	AND "isbn-13" !~* E'(97(8|9))';