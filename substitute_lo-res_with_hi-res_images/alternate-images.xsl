<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- change image src to alternate image -->
  <xsl:template match="image[.//xref/@type='alternate']">
    <image src="{.//xref[@type='alternate']/@href}">
      <xsl:copy-of select="@*[not(name()='src')]"/>
    </image>
  </xsl:template>

  <!-- copy all other elements unchanged -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
