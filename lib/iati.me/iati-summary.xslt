<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:functx="http://www.functx.com"
  xmlns:me="http://iati.me"
  expand-text="yes">

  <xsl:import href="../functx.xslt"/>
  <xsl:import href="../office/spreadsheet.xslt"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/iati-activities">
    <xsl:variable name="data">
      <file>
        <xsl:apply-templates select="iati-activity">
          <xsl:sort select="iati-identifier"/>
        </xsl:apply-templates>
      </file>
    </xsl:variable>
    <xsl:apply-templates select="$data" mode="office-spreadsheet-file"/>
  </xsl:template>

  <xsl:template match="iati-activity">
    <row>
      <column name="IATI activity identifier" style="co3">{iati-identifier}</column>
      <column name="IATI parent activity identifier" style="co3">{(related-activity[@type='1']/@ref)=>sort()=>string-join(', ')}</column>
      <column name="Activity name" style="co4">{title/narrative[1]}</column>
      
      
      <column name="# parent activities" type="value">{me:nonzero(count(related-activity[@type='1']))}</column>
      <!--      <column name="# child activities">{me:nonzero(count(related-activity[@type='2']))}</column>-->
      
      <column name="Basic info present?">{me:yesno(title/narrative[1]!='' and description/narrative[1]!='' 
        and participating-org and activity-date)}</column>
      <column name="DAC5 sectors">{(sector[@vocabulary='1' or not(@vocabulary)]/@code)=>sort()=>string-join(', ')}</column>
      
      <column name="Geography:" style="co2"></column>
      <column name="Countries">{(recipient-country/@code)=>sort()=>string-join(', ')}</column>
      <column name="# locations">{me:nonzero(count(location))}</column>
      
      <column name="Participating orgs:" style="co2"></column>
      <column name="# funding" type="value">{me:nonzero(count(participating-org[@role='1']))}</column>
      <column name="# accountable" type="value">{me:nonzero(count(participating-org[@role='2']))}</column>
      <column name="# implementing" type="value">{me:nonzero(count(participating-org[@role='4']))}</column>

      <column name="Transactions:" style="co2"></column>
      <column name="# incoming commitments" type="value">{me:nonzero(count(transaction[transaction-type/@code='11']))}</column>
      <column name="# outgoing commitments" type="value">{me:nonzero(count(transaction[transaction-type/@code='2']))}</column>
      <column name="# incoming funds" type="value">{me:nonzero(count(transaction[transaction-type/@code='1']))}</column>
      <column name="# disbursements" type="value">{me:nonzero(count(transaction[transaction-type/@code='3']))}</column>
      <column name="# expenditures" type="value">{me:nonzero(count(transaction[transaction-type/@code='4']))}</column>
      
      <column name="Results:" style="co2"></column>
      <column name="# indicators" type="value">{me:nonzero(count(result/indicator))}</column>
      
    </row>
  </xsl:template>
  
  <xsl:function name="me:yesno" as="xs:string">
    <xsl:param name="bool"/>
    <xsl:text>{if ($bool) then ('yes') else ('no')}</xsl:text>
  </xsl:function>

  <xsl:function name="me:nonzero" as="xs:string">
    <xsl:param name="val"/>
    <xsl:text>{if ($val!=0) then ($val) else ('')}</xsl:text>
  </xsl:function>
</xsl:stylesheet>
