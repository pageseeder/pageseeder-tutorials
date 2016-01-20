<?xml version="1.0"?>
<!--
  This schematron validates a PSML document.

  The schematron rules can be used to enforce additional constraints required
  by the application.

  @see https://dev.pageseeder.com/api/data/psml.html
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            title="Rules for film documents">

  <!--
    Set of rules applying to the document properties
  -->
  <sch:pattern name="Properties">
    <sch:let name="URI" value="'/ps/films/tutorial/documents/film_codes.psml'"/>
    <sch:let name="code-list-document" value="document($URI)" />
    <!-- Classification -->
    <sch:rule context="property[@name='classification']">
      
      <sch:let name="classification-list" value="$code-list-document//fragment[@id='classification-codes']"/>
      <!--sch:let name="current-value" value="./@value castable as xs:string"/-->
      <sch:assert test="$classification-list//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - classification '<sch:value-of select="@value"/>' is not valid. 
      </sch:assert>
    </sch:rule>
    
    <!-- Year-->
       <sch:rule context="property[@name='year']">
         <sch:assert test="number(@value) le number(year-from-date(current-date())) and number(@value) gt 1900">
         Fragment '<sch:value-of select="../@id"/>' - year '<sch:value-of select="@value"/>' is not valid.
         </sch:assert>
    </sch:rule>
	
    <!-- Genre -->
    <sch:rule context="property[@name='genre']">
       <sch:assert test="@count and count(value)">
         Fragment '<sch:value-of select="../@id"/>' -  genre should be specified at least one genre.
       </sch:assert>
     </sch:rule>
    <sch:rule context="property[@name='genre']/value">
       <sch:let name="genre-list" value="$code-list-document//fragment[@id='genre-codes']"/>
       <sch:assert test="$genre-list//item=current()">
         Fragment '<sch:value-of select="../../@id"/>' -  genre '<sch:value-of select="current()"/>' is not valid. 
         </sch:assert>
     </sch:rule>
	 
     <!-- Director -->
    <sch:rule context="property[@name='director']">
       <sch:assert test="@count and count(value)">
         Fragment '<sch:value-of select="../@id"/>' -  direcotr should be specified at least one name.
       </sch:assert>
     </sch:rule>
     
     <!-- Writer -->
    <sch:rule context="property[@name='writer']">
       <sch:assert test="@count and count(value)">
         Fragment '<sch:value-of select="../@id"/>' -  writer should be specified at least one name.
       </sch:assert>
     </sch:rule>
    
    <!-- Producer -->
    <sch:rule context="property[@name='producer']">
       <sch:assert test="@count and count(value)">
         Fragment '<sch:value-of select="../@id"/>' -  producer should be specified at least one name.
       </sch:assert>
     </sch:rule>
    
    <!-- Actor -->
    <sch:rule context="property[@name='actor']">
       <sch:assert test="@count and count(value)">
         Fragment '<sch:value-of select="../@id"/>' -  actor should be specified at least one name.
       </sch:assert>
     </sch:rule>
    
    <!-- Country -->
    <sch:rule context="property[@name='country']">
       <sch:assert test="@value">
         Fragment '<sch:value-of select="../@id"/>' -  country should be specified at least one country.
       </sch:assert>
     </sch:rule>
  </sch:pattern>

  <!--
    Set of rules applying to the document text
  -->
  <sch:pattern name="summary">
     <sch:rule context="section[@id='summary']">
       <sch:assert test="count(descendant::para)">
         Documdent '<sch:value-of select="../@id"/>' :  miss film summary
       </sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <!--
    Set of rules applying to the image
  -->  
  <sch:pattern name="image">
    <sch:rule context="section[@id='image']">       
       <sch:assert test="count(descendant::image) and descendant::image/@src">
         Document '<sch:value-of select="../@id"/>' :  miss film poster.
       </sch:assert>
    </sch:rule>
    <sch:rule context="image">       
       <sch:assert test="not(@unresolved) and @uriid">
         Fragment '<sch:value-of select="../@id"/>' -  image at <sch:value-of select="@src"/> is unresolved.
       </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
