<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:iati-me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="">

  <xsl:import href="../lib/functx.xslt"/>
  <xsl:import href="../lib/htdocs/bootstrap.xslt"/>
  <xsl:import href="../lib/iati.me/feedback.xslt"/>
  <xsl:variable name="categories" select="$feedback-meta/iati-me:categories/iati-me:category"/>

  <xsl:template match="/" mode="html-body">
    <!-- <nav class="navbar navbar-inverse navbar-fixed-top"> -->
    <nav class="navbar navbar-inverse">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li><a href="iati-activities.list.html">Home</a></li>
            <li><a href="iati-activities.gantt.html">Results overview</a></li>
            <li><a href="iati-activities.summary.html">Quality feedback</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>

    <div class="container-fluid" role="main">

    <h1>IATI Data Quality Feedback</h1>

    <xsl:for-each-group select="//iati-activity" group-by="reporting-org/@ref">
      <!-- <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='danger'])"/>
      <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='warning'])"/>
      <xsl:sort order="descending" select="count(current-group()//iati-me:feedback[@type='info'])"/>
      <xsl:sort order="ascending" select="count(current-group()//iati-me:feedback[@type='success'])"/> -->
      <xsl:sort select="lower-case((current-group()/reporting-org/(narrative,.)[1])[1])"/>

      <xsl:variable name="orgName" select="(current-group()/reporting-org/(narrative,.)[1])[1]"/>
      <xsl:variable name="feedback" select="current-group()//iati-me:feedback"/>
      <xsl:variable name="orgActivities" select="current-group()"/>

      <div class="panel panel-default">
        <div class="panel-heading">
          <h3><xsl:value-of select="$orgName"/></h3>
        </div>

        <div class="panel-body collapse-group">
          <div class="row">
            <div class="col-md-3">
              <h4>Number of comments per severity  <span class="badge"># activities</span></h4>
              <p>Click on a severity to hide/show comments</p>
              <ul class="list-group">
                <xsl:for-each select="$feedback-meta/iati-me:severities/iati-me:severity">
                  <xsl:variable name="type" select="@type"/>
                  <xsl:variable name="activities" select="count(current-group()[.//iati-me:feedback[@type=$type]])"/>
                  <xsl:variable name="comments" select="count($feedback[@type=$type])"/>

                  <xsl:if test="$comments > 0">
                    <li data-toggle="collapse" aria-label="Collapse">
                      <xsl:attribute name="class">list-group-item list-group-item-<xsl:value-of select="$type"/></xsl:attribute>
                      <xsl:attribute name="data-target">.toggle-<xsl:value-of select="$type"/></xsl:attribute>

                      <span class="badge"><xsl:value-of select="$activities"/></span>

                      <span>
                        <xsl:attribute name="class">label label-<xsl:value-of select="$type"/></xsl:attribute>
                        <xsl:value-of select="$comments"/>
                      </span>
                      <xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="$comments = 1"> <xsl:value-of select="."/></xsl:when>
                        <xsl:otherwise> <xsl:value-of select="."/>s</xsl:otherwise>
                      </xsl:choose>
                    </li>
                  </xsl:if>
                </xsl:for-each>

                <xsl:variable name="nocomments" select="count(current-group()[not(.//iati-me:feedback)])"/>
                <xsl:if test="$nocomments > 0">
                  <li class="list-group-item list-group-item-success">
                    <span class="badge"><xsl:value-of select="$nocomments"/></span>
                    <span class="label label-success"><span class="glyphicon glyphicon-ok" aria-hidden="true"/></span>
                    <xsl:text> </xsl:text>
                    No comments
                  </li>
                </xsl:if>

                <xsl:variable name="nocomments" select="count(current-group()[not(.//iati-me:feedback)])"/>
                <xsl:if test="$nocomments > 0">
                  <li class="list-group-item">
                    <span class="badge"><xsl:value-of select="count(current-group())"/></span>

                    <span class="label label-primary">
                      <xsl:value-of select="count($feedback)"/>
                    </span>
                    <xsl:choose>
                      <xsl:when test="count($feedback) = 1"> Comment</xsl:when>
                      <xsl:otherwise> Comments in total</xsl:otherwise>
                    </xsl:choose>
                  </li>
                </xsl:if>
              </ul>

              <h4>Number of comments per type</h4>
              <ul class="list-group">
                <xsl:for-each select="$feedback-meta/iati-me:severities/iati-me:severity">
                  <xsl:variable name="type" select="@type"/>

                  <xsl:for-each-group select="$feedback[@type=$type]" group-by="@id">
                    <xsl:sort select="count(current-group())" order="descending"/>

                    <xsl:variable name="id" select="current-group()/@id[1]"/>
                    <xsl:variable name="activities" select="count($orgActivities[.//iati-me:feedback[@id=$id]])"/>

                    <li>
                      <xsl:attribute name="class">list-group-item list-group-item-<xsl:value-of select="$type"/></xsl:attribute>

                      <span class="badge"><xsl:value-of select="$activities"/></span>

                      <span>
                        <xsl:attribute name="class">label label-<xsl:value-of select="$type"/></xsl:attribute>
                        <xsl:value-of select="count(current-group())"/>
                      </span>
                      <xsl:text> </xsl:text>

                      <strong><xsl:value-of select="@class[1]"/>: </strong>
                      <xsl:value-of select="data(current-group()[1])"/>
                    </li>
                  </xsl:for-each-group>
                </xsl:for-each>
              </ul>

              <h4>Number of comments per category</h4>
              <ul class="list-group">
                <xsl:for-each-group select="$feedback" group-by="(@src,'n/a')[1]">
                  <xsl:sort select="count(current-group())" order="descending"/>
                  <xsl:variable name="src" select="(@src,'n/a')[1]"/>
                  <li class="list-group-item">
                    <span class="label label-primary pull-right">
                      <xsl:value-of select="count(current-group())"/>
                    </span>
                    <xsl:value-of select="$feedback-meta/iati-me:sources/iati-me:source[@src=$src]"/>
                    <xsl:apply-templates select="$feedback-meta/iati-me:sources/iati-me:source[@src=$src]/@logo"/>
                  </li>
                </xsl:for-each-group>
              </ul>
            </div>

            <div class="col-md-9">
              <button type="button" class="btn btn-default showdetails" data-toggle="collapse">
                <xsl:attribute name="data-target">#<xsl:value-of select="current-grouping-key()"/></xsl:attribute>
                Show/hide activities with comments
              </button>

              <div class="panel panel-default collapse in">
                <xsl:attribute name="id"><xsl:value-of select="current-grouping-key()"/></xsl:attribute>
                <div class="panel-body">
                  <table class="table table-condensed details feedback-list">
                    <xsl:apply-templates select="current-group()[//iati-me:feedback]"/>
                  </table>
                  <button type="button" class="btn btn-default" data-toggle="collapse">
                    <xsl:attribute name="data-target">#<xsl:value-of select="current-grouping-key()"/></xsl:attribute>
                    Hide activities
                  </button>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>

    </xsl:for-each-group>
    </div>
  </xsl:template>

  <xsl:template match="iati-activity">
      <thead>
        <tr>
          <th>
            <h3>
              <xsl:if test="count(descendant::iati-me:feedback[@type='danger'])>0">
                <span class="label label-danger"><xsl:value-of select="count(descendant::iati-me:feedback[@type='danger'])"/> </span>
              </xsl:if>
              <xsl:if test="count(descendant::iati-me:feedback[@type='warning'])>0">
                <span class="label label-warning"><xsl:value-of select="count(descendant::iati-me:feedback[@type='warning'])"/> </span>
              </xsl:if>
              <xsl:if test="count(.//iati-me:feedback[@type='info'])>0">
                <span class="label label-info"><xsl:value-of select="count(.//iati-me:feedback[@type='info'])"/> </span>
              </xsl:if>
              <xsl:if test="count(.//iati-me:feedback[@type='success'])>0">
                <span class="label label-success"><xsl:value-of select="count(.//iati-me:feedback[@type='success'])"/> </span>
              </xsl:if>
              <xsl:if test="count(.//iati-me:feedback) = 0">
                <span class="label label-success"><span class="glyphicon glyphicon-ok" aria-hidden="true"/> </span>
              </xsl:if>
              <xsl:value-of select="title[1]"/>
              <small>
                <a target="_blank">
                  <xsl:attribute name="href" select="concat(encode-for-uri(iati-identifier[1]), '.html')"/><code><xsl:value-of select="functx:trim(string-join(iati-identifier/text(),''))"/></code>
                </a>
              </small>
            </h3>
          </th>
        </tr>
      </thead>
      <xsl:for-each-group select="descendant::iati-me:feedback" group-by="@class">
        <xsl:sort select="count(current-group())" order="descending"/>
        <xsl:for-each-group select="current-group()" group-by="@type">
          <tbody>
            <xsl:attribute name="class">
              toggle-<xsl:value-of select="@type"/> collapse in
            </xsl:attribute>
            <xsl:apply-templates select="current-group()"/>
          </tbody>
        </xsl:for-each-group>
      </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="iati-me:feedback">
    <xsl:variable name="src" select="@src"/>
    <xsl:variable name="class" select="@class"/>
    <tr>
      <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
      <td>
        <div class="context">
          <span class="pull-right">
            <xsl:apply-templates select="@href"/>
            <xsl:apply-templates select="$feedback-meta/iati-me:sources/iati-me:source[@src=$src]/@logo"/>
          </span>
          <span class="feedback-class">
            <xsl:value-of select="$feedback-meta/iati-me:categories/iati-me:category[@class=$class]/iati-me:title"/>:
          </span>
          <xsl:apply-templates select="." mode="context"/>
          <xsl:copy-of select="*|text()"/>
        </div>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
