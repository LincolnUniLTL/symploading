<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:crosswalks="info:symplectic/crosswalks"
  xmlns:load="http://library.lincoln.ac.nz/xmlns/sqlload"
  version="1.0"
  >

  <!-- Required for all crosswalks - import the standard toolkit -->
  <xsl:import href="symplectic_xwalks_toolkit.xsl" />

  <xsl:variable name="tablename">ir_metadata</xsl:variable>

  <xsl:output method="text" />
  
  <xsl:template match="/">
    <xsl:text>
DROP TABLE </xsl:text><xsl:value-of select="$tablename" /><xsl:text>;

CREATE TABLE </xsl:text><xsl:value-of select="$tablename" /><xsl:text> (
	id integer CONSTRAINT ir_key PRIMARY KEY,
	category varchar(40),
	"type" varchar(50)
	);
    </xsl:text>    
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="load:mapping">
    <xsl:text>/* *********** </xsl:text>
    <xsl:value-of select="@underlying" />
    <xsl:text> *********** */
</xsl:text>
    
    <xsl:variable name="crosswalk-mappings" select="document(@location)//crosswalks:mappings" />

    <xsl:apply-templates select="@underlying" />
    <xsl:text>
	FROM metadatafieldregistry R, metadatavalue V
	WHERE R.metadata_field_id = V.metadata_field_id
		AND element LIKE 'type'
    AND (</xsl:text>
    <xsl:apply-templates select="load:dspace" />
    <xsl:text>)
  ;</xsl:text>
    <xsl:apply-templates select="$crosswalk-mappings/crosswalks:mapping">
      <xsl:with-param name="underlying" select="@underlying" />
    </xsl:apply-templates>
    <!-- now process any subtypes -->
    <xsl:apply-templates select="@subtype" />
  </xsl:template>

  <xsl:template match="@subtype">
    <xsl:text>

-- add column to accommodate subtype field
ALTER TABLE </xsl:text><xsl:value-of select="$tablename" /><xsl:text>
	ADD COLUMN "</xsl:text>
    <xsl:value-of select="."  />
    <xsl:text>" text;</xsl:text>
    <xsl:apply-templates select="../load:dspace" mode="subtype" />
  </xsl:template>

  <xsl:template match="load:dspace" mode="subtype">
    <xsl:apply-templates select="@subtype-value | load:subtype" />
  </xsl:template>

  <xsl:template match="load:subtype">
    <xsl:text>

-- populate complexly sourced subtype field with mapped value
UPDATE </xsl:text>
    <xsl:value-of select="$tablename" />
    <xsl:text>
	SET "</xsl:text>
    <xsl:value-of select="(ancestor::*/@subtype)[1]"  />
    <xsl:text>" = '</xsl:text>
    <xsl:value-of select="@value"  />
    <xsl:text>'
	FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
	WHERE R.metadata_field_id = V.metadata_field_id
	AND V.item_id = id
	AND ( short_id || '.' || element || CASE WHEN qualifier IS NULL THEN '' ELSE '.' || qualifier END ) LIKE '</xsl:text>
    <xsl:value-of select="(ancestor-or-self::*/@subtype-source)[last()]" />
    <xsl:text>'
    AND text_value LIKE '</xsl:text>
    <xsl:value-of select="@match"  />
    <xsl:text>'
    AND V.item_id IN (
      SELECT item_id
      FROM metadatafieldregistry R, metadatavalue V
      WHERE R.metadata_field_id = V.metadata_field_id
      AND element LIKE 'type'
      AND text_value LIKE '</xsl:text>
    <xsl:value-of select="../@type"  />
    <xsl:text>'
    );
    </xsl:text>
  </xsl:template>

  <xsl:template match="@subtype-value">
    <xsl:text>

-- populate subtype field with mapped value
UPDATE </xsl:text><xsl:value-of select="$tablename" /><xsl:text>
	SET "</xsl:text>
    <xsl:value-of select="(ancestor::*/@subtype)[1]"  />
    <xsl:text>" = '</xsl:text>
    <xsl:value-of select="."  />
    <xsl:text>'
	FROM metadatafieldregistry R, metadatavalue V
	WHERE R.metadata_field_id = V.metadata_field_id
	AND V.item_id = id
	AND element LIKE 'type'
  AND text_value LIKE '</xsl:text>
    <xsl:value-of select="../@type"  />
    <xsl:text>';
    </xsl:text>
  </xsl:template>

  <xsl:template match="@underlying">
    <xsl:text>
INSERT INTO </xsl:text><xsl:value-of select="$tablename" /><xsl:text> (id, category, "type")
  SELECT item_id, 'publication', '</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>'</xsl:text>
  </xsl:template>

  <xsl:template match="load:dspace">
    <xsl:if test="preceding-sibling::load:dspace">
      <xsl:text> OR</xsl:text>
    </xsl:if>
    <xsl:text> text_value LIKE '</xsl:text>
    <xsl:value-of select="@type" />
    <xsl:text>'</xsl:text>
  </xsl:template>

  <xsl:template match="crosswalks:mapping[@elements and not(@elements='authors')]">
    <xsl:param name="underlying" />

    <xsl:variable name="elements-col">
      <xsl:choose>
        <xsl:when test="contains(@elements,',')">
          <xsl:value-of select="normalize-space(substring-before(@elements,','))" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@elements" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- add column if needed -->
    <xsl:text>
ALTER TABLE </xsl:text><xsl:value-of select="$tablename" /><xsl:text>
	ADD COLUMN "</xsl:text>
    <xsl:value-of select="$elements-col"  />
    <xsl:text>" text;
</xsl:text>

    <xsl:text>
UPDATE </xsl:text><xsl:value-of select="$tablename" /><xsl:text> IR
  SET "</xsl:text>
    <xsl:value-of select="$elements-col" />
    <xsl:text>" = nullif( array_to_string( array( SELECT text_value
    FROM metadatafieldregistry R, metadatavalue V, metadataschemaregistry S
    WHERE R.metadata_field_id = V.metadata_field_id
    AND R.metadata_schema_id = S.metadata_schema_id
    AND V.item_id IN (
    SELECT id
    FROM </xsl:text><xsl:value-of select="$tablename" /><xsl:text>
    WHERE "type" LIKE '</xsl:text>
    <xsl:value-of select="$underlying"  />
    <xsl:text>'
    )
    AND ( short_id || '.' || element || CASE WHEN qualifier IS NULL THEN '' ELSE '.' || qualifier END ) ILIKE '</xsl:text>
    <xsl:value-of select="@dspace"/>
    <xsl:text>'
    AND V.item_id = IR.id
    ), ', '
    ), '')
    WHERE "type" LIKE '</xsl:text>
    <xsl:value-of select="$underlying"  />
    <xsl:text>';
</xsl:text>

  </xsl:template>

</xsl:stylesheet>