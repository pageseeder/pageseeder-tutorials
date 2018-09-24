<?xml version="1.0"?>
<!--
  This stylesheet can be used to convert film data into PSML.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output encoding="utf-8" method="text" media-type="text/plain" />
  
  <!-- Create one file per film -->
  <xsl:template match="/">
    <xsl:for-each select="//film">
     <xsl:variable name="path" select="concat('film-',position(),'.psml')" />
    <!-- List films for checking -->
    <xsl:value-of select="$path"/><xsl:text> = </xsl:text><xsl:value-of select="title"/><xsl:text>&#xA;</xsl:text>
     <xsl:result-document href="{$path}" method="xml" indent="yes">
       <xsl:apply-templates select="."/>
     </xsl:result-document>
    </xsl:for-each>
    <!-- Output total for checking -->
    <xsl:text>Converted </xsl:text><xsl:value-of select="count(//film)"/><xsl:text> films.</xsl:text>
  </xsl:template>
  
  <!-- Film document -->
  <xsl:template match="film">
    <document type="film" level="portable" >
      <documentinfo>
        <uri title="{title}" />
      </documentinfo>
        
      <section id="title">
        <fragment id="1">
          <heading level="1"><xsl:value-of select="title"/></heading>
        </fragment>
      </section>
        
      <section id="details">
        <properties-fragment id="2">
          <property name="year" title="Year" value="{substring-before(released,'-')}" />
          <property name="classification" title="Classification" value="{rating}" />
          <property name="genre" title="Genre" count="n">
            <xsl:for-each select="tokenize(genre,',')">
              <value><xsl:value-of select="normalize-space(.)"/></value>
            </xsl:for-each>
          </property>
          <property name="country" title="Country" value="{country}" />
          <property name="director" title="Director" count="n">
            <xsl:for-each select="distinct-values(.//director/name)">
              <value><xsl:value-of select="."/></value>
            </xsl:for-each>
          </property>
          <property name="producer" title="Producer" count="n">
            <xsl:for-each select="distinct-values(.//producer/name)">
              <value><xsl:value-of select="."/></value>
            </xsl:for-each>
          </property>
          <property name="writer" title="Writer" count="n">
            <xsl:for-each select="distinct-values(.//writer/name)">
              <value><xsl:value-of select="."/></value>
            </xsl:for-each>
          </property>
          <property name="actor" title="Actor" count="n">
            <xsl:for-each select="distinct-values(.//actor/name)">
              <value><xsl:value-of select="."/></value>
            </xsl:for-each>
          </property>
        </properties-fragment>
      </section>

      <section id="summary" title="Summary">
        <fragment id="3">
          <xsl:apply-templates select="summary/p" />
        </fragment>
      </section>

      <section id="image" title="Image">
        <fragment id="5">
          <xsl:if test="image">
            <image src="images/{image}" />
          </xsl:if>
        </fragment>
      </section>
    </document>
  </xsl:template>

  <!-- paragraphs -->
  <xsl:template match="p">
    <para>
      <xsl:apply-templates />
    </para>
  </xsl:template>

  <!-- Directors -->
  <xsl:template match="director">
    <inline label="director">
      <xsl:value-of select="name" />
    </inline>
  </xsl:template>

  <!-- Producers -->
  <xsl:template match="producer">
    <inline label="producer">
      <xsl:value-of select="name" />
    </inline>
  </xsl:template>

  <!-- Writers -->
  <xsl:template match="writer">
    <inline label="writer">
      <xsl:value-of select="name" />
    </inline>
  </xsl:template>

  <!-- Actors -->
  <xsl:template match="actor">
    <inline label="actor">
      <xsl:value-of select="name" />
    </inline>
  </xsl:template>
  
</xsl:stylesheet>
