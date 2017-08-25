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

<xsl:variable name="results" select="//header/http-parameters/parameter[@name='results']" />
<xsl:variable name="index"   select="if (//uri-parameters/parameter[@name='index']) then //uri-parameters/parameter[@name='index'] else 'films'" />

<xsl:template match="content[@name='search-catalog']" mode="content"/>
<xsl:template match="content[@name='basic-search']" mode="content">
  <div class="row collapse">
    <div class="small-12 columns search">
      <h2>Search index: <a
        href="#search-films" class="toggle-search{if ($index = 'films') then ' selected' else ''}">films</a> | <a
        href="#search-bios"  class="toggle-search{if ($index = 'bios' ) then ' selected' else ''}">bios</a></h2>
      <xsl:variable name="searched" select="index-search/basic-query/base/*" />
      <xsl:call-template name="search-form">
        <xsl:with-param name="name">films</xsl:with-param>
        <xsl:with-param name="fields"         select="../content[@name='search-films-catalog']/catalog/field[@tokenized = 'true'][not(starts-with(@name, '_'))]" />
        <xsl:with-param name="selected-field" select="if ($searched/field) then $searched/field else 'fulltext'" />
        <xsl:with-param name="searched-term"  select="$searched/text" />
      </xsl:call-template>
      <xsl:call-template name="search-form">
        <xsl:with-param name="name">bios</xsl:with-param>
        <xsl:with-param name="fields"         select="../content[@name='search-bios-catalog']/catalog/field[@tokenized = 'true'][not(starts-with(@name, '_'))]" />
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
  <xsl:param name="name" />
  <xsl:param name="fields" />
  <xsl:param name="selected-field" select="'fulltext'" />
  <xsl:param name="searched-term" />
  <form id="search-{$name}" class="search-form{if ($index != $name) then ' hidden' else ''}"
        method="GET" action="/lucene/{$name}/search.html">
    <input type="hidden" name="results" value="{if ($results) then $results else '20'}" />
    <div class="row collapse search">
      <div class="small-3 columns">
        <label>Field</label>
        <select name="field">
          <xsl:for-each select="$fields">
            <option value="{@name}">
              <xsl:if test="@name = $selected-field"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>
              <xsl:value-of select="$name" />&#160;<xsl:value-of select="@name" />
            </option>
          </xsl:for-each>
        </select>
      </div>
      <div class="small-4 columns">
        <label>Term</label>
        <input type="text" class="term" name="term" value="{$searched-term}" />
      </div>
      <div class="small-1 columns end">
        <label>&#160;</label>
        <button class="button" type="submit">Go</button>
      </div>
    </div>
  </form>
</xsl:template>

</xsl:stylesheet>
