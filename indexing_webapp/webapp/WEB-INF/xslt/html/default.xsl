<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY application-version SYSTEM "../../version.ent">
]>
<!--
  Global template invoked by Berlioz
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ps="http://www.pageseeder.com/editing/2.0"
                xmlns:bf="http://weborganic.org/Berlioz/XSLT/Function"
                exclude-result-prefixes="#all">

<!-- Common stylesheets -->
<xsl:import href="default/_frame.xsl"/>
<xsl:import href="default/_search-results-html.xsl"/>

<!-- By convention, we organise by [group]/[service].xsl -->
<xsl:import href="default/search.xsl"/>
<xsl:import href="default/browse.xsl"/>
<xsl:import href="default/autosuggest.xsl"/>

<!-- General Output properties. -->
<xsl:output method="html" encoding="utf-8" indent="yes" undeclare-prefixes="no" media-type="text/html" />

<!--
  Main template called in all cases.
-->
<xsl:template match="/root">
<!-- Display the HTML Doctype -->
<xsl:text disable-output-escaping="yes"><![CDATA[<!doctype html>
]]></xsl:text>
<html lang="en">
<head>
  <title>Movies Search Tool</title>
  <xsl:apply-templates select="." mode="style"/>
</head>
<body class="page-{@service} bz-service-{@service}">
  <header class="header">
    <div class="row header-inner">
      <div class="medium-12 columns">
        <h1>Movies Search Tool</h1>
        <h2>an example of flint implementation</h2>
      </div>
    </div>
    <div class="row">
      <div class="small-12 columns">
        <div class="nav-wrapper">
          <xsl:apply-templates select="." mode="navigation"/>
        </div>
      </div>
    </div>
  </header>
  <main class="main">
    <div class="row">
      <div class="small-12 columns">
        <div class="article-wrapper">
          <article>
            <xsl:apply-templates select="//content[@target='main']" mode="content"/>
          </article>
        </div>
      </div>
    </div>
  </main>
  <footer class="footer" role="contentinfo">
    <div class="row">
      <div class="small-12 columns text-center">
        <p>Movies Search Tool</p>
      </div>
    </div>
  </footer>
  <xsl:apply-templates select="." mode="script"/>
</body>
</html>
</xsl:template>

<!--
  Display the primary navigation (displayed just under the header)
-->
<xsl:template match="root[@group='default']" mode="navigation">
<xsl:variable name="service"  select="@service"/>
<xsl:variable name="pathinfo" select="header/path"/>
<nav class="primary-nav">
  <ul>
    <li>
      <xsl:if test="$service = 'search'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
      <a href="/search.html">Search</a>
    </li>
    <li>
      <xsl:if test="$service = 'browse'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
      <a href="/browse.html">Browse</a>
    </li>
    <li>
      <xsl:if test="$service = 'autosuggest'"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
      <a href="/autosuggest.html">Autosuggest</a>
    </li>
  </ul>
</nav>
</xsl:template>

</xsl:stylesheet>
