<?xml version="1.0"?>
<!--

  @author Christophe Lauret
  @version 26 September 2011
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:dec="java:java.net.URLDecoder"
                              xmlns:ps="http://www.pageseeder.com/editing/2.0"
                              xmlns:bf="http://weborganic.org/Berlioz/XSLT/Function"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
                              exclude-result-prefixes="xsl ps dec bf xs">

<xsl:template match="content[@name='search-index']" mode="content"/>
<xsl:template match="content[@name='basic-search']" mode="content">
  <h2>Basic search</h2>
  <div class="row collapse">
    <div class="small-12 columns search">
      <xsl:variable name="searched" select="index-search/basic-query/base/term-parameter" />
      <xsl:call-template name="search-form">
        <xsl:with-param name="fields"         select="../content[@name='search-index']//fields/field" />
        <xsl:with-param name="selected-field" select="if ($searched/field) then $searched/field else 'fulltext'" />
        <xsl:with-param name="searched-term"  select="$searched/text" />
      </xsl:call-template>
      <div class="results">
        <xsl:apply-templates select="." mode="search-results-html" />
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template name="search-form">
  <xsl:param name="fields" />
  <xsl:param name="selected-field" select="'fulltext'" />
  <xsl:param name="searched-term" />
  <h3>Search term</h3>
  <form id="search-form" method="GET" action="/search.html">
    <xsl:variable name="results" select="//header/http-parameters/parameter[@name='results']" />
    <input type="hidden" name="results" value="{if ($results) then $results else '20'}" />
    <div class="row collapse search">
      <div class="small-4 columns">
        <label for="field">Field</label>
        <select name="field" id="field">
          <xsl:for-each select="$fields[not(starts-with(., '_'))]">
            <option>
              <xsl:if test=". = $selected-field"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>
              <xsl:value-of select="." />
            </option>
          </xsl:for-each>
        </select>
      </div>
      <div class="small-7 columns">
        <label for="autosuggest">Term</label>
        <input type="text" id="term" class="term" name="term" value="{$searched-term}" />
      </div>
      <div class="small-1 columns">
        <label>&#160;</label>
        <button class="button" type="submit">Go</button>
      </div>
    </div>
  </form>
</xsl:template>

</xsl:stylesheet>
