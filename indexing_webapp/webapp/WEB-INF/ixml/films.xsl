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

<!-- Standard output for Flint Documents 3.0 -->
<xsl:output method="xml" indent="no" encoding="utf-8"
            doctype-public="-//Weborganic//DTD::Flint Index Documents 3.0//EN"
            doctype-system="http://weborganic.org/schema/flint/index-documents-3.0.dtd"/>

<!-- Send by the indexer -->
<xsl:param name="_src"          />
<xsl:param name="_path"         />
<xsl:param name="_filename"     />
<xsl:param name="_visibility"   />
<xsl:param name="_lastmodified" />

<!-- Matches the root -->
<xsl:template match="/">
<!-- if not in version copy folder then index -->
 <documents version="3.0">
    <!-- Content-specific -->
    <xsl:apply-templates select="document" />
 </documents>
</xsl:template>

<xsl:template match="document">
  <document>
    <!-- Common fields -->
    <field name="_src"          tokenize="false" store="false"><xsl:value-of select="$_src"/></field>
    <field name="_path"         tokenize="false"><xsl:value-of select="$_path"/></field>
    <field name="_filename"     tokenize="false"><xsl:value-of select="$_filename"/></field>
    <field name="_lastmodified" tokenize="false"><xsl:value-of select="$_lastmodified"/></field>
    <field name="_visibility"   tokenize="false"><xsl:value-of select="$_visibility"/></field>
    <field name="type"          tokenize="false"><xsl:value-of select="@type"/></field>
    <field name="title"         tokenize="false"><xsl:value-of select="if (.//heading) then (.//heading)[1] else
                                                                       if (documentinfo/uri/@title) then documentinfo/uri/@title else $_filename"/></field>
    <field name="fulltext"      tokenize="true">
      <xsl:value-of select="concat(string-join(section/properties-fragment/property/@value, ' '), ' ',
                                   string-join(section/properties-fragment/property/value, ' '), ' ',
                                   string-join(section/fragment, ' '))"/>
    </field>
    <field name="index" numeric-type="int"><xsl:value-of select="replace($_filename, '(film-|\.psml)', '')"/></field>
    <!-- field used add more weight to american movies -->
    <field name="american-level"><xsl:value-of select="if (.//property[@name = 'country']/@value = 'USA') then 2 else 0" /></field>
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
          <field name="{$field}" tokenize="false"><xsl:value-of select="."/></field>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="xref">
        <xsl:variable name="field" select="@name" />
        <xsl:for-each select="xref">
          <field name="{$field}" tokenize="false"><xsl:value-of select="."/></field>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <field name="{@name}" tokenize="false"><xsl:value-of select="@value"/></field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- About -->
<xsl:template match="section[@id='summary']">
  <field name="summary" store="true"><xsl:value-of select="string(.)" /></field>
</xsl:template>

<!-- Links -->
<xsl:template match="section[@id='image']">
  <xsl:if test=".//image">
    <field name="image" tokenize="false">/content/films/<xsl:value-of select="(.//image)[1]/@src" /></field>
  </xsl:if>
</xsl:template>

<!-- Ignore other sections -->
<xsl:template match="section" />

</xsl:stylesheet>
