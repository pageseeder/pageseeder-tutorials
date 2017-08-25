<?xml version="1.0"?>
<!--
  This is the standard stylesheet to convert PSML to HTML.

  You __should not modify__ this file, instead you should create templates in mode 'psml' with a higher priority
  in order to override the default template. The default priority for most of the templates in this stylesheet
  is '0'.

  Functions are all on the 'http://pageseeder.com/PSML' namespace and may be used externally unless
  specified otherwise.

  This version works for PSML Beta 7.

  @see http://dev.pageseeder.com/api/

  @version BerliozBase-0.8.2
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:psml="http://pageseeder.com/PSML"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
                              exclude-result-prefixes="#all">

<!-- Document maps to `<article>` tag with class 'psml-content' -->
<xsl:template match="document" mode="psml">
<article class="psml-content">
  <xsl:if test="@type"><xsl:attribute name="data-type" select="@type"/></xsl:if>
  <xsl:apply-templates mode="psml"/>
</article>
</xsl:template>

<!-- Do not display the document info by default -->
<xsl:template match="documentinfo" mode="psml"/>

<!-- Section maps to `<section>` tag -->
<xsl:template match="section" mode="psml">
  <section>
    <xsl:if test="@id"><xsl:attribute name="id" select="@id"/></xsl:if>
    <xsl:apply-templates mode="psml"/>
  </section>
</xsl:template>

<!-- Default fragment with PSML content  maps to `<div>` -->
<xsl:template match="fragment" mode="psml">
  <!-- XXX We could simply output an anchor... -->
  <div id="{@id}">
    <xsl:apply-templates mode="psml"/>
  </div>
</xsl:template>


<!-- Inline elements ========================================================================== -->

<!--
  Regular link maps to `<a>` tag.

  Additional classes are added depending on the kind of link.
-->
<xsl:template match="link" mode="psml">
  <a>
    <!-- Named links are deprecated -->
    <xsl:copy-of select="@name|@href" />
    <xsl:if test="@role">
      <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
      <xsl:attribute name="data-role"><xsl:value-of select="@role"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="starts-with(@href, 'mailto:')">
      <xsl:attribute name="rel">nofollow</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="psml"/>
  </a>
  <!-- the non-breaking space is so that when editing in firefox you can add text after the link easily -->
  <xsl:if test="not(starts-with(normalize-space(following::text()[1]),'&#160;'))">&#160;</xsl:if>
</xsl:template>

<!-- Regular links -->
<xsl:template match="anchor" mode="psml">
  <a name="{@name}"/>
</xsl:template>

<!--
  PageSeeder cross-references map to `<a>` tag.

  The href is computed using the `psml:resolve-xref(@href)` function.
-->
<xsl:template match="xref" mode="psml">
  <a href="{psml:resolve-xref(@href)}">
  <xsl:attribute name="class">
    <xsl:text>xref</xsl:text>
    <xsl:for-each select="tokenize(@labels,',')">
      <xsl:text> label-</xsl:text><xsl:value-of select="replace(., '-','_')"/>
    </xsl:for-each>
  </xsl:attribute>
  <xsl:choose>
    <xsl:when test=".=''">
      <xsl:value-of select="if (@title!='') then @title else @urititle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="psml"/>
    </xsl:otherwise>
  </xsl:choose>
  </a>
</xsl:template>

<!-- Directly maps to HTML `<b>` tag. -->
<xsl:template match="bold" mode="psml">
<b><xsl:apply-templates mode="psml"/></b>
</xsl:template>

<!-- Directly maps to HTML `<sup>` tag. -->
<xsl:template match="sup" mode="psml">
<sup><xsl:apply-templates mode="psml"/></sup>
</xsl:template>

<!-- Directly maps to HTML `<sub>` tag. -->
<xsl:template match="sub" mode="psml">
<sub><xsl:apply-templates mode="psml"/></sub>
</xsl:template>

<!-- Directly maps to HTML `<u>` tag. -->
<xsl:template match="underline" mode="psml">
<u><xsl:apply-templates mode="psml"/></u>
</xsl:template>

