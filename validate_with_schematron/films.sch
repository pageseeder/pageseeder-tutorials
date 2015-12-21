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
    Rules for properties
  -->
  <sch:pattern name="Properties">
  
   <!-- Classification -->
   <sch:rule context="property[@name='classification']">
     <sch:assert test="contains('M PG G R18+', @value)">
       Fragment '<sch:value-of select="../@id"/>' - classification '<sch:value-of select="@value"/>' must be G, M, PG or R18+.
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
        Fragment '<sch:value-of select="../@id"/>' - genre '<sch:value-of select="@value"/>' should be specified at least one genre. 
      </sch:assert> 
    </sch:rule>    

  </sch:pattern>

  <!--
    Rules for image
  -->
  <sch:pattern name="Image">
  
    <!-- Image exists -->
    <sch:rule context="section[@id='image']">      
       <sch:assert test="count(descendant::image) and descendant::image/@src">
         Document '<sch:value-of select="../@id"/>' :  miss film poster.
       </sch:assert>
    </sch:rule>
    
    <!-- Image resolved -->
    <sch:rule context="image">      
       <sch:assert test="not(@unresolved) and @uriid">
         Fragment '<sch:value-of select="../@id"/>' -  image at <sch:value-of select="@src"/> is unresolved.
       </sch:assert>
    </sch:rule>
  </sch:pattern>
  
</sch:schema>

