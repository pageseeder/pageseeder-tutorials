<?xml version="1.0"?>
<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:saxon="http://saxon.sf.net/"
               exclude-result-prefixes="#all">

  <xsl:output indent="yes" method="xml" encoding="utf-8" />
  <xsl:param name="_output" select="''" />
  <xsl:template match="workbook|worksheet" />

  <xsl:template match="row">
    <xsl:variable name="title" select="./col[@title='Title']"/>
    <xsl:variable name="year" select="./col[@title='Released']"/>
    <xsl:variable name="filename">
      <xsl:value-of select="$title" />
      <xsl:if test="$year != ''"><xsl:text>-</xsl:text><xsl:value-of select="$year" /></xsl:if>
    </xsl:variable>
    <xsl:variable name="output-file" select="concat($_output, $filename, '.psml')" />
    
    <xsl:result-document href="{$output-file}">
      <document type="film" level="portable">
        <documentinfo>
          <uri title="{$title}">
            <displaytitle><xsl:value-of select="$title"/></displaytitle>
          </uri>
        </documentinfo>
        <section id="title">
          <fragment id="1">
            <heading level="1"><xsl:value-of select="$title"/></heading>
          </fragment>
        </section>
        <section id="details">
          <properties-fragment id="2">
            <property name="year" title="Release Date" value="{$year}" />
            <property name="classification" title="Classification" value="{./col[@title='Rating']}" />
            <property name="genre" title="Genre" value="{./col[@title='Genre']}" />
            <property name="country" title="Country" value="{./col[@title='Country']}" />
            <property name="director" title="Director" value="{./col[@title='Director']}" /> 
          </properties-fragment>          
        </section>      
        <section id="summary" title="Summary">
          <fragment id="3">
            <para><xsl:value-of select="./col[@title='Summary']"/></para>
          </fragment>
        </section>
      </document>    
    </xsl:result-document>
  </xsl:template>               
</xsl:transform>