<!-- Directly maps to HTML `<i>` tag. -->
<xsl:template match="italic" mode="psml">
<i><xsl:apply-templates mode="psml"/></i>
</xsl:template>

<!-- Directly maps to HTML `<code>` tag. -->
<xsl:template match="monospace" mode="psml">
  <code><xsl:apply-templates mode="psml"/></code>
</xsl:template>

<!--
  Inline label mapped to a `<span>` element.

  The original label is preserved in a data-label attribute, the class attribute is
  generated using the psml:label-class function.
-->
<xsl:template match="inline" mode="psml">
  <span data-label="{@label}" class="{psml:label-class(@label)}">
    <xsl:apply-templates mode="psml"/>
  </span>
</xsl:template>

<!--
  Block label mapped to a `<div>` element.

  The original label is preserved in a data-label attribute, the class attribute is
  generated using the psml:label-class function.
-->
<xsl:template match="block" mode="psml">
  <div data-label="{@label}" class="{psml:label-class(@label)}">
    <xsl:apply-templates mode="psml"/>
  </div>
</xsl:template>

<!-- Headings ================================================================================= -->

<!--
  Heading mapped to the corresponding HTML heading elements `h1`, `h2`, `h3`,  `h4`, `h5`, `h6`
-->
<xsl:template match="heading" mode="psml">
<xsl:element name="h{@level}">
  <xsl:if test="@prefix"><xsl:attribute name="data-prefix"><xsl:value-of select="@prefix"/></xsl:attribute></xsl:if>
  <xsl:if test="@id"><a name="{@id}"/></xsl:if>
  <xsl:if test="@numbered = 'true'">
    <!-- TODO display numbering and handle prefix -->
    <xsl:value-of select="@label"/>&#160;<xsl:text />
  </xsl:if>
  <xsl:apply-templates mode="psml"/>
</xsl:element>
</xsl:template>

<!-- Titles ================================================================================= -->

<!-- Section titles map to `h1` -->
<xsl:template match="title[not(@level)]" mode="psml">
<h1 class="title"><xsl:apply-templates mode="psml"/></h1>
</xsl:template>

<!-- Section titles map to `h2` -->
<xsl:template match="title[@level='2']" mode="psml">
<h2 class="title"><xsl:apply-templates mode="psml"/></h2>
</xsl:template>

<!-- Text ===================================================================================== -->

<!-- Paragraph mapped to a `<p>` element. -->
<xsl:template match="para" mode="psml">
<p>
  <xsl:if test="@indent"><xsl:attribute name="class">indent-<xsl:value-of select="@indent"/></xsl:attribute></xsl:if>
  <xsl:if test="@prefix"><xsl:attribute name="data-prefix"><xsl:value-of select="@prefix"/></xsl:attribute></xsl:if>
  <xsl:apply-templates mode="psml"/>
</p>
</xsl:template>

<!-- Preformatted text mapped to a `<pre>` element. -->
<xsl:template match="preformat" mode="psml">
<pre>
  <xsl:if test="@role">
    <xsl:attribute name="class"    select="@role" />
    <xsl:attribute name="data-role" select="@role" />
  </xsl:if>
  <xsl:apply-templates mode="psml"/>
</pre>
</xsl:template>

<!-- Break mapped to a `<br>` element. -->
<xsl:template match="br" mode="psml">
<br/>
</xsl:template>

<!-- Lists ==================================================================================== -->

<!-- Unordered list mapped to `<ul>` element. -->
<xsl:template match="list" mode="psml">
  <ul>
    <xsl:if test="@type or @role"><xsl:attribute name="class"><xsl:value-of select="@type|@role" separator=" " /></xsl:attribute></xsl:if>
    <xsl:apply-templates mode="psml"/>
  </ul>
</xsl:template>

<!-- Ordered list mapped to `<ol>` element. -->
<xsl:template match="nlist" mode="psml">
  <ol>
    <xsl:if test="@start"><xsl:attribute name="start"><xsl:value-of select="@start" /></xsl:attribute></xsl:if>
    <xsl:if test="@type or @role"><xsl:attribute name="class"><xsl:value-of select="@type|@role" separator=" "/></xsl:attribute></xsl:if>
    <xsl:apply-templates mode="psml"/>
  </ol>
