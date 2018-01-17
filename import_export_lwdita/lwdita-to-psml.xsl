<?xml version="1.0"?>
<!--
  This stylesheet can be used to convert Lightweight DITA to PSML format.

  @author Philip Rutherford
  
  @version 0.1-beta
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:psf="http://www.pageseeder.com/function"
                              exclude-result-prefixes="psf">

<xsl:output encoding="ascii" indent="no" method="xml" />

<xsl:param name="group-name" select="'undefined'" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<!-- ========== top level elements ========== -->

<xsl:template match="topic">
  <document  type="topic" level="portable">
    <documentinfo>
      <!-- truncate to maximum docid length of 100 -->
      <uri docid="{substring(concat($group-name, '_', psf:sanitize-docid(@id)), 1, 100)}">
        <xsl:if test="title">
          <xsl:attribute name="title">
            <xsl:apply-templates select="title" mode="text" />
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="shortdesc">
          <description>
            <xsl:apply-templates select="shortdesc" mode="text" />
          </description>
        </xsl:if>
      </uri>
    </documentinfo>
    <xsl:apply-templates select="prolog|body" />
  </document>
</xsl:template>

<xsl:template match="map">
  <document type="map" level="portable">
    <xsl:if test="@id or topicmeta/navtitle">
      <documentinfo>
        <uri>
          <xsl:if test="@id">
            <!-- truncate to maximum docid length of 100 -->
            <xsl:attribute name="docid" select="substring(concat($group-name, '_', psf:sanitize-docid(@id)), 1, 100)" />
          </xsl:if>
          <xsl:if test="topicmeta/navtitle">
            <xsl:attribute name="title">
              <xsl:apply-templates select="topicmeta/navtitle" mode="text" />
            </xsl:attribute>
          </xsl:if>
        </uri>
      </documentinfo>
    </xsl:if>
    <section id="keydefs" title="Keydefs">
      <fragment id="1">
        <xsl:apply-templates select="keydef"/>
      </fragment>
    </section>
    <section id="topicrefs" title="Topicrefs">
      <xref-fragment id="2">
        <xsl:apply-templates select="topicref"/>
      </xref-fragment>
    </section>
  </document>
</xsl:template>

<!-- ========== map elements ========== -->

<xsl:template match="keydef">
  <para>
    <inline label="keydef"><xsl:value-of select="@keys" /></inline>
    <xsl:apply-templates select="topicmeta/linktext" />
  </para> 
</xsl:template>

<xsl:template match="topicref">
  <blockxref href="{psf:href-to-path(@href)}" frag="default" type="embed">
    <xsl:sequence select="psf:add-labels(@props)" />
    <xsl:if test="topicmeta/navtitle">
      <xsl:attribute name="display" select="'manual'" />
      <xsl:attribute name="title">
        <xsl:apply-templates select="topicmeta/navtitle" mode="text" />
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="ancestor::topicref">
      <xsl:attribute name="level" select="count(ancestor::topicref)" />
    </xsl:if>
    <xsl:value-of select="topicmeta/navtitle" />  
  </blockxref>
  <xsl:apply-templates select="topicref"/>
</xsl:template>

<!-- ========== elements with @conref ========== -->
<!-- @conref supported for audio, dl, dentry, note, ol, p, pre, section, simpletable, ul, video elements -->
<!-- @conref not supported for fn, dt, dd, li, sentry, sthead, strow elements (this content must be wrapped in p elements) -->

<xsl:template match="*[@conref][(self::dl or self::dentry or self::note or self::ol
       or self::p or self::pre or self::simpletable or self::ul)]" priority="2">
  <blockxref href="{psf:href-to-path(@conref)}" frag="{psf:href-to-fragment(@conref)}" type="transclude" display="document+fragment">
    <xsl:sequence select="psf:add-labels(@props)" />
    <xsl:value-of select="substring-after(@conref, '#')" />
  </blockxref>
</xsl:template>

<xsl:template match="audio[@conref]" priority="2">
  <fragment id="{psf:generate-fragment-id(.)}">
    <blockxref href="{psf:href-to-path(@conref)}" frag="{psf:href-to-fragment(@conref)}" type="transclude" display="document+fragment">
      <xsl:sequence select="psf:add-labels(@props)" />
      <xsl:value-of select="substring-after(@conref, '#')" />
    </blockxref>
  </fragment>
</xsl:template>

