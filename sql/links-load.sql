-- ***************
-- Part of metadata export for Symplectic Elements
-- ***************

/* ******* Create and populate IR links table ********* */

-- after cleaning …
-- Create the links table
CREATE TABLE ir_links (
	discard text, -- to be killed
	"name" text, -- to be killed
	"full" text, -- to be killed
	"category-1" text,
	"id-1" text,
	"category-2" text,
	"id-2" text,
	"link-type-id" text,
	tokens text -- to be killed
	);

-- Bring data back in
\copy ir_links FROM './symplectic/imp-names-for-links.csv' WITH CSV HEADER

-- Remove unneeded columns
DELETE FROM ir_links WHERE btrim(lower(discard)) = 'x';
ALTER TABLE ir_links DROP COLUMN discard;
ALTER TABLE ir_links DROP COLUMN "name";
ALTER TABLE ir_links DROP COLUMN "full";
ALTER TABLE ir_links DROP COLUMN tokens;