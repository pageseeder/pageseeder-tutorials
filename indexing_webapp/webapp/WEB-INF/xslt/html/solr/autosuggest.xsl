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

<xsl:template match="content[@name='autosuggest-solr']" mode="content">
  <h2>Autosuggest</h2>
  <div class="row">
    <div class="small-2 columns text-right">People</div>
    <div class="small-4 columns end">
      <input type="text" class="autosuggest" name="term" data-href="/solr/autosuggest/solr-people.xml" />
    </div>
  </div>
  <div class="row">
    <div class="small-2 columns text-right">Movies</div>
    <div class="small-4 columns end">
      <input type="text" class="autosuggest movies" name="term" data-href="/solr/autosuggest/movies.xml" />
    </div>
  </div>
  <div class="row">
    <div class="small-2 columns text-right">Movies<br/><small>with extra weight to USA</small></div>
    <div class="small-4 columns end">
      <input type="text" class="autosuggest movies" name="term" data-href="/solr/autosuggest/usmovies.xml" />
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
