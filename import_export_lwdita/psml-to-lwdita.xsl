<?xml version="1.0"?>
<!--
  This stylesheet can be used to convert PSML with level="processed" to Lightweight DITA format.

  @author Philip Rutherford
  
  @version 0.1-beta
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
                              xmlns:psf="http://www.pageseeder.com/function"
                              exclude-result-prefixes="psf xs">

<xsl:output encoding="ascii" indent="no" method="xml" />

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<!-- ========== top level elements ========== -->

<xsl:template match="document[@type='topic']">
<xsl:text disable-output-escaping="yes">
&lt;!DOCTYPE topic PUBLIC "-//OASIS//DTD LIGHTWEIGHT DITA Topic//EN" "lw-topic.dtd"&gt;
</xsl:text>
  <topic id="{substring-after(documentinfo/uri/@docid, '_')}">
    <xsl:if test="documentinfo/uri/@title">
      <title>
        <xsl:sequence select="psf:text-to-keyref(documentinfo/uri/@title)" />
      </title>
    </xsl:if>
    <xsl:if test="documentinfo/uri/description">
      <shortdesc>
        <xsl:sequence select="psf:text-to-keyref(documentinfo/uri/description)" />
      </shortdesc>
    </xsl:if>
    <xsl:apply-templates select="metadata" />
    <body>
      <xsl:apply-templates select="section" />
    </body>
  </topic>
</xsl:template>

<xsl:template match="document[@type='map']">
<xsl:text disable-output-escaping="yes">
&lt;!DOCTYPE map PUBLIC "-//OASIS//DTD XDITA Map//EN" "lw-map.dtd"&gt;
</xsl:text>
  <map>
    <xsl:if test="documentinfo/uri/@docid">
      <xsl:attribute name="id" select="substring-after(documentinfo/uri/@docid, '_')" />
    </xsl:if>
    <xsl:if test="documentinfo/uri/@title">
      <topicmeta>
        <navtitle>
          <xsl:sequence select="psf:text-to-keyref(documentinfo/uri/@title)" />
        </navtitle>
      </topicmeta>
    </xsl:if>
    <xsl:apply-templates select="section[@title='Keydefs']/fragment/para" mode="keydef" />
    <xsl:sequence select="psf:nest-topicrefs(section[@title='Topicrefs']/xref-fragment/blockxref, 0)" />
  </map>
</xsl:template>

<!-- ========== map elements ========== -->

<xsl:template match="para[inline/@label='keydef']" mode="keydef">
  <keydef keys="{inline}">
    <topicmeta>
      <linktext>
        <xsl:apply-templates select="node()[not(self::inline[@label='keydef'])]" />
      </linktext>
    </topicmeta>
  </keydef> 
</xsl:template>

<xsl:template match="blockxref" mode="topicref">
  <topicref href="{psf:path-to-dpath(@href)}">
    <xsl:if test="ends-with(@href,'.psml')">
      <xsl:attribute name="format" select="'dita'" />
    </xsl:if>
    <xsl:sequence select="psf:add-props(@labels)" />
    <xsl:if test="@display='manual'">
      <topicmeta>
        <navtitle>
          <xsl:sequence select="psf:text-to-keyref(@title)" />
        </navtitle>
      </topicmeta>
    </xsl:if>
  </topicref>
</xsl:template>

<!-- ========== elements with @conref ========== -->
<!-- @conref supported for audio, dl, dentry, note, ol, p, pre, section, simpletable, ul, video elements -->
<!-- @conref not supported for fn, dt, dd, li, sentry, sthead, strow elements (this content must be wrapped in p elements) -->