<xsl:template match="video[@conref]" priority="2">
  <fragment id="{psf:generate-fragment-id(.)}">
    <blockxref href="{psf:href-to-path(@conref)}" frag="{psf:href-to-fragment(@conref)}" type="transclude" display="document+fragment">
      <xsl:sequence select="psf:add-labels(@props)" />
      <xsl:value-of select="substring-after(@conref, '#')" />
    </blockxref>
  </fragment>
</xsl:template>

<xsl:template match="section[@conref]" priority="2">
  <section id="{if (@id) then @id else concat('pss-', count(preceding::*))}">
    <xref-fragment id="concat('psf-', count(preceding::*))">
      <blockxref href="{psf:href-to-path(@conref)}" frag="{psf:href-to-fragment(@conref)}" type="transclude" display="document+fragment">
        <xsl:sequence select="psf:add-labels(@props)" />
        <xsl:value-of select="substring-after(@conref, '#')" />
      </blockxref>
    </xref-fragment>
  </section>
</xsl:template>

<!-- ========== topic elements ========== -->

<xsl:template match="body">
  <!-- split each section into it's own group -->
  <xsl:for-each-group select="*" group-starting-with="section">
    <xsl:for-each-group select="current-group()" group-ending-with="section">
      <xsl:choose>
        <xsl:when test="name(current-group()[1]) = 'section'">
          <xsl:apply-templates select="current-group()[1]" />
        </xsl:when>
        <xsl:otherwise>
          <section id="{concat('pss-', count(preceding::*))}">
            <!-- split any elements with IDs or video/audio into their own fragment -->
            <xsl:for-each-group select="current-group()" group-starting-with="*[@id]|video|audio">
              <xsl:for-each-group select="current-group()" group-ending-with="*[@id]|video|audio">
                <xsl:choose>
                  <xsl:when test="current-group()[1][self::video or self::audio]">
                    <xsl:apply-templates select="current-group()[1]" />
                  </xsl:when>
                  <xsl:otherwise>
                    <fragment id="{psf:generate-fragment-id(current-group()[1])}">
                      <xsl:apply-templates select="current-group()" />
                    </fragment>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each-group>
            </xsl:for-each-group>
          </section>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:for-each-group>
</xsl:template>

<xsl:template match="b">
  <bold>
    <xsl:apply-templates />
  </bold>
</xsl:template>

<xsl:template match="xref">
  <xsl:choose>
    <xsl:when test="starts-with(@href, 'http:') or starts-with(@href, 'https:')">
      <link href="{@href}">
         <xsl:sequence select="psf:add-role(@props)" />
         <xsl:sequence select="psf:keyref(.)" />
         <xsl:apply-templates />
      </link>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="title">
        <xsl:apply-templates mode="text" />
      </xsl:variable>
      <xref href="{psf:href-to-path(@href)}" frag="{psf:href-to-fragment(@href)}" display="manual" title="{$title}">
        <xsl:sequence select="psf:add-labels(@props)" />
        <xsl:value-of select="$title" />  
      </xref>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dd">
    <xsl:apply-templates select="p/node()" />
</xsl:template>

<xsl:template match="dlentry">
  <para prefix="{dt}">
    <xsl:apply-templates select="dd" />
  </para>
</xsl:template>

<xsl:template match="dl">
  <block label="dl">
    <xsl:apply-templates />
  </block>
</xsl:template>

<xsl:template match="desc" mode="fig">
  <block label="desc">
    <xsl:apply-templates />
  </block>
</xsl:template>

<xsl:template match="title" mode="fig">
  <block label="title">
    <xsl:apply-templates />
  </block>
</xsl:template>

<xsl:template match="@scale" mode="fig">
  <inline label="scale"><xsl:value-of select="."/></inline>
</xsl:template>

<xsl:template match="@frame" mode="fig">
  <inline label="frame"><xsl:value-of select="."/></inline>
</xsl:template>

<xsl:template match="@expanse" mode="fig">
  <inline label="expanse"><xsl:value-of select="."/></inline>
</xsl:template>

<xsl:template match="@props" mode="fig">
  <inline label="props"><xsl:value-of select="."/></inline>
</xsl:template>

<xsl:template match="@*" mode="fig" />

<xsl:template match="fig">
  <block label="fig">
    <xsl:apply-templates select="@*|desc|title" mode="fig"/>
    <xsl:apply-templates select="*[not(self::desc or self::title)]" />
  </block>
</xsl:template>

<xsl:template match="fn">
  <inline label="fn">
    <xsl:apply-templates />
  </inline>
</xsl:template>

<xsl:template match="image">
  <image src="{@href}">
    <xsl:copy-of select="@*[name() = 'width' or name() = 'height']"/>
    <xsl:if test="alt">
      <xsl:attribute name="alt" select="alt" />
    </xsl:if>
  </image>
