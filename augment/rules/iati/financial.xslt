<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx">

<xsl:template match="transaction[provider-org and receiver-org]" mode="rules" priority="7.1">

  <xsl:if test="provider-org/@provider-activity-id eq receiver-org/@receiver-activity-id">
    <iati-me:feedback type="warning" class="financial">
      The <code>provider-activity-id</code> and
      <code>receiver-activity-id</code> are the same: financial flows should be between
      different activities.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="upper-case(transaction-type/@code)=('2','C')
    and provider-org/@provider-activity-id
    and not(receiver-org/@receiver-activity-id)">
    <iati-me:feedback type="warning" class="financial">
      The transaction is a commitment from the activity,
      and has a <code>provider-activity-id</code>
      but no <code>receiver-activity-id</code>.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="upper-case(transaction-type/@code)=('3','D')
    and provider-org/@provider-activity-id
    and not(receiver-org/@receiver-activity-id)">
    <iati-me:feedback type="warning" class="financial">
      The transaction is a disbursement from the activity,
      and has a <code>provider-activity-id</code>
      but no <code>receiver-activity-id</code>.
    </iati-me:feedback>
  </xsl:if>

  <xsl:if test="upper-case(transaction-type/@code)=('4','E')
    and receiver-org/@receiver-activity-id">
    <iati-me:feedback type="warning" class="financial">
      The transaction is an expenditure from the activity,
      but has a <code>receiver-activity-id</code>
      suggesting it may be a disbursement.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>

</xsl:stylesheet>