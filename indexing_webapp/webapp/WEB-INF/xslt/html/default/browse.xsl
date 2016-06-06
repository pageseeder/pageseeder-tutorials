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

<xsl:template match="content[@name='browse-facets']" mode="content" />
<xsl:template match="content[@name='browse-search']" mode="content">
  <h2>Browse index</h2>
  <div class="row collapse">
    <div class="small-4 columns facets">
      <xsl:call-template name="facets">
        <xsl:with-param name="facets" select="index-search/facets/facet" />
        <xsl:with-param name="values" select="index-search//query//parameters/term-parameter" />
      </xsl:call-template>
    </div>
    <div class="small-8 columns">
      <div class="results">
        <xsl:apply-templates select="." mode="search-results-html" />
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template name="facets">
  <xsl:param name="facets" />
  <xsl:param name="values" select="()" />
  
  <h3>Facets</h3>
  <xsl:for-each select="$facets">
    <div class="facet-values">
      <div class="field"><xsl:value-of select="@name" /></div>
      <ul class="values">
        <xsl:for-each select="term">
          <xsl:sort select="if (normalize-space(@text) = '') then 'zzzzzzzzzzzzzzzzzz' else @text" />
          <xsl:variable name="selected" select="$values[field = current()/@field][text = current()/@text]" />
          <li data-field="{@field}" data-value="{@text}">
            <xsl:if test="$selected"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
              <xsl:variable name="with" select="string-join(for $p in $values[field != current()/@field] return concat($p/field, ':', encode-for-uri($p/text)), ',')" />
              <xsl:variable name="me"   select="if ($selected) then '' else concat(if ($with = '') then '' else ',', @field, ':', encode-for-uri(@text))"/>
              <a href="/browse.html?with={$with}{$me}">
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
