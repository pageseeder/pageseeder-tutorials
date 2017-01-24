<?xml version="1.0"?>
<!--
  This stylesheet can be used to convert film and bio data into PSML.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:psof="http://www.pageseeder.org/function">

<xsl:output encoding="utf-8" method="text" />

  <xsl:variable name="bios" select="document('wikipediabios.xml')" />
  <xsl:variable name="films" select="/collection" />
  <!-- construct blank bios as place holders -->
  <xsl:variable name="people">
    <people>
      <xsl:for-each select="distinct-values(//film//name/@sort)">
        <bio number="{position()}">
          <name sort="{.}"><xsl:value-of select="($films//name[@sort=current()])[1]" /></name>
        </bio>
      </xsl:for-each>
    </people>
  </xsl:variable>
  
  
  <xsl:template match="/">
    <!-- Create one film file per film -->
    <xsl:for-each select="//film">
      <xsl:variable name="path" select="concat('films/film-',position(),'.psml')" />
      <!-- List films for checking -->
      <xsl:value-of select="$path"/><xsl:text> = </xsl:text><xsl:value-of select="title"/><xsl:text>&#xA;</xsl:text>
      <xsl:result-document href="{$path}" method="xml" indent="yes">
        <xsl:apply-templates select="." mode="film"/>
      </xsl:result-document>
    </xsl:for-each>

    <!-- Create one bio file per person -->
    <xsl:for-each select="$people//bio">
      <xsl:variable name="path" select="concat('bios/bio-',@number,'.psml')" />
      <!-- List people for checking -->
      <xsl:value-of select="$path"/><xsl:text> = </xsl:text><xsl:value-of select="name/@sort"/><xsl:text>&#xA;</xsl:text>
      <xsl:result-document href="{$path}" method="xml" indent="yes">
        <xsl:variable name="bio" select="$bios//bio[name/@sort=current()/name/@sort]" />
        <xsl:choose>
          <!-- when bio found use it -->
          <xsl:when test="$bio">
            <xsl:apply-templates select="$bio" mode="bio"/>
          </xsl:when>
          <!-- otherwise use blank bio -->
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="bio"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>
  
  <!-- ====================== FILM TEMPLATES ====================== -->
  
  <!-- Film document -->
  <xsl:template match="film" mode="film">
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
          <property name="director" title="Director" count="n" datatype="xref">
            <xsl:for-each select="distinct-values(.//director/name/@sort)">
              <xsl:sequence select="psof:bio-xref(.)" />
            </xsl:for-each>
          </property>
          <property name="producer" title="Producer" count="n" datatype="xref">
            <xsl:for-each select="distinct-values(.//producer/name/@sort)">
              <xsl:sequence select="psof:bio-xref(.)" />
            </xsl:for-each>
          </property>
          <property name="writer" title="Writer" count="n" datatype="xref">
            <xsl:for-each select="distinct-values(.//writer/name/@sort)">
              <xsl:sequence select="psof:bio-xref(.)" />
            </xsl:for-each>
          </property>
          <property name="actor" title="Actor" count="n" datatype="xref">
            <xsl:for-each select="distinct-values(.//actor/name/@sort)">
              <xsl:sequence select="psof:bio-xref(.)" />
            </xsl:for-each>
          </property>
        </properties-fragment>
      </section>

      <section id="summary" title="Summary">
        <fragment id="3">
          <xsl:apply-templates select="summary/p" mode="film" />
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
  <xsl:template match="p" mode="film">
    <para>
      <xsl:apply-templates mode="film" />
    </para>
  </xsl:template>

  <!-- director, producers, writers, actors -->
  <xsl:template match="director | producer | writer | actor" mode="film">
    <xsl:sequence select="psof:bio-xref(name/@sort)" />
  </xsl:template>

  <!--
    Returns an xref to a bio
    
    @param name  the sort name of the bio
  -->
  <xsl:function name="psof:bio-xref">
    <xsl:param name="name"/>
    <xsl:variable name="bio" select="$people//bio[name/@sort=$name]" />
    <xref href="{concat('../bios/bio-', $bio/@number,'.psml')}" frag="default">
      <!-- Note that when uploaded PageSeeder will replace the sort name with the bio title -->
      <xsl:value-of select="$name" />
    </xref>
  </xsl:function>

  <!-- ====================== BIO TEMPLATES ====================== -->

  <!-- Bio document -->
  <xsl:template match="bio" mode="bio">
    <document type="bio" level="portable" >
      <documentinfo>
        <uri title="{name}" />
      </documentinfo>
        
      <section id="title">
        <fragment id="1">
          <heading level="1"><xsl:value-of select="name"/></heading>
        </fragment>
      </section>
        
      <section id="details">
        <properties-fragment id="2">
          <property name="sort-name" title="Sort name" value="{name/@sort}" />
          <property name="born" title="Born" value="{date[@type='birth']}" datatype="date"/>
          <property name="birth-place" title="Birth place" value="{place}" />
          <property name="died" title="Died" value="{date[@type='death']}" datatype="date"/>
        </properties-fragment>
      </section>

      <section id="summary" title="Summary">
        <fragment id="3">
          <xsl:apply-templates select="p" mode="bio" />
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
  <xsl:template match="p" mode="bio">
    <para>
      <xsl:apply-templates mode="bio" />
    </para>
  </xsl:template>

  <!-- titles -->
  <xsl:template match="title" mode="bio">
    <xsl:variable name="film" select="$films//film[title=current()]" />
    <xsl:choose>
      <xsl:when test="$film">
        <xref href="{concat('../films/film-',count($film/preceding-sibling::film) + 1,'.psml')}" frag="default">
          <xsl:value-of select="." />
        </xref>
      </xsl:when>
      <xsl:otherwise>
      <inline label="film">
        <xsl:value-of select="." />
      </inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- release dates -->
  <xsl:template match="date[type='release']" mode="bio">
    <inline label="released">
      <xsl:value-of select="." />
    </inline>
  </xsl:template>
  
</xsl:stylesheet>