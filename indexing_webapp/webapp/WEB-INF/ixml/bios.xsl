<?xml version="1.0"?> 
<!--
  The stylesheet to generate an Indexable document from source film PSML.

  @author Jean-Baptiste Reure
  @version 9 December 2015
-->
<xsl:stylesheet version="2.0" xmlns:idx="http://weborganic.com/Berlioz/Index"
                              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:ps="http://www.pageseeder.com/editing/2.0"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
                              exclude-result-prefixes="idx ps xs">

<!-- Standard output for Flint Documents 5.0 -->
<xsl:output method="xml" indent="no" encoding="utf-8"
            doctype-public="-//Flint//DTD::Index Documents 5.0//EN"
            doctype-system="https://pageseeder.org/schema/flint/index-documents-5.0.dtd"/>

<xsl:param name="_filename" />

<!-- Matches the root -->
<xsl:template match="/">
<!-- if not in version copy folder then index -->
 <documents version="5.0">
    <!-- Content-specific -->
    <xsl:apply-templates select="document" />
 </documents>
</xsl:template>

<xsl:template match="document">
  <document>
    <field name="uriid" tokenize="false"><xsl:value-of select="/document/documentinfo/uri/@id"/></field>
    <field name="index" tokenize="false"><xsl:value-of select="replace($_filename, '(bio-|\.psml)', '')"/></field>
    <field name="type"  tokenize="false"><xsl:value-of select="@type"/></field>
    <field name="title" tokenize="true"><xsl:value-of select="(.//heading)[1]"/></field>
    <field name="search-name" tokenize="true"><xsl:value-of select="string-join(.//property[@name = 'common-name' or @name = 'full-name']/@value, ' ')"/></field>
    <!-- use sections -->
    <xsl:apply-templates select="section" />
  </document>
</xsl:template>

<!-- Details -->
<xsl:template match="section[@id='details']">
  <xsl:for-each select="properties-fragment/property">
    <xsl:choose>
      <xsl:when test="value">
        <xsl:variable name="field" select="@name" />
        <xsl:for-each select="value">
          <field name="prop_{$field}" tokenize="false"><xsl:value-of select="."/></field>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <field name="prop_{@name}" tokenize="false"><xsl:value-of select="@value"/></field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- About -->
<xsl:template match="section[@id='summary']">
  <field name="summary" store="true"><xsl:value-of select="string(.)" /></field>
</xsl:template>

<!-- Image -->
<xsl:template match="section[@id='image']">
  <xsl:if test=".//image">
    <field name="image" tokenize="false">/content/bios/<xsl:value-of select="(.//image)[1]/@src" /></field>
  </xsl:if>
</xsl:template>

<!-- Links -->
<xsl:template match="section[@id='wiki']">
  <xsl:if test=".//link">
    <field name="wiki-link" tokenize="false"><xsl:value-of select="(.//link)[1]/@href" /></field>
  </xsl:if>
</xsl:template>

<!-- Ignore other sections -->
<xsl:template match="section" />

</xsl:stylesheet>