<xsl:template match="blockxref[@type='transclude'][./fragment[@type='audio']]" priority="2">
  <audio conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </audio>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/block[@label='dl']][count(./fragment/*)=1]" priority="2">
  <dl conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </dl>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/para/@prefix][count(./fragment/*)=1]" priority="2">
  <dentry conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </dentry>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/block[ends-with(@label, 'note')]][count(./fragment/*)=1]" priority="2">
  <note conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </note>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/nlist][count(./fragment/*)=1]" priority="2">
  <ol conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </ol>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/para][count(./fragment/*)=1]" priority="2">
  <p conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </p>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/pre][count(./fragment/*)=1]" priority="2">
  <pre conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </pre>
</xsl:template>

<xsl:template match="section[xref-fragment/blockxref/@type='transclude'][count(*)=1][count(*/*)=1]" priority="2">
  <section conref="{concat(psf:path-to-dpath(xref-fragment/blockxref/@href),
        psf:fragment-to-dfragment(xref-fragment/blockxref/@frag, xref-fragment/blockxref/@docid))}">
    <xsl:sequence select="psf:add-props(xref-fragment/blockxref/@labels)" />
  </section>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/table][count(./fragment/*)=1]" priority="2">
  <simpletable conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </simpletable>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment/list][count(./fragment/*)=1]" priority="2">
  <ul conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </ul>
</xsl:template>

<xsl:template match="blockxref[@type='transclude'][./fragment[@type='video']]" priority="2">
  <video conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </video>
</xsl:template>

<!-- fallback is section -->
<xsl:template match="blockxref[@type='transclude']">
  <section conref="{concat(psf:path-to-dpath(@href),
        psf:fragment-to-dfragment(@frag,@docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
  </section>
</xsl:template>

<!-- ========== topic elements ========== -->

<xsl:template match="bold">
  <b>
    <xsl:apply-templates />
  </b>
</xsl:template>

<xsl:template match="link">
  <xref href="{@href}">
    <xsl:sequence select="psf:add-props(@role)" />
    <xsl:sequence select="psf:inline-to-keyref" />
    <xsl:apply-templates select="node()[not(self::inline[@label='keyref'])]"/>
  </xref>
</xsl:template>

<xsl:template match="xref">
  <xref href="{concat(psf:path-to-dpath(@href),
        psf:xref-fragment-to-dfragment(@frag, @docid))}">
    <xsl:sequence select="psf:add-props(@labels)" />
    <xsl:sequence select="psf:text-to-keyref(.)" />
  </xref>
</xsl:template>

<xsl:template match="para[@prefix]" mode="dl">
  <dlentry>
    <xsl:sequence select="psf:element-id(.)" />
    <dt><xsl:value-of select="@prefix" /></dt>
    <dd>
      <p><xsl:apply-templates/></p>
    </dd>
  </dlentry>
</xsl:template>

<xsl:template match="block[@label='dl']">
  <dl>
    <xsl:sequence select="psf:element-id(.)" />
    <xsl:apply-templates  mode="dl"/>
  </dl>
</xsl:template>

<xsl:template match="block[@label='desc']" mode="fig">
  <desc>
    <xsl:apply-templates />
  </desc>
</xsl:template>

<xsl:template match="block[@label='title']" mode="fig">
  <title>
    <xsl:apply-templates />
  </title>
</xsl:template>

<xsl:template match="block[@label='fig']">
  <fig>
    <xsl:if test="inline[@label='scale']">
      <xsl:attribute name="scale" select="inline[@label='scale']"/>
    </xsl:if>
    <xsl:if test="inline[@label='frame']">
      <xsl:attribute name="frame" select="inline[@label='frame']"/>
    </xsl:if>
    <xsl:if test="inline[@label='expanse']">
      <xsl:attribute name="expanse" select="inline[@label='expanse']"/>
    </xsl:if>
    <xsl:if test="inline[@label='props']">
      <xsl:attribute name="props" select="inline[@label='props']"/>
    </xsl:if>
    <xsl:apply-templates select="block[@label='desc' or @label='title']" mode="fig"/>
    <xsl:apply-templates select="*[not(self::block[@label='desc' or @label='title'] or
        self::inline[@label='scale' or @label='frame' or @label='expanse' or @label='props'])]" />
  </fig>
</xsl:template>

<xsl:template match="inline[@label='fn']" priority="2">
  <fn>
    <xsl:apply-templates />
  </fn>
</xsl:template>

<xsl:template match="image">
  <image href="{@src}">
    <xsl:copy-of select="@*[name() = 'width' or name() = 'height']"/>
    <xsl:if test="@alt">
      <alt><xsl:value-of select="@alt" /></alt>
    </xsl:if>
  </image>
</xsl:template>

<xsl:template match="italic">
  <i>
    <xsl:apply-templates />
  </i>
</xsl:template>

<xsl:template match="item">
  <li>
    <xsl:apply-templates />
  </li>
</xsl:template>

<xsl:template match="block[ends-with(@label, 'note')]">
  <note>
    <xsl:sequence select="psf:element-id(.)" />
    <xsl:if test="(ends-with(@label, '-note'))">
      <xsl:attribute name="type" select="substring-before(@label,'-note')" />
    </xsl:if>
    <xsl:apply-templates />
  </note>
</xsl:template>

<xsl:template match="nlist">
  <ol>
    <xsl:sequence select="psf:element-id(.)" />
    <xsl:sequence select="psf:add-props(@role)" />
    <xsl:apply-templates />
  </ol>
</xsl:template>

<xsl:template match="para">
  <p>
    <xsl:sequence select="psf:element-id(.)" />
    <xsl:apply-templates />
  </p>
</xsl:template>

<xsl:template match="inline[@label='keyref']" priority="2">
  <ph keyref="{.}"/>
</xsl:template>

<xsl:template match="inline[@label]">
  <ph props="@label">
    <xsl:sequence select="psf:inline-to-keyref(.)" />
    <xsl:apply-templates select="node()[not(self::inline[@label='keyref'])]"/>
  </ph>
</xsl:template>

<xsl:template match="preformat">
  <pre>
    <xsl:sequence select="psf:element-id(.)" />
    <xsl:sequence select="psf:add-props(@role)" />
    <xsl:apply-templates />
  </pre>
</xsl:template>

<xsl:template match="metadata[properties]">
  <prolog>
    <xsl:for-each select="properties/property">
      <data name="{@name}" value="{@value}" />
    </xsl:for-each>
  </prolog>
</xsl:template>

<xsl:template match="section">
  <section>
    <xsl:if test="not(starts-with(substring-after(@id,'-'),'pss-'))">
      <xsl:attribute name="id" select="substring-after(@id,'-')" />
    </xsl:if>
    <xsl:apply-templates />
  </section>
</xsl:template>

<xsl:template match="fragment">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="table">
  <simpletable>
    <xsl:sequence select="psf:element-id(.)" />
    <xsl:apply-templates />
  </simpletable>
</xsl:template>

<xsl:template match="cell">
  <stentry>
    <xsl:apply-templates />
  </stentry>
</xsl:template>

<xsl:template match="row[@part='header']">
  <sthead>
    <xsl:apply-templates />
  </sthead>
</xsl:template>

<xsl:template match="row">
  <strow>
    <xsl:apply-templates />
  </strow>
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

<xsl:template match="heading[@level='2']">
  <title>
    <xsl:apply-templates />
  </title>
</xsl:template>

<xsl:template match="underline">
  <u>
    <xsl:apply-templates />
  </u>
</xsl:template>

<xsl:template match="list">
  <ul>
    <xsl:sequence select="psf:element-id(.)" />
    <xsl:sequence select="psf:add-props(@role)" />
    <xsl:apply-templates />
  </ul>
</xsl:template>

<!-- ========== multimedia elements ========== -->

<xsl:template match="properties-fragment[@type='video']">
  <video id="{substring-after(@id,'-')}">
    <xsl:if test="normalize-space(property[@name='width']/@value) != ''">
      <xsl:attribute name="width" select="property[@name='width']/@value" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='height']/@value) != ''">
      <xsl:attribute name="height" select="property[@name='height']/@value" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='desc']/markdown) != ''">
      <desc>
        <xsl:sequence select="psf:text-to-keyref(property[@name='desc']/markdown)" />
      </desc>      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='video-poster']/@value) != ''">
      <video-poster value="{property[@name='video-poster']/@value}" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-controls']/@value) != ''">
      <media-controls value="{property[@name='media-controls']/@value}" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-autoplay']/@value) != ''">
      <media-autoplay value="{property[@name='media-autoplay']/@value}" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-loop']/@value) != ''">
      <media-loop value="{property[@name='media-loop']/@value}" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-muted']/@value) != ''">
      <media-muted value="{property[@name='media-muted']/@value}" />      
    </xsl:if>
    <xsl:for-each select="property[@name='media-source']/value">
      <media-source value="{.}" />      
    </xsl:for-each>
    <xsl:for-each select="property[@name='media-track']/value">
      <media-track value="{.}" />      
    </xsl:for-each>
  </video>
</xsl:template>


<xsl:template match="properties-fragment[@type='audio']">
  <audio id="{substring-after(@id,'-')}">
    <xsl:if test="normalize-space(property[@name='desc']/markdown) != ''">
      <desc>
        <xsl:sequence select="psf:text-to-keyref(property[@name='desc']/markdown)" />
      </desc>      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-controls']/@value) != ''">
      <media-controls value="{property[@name='media-controls']/@value}" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-autoplay']/@value) != ''">
      <media-autoplay value="{property[@name='media-autoplay']/@value}" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-loop']/@value) != ''">
      <media-loop value="{property[@name='media-loop']/@value}" />      
    </xsl:if>
    <xsl:if test="normalize-space(property[@name='media-muted']/@value) != ''">
      <media-muted value="{property[@name='media-muted']/@value}" />      
    </xsl:if>
    <xsl:for-each select="property[@name='media-source']/value">
      <media-source value="{.}" />      
    </xsl:for-each>
    <xsl:for-each select="property[@name='media-track']/value">
      <media-track value="{.}" />      
    </xsl:for-each>
  </audio>
</xsl:template>

<!-- ========== functions ========== -->

<!-- Convert PSML path to DITA path -->
<xsl:function name="psf:path-to-dpath">
  <xsl:param name="path" />
  <xsl:value-of select="if (ends-with($path, '.psml')) then concat(substring-before($path, '.psml'), '.dita') else $path" />
</xsl:function>

<!-- Convert PSML blockxref fragment/docid to DITA #fragment -->
<xsl:function name="psf:fragment-to-dfragment">
  <xsl:param name="fragment" />
  <xsl:param name="docid" />
  <xsl:if test="$fragment != 'default'">
    <xsl:value-of select="concat('#', substring-after($docid, '_'), '/', $fragment)" />
  </xsl:if>
</xsl:function>

<!-- Convert PSML xref fragment/docid to DITA #fragment -->
<xsl:function name="psf:xref-fragment-to-dfragment">
  <xsl:param name="frag" />
  <xsl:param name="docid" />
  <xsl:variable name="fragment" select="substring-after($frag,'-')" />
  <xsl:if test="$fragment != 'default'">
    <xsl:value-of select="concat('#', substring-after($docid, '_'), '/', $fragment)" />
  </xsl:if>
</xsl:function>

<!-- Replace [x] in text with <ph keyref="x" /> -->
<xsl:function name="psf:text-to-keyref">
  <xsl:param name="text" />
  <xsl:if test="normalize-space($text) != ''">
    <xsl:analyze-string select="$text" regex="\[(.*)\]">
      <xsl:matching-substring>
        <ph keyref="{regex-group(1)}" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="." />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:if>
</xsl:function>

<!-- Nest topicrefs based on blockxref/@label -->
<xsl:function name="psf:nest-topicrefs">
  <xsl:param name="xrefs" as="element(blockxref)*" />  
  <xsl:param name="level" as="xs:integer" /> 
  <xsl:for-each-group select="$xrefs" group-adjacent="if (number(@level) gt $level) then 1 else 0">
    <xsl:variable name="current" select="current-group()[1]" />
    <xsl:variable name="previous" select="$current/preceding::blockxref[1]" />
    <xsl:choose>
      <xsl:when test="number($current/@level) gt $level and $previous">
        <topicref href="{psf:path-to-dpath($previous/@href)}">
          <xsl:if test="ends-with($previous/@href,'.psml')">
            <xsl:attribute name="format" select="'dita'" />
          </xsl:if>
          <xsl:sequence select="psf:add-props($previous/@labels)" />
          <xsl:if test="$previous/@display='manual'">
            <topicmeta>
              <navtitle>
                <xsl:sequence select="psf:text-to-keyref($previous/@title)" />
              </navtitle>
            </topicmeta>
          </xsl:if>
          <xsl:sequence select="psf:nest-topicrefs(current-group(), $current/@level)" />
        </topicref>
      </xsl:when>
      <xsl:otherwise>
        <!-- don't process last blockxref as it will be used to wrap higher levels -->
        <xsl:apply-templates select="current-group()[position()!=last()]" mode="topicref"/>
        <!-- process last blockxref as we are at the end -->
        <xsl:if test="position()=last()">
          <xsl:apply-templates select="current-group()[position()=last()]" mode="topicref"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each-group>
</xsl:function>

<!-- Add props attribute -->
<xsl:function name="psf:add-props">
  <xsl:param name="labels" />
  <xsl:if test="normalize-space($labels) != ''">
    <xsl:attribute name="props" select="$labels" />
  </xsl:if>
</xsl:function>

<!-- Convert PSML inline label to @keyref -->
<xsl:function name="psf:inline-to-keyref">
  <xsl:param name="element" as="element()"/>
  <xsl:if test="$element/inline[@label='keyref']">
    <xsl:attribute name="keyref" select="($element/inline[@keyref])[1]" />
  </xsl:if>
</xsl:function>

<!-- Generate element ID from fragment ID -->
<xsl:function name="psf:element-id">
  <xsl:param name="element" as="element()"/>
  <!-- if first element in fragment -->
  <xsl:if test="$element/parent::fragment and count($element/preceding-sibling::*) = 0">
    <xsl:attribute name="id" select="substring-after($element/parent::fragment/@id,'-')" />
  </xsl:if>
</xsl:function>

</xsl:stylesheet>