</xsl:template>

<!--
  List item mapped to `<li>` element.

  Note: nitem included for backward compatibility only, and may be removed in future versions.

  @context list|nlist
-->
<xsl:template match="item | nitem" mode="psml">
  <li>
    <xsl:apply-templates select="node()[not(self::list or self::nlist)]" mode="psml"/>
  </li>
  <!-- lists must be outside items for editing in Mozilla -->
  <xsl:apply-templates select="list | nlist" mode="psml"/>
</xsl:template>

<!-- Tables =================================================================================== -->

<!--
  Table assumed to be denormalized.

  The default default template will normalize the table first in order to correctly compute the
  rules applied to columns.

  Normalization is not necessary if the table does not have any column definitions or does not
  include any row or column span.

  After the table is normalized, the XSLT template in mode "psml-normalized" is applied.

     table = element table {
       attribute role?,
       attribute width?,
       attribute height?,
       caption?
       col*,
       row+,
     }
-->
<xsl:template match="table" mode="psml">
  <xsl:apply-templates select="psml:normalize-table(.)" mode="psml-normalized"/>
</xsl:template>

<!--
  Normalized table mapped to `<table>` element.

  This templates expects a normalized table in order to compute properly the column properties.

  If there is any column definition, they are grouped into the `<colgroup>` element.

  The 'cellspacing', 'cellpadding' and 'border' attributes arer copied to the table but this may no longer
  be the case in future versions as these attributes have been deprecated.

  The 'width' and 'height' attributes will be transformed into inline CSS rules.

  Any row with part 'header' or 'footer', will be grouped together in a `<thead>` or `<tfoot>` element
  respectively.
-->
<xsl:template match="table" mode="psml-normalized">
  <xsl:variable name="cols" select="psml:normalize-cols(.)" as="element(col)*"/>
  <table>
    <xsl:copy-of select="@summary | @cellspacing | @cellpadding | @border"/>
    <xsl:if test="@role"><xsl:attribute name="class" select="@role"/></xsl:if>
    <xsl:if test="@width or @height">
      <xsl:attribute name="style">
        <xsl:if test="@width">width:<xsl:value-of select="@width"/>;</xsl:if>
        <xsl:if test="@height">height:<xsl:value-of select="@height"/></xsl:if>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="col">
      <colgroup><xsl:apply-templates select="col" mode="psml"/></colgroup>
    </xsl:if>
    <xsl:if test="caption">
      <caption><xsl:apply-templates select="caption/node()" mode="psml"/></caption>
    </xsl:if>
    <xsl:if test="row[@part='header']">
      <thead>
        <xsl:apply-templates select="row[@part='header']" mode="psml">
          <xsl:with-param name="cols" select="$cols" tunnel="yes" />
        </xsl:apply-templates>
      </thead>
    </xsl:if>
    <xsl:if test="row[@part='footer']">
      <tfoot>
       <xsl:apply-templates select="row[@part='footer']" mode="psml">
         <xsl:with-param name="cols" select="$cols" tunnel="yes" />
       </xsl:apply-templates>
      </tfoot>
    </xsl:if>
    <tbody>
      <xsl:apply-templates select="row[not(@part) or @part = 'body']" mode="psml">
        <xsl:with-param name="cols" select="$cols" tunnel="yes" />
      </xsl:apply-templates>
    </tbody>
  </table>
</xsl:template>

<!--
  Column definition mapped to `<col>` element.

  The 'part', 'role' and 'align' attributes are preserved as 'data-*' attributes.

  The 'width' attribute will be transformed into inline CSS.

     col = element col {
       attribute role?,
       attribute span?,
       attribute width?,
       attribute align?,
       attribute part?,
     }

  @context table