</xsl:template>

<xsl:template match="i">
  <italic>
    <xsl:apply-templates />
  </italic>
</xsl:template>

<xsl:template match="li">
  <item>
    <xsl:apply-templates />
  </item>
</xsl:template>

<xsl:template match="note">
  <block label="{if (normalize-space(@type) != '') then concat(replace(@type, '[^-_a-zA-Z0-9]', '-'), '-note') else 'note'}">
    <xsl:apply-templates />
  </block>
</xsl:template>

<xsl:template match="ol">
  <nlist>
    <xsl:sequence select="psf:add-role(@props)" />
    <xsl:apply-templates />
  </nlist>
</xsl:template>

<xsl:template match="p">
  <para>
    <xsl:apply-templates />
  </para>
</xsl:template>

<xsl:template match="ph">
  <xsl:choose>
    <xsl:when test="@keyref">
      <xsl:sequence select="psf:keyref(.)" />
    </xsl:when>
    <xsl:when test="normalize-space(@props) != ''">
      <inline label="{replace(@props, '[^-_a-zA-Z0-9]', '-')}">
        <xsl:apply-templates />
      </inline>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ph[@keyref]" mode="text">
  <xsl:text>[</xsl:text><xsl:value-of select="@keyref" /><xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="*" mode="text">
  <xsl:apply-templates mode="text" />
</xsl:template>

<xsl:template match="text()" mode="text">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="pre">
  <preformat>
    <xsl:sequence select="psf:add-role(@props)" />
    <xsl:apply-templates />
  </preformat>
</xsl:template>

<xsl:template match="prolog">
  <metadata>
    <properties>
      <xsl:for-each select="data">
       <property name="{@name}" value="{@value}" />
      </xsl:for-each>
    </properties>
  </metadata>
</xsl:template>

<xsl:template match="section">
  <xsl:variable name="section" select="." />
  <section id="{if (@id) then @id else concat('pss-', count(preceding::*))}">
    <!-- split any elements with IDs or video/audio into their own fragment -->
    <xsl:for-each-group select="*" group-starting-with="*[@id]|video|audio">
      <xsl:for-each-group select="current-group()" group-ending-with="*[@id]|video|audio">
        <xsl:choose>
          <xsl:when test="current-group()[1][self::video or self::audio]">
            <xsl:apply-templates select="current-group()[1]" />
          </xsl:when>
          <xsl:otherwise>
            <!-- if first group use section @id to support conref to section -->
            <fragment id="{if (position() = 1 and $section/@id) then $section/@id else
                  psf:generate-fragment-id(current-group()[1])}">
              <xsl:apply-templates select="current-group()" />
            </fragment>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </section>
</xsl:template>

<xsl:template match="simpletable">
  <table>
    <xsl:apply-templates />
  </table>
</xsl:template>

<xsl:template match="stentry">
  <cell>
    <xsl:apply-templates />
  </cell>
</xsl:template>

<xsl:template match="sthead">
  <row part="header">
    <xsl:apply-templates />
  </row>
</xsl:template>

<xsl:template match="strow">
  <row>
    <xsl:apply-templates />
  </row>
</xsl:template>

<xsl:template match="sub">
  <sub>
    <xsl:apply-templates />
  </sub>
</xsl:template>

<xsl:template match="sup">
  <sup>
    <xsl:apply-templates />
  </sup>
</xsl:template>

<xsl:template match="title">
  <heading level="2">
    <xsl:apply-templates />
  </heading>
</xsl:template>

<xsl:template match="u">
  <underline>
    <xsl:apply-templates />
  </underline>
</xsl:template>

<xsl:template match="ul">
  <list>
    <xsl:sequence select="psf:add-role(@props)" />
    <xsl:apply-templates />
  </list>
</xsl:template>

<!-- ========== multimedia elements ========== -->

<xsl:template match="video">
  <properties-fragment id="{psf:generate-fragment-id(.)}" type="video">
    <property name="desc" title="Descrpition" datatype="markdown">
      <markdown><xsl:apply-templates select="desc" mode="text" /></markdown>
    </property>
    <property name="width" title="Width" value="{@width}" />
    <property name="height" title="Height" value="{@height}" />
    <property name="video-poster" title="Poster image" value="{video-poster/@value}" />
    <property name="media-controls" title="Controls" value="{media-controls/@value}" />
    <property name="media-autoplay" title="Autoplay" value="{media-autoplay/@value}" />
    <property name="media-loop" title="Loop" value="{media-loop/@value}" />
    <property name="media-muted" title="Muted" value="{media-muted/@value}" />
    <property name="media-source" title="Source" count="n">
      <xsl:for-each select="media-source">
        <value><xsl:value-of select="@value" /></value>
      </xsl:for-each>
    </property>
    <property name="media-track" title="Text track" count="n">
      <xsl:for-each select="media-track">
        <value><xsl:value-of select="@value" /></value>
      </xsl:for-each>
    </property>
  </properties-fragment>
