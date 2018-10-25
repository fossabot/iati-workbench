<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:merge="http://iati.me/merge"
  exclude-result-prefixes="xs"
  expand-text="yes"
  version="3.0">
  
  <xsl:variable name="file"/>
  <xsl:variable name="reporting-org"/>
  <xsl:variable name="reporting-org-type"/>
  
  <!--Activities: -->
  <xsl:template match="record[starts-with($file, 'Projects')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI Activity Identifier'), $reporting-org) and not(merge:boolean(merge:entry(., 'Exclusion applies?')))">
      <iati-activity default-currency="{merge:entry(., 'Currency')}"
        last-updated-datetime="{current-dateTime()}"
        xml:lang="{(merge:entry(., 'Language'),'en')[1]}"
        merge:id="{merge:entry(., 'IATI activity identifier')}">
        <iati-identifier>{merge:entry(., 'IATI activity identifier')}</iati-identifier>
        <reporting-org ref="{$reporting-org}" type="{$reporting-org-type}">
          <narrative>{$reporting-org-name}</narrative>
        </reporting-org>
        <contact-info type="{merge:entry(., 'Contact info type')}">
          <organisation>
            <narrative>{merge:entry(., 'Contact info organisation')}</narrative>
          </organisation>
          <telephone>{merge:entry(., 'Contact telephone')}</telephone>
          <email>{merge:entry(., 'Contact email')}</email>
          <website>{merge:entry(., 'Contact website')}</website>
          <mailing-address>{merge:entry(., 'Contact mailing address')}</mailing-address>
        </contact-info>
        
        <title>
          <narrative>{merge:entry(., 'Activity name')}</narrative>
        </title>
        
        <description type="1">
          <narrative>{merge:entry(., 'General description')}</narrative>
        </description>
        <description type="2">
          <narrative>{merge:entry(., 'Main objectives and outcomes')}</narrative>
        </description>
        <description type="3">
          <narrative>{merge:entry(., 'Targetgroup or reach')}</narrative>
        </description>
        <description type="4">
          <narrative>{merge:entry(., 'Background')}</narrative>
        </description>
        
        <activity-status code="{merge:entry(., 'Activity status')}"/>
        <activity-date type="1" iso-date="{merge:date(merge:entry(., 'Planned start date', ''))}"/>
        <activity-date type="2" iso-date="{merge:date(merge:entry(., 'Actual start date', ''))}"/>
        <activity-date type="3" iso-date="{merge:date(merge:entry(., 'Planned end date', ''))}"/>
        <activity-date type="4" iso-date="{merge:date(merge:entry(., 'Actual end date', ''))}"/>
        
        <activity-scope code="{merge:entry(., 'Activity scope')}"/>
        
        <!-- Budget may be in the project file -->
        <xsl:if test="merge:entry(., ('Budget', 'Total Budget')) != ''">
          <budget status="{merge:entry(., 'Budget status', '1')}" type="{merge:entry(., 'Budget type', '1')}">
            <xsl:variable name="start-date">
              <xsl:choose>
                <xsl:when test="merge:entry(., 'Budget start date')!=''">{merge:entry(., 'Budget start date')}</xsl:when>
                <xsl:when test="merge:entry(., 'Actual start date')!=''">{merge:entry(., 'Actual start date')}</xsl:when>
                <xsl:otherwise>{merge:entry(., 'Planned start date')}</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="end-date">
              <xsl:choose>
                <xsl:when test="merge:entry(., 'Budget end date')!=''">{merge:entry(., 'Budget end date')}</xsl:when>
                <xsl:when test="merge:entry(., 'Actual end date')!=''">{merge:entry(., 'Actual end date')}</xsl:when>
                <xsl:otherwise>{merge:entry(., 'Planned end date')}</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <period-start iso-date="{merge:date($start-date)}"/>
            <period-end iso-date="{merge:date($end-date)}"/>
            <value value-date="{merge:date($start-date)}" currency="{(merge:entry(., 'Currency'), merge:currency-symbol(merge:entry(., 'Amount')), 'EUR')[1]}">{merge:currency-value(merge:entry(., ('Budget', 'Total Budget')))}</value>
          </budget>
        </xsl:if>
        
        <!-- Policy marker may be in the project file -->
        <xsl:if test="merge:entry(., 'Policy marker') != ''">
          <policy-marker significance="{merge:entry(., ('Policy significance', 'Significance'))}"
            code="{merge:entry(., 'Policy marker')}"
            vocabulary="1"/>
        </xsl:if>
        
        <related-activity ref="{merge:entry(., 'IATI parent activity identifier')}" type="1"/>
        
        <collaboration-type code="{merge:entry(., 'Collaboration type')}"/>
        <default-flow-type code="{merge:entry(., 'Default flow type')}"/>
        <default-finance-type code="{merge:entry(., 'Default finance type')}"/>
        <default-aid-type code="{merge:entry(., 'Default aid type')}"/>
        <default-tied-status code="{merge:entry(., 'Default tied status')}"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>

  <!--  Budgets: -->
  <xsl:template match="record[starts-with($file, 'Budgets')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <budget status="{merge:entry(., 'Budget status')}" type="{merge:entry(., 'Budget type')}">
          <period-start iso-date="{merge:date(merge:entry(., 'Budget start date'))}"/>
          <period-end iso-date="{merge:date(merge:entry(., 'Budget end date'))}"/>
          <value value-date="{(merge:date(merge:entry(., 'Value date')), merge:date(merge:entry(., 'Budget start date')))[1]}" currency="{merge:entry(., 'Currency')}">{merge:decimal(merge:entry(., 'Budget'))}</value>
        </budget>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Policy markers: -->
  <xsl:template match="record[starts-with($file, 'Policy')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <policy-marker significance="{merge:entry(., ('Significance', 'Policy significance'))}" code="{merge:entry(., 'Policy marker')}" vocabulary="1"/>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Sectors: -->
  <xsl:template match="record[starts-with($file, 'Sectors')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier'), $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <sector percentage="{merge:decimal(merge:entry(., 'Budget percentage'))}" code="{merge:entry(., 'Sector code')}" vocabulary="{(merge:entry(., ('Sector vocabulary', 'Sector vocabulaire')))[1]}">
          <narrative>{merge:entry(., 'Sector name')}</narrative>
        </sector>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Transactions: -->
  <xsl:template match="record[starts-with($file, 'Transactions')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <transaction ref="{merge:entry(., 'Reference')}">
          <transaction-type code="{entry[@name=('Type', 'Transaction Type Code')]}"/>
          <transaction-date iso-date="{merge:date(merge:entry(., 'Date'))}" />
          <value value-date="{(merge:date(merge:entry(., 'Value date')), merge:date(merge:entry(., 'Date')))[1]}" currency="{(merge:entry(., 'Currency'), merge:currency-symbol(merge:entry(., 'Amount')))[1]}">{merge:currency-value(merge:entry(., 'Amount'))}</value>
          <description>
            <narrative>{merge:entry(., 'Description')}</narrative>
          </description>
          <xsl:if test="merge:entry(., 'Provider organisation')!='' or merge:entry(., 'Provider organisation identifier')!=''">
            <provider-org ref="{merge:entry(., 'Provider organisation identifier')}" provider-activity-id="{merge:entry(., 'Provider activity identifier')}" type="{merge:entry(., ('Provider organisation type', 'Provider organization type'))}">
              <narrative>{merge:entry(., 'Provider organisation')}</narrative>
            </provider-org>            
          </xsl:if>
          <xsl:if test="merge:entry(., 'Receiver organisation')!='' or merge:entry(., 'Receiver organisation identifier')!=''">
            <receiver-org ref="{merge:entry(., 'Receiver organisation identifier')}" receiver-activity-id="{merge:entry(., 'Receiver activity identifier')}" type="{merge:entry(., ('Receiver organisation type', 'Receiver organization type'))}">
              <narrative>{merge:entry(., 'Receiver organisation')}</narrative>
            </receiver-org>
          </xsl:if>
        </transaction>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Results: -->
  <xsl:template match="record[starts-with($file, 'Results')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <result
          type="{merge:entry(., 'Result type')}"
          merge:id="{merge:entry(., 'Result title')}">
          <xsl:if test="merge:entry(., 'Aggregation status') != ''"><xsl:attribute name="aggregation-status">{merge:boolean(merge:entry(., 'Aggregation status'))}</xsl:attribute></xsl:if>
          <title>
            <narrative>{merge:entry(., 'Result title')}</narrative>
          </title>
          <description>
            <narrative>{merge:entry(., 'Result description')}</narrative>
          </description>
          
          <indicator
            merge:id="{merge:entry(., 'Indicator title')}"
            measure="{merge:entry(., 'Indicator measure')}">
            <!--ascending="true">-->
            <xsl:if test="merge:entry(., 'Indicator reference')!=''">
              <reference vocabulary="99" code="{merge:entry(., 'Indicator reference')}"/>
            </xsl:if>
            
            <title>
              <narrative>{merge:entry(., 'Indicator title')}</narrative>
            </title>
            <description>
              <narrative>{merge:entry(., 'Indicator description')}</narrative>
            </description>
            
            <xsl:if test="merge:entry(., 'Baseline year')!=''">
              <baseline year="{merge:entry(., 'Baseline year')}" value="{merge:decimal(merge:entry(., 'Baseline'))}">
                <comment>
                  <narrative>{merge:entry(., 'Baseline comment')}</narrative>
                </comment>
              </baseline>
            </xsl:if>
            
            <xsl:if test="merge:entry(., 'Start date')!=''">
              <period>
                <period-start iso-date="{merge:date(merge:entry(., 'Start date'))}"/>
                <period-end iso-date="{merge:date(merge:entry(., 'End date'))}"/>
                <xsl:if test="merge:entry(., 'Target')!='' or merge:entry(., 'Target comment')!=''">
                  <target value="{merge:decimal(merge:entry(., 'Target'))}">
                    <comment>
                      <narrative>{merge:entry(., 'Target comment')}</narrative>
                    </comment>
                  </target>
                </xsl:if>
                <xsl:if test="merge:entry(., 'Actual')!='' or merge:entry(., 'Actual comment')">
                  <actual value="{merge:decimal(merge:entry(., 'Actual'))}">
                    <comment>
                      <narrative>{merge:entry(., 'Actual comment')}</narrative>
                    </comment>
                  </actual>
                </xsl:if>
              </period>
            </xsl:if>
          </indicator>
        </result>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Geo: -->
  <xsl:template match="record[starts-with($file, 'Countries')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <xsl:choose>
          <xsl:when test="merge:entry(., 'Country code')!=''">
            <recipient-country code="{merge:entry(., 'Country code')}" percentage="{merge:decimal(merge:entry(., 'Budget percentage'))}">
              <xsl:if test="merge:entry(., 'Country name')!=''">
                <narrative>{merge:entry(., 'Country name')}</narrative>
              </xsl:if>
            </recipient-country>
          </xsl:when>
          <xsl:when test="merge:entry(., 'Region code')!=''">
            <recipient-region code="{merge:entry(., 'Region code')}" percentage="{merge:decimal(merge:entry(., 'Budget percentage'))}">
              <xsl:if test="merge:entry(., 'Region name')!=''">
                <narrative>{merge:entry(., 'Region name')}</narrative>
              </xsl:if>
            </recipient-region>
          </xsl:when>          
        </xsl:choose>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  
  <!--  Participating: -->
  <xsl:template match="record[starts-with($file, 'Participating')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier')[1], $reporting-org)">
      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <participating-org role="{merge:entry(., ('Role', 'Organisation Role'))}" type="{merge:entry(., ('Type', 'Organisation Type'))}" ref="{merge:entry(., 'Organisation identifier')}" activity-id="{merge:entry(., 'Activity identifier')}">
          <narrative>{merge:entry(., 'Organisation name')}</narrative>
        </participating-org>
      </iati-activity>
    </xsl:if>
  </xsl:template>
  
  <!--  Documents: -->
  <xsl:template match="record[starts-with($file, 'Documents') or ends-with($file, 'Documents')]">
    <xsl:if test="starts-with(merge:entry(., 'IATI activity identifier'), $reporting-org)">
      
      <!-- Replace Google Drive sharing links (open a preview page) with direct download links -->
      <xsl:variable name="url" select="replace(
        replace(merge:entry(., 'Web address'), 
          '^https://drive.google.com/open\?id=(.+)', 
          'https://drive.google.com/uc?export=download&amp;id=$1'),
        
        '^https://drive.google.com/file/d/(.+)/view\?usp=sharing', 
        'https://drive.google.com/uc?export=download&amp;id=$1')"/>

      <iati-activity merge:id="{merge:entry(., 'IATI activity identifier')}">
        <document-link format="{merge:format(merge:entry(., 'Format'))}" url="{$url}">
          <title>
            <narrative><xsl:value-of select="merge:entry(., 'Document title')"/></narrative>
          </title>
          <description>
            <narrative><xsl:value-of select="merge:entry(., 'Document description')"/></narrative>
          </description>
          <category code="{merge:entry(., 'Category')}"/>
          <xsl:if test="merge:entry(., 'Document language')!=''">
            <language code="{merge:entry(., 'Document language')}" />
          </xsl:if>
          <document-date iso-date="{merge:date(merge:entry(., 'Document date'))}" />
        </document-link>
      </iati-activity>          
    </xsl:if>
  </xsl:template>  
</xsl:stylesheet>