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

<xsl:template match="content" mode="search-results-html">
  <xsl:if test="index-search/search-results">
    <section id="search-results">
      <h3>Search Results</h3>
      <xsl:choose>
        <xsl:when test="not(index-search/search-results/documents/document)">
          <p>No results from search <code><xsl:value-of select="index-search/search-results/query/@lucene" /></code>.</p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="with">
            <xsl:variable name="params" select="index-search/search-results/query//parameters/term-parameter" />
            <xsl:if test="$params">
              <xsl:text> with facets </xsl:text>
              <xsl:for-each select="$params">
                <xsl:choose>
                  <xsl:when test="position() = 0" />
                  <xsl:when test="position() = last()"> and </xsl:when>
                  <xsl:when test="position() != 0">, </xsl:when>
                </xsl:choose>
                <code><xsl:value-of select="field"/>:<xsl:value-of select="text"/></code>
              </xsl:for-each>
            </xsl:if>
          </xsl:variable>
          <p>Found <xsl:value-of select="index-search/search-results/metadata/hits/total" /> results<xsl:value-of select="$with" />.</p>
          <xsl:if test="index-search/search-results/metadata/hits[number(total) gt number(per-page)]">
            <xsl:variable name="current" select="number(index-search/search-results/metadata/page/current)" />
            <xsl:variable name="total"   select="number(index-search/search-results/metadata/page/last)" />
            <ul class="pagination">
              <xsl:for-each select="xs:integer(max((1, $current - 3))) to xs:integer(min(($current + 3, $total)))">
                <li class="page{if (. = $current) then ' current' else ''}">
                  <a href="#" data-page="{.}"><xsl:value-of select="." /></a>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
          <ol class="results">
            <xsl:apply-templates select="index-search/search-results/documents" mode="html" />
          </ol>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:if>
</xsl:template>

<xsl:template match="document" mode="html">
  <xsl:param name="expand" select="false()" tunnel="yes" />
  <li class="result">
    <ul class="details">
      <li class="title"><xsl:value-of select="field[@name = 'title']" /></li>
      <li><xsl:value-of select="concat(field[@name = 'year'], ', ', field[@name = 'country'])" /></li>
      <li><label>Genre: </label><xsl:value-of    select="string-join(field[@name = 'genre'],    '/')" /></li>
      <li><label>Director: </label><xsl:value-of select="string-join(field[@name = 'director'], ', ')" /></li>
      <li><label>Cast: </label><xsl:value-of     select="string-join(field[@name = 'actor'],    ', ')" /></li>
    </ul>
    <img src="{field[@name = 'image']}" width="120" />
    <div class="film-title"><xsl:value-of select="bf:document-title(.)" /></div>
  </li>
</xsl:template>

<xsl:function name="bf:document-title">
  <xsl:param name="doc" as="element(document)" />
  <xsl:choose>
    <xsl:when test="$doc/field[@name = 'title']"><xsl:value-of select="$doc/field[@name = 'title']" /></xsl:when>
    <xsl:when test="$doc/field[@name = 'name' ]"><xsl:value-of select="$doc/field[@name = 'name']" /></xsl:when>
    <xsl:otherwise><xsl:value-of select="$doc/field[@name = '_path']" /></xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>