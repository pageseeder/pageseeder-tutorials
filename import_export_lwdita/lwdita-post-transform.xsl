<?xml version="1.0"?>
<!--
  This stylesheet transforms a PSML LwDITA map document with level="processed"
  including substituting keyref with matching keydef content.

  @author Philip Rutherford
  
  @version 0.1-beta
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:psf="http://www.pageseeder.com/function"
                              exclude-result-prefixes="psf">

  <xsl:output encoding="utf8" indent="no" method="xml" />

  <xsl:variable name="keydefs" select="(//section[@title='Keydefs']/fragment)[1]" />
  
  <!-- don't output Keydefs section -->
  <xsl:template match="section[@title='Keydefs']">
  </xsl:template>
  
  <!-- substitute keyref inline label-->
  <xsl:template match="inline[@label='keyref']">
    <xsl:variable name="keydef" select="$keydefs/para[inline/@label='keydef' and
        normalize-space(inline) = normalize-space(current())]"/>
    <xsl:choose>
      <xsl:when test="$keydef">
        <xsl:apply-templates select="$keydef/node()[not(self::inline[@label='keydef'])]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*" />
          <xsl:apply-templates select="node()" />
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- substitute [keyref] text -->
  <xsl:template match="markdown">
    <markdown>
      <xsl:apply-templates mode="markdown"/>
    </markdown>
  </xsl:template>

  <xsl:template match="text()" mode="markdown">
    <xsl:value-of select="psf:text-to-keydef(.)"/>
  </xsl:template>

  <!-- copy all other markdown content unchanged -->
  <xsl:template match="*" mode="markdown">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="node()" mode="markdown"/>
    </xsl:copy>
  </xsl:template>

  <!-- don't output figure inline details -->
  <xsl:template match="block[@label='fig']">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="*[not(self::inline[@label='scale' or @label='frame' or @label='expanse' or @label='props'])]" />
    </xsl:copy>
  </xsl:template>

  <!-- video to links -->
  <xsl:template match="properties-fragment[@type='video']">
    <fragment id="{@id}">
      <xsl:apply-templates select="property[@name='desc']/markdown/node()" mode="markdown"/>
      <para>
        <xsl:for-each select="property[@name='media-source']/value">
          <link href="{.}">Video</link>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </para>
    </fragment>
  </xsl:template>

  <!-- audio to links -->
  <xsl:template match="properties-fragment[@type='audio']">
    <fragment id="{@id}">
      <xsl:apply-templates select="property[@name='desc']/markdown/node()" mode="markdown"/>
      <para>
        <xsl:for-each select="property[@name='media-source']/value">
          <link href="{.}">Audio</link>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </para>
    </fragment>
  </xsl:template>

  <!-- copy all other elements unchanged -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Replace [x] in text with matching keydef content -->
  <xsl:function name="psf:text-to-keydef">
    <xsl:param name="text" />
    <xsl:if test="normalize-space($text) != ''">
      <xsl:analyze-string select="$text" regex="\[(.*)\]">
        <xsl:matching-substring>
          <xsl:variable name="keydef" select="$keydefs/para[inline/@label='keydef' and
              normalize-space(inline) = normalize-space(regex-group(1))]"/>
          <xsl:choose>
            <xsl:when test="$keydef">
              <xsl:value-of select="$keydef/node()[not(self::inline[@label='keydef'])]" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('[', regex-group(1), ']')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="." />
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:if>
  </xsl:function>

</xsl:stylesheet>