-->
<xsl:template match="col" mode="psml">
<col>
  <xsl:copy-of select="@span"/>
  <!-- We keep track of these column attributes using a data attributes -->
  <xsl:if test="@part" ><xsl:attribute name="data-part"  select="@part" /></xsl:if>
  <xsl:if test="@role" ><xsl:attribute name="data-role"  select="@role" /></xsl:if>
  <xsl:if test="@align"><xsl:attribute name="data-align" select="@align"/></xsl:if>
  <!-- The width can be specified directly at the column level -->
  <xsl:if test="@width"><xsl:attribute name="style" select="concat('width:', @width)"/></xsl:if>
</col>
</xsl:template>

<!--
  Table row mapped to `<tr>` element.

  The 'part', 'role' and 'align' attributes are preserved as 'data-*' attributes.

  The 'width' attribute will be transformed into inline CSS.

     row = element row {
       attribute role?,
       attribute align?,
       attribute part?,
       (cell | hcell)+
     }

  @param cols The columns definitions for all cells in that row (may be supplied by table template)
  @context table
-->
<xsl:template match="row" mode="psml">
  <xsl:param name="cols" select="psml:normalize-cols(parent::table)" tunnel="yes" as="element(col)*"/>
  <tr>
    <xsl:for-each select="@role"><xsl:attribute name="class" select="."/></xsl:for-each>
    <xsl:if test="@align"><xsl:attribute name="style" select="psml:to-align-css(@align)"/></xsl:if>
    <xsl:apply-templates mode="psml"/>
  </tr>
</xsl:template>

<!--
  Table cell mapped to `<td>` or `<th>` element.

  The cell will be considered a header cell if it is a PSML <hcell> element or it is part of a column
  or header row.

      cell = element cell {
        attribute role?,
        attribute colspan?,
        attribute rowspan?,
        attribute align?,
        text
      }

  @param cols  An array of `<col>` to compute applicable column properties to the cell

  @context row
-->
<xsl:template match="cell|hcell" mode="psml">
<xsl:param name="cols" select="psml:normalize-cols(ancestor::table[1])" tunnel="yes" as="element(col)*"/>
<!-- Position of the cell without including rowspans -->
<xsl:variable name="position" select="count(preceding-sibling::*) + 1"/>
<xsl:variable name="col" select="$cols[$position]" as="element(col)?"/>
<xsl:element name="{if (self::hcell or parent::row/@part='header' or $col/@part = 'header') then 'th' else 'td'}">
  <xsl:copy-of select="@width | @rowspan | @colspan | @valign"/>
  <!-- Roles add up -->
  <xsl:if test="@role or $col/@role">
    <xsl:attribute name="class" select="@role|$col/@role"/>
  </xsl:if>
  <!-- Alignments override -->
  <xsl:choose>
    <xsl:when test="@align"><xsl:attribute name="style" select="psml:to-align-css(@align)"/></xsl:when>
    <xsl:when test="not(parent::row/@align) and $col/@align"><xsl:attribute name="style" select="psml:to-align-css($col/@align)"/></xsl:when>
  </xsl:choose>
  <xsl:apply-templates mode="psml"/>
</xsl:element>
</xsl:template>

<!--
  Ignore virtual cells.

  Virtual cells may be produced during the normalization process.
-->
<xsl:template match="virtual" mode="psml"/>


<!-- Images =================================================================================== -->

<!--
  Image mapped to an <img> element.

  The 'width', 'height' and 'alt' attributes are simply copied.
-->
<xsl:template match="image" mode="psml">
  <img src="{ancestor::psml-file/@base}{@src}">
    <xsl:copy-of select="@width | @height | @alt"/>
  </img>
</xsl:template>

<!-- Metadata =================================================================================== -->

<!--
  Properties fragments are output as `<table>`
-->
<xsl:template match="properties-fragment" mode="psml">
<table class="psml-properties">
<tbody>
  <xsl:for-each select="property">
    <tr data-name="{@name}" data-datatype="{@datatype}">
      <th><xsl:value-of select="if (@title) then @title else @name"/></th>
      <td>
        <xsl:choose>
          <xsl:when test="@count='n'">
            <ul>
              <xsl:for-each select="value|xref"><li><xsl:apply-templates select="." mode="psml"/></li></xsl:for-each>
            </ul>
          </xsl:when>
          <xsl:when test="@value"><xsl:value-of select="@value"/></xsl:when>
          <xsl:otherwise><xsl:apply-templates mode="psml"/></xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:for-each>
