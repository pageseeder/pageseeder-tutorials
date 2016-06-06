<?xml version="1.0"?>
<!--
  General frame for the Berlioz administration.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:bf="http://pageseeder.org/berlioz/xslt/function"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
                              exclude-result-prefixes="#all">

<!-- =========================================================================================== -->
<!-- Styles and scripts                                                                          -->
<!-- =========================================================================================== -->

<!--
  Returns the CSS link tag if the corresponding file exists.

  Looks for '/style/[group].css'
  Looks for '/style/[group]/[service].css'

  @param header  berlioz header
-->
<xsl:template match="root" mode="style" as="element(link)*">
  <xsl:variable name="context" select="header/path/@context"/>
  
  <link href="//fonts.googleapis.com/css?family=Open+Sans:400,600,700,300" rel="stylesheet" type="text/css"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.0.5/css/foundation.min.css" rel="stylesheet" type="text/css"/>
  <link href="https://code.jquery.com/ui/1.11.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css"/>

  <xsl:if test="unparsed-text-available(concat('../../../../style/', @group, '.css'))">
    <link rel="stylesheet" href="{$context}/style/{@group}.css" type="text/css"/>
  </xsl:if>
  <xsl:if test="unparsed-text-available(concat('../../../../style/', @group, '/', @service ,'.css'))">
    <link rel="stylesheet" href="{$context}/style/{@group}/{@service}.css" type="text/css"/>
  </xsl:if>
</xsl:template>

<!--
  Returns the JavaScript script tag if the corresponding file exists.

  @return the corresponding scripts
-->
<xsl:template match="root" mode="script" as="element(script)*">
  <xsl:variable name="context" select="header/path/@context"/>

  <!-- TODO support for context for fallback scripts -->
  <!-- Use CDN for jQuery and Foundation with local fallback -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
  <script><![CDATA[window.jQuery || document.write('<script src="/script/lib/jquery-2.1.4.min.js">\x3C/script>')]]></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.0.5/js/foundation.min.js"></script>
  <script><![CDATA[window.Foundation || document.write('<script src="/script/lib/foundation-6.0.5.min.js">\x3C/script>')]]></script>
  <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
  <script><![CDATA[window.Foundation || document.write('<script src="/script/lib/jquery-ui.1.11.4.min.js">\x3C/script>')]]></script>
  
  <script src="{$context}/script/lib/jquery.tablesorter.min.js"></script>

  <xsl:if test="unparsed-text-available(concat('../../../../script/', @group, '.js'))">
    <script src="{$context}/script/{@group}.js"/>
  </xsl:if>
  <xsl:if test="unparsed-text-available(concat('../../../../script/', @group, '/', @service ,'.js'))">
    <script src="{$context}/script/{@group}/{@service}.js"/>
  </xsl:if>

  <script>$(document).foundation();</script>
</xsl:template>

</xsl:stylesheet>