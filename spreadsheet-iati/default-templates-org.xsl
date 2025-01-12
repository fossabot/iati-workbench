<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://iati.me/merge"
  exclude-result-prefixes="xs"
  expand-text="yes"
  version="3.0">
  
<!--  <xsl:variable name="file"/>
  <xsl:variable name="reporting-org"/>
  <xsl:variable name="reporting-org-type"/>
-->  <xsl:variable name="default-currency"/>

  <!--  Budgets: -->
  <xsl:template match="record[contains(lower-case($file), 'organisation-budgets')]">
    <xsl:if test="(merge:entry(., 'IATI organisation identifier')[1] = $reporting-org)">
      <iati-organisation merge:id="{merge:entry(., 'IATI organisation identifier')}"
        last-updated-datetime="{current-dateTime()}"
        xml:lang="{lower-case(merge:entry(., 'Language', 'en'))}"
        default-currency="{merge:entry(., 'Currency', ($default-currency, 'EUR')[1])}">
        <organisation-identifier>{merge:entry(., 'IATI organisation identifier')}</organisation-identifier>
        <reporting-org ref="{$reporting-org}" type="{$reporting-org-type}">
          <narrative>{$reporting-org-name}</narrative>
        </reporting-org>
        
        <name>
          <narrative>{$reporting-org-name}</narrative>
        </name>

        <xsl:choose>
          <xsl:when test="merge:entry(., 'Country code')!=''">
            <recipient-country-budget status="{merge:entry(., 'Budget status')}">
              <recipient-country code="{merge:entry(., 'Country code')}"/>
              <xsl:apply-templates select="." mode="budget-details"/>              
            </recipient-country-budget>
          </xsl:when>
          <xsl:when test="merge:entry(., 'Region code')!=''">
            <recipient-region-budget status="{merge:entry(., 'Budget status')}">
              <recipient-region code="{merge:entry(., 'Region code')}" 
                vocabulary="{merge:entry(., 'Region vocabulary', '1')}">
                <xsl:if test="merge:entry(., 'Region name')!=''">
                  <narrative>{merge:entry(., 'Region name')}</narrative>
                </xsl:if>
              </recipient-region>
              <xsl:apply-templates select="." mode="budget-details"/>              
            </recipient-region-budget>
          </xsl:when>
          <xsl:when test="merge:entry(., 'Recipient organisation name')!=''">
            <recipient-org-budget status="{merge:entry(., 'Budget status')}">
              <recipient-org ref="{merge:entry(., 'Recipient organisation identifier')}">
                <narrative>{merge:entry(., 'Recipient organisation name')}</narrative>
              </recipient-org>
              <xsl:apply-templates select="." mode="budget-details"/>              
            </recipient-org-budget>
          </xsl:when>
          <xsl:otherwise>
            <total-budget status="{merge:entry(., 'Budget status')}">
              <xsl:apply-templates select="." mode="budget-details"/>
            </total-budget>
          </xsl:otherwise>
        </xsl:choose>
      </iati-organisation>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="budget-details">
    <period-start iso-date="{merge:date(merge:entry(., 'Budget start date'))}"/>
    <period-end iso-date="{merge:date(merge:entry(., 'Budget end date'))}"/>
    <value value-date="{(merge:date(merge:entry(., 'Value date')), merge:date(merge:entry(., 'Budget start date')))[1]}" currency="{(merge:entry(., 'Currency'), merge:currency-symbol(merge:entry(., 'Budget')))[1]}">{merge:currency-value(merge:entry(., 'Budget'))}</value>
  </xsl:template>
  
  <!--  Documents: -->
  <xsl:template match="record[contains(lower-case($file), 'organisation-documents')]">
    <xsl:if test="(merge:entry(., 'IATI organisation identifier')[1] = $reporting-org)">
      
      <!-- Replace Google Drive sharing links (open a preview page) with direct download links -->
      <xsl:variable name="url" select="replace(
        replace(merge:entry(., 'Web address'), 
          '^https://drive.google.com/open\?id=(.+)', 
          'https://drive.google.com/uc?export=download&amp;id=$1'),
        
        '^https://drive.google.com/file/d/(.+)/view\?usp=sharing', 
        'https://drive.google.com/uc?export=download&amp;id=$1')"/>

      <iati-organisation merge:id="{merge:entry(., 'IATI organisation identifier')}">
        <document-link format="{merge:format(merge:entry(., 'Format'))}" url="{$url}">
          <title>
            <narrative><xsl:value-of select="merge:entry(., 'Document title')"/></narrative>
          </title>
          <description>
            <narrative><xsl:value-of select="merge:entry(., 'Document description')"/></narrative>
          </description>
          <category code="{merge:entry(., 'Category')}"/>
          <xsl:if test="merge:entry(., 'Document language')!=''">
            <language code="{lower-case(merge:entry(., 'Document language'))}" />
          </xsl:if>
          <xsl:if test="merge:entry(., 'Document date')!=''">
            <document-date iso-date="{merge:date(merge:entry(., 'Document date'))}" />
          </xsl:if>
        </document-link>
      </iati-organisation>          
    </xsl:if>
  </xsl:template>

  <!-- Expenditure -->
  <xsl:template match="record[contains(lower-case($file), 'organisation-expenditure')]">
    <xsl:if test="(merge:entry(., 'IATI organisation identifier')[1] = $reporting-org)">
      <iati-organisation merge:id="{merge:entry(., 'IATI organisation identifier')}">
        <total-expenditure>
          <period-start iso-date="{merge:date(merge:entry(., 'Period start date'))}"/>
          <period-end iso-date="{merge:date(merge:entry(., 'Period end date'))}"/>
          <value value-date="{(merge:date(merge:entry(., 'Value date')), merge:date(merge:entry(., 'Period start date')))[1]}" currency="{(merge:entry(., 'Currency'), merge:currency-symbol(merge:entry(., 'Expenditure')))[1]}">{merge:currency-value(merge:entry(., 'Expenditure'))}</value>
        </total-expenditure>
      </iati-organisation>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>