</tbody>
</table>
</xsl:template>

<!-- Utility Functions =======================================================================  -->

<!--
  Resolves the specified link  by removing the '.psml' extension if any and encoding the characters
  to produce a valid URI.

  For example '/bing/My URL.psml' -> '/bing/My%20URL'

  @param href The href to resolve.
  @return the corresponding link
-->
<xsl:function name="psml:resolve-xref" as="xs:string">
  <xsl:param name="href" as="xs:string"/>
  <!-- Decompose the xref -->
  <xsl:analyze-string select="$href" regex="([^?#]+)(\?[^#]*)?(#.*)?" >
    <xsl:matching-substring>
      <xsl:variable name="path"     select="regex-group(1)"/>
      <xsl:variable name="query"    select="regex-group(2)"/>
      <xsl:variable name="fragment" select="regex-group(3)"/>
      <xsl:value-of select="psml:resolve-xref($path, $query, $fragment)"/>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:message>Unable to parse xref: <xsl:value-of select="$href"/></xsl:message>
      <xsl:value-of select="$href"/>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:function>

<!--
  Returns the CSS class for for the given label name.

  This function turns the label to lower case, replaces non-word characters by a dash and
  prefix the label by 'label-'.

  @param label The name of the label
  @return the corresponding CSS class.
-->
<xsl:function name="psml:label-class" as="xs:string">
  <xsl:param name="label" as="xs:string"/>
  <xsl:value-of select="concat('label-', lower-case(replace($label, '\W', '-')))"/>
</xsl:function>

<!--
  Resolves the specified link  by removing the '.psml' extension if any and encoding the characters
  to produce a valid URI.

  For example '/bing/My URL.psml' -> '/bing/My%20URL'

  @param href The href to resolve.
  @return the corresponding link
-->
<xsl:function name="psml:resolve-xref" as="xs:string">
  <xsl:param name="path"     as="xs:string"/>
  <xsl:param name="query"    as="xs:string"/>
  <xsl:param name="fragment" as="xs:string"/>
  <xsl:analyze-string regex="^.+content/(.+)\.(ps|x)ml$" select="$path">
    <!-- An internal match -->
    <xsl:matching-substring>
      <xsl:value-of select="concat('/',regex-group(1), '.html', $query, $fragment)"/>
    </xsl:matching-substring>
    <!-- copy verbatim otherwise -->
    <xsl:non-matching-substring>
      <xsl:analyze-string regex="^(.+)\.psml$" select="$path">
        <!-- An internal match -->
        <xsl:matching-substring>
          <xsl:value-of select="concat(regex-group(1), '.html', $query, $fragment)"/>
        </xsl:matching-substring>
        <!-- copy verbatim otherwise -->
        <xsl:non-matching-substring>
          <xsl:value-of select="concat($path, $query, $fragment)"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:function>

<!--
  Returns the CSS for the align attribute as a `text-align` CSS property.

  @param align The align attribute
  @return the corresponding CSS.
-->
<xsl:function name="psml:to-align-css" as="xs:string?">
  <xsl:param name="align" as="attribute(align)"/>
  <xsl:if test="matches($align, 'left|center|right|justify')"><xsl:value-of select="concat('text-align:',$align,';')"/></xsl:if>
</xsl:function>

<!--
  Normalized `<col>` elements so that the column definition can be used for individual cells using
  their position.

  @param table The table
  @return an array of columns
-->
<xsl:function name="psml:normalize-cols" as="element(col)*">
  <xsl:param name="table" as="element(table)"/>
  <xsl:for-each select="$table/col">
    <xsl:variable name="attr" select="@align|@role|@part"/>
    <xsl:variable name="count" select="if (@span) then @span else 1" as="xs:integer"/>
    <xsl:for-each select="1 to $count">
      <col><xsl:copy-of select="$attr"/></col>
    </xsl:for-each>
  </xsl:for-each>
