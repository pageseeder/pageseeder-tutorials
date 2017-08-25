<?xml version="1.0"?>
<!--

  @author Christophe Lauret
  @version 26 September 2011
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:dec="java:java.net.URLDecoder"
                              xmlns:ps="http://www.pageseeder.com/editing/2.0"
                              xmlns:bf="http://weborganic.org/Berlioz/XSLT/Function"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
                              exclude-result-prefixes="xsl ps dec bf xs">

<xsl:template match="content" mode="search-results-html">
  <xsl:if test="index-search/search-results">
    <section id="search-results">
      <h3>Search Results</h3>
      <xsl:choose>
        <xsl:when test="not(index-search/search-results/documents/document)">
          <p>No results from search <code><xsl:value-of select="index-search/search-results/query/@lucene" /></code>.</p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="with">
            <xsl:variable name="params" select="index-search/search-results/query//parameters/term-parameter" />
            <xsl:if test="$params">
              <xsl:text> with facets </xsl:text>
              <xsl:for-each select="$params">
                <xsl:choose>
                  <xsl:when test="position() = 0" />
                  <xsl:when test="position() = last()"> and </xsl:when>
                  <xsl:when test="position() != 0">, </xsl:when>
                </xsl:choose>
                <code><xsl:value-of select="replace(field, 'prop_', '')"/>:<xsl:value-of select="text"/></code>
              </xsl:for-each>
            </xsl:if>
          </xsl:variable>
          <p>Found <xsl:value-of select="index-search/search-results/metadata/hits/total" /> results<xsl:value-of select="$with" />.</p>
          <xsl:if test="index-search/search-results/metadata/hits[number(total) gt number(per-page)]">
            <xsl:variable name="current" select="number(index-search/search-results/metadata/page/current)" />
            <xsl:variable name="total"   select="number(index-search/search-results/metadata/page/last)" />
            <ul class="pagination">
              <xsl:for-each select="xs:integer(max((1, $current - 3))) to xs:integer(min(($current + 3, $total)))">
                <li class="page{if (. = $current) then ' current' else ''}">
                  <a href="#" data-page="{.}"><xsl:value-of select="." /></a>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
          <ol class="results">
            <xsl:apply-templates select="index-search/search-results/documents" mode="html" />
          </ol>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:if>
</xsl:template>

<xsl:template match="document[field[@name = 'type'] = 'film']" mode="html">
  <xsl:param name="expand" select="false()" tunnel="yes" />
  <li class="result card">
    <h4 class="movie_title"><xsl:value-of select="bf:document-title(.)" /></h4>
    <div class="card-section">
      <table class="movie">
        <thead><tr><th colspan="3" class="info"><xsl:value-of select="field[@name = 'title']" /></th></tr></thead>
        <tbody>
          <tr>
            <th colspan="2"><b>Director:</b></th>
            <td>
              <xsl:for-each select="field[@name = 'prop_director']">
                <p>
                  <a class="bio" href="/lucene/search/bio.xml?name={encode-for-uri(normalize-space(replace(lower-case(.), '[^a-z ]', ' ')))}"><xsl:value-of select="." /></a>
                  <xsl:if test="position() != last()">,</xsl:if>
                </p>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th colspan="2"><b>Year:</b></th>
            <td><a href="/lucene/browse.html?with=prop_year:{field[@name = 'prop_year']}"><xsl:value-of select="field[@name = 'prop_year']" /></a></td>
          </tr>
          <tr>
            <td class="blank-cell"></td>
            <th class="title">Cast:</th>
            <td>
              <xsl:for-each select="field[@name = 'prop_actor']">
                <p>
                  <xsl:for-each select="tokenize(., '[^a-zA-Z]')">
                    <a class="bio" href="/lucene/search/bio.xml?name={encode-for-uri(lower-case(.))}"><xsl:value-of select="." /></a>
                    <xsl:text> </xsl:text>
                  </xsl:for-each>
                  <xsl:if test="position() != last()">,</xsl:if>
                </p>
              </xsl:for-each>
            </td>
            <td></td>
          </tr>
          <tr>
            <td class="blank-cell"></td>
            <th class="title">Genre:</th>
            <td>
              <xsl:for-each select="field[@name = 'prop_genre']">
                <p>
                  <a href="/lucene/browse.html?with=prop_genre:{encode-for-uri(.)}"><xsl:value-of select="." /></a>
                  <xsl:if test="position() != last()">/</xsl:if>
                </p>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <td class="blank-cell"></td>
          </tr>
        </tbody>
      </table>
    </div>
    <img src="{field[@name = 'image']}" />
  </li>
</xsl:template>

<xsl:function name="bf:document-title">
  <xsl:param name="doc" as="element(document)" />
  <xsl:choose>
    <xsl:when test="$doc/field[@name = 'prop_common-name']"><xsl:value-of select="$doc/field[@name = 'prop_common-name']" /></xsl:when>
    <xsl:when test="$doc/field[@name = 'title']"><xsl:value-of select="$doc/field[@name = 'title']" /></xsl:when>
    <xsl:when test="$doc/field[@name = 'name' ]"><xsl:value-of select="$doc/field[@name = 'name']" /></xsl:when>
    <xsl:otherwise><xsl:value-of select="$doc/field[@name = '_path']" /></xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:template match="document[field[@name = 'type'] = 'bio']" mode="html">
  <xsl:param name="expand" select="false()" tunnel="yes" />
  <li class="result card">
    <h4 class="bio_title"><xsl:value-of select="bf:document-title(.)" /></h4>
    <div class="card-section">
      <table class="bio">
        <tbody>
          <xsl:if test="extract">
            <tr><td colspan="2"><xsl:apply-templates select="extract" mode="html" /></td></tr>
          </xsl:if>
          <tr>
            <th><b>Born:</b></th>
            <td>
              <xsl:value-of select="field[@name = 'prop_born']" />
              <xsl:if test="string(field[@name = 'prop_birth-place']) != ''">
                <xsl:text> in </xsl:text>
                <xsl:value-of select="field[@name = 'prop_birth-place']" />
              </xsl:if>
            </td>
          </tr>
          <xsl:if test="string(field[@name = 'prop_died']) != ''">
            <tr>
              <th><b>Died:</b></th>
              <td><xsl:value-of select="field[@name = 'prop_died']" /></td>
            </tr>
          </xsl:if>
          <tr>
            <td colspan="2"><a href="/bio/{field[@name = 'index']}.html">See more</a></td>
          </tr>
          <tr>
            <td colspan="2" class="blank-cell"></td>
          </tr>
        </tbody>
      </table>
    </div>
    <img src="{field[@name = 'image']}" />
  </li>
</xsl:template>

<xsl:template match="term" mode="html">
  <strong><xsl:apply-templates mode="html" /></strong>
</xsl:template>

</xsl:stylesheet>