</xsl:template>


<xsl:template match="audio">
  <properties-fragment id="{psf:generate-fragment-id(.)}" type="audio">
    <property name="desc" title="Descrpition" datatype="markdown">
      <markdown><xsl:apply-templates select="desc" mode="text" /></markdown>
    </property>
    <property name="media-controls" title="Controls" value="{media-controls/@value}" />
    <property name="media-autoplay" title="Autoplay" value="{media-autoplay/@value}" />
    <property name="media-loop" title="Loop" value="{media-loop/@value}" />
    <property name="media-muted" title="Muted" value="{media-muted/@value}" />
    <property name="media-source" title="Source" count="n">
      <xsl:for-each select="media-source">
        <value><xsl:value-of select="@value" /></value>
      </xsl:for-each>
    </property>
    <property name="media-track" title="Text track" count="n">
      <xsl:for-each select="media-track">
        <value><xsl:value-of select="@value" /></value>
      </xsl:for-each>
    </property>
  </properties-fragment>
</xsl:template>

<!-- ========== functions ========== -->

<!-- Convert DITA href to PSML path -->
<xsl:function name="psf:href-to-path">
  <xsl:param name="href" />
  <xsl:variable name="dpath" select="if (contains($href, '#')) then substring-before($href, '#') else $href" />
  <xsl:value-of select="if (ends-with($dpath, '.dita')) then concat(substring-before($dpath, '.dita'), '.psml') else $dpath" />
</xsl:function>

<!-- Convert DITA href to PSML fragment -->
<xsl:function name="psf:href-to-fragment">
  <xsl:param name="href" />
  <xsl:variable name="fragment" select="substring-after($href, '#')" />
  <xsl:value-of select="if (contains($fragment, '/')) then
      psf:sanitize-fragment(substring-after($fragment, '/')) else 'default'" />
</xsl:function>

<!-- Convert @keyref to PSML inline label -->
<xsl:function name="psf:keyref">
  <xsl:param name="element" as="element()"/>
  <xsl:if test="$element/@keyref">
    <inline label="keyref"><xsl:value-of select="$element/@keyref"/></inline>
  </xsl:if>
</xsl:function>

<!-- Sanitize labels attribute value and add -->
<xsl:function name="psf:add-labels">
  <xsl:param name="labels" />
  <xsl:if test="normalize-space($labels) != ''">
    <xsl:attribute name="labels" select="replace($labels, '[^-_a-zA-Z0-9,]', '-')" />
  </xsl:if>
</xsl:function>

<!-- Sanitize label attribute value and add -->
<xsl:function name="psf:add-label">
  <xsl:param name="label" />
  <xsl:if test="normalize-space($label) != ''">
    <xsl:attribute name="label" select="replace($label, '[^-_a-zA-Z0-9]', '-')" />
  </xsl:if>
</xsl:function>

<!-- Sanitize role attribute value and add -->
<xsl:function name="psf:add-role">
  <xsl:param name="label" />
  <xsl:if test="normalize-space($label) != ''">
    <xsl:attribute name="label" select="replace($label, '[^-_a-zA-Z0-9]', '-')" />
  </xsl:if>
</xsl:function>

<!-- Generate fragment ID for an element -->
<xsl:function name="psf:generate-fragment-id">
  <xsl:param name="element" as="element()"/>
  <xsl:value-of select="if ($element/@id) then
            psf:sanitize-fragment($element/@id) else
            concat('psf-', count($element/preceding::*))" />
</xsl:function>

<!-- Sanitize fragment ID -->
<xsl:function name="psf:sanitize-fragment">
  <xsl:param name="id" />
  <xsl:value-of select="replace($id, '[^-_a-zA-Z0-9,=&amp;]', '-')" />
</xsl:function>

<!-- Sanitize document ID -->
<xsl:function name="psf:sanitize-docid">
  <xsl:param name="id" />
  <xsl:value-of select="replace($id, '[^-_a-zA-Z0-9]', '-')" />
</xsl:function>

</xsl:stylesheet>