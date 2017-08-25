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

  <xsl:for-each select="content[@name = 'bundles']/style">
    <link rel="stylesheet" href="{$context}{@src}" type="text/css"/>
  </xsl:for-each>
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

  <xsl:for-each select="content[@name = 'bundles']/script">
  <script src="{$context}{@src}"></script>
  </xsl:for-each>

  <script>$(document).foundation();</script>
</xsl:template>

<!--
  Display the primary navigation (displayed just under the header)
-->
<xsl:template match="root" mode="navigation">
<xsl:param name="group" select="@group"/>
<xsl:variable name="pathinfo" select="header/path"/>
<nav class="primary-nav">
  <ul>
    <li>
      <xsl:if test="ends-with(@service, 'browse')"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
      <a href="/{$group}/browse.html">Browse</a>
    </li>
    <li>
      <xsl:if test="ends-with(@service, 'search')"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
      <a href="/{$group}/search.html">Search</a>
    </li>
    <li>
      <xsl:if test="ends-with(@service, 'autosuggest')"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
      <a href="/{$group}/autosuggest.html">Autosuggest</a>
    </li>
    <xsl:if test="@service = 'bio'">
      <li class="active"><a href="#">Biography</a></li>
    </xsl:if>
  </ul>
</nav>
</xsl:template>

</xsl:stylesheet>