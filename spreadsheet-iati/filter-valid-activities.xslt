<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" expand-text="yes"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:val="http://saxon.sf.net/ns/validation"
  exclude-result-prefixes="xs">
  
  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:output indent="yes"/>

  <!-- filter either all valid or all invalid activities -->
  <xsl:param name="select-valid" select="true()" as="xs:boolean"/>

  <xsl:variable name="invalid" select="distinct-values(//val:error/@iati-identifier)"/>
  
  <xsl:template match="val:validation-report">
    <xsl:apply-templates select="doc(@system-id)"/>
  </xsl:template>

  <!-- skip invalid or valid activities depending on select-valid -->
  <xsl:template match="iati-activity[$select-valid and (iati-identifier=$invalid)]"/>  
  <xsl:template match="iati-activity[not($select-valid) and not(iati-identifier=$invalid)]"/>
</xsl:stylesheet>