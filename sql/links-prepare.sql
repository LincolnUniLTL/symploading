-- ***************
-- Part of metadata export for Symplectic Elements
-- ***************

/* ******* Prepare matching names for links table ********* */

-- Create a temporary table to hold the staff listing
CREATE TABLE ppl_names (
	emplid text,
	last_name text,
	"names" text,
	ignore_last text,
	first_name text,
	middle_name text,
	name_display text,
	name_formal text
	);

-- because there were some encoding issues …
SET client_encoding='LATIN1';

-- Import the CSV file
\copy ppl_names FROM './symplectic/imp-staff-postgrad-names.csv' WITH CSV HEADER

-- Match imported names on first initial and surname
/*
-- Preview the results before exporting using this query
WITH P AS ( SELECT *, regexp_matches(P.full, E'^(.+),\\s*(\\S).*$', 'i') AS tokens FROM ir_persons P)
SELECT NULL AS discard, ( N.last_name || ', ' || N.names ) AS "name", P.full, 'publication' AS "category-1", P.id AS "id-1", 'user' AS "category-2", N.emplid AS "id-2", '8' AS "link-type-id", P.tokens
	FROM ppl_names N, P
	WHERE N.last_name = P.tokens[1]
	AND upper(P.tokens[2]) = upper(substring(N.first_name from 1 for 1));
*/

-- Ugly one-line export for psql client
\copy ( WITH P AS ( SELECT *, regexp_matches(P.full, E'^(.+),\\s*(\\S).*$', 'i') AS tokens from ir_persons P) select NULL AS discard, ( N.last_name || ', ' || N.names ) AS "name", P.full, 'publication' AS "category-1", P.id AS "id-1", 'user' AS "category-2", N.emplid AS "id-2", '8' AS "link-type-id", P.tokens FROM ppl_names N, P WHERE N.last_name = P.tokens[1] AND upper(P.tokens[2]) = upper(substring(N.first_name from 1 for 1)) ) TO './symplectic/exp-namematches.csv' WITH CSV HEADER