</xsl:function>

<!-- Table normalization ===============================================================================  -->

<!--
  Normalizes the table by creating virtual cells expanding the column and row spans.

  This is three-step process:
  1. Process the column spans
  2. Process the row spans
  3. Remove the attributes on virtual cells

  @param table the table to normalize
  @return The same table including virtual cells marked as 'virtual' elements
-->
<xsl:function name="psml:normalize-table" as="element(table)">
  <xsl:param name="table" as="element(table)"/>
  <!-- 1. Process the column spans -->
  <xsl:variable name="table-colspans-normalized" as="element(table)">
    <xsl:apply-templates select="$table" mode="normalize-colspan" />
  </xsl:variable>
  <!-- 2. Process the row spans -->
  <xsl:variable name="table-rowspans-normalized">
    <xsl:apply-templates select="$table-colspans-normalized" mode="normalize-rowspan" />
  </xsl:variable>
  <!-- 3. Remove the attributes on virtual cells -->
  <xsl:apply-templates select="$table-rowspans-normalized" mode="normalize-clean" />
</xsl:function>


<!--
  Copy all nodes by default while normalizing
  @private
-->
<xsl:template match="*" mode="normalize-colspan normalize-rowspan normalize-clean">
<xsl:copy>
  <xsl:copy-of select="@*"/>
  <xsl:apply-templates mode="#current" />
</xsl:copy>
</xsl:template>

<!--
  Expand the colspans as virtual nodes
  @private
-->
<xsl:template match="cell|hcell" mode="normalize-colspan">
  <!-- Copy the original verbatim -->
  <xsl:copy-of select="." />
  <!-- Fill up with some virtual cells -->
  <xsl:if test="@colspan > 1">
    <xsl:variable name="cell" select="."/>
    <xsl:for-each select="1 to (@colspan - 1) cast as xs:integer">
      <virtual><xsl:copy-of select="$cell/@rowspan"/></virtual>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<!--
  Process the rowspans row by row using recursive template
  @private
-->
<xsl:template match="table" mode="normalize-rowspan">
  <xsl:copy>
    <xsl:copy-of select="@*|*[not(self::row)]"/>
    <xsl:copy-of select="row[1]" />
    <xsl:apply-templates select="row[2]" mode="normalize-rowspan">
      <xsl:with-param name="previous" select="row[1]" />
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<!--
  Process the rowspans row using recursive template
  @private
-->
<xsl:template match="row" mode="normalize-rowspan">
  <xsl:param name="previous" as="element(row)" />
  <xsl:variable name="current" select="." as="element(row)"/>
  <xsl:variable name="normalized-cells">
    <xsl:for-each select="$previous/*">
      <xsl:choose>
        <xsl:when test="@rowspan > 1">
          <virtual rowspan="{@rowspan - 1}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$current/*[1 + count(current()/preceding-sibling::*[not(@rowspan) or (@rowspan = 1)])]" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="newRow" as="element(row)">
    <xsl:copy>
      <xsl:copy-of select="$current/@*" />
      <xsl:copy-of select="$normalized-cells" />
    </xsl:copy>
  </xsl:variable>

  <xsl:copy-of select="$newRow" />

  <xsl:choose>
    <!-- Keep processing -->
    <xsl:when test="following-sibling::row">
      <xsl:apply-templates select="following-sibling::row[1]" mode="normalize-rowspan">
        <xsl:with-param name="previous" select="$newRow" />
      </xsl:apply-templates>
    </xsl:when>
    <!-- Still some rowspan to process but reached end of table, keep processing the last line -->
    <xsl:when test="$normalized-cells//*[@rowspan > 1]">
      <xsl:apply-templates select="$current" mode="normalize-rowspan">
        <xsl:with-param name="previous" select="$newRow" />
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!--
  Remove uncessary attributes from virtual nodes
  @private
-->
<xsl:template match="row[not(cell|hcell)]" mode="normalize-clean"/>

<!--
  Remove uncessary attributes from virtual nodes
  @private
-->
<xsl:template match="virtual" mode="normalize-clean">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
