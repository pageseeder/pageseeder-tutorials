<?xml version="1.0"?>
<!--
  This stylesheet can be used to convert film data into PSML.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output encoding="utf-8" method="text" />
  
  <!-- Create one file per film -->
  <xsl:template match="/">
    <xsl:for-each select="//film">
     <xsl:variable name="path" select="concat('film-',position(),'.psml')" />
     <xsl:result-document href="{$path}" method="xml" indent="yes">
       <xsl:apply-templates select="."/>
     </xsl:result-document>
    </xsl:for-each>
    <!-- output total for checking -->
    <xsl:text>Converted </xsl:text><xsl:value-of select="count(//film)"/><xsl:text> films.</xsl:text>
  </xsl:template>
  
  <!-- film document -->
  <xsl:template match="film">
    <document type="film" level="portable" >
      <documentinfo>
        <uri title="{display_title}" />
      </documentinfo>
        
      <section id="title">
        <fragment id="1">
          <heading level="1"><xsl:value-of select="display_title"/></heading>
        </fragment>
      </section>
        
      <section id="details">
        <properties-fragment id="2">
          <property name="opening_date" title="Opening date" value="{opening_date}" datatype="date" />
          <property name="directed_by" title="Directed by" value="{directed_by}"  />
          <property name="classification" title="Classification" value="{rating}" />
          <property name="genre" title="Genre" count="n">
            <xsl:for-each select="genre">
              <value><xsl:value-of select="."/></value>
            </xsl:for-each>
          </property>
        </properties-fragment>
      </section>

      <section id="about" title="About">
        <fragment id="3">
          <xsl:apply-templates select="about/p" />
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

  <!-- Paragraphs -->
  <xsl:template match="p">
    <para>
      <xsl:apply-templates />
    </para>
  </xsl:template>

  <!-- Actors -->
  <xsl:template match="actor">
    <inline label="actor">
      <xsl:apply-templates />
    </inline>
  </xsl:template>
  
</xsl:stylesheet>
