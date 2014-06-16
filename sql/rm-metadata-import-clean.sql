-- ***************
-- Part of metadata export for Symplectic Elements
-- ***************

/* ******* Create table and import RM metadata file ********* */

CREATE TABLE rm_metadata (
	id text,
	category text,
	"type" text,
	title text,
	"author-url" text,
	editors text,
	series text,
	edition text,
	volume text,
	pagination text,
	publisher text,
	"publisher-url" text,
	"place-of-publication" text,
	"publication-date" text,
	"isbn-10" text,
	"isbn-13" text,
	doi text,
	medium text,
	"publication-status" text,
	keywords text,
	notes text,
	"number" text,
	"parent-title" text,
	"name-of-conference" text,
	location text,
	"start-date" text,
	"finish-date" text,
	journal text,
	issue text,
	issn text,
	pii text,
	"patent-number" text,
	"associated-authors" text,
	"filed-date" text,
	"patent-status" text,
	"commissioning-body" text,
	confidential text,
	"number-of-pieces" text,
	version text,
	eissn text,
	"c-start-length" text,
	"c-end-length" text,
	"c-broadcast-programme" text,
	"c-audience" text,
	"c-conferences-stype-lu" text,
	"c-thesis-stypes-lu" text,
	"c-reports-stypes-lu" text,
	"c-extension-presentation" text
	);

SET client_encoding='LATIN1';
\copy rm_metadata FROM './rm_metadata.csv' WITH CSV HEADER

-- cleanse RM table data of leading and trailing spaces
UPDATE rm_metadata
	SET "type" = btrim("type"),
		title = btrim(title),
		editors = btrim(editors),
		volume = btrim(volume),
		pagination = btrim(pagination),
		publisher = btrim(publisher),
		"publisher-url" = btrim("publisher-url"),
		"place-of-publication" = btrim("place-of-publication"),
		"publication-date" = btrim("publication-date"),
		doi = btrim(doi),
		medium = btrim(medium),
		"publication-status" = btrim("publication-status"),
		keywords = btrim(keywords),
		notes = btrim(notes),
		"number" = btrim("number"),
		"parent-title" = btrim("parent-title"),
		"name-of-conference" = btrim("name-of-conference"),
		location = btrim(location),
		journal = btrim(journal),
		issue = btrim(issue),
		issn = btrim(issn),
		"patent-number" = btrim("patent-number"),
		"commissioning-body" = btrim("commissioning-body"),
		version = btrim(version),
		"c-start-length" = btrim("c-start-length"),
		"c-end-length" = btrim("c-end-length"),
		"c-broadcast-programme" = btrim("c-broadcast-programme"),
		"c-conferences-stype-lu" = btrim("c-conferences-stype-lu"),
		"c-thesis-stypes-lu" = btrim("c-thesis-stypes-lu"),
		"c-reports-stypes-lu" = btrim("c-reports-stypes-lu"),
		"c-extension-presentation" = btrim("c-extension-presentation")
	;

/* ******* Fix up ISSN/ISBNs ********* */

UPDATE rm_metadata
	SET issn = '',
		"isbn-10" = issn
	WHERE issn ~* E'^\\d{9}(\\d|X)$'; -- only get away with this because there are no dashes in issns

UPDATE rm_metadata
	SET issn = '',
		"isbn-13" = issn
	WHERE issn ~* E'(97(8|9))\\d{9}(\\d|X)$'; -- only get away with this because there are no dashes in issns
