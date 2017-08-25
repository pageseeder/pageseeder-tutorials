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

<xsl:template match="content[@name='browse-search-solr']" mode="content">
  <h2>Browse index</h2>
  <div class="row collapse">
    <div class="small-4 columns facets">
      <xsl:call-template name="solr-facets">
        <xsl:with-param name="facets" select="index-search/facets/facet" />
      </xsl:call-template>
    </div>
    <div class="small-8 columns">
      <div class="results">
        <xsl:apply-templates select="." mode="search-results-html" />
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template name="solr-facets">
  <xsl:param name="facets" />
  <xsl:variable name="selected-facets" select="tokenize(//http-parameters/parameter[@name = 'with'], ',')" />
  
  <h3>Facets</h3>
  <xsl:for-each select="$facets">
    <div class="facet-values">
      <div class="field"><xsl:value-of select="replace(@name, '^prop_', '')" /></div>
      <ul class="values">
        <xsl:for-each select="term[not(@cardinality = '0')]">
          <xsl:sort select="if (normalize-space(@text) = '') then 'zzzzzzzzzzzzzzzzzz' else @text" />
          <xsl:variable name="selected" select="$selected-facets[string(.) = concat(current()/@field, ':&quot;', current()/@text, '&quot;')]" />
          <li data-field="{@field}" data-value="{@text}">
            <xsl:if test="$selected"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
            <xsl:variable name="with" select="string-join($selected-facets[not(starts-with(., concat(current()/@field, ':')))], ',')" />
            <xsl:variable name="me"   select="if ($selected) then '' else concat(if (string($with) = '') then '' else ',', @field, ':&quot;', encode-for-uri(@text), '&quot;')"/>
            <a href="/solr/browse.html?with={$with}{$me}">
              <xsl:choose>
                <xsl:when test="normalize-space(@text) = ''"><i>(empty string)</i></xsl:when>
                <xsl:otherwise><xsl:value-of select="@text" /></xsl:otherwise>
              </xsl:choose>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="@cardinality" />
              <xsl:text> value</xsl:text>
              <xsl:value-of select="if (@cardinality = '1') then '' else 's'" />
              <xsl:text>)</xsl:text>
            </a>    
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
