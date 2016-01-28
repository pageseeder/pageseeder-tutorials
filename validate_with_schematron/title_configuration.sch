<?xml version="1.0"?>
<!--
  This schematron validates a PSML document.

  The schematron rules can be used to enforce additional constraints required
  by the application.

  @see https://dev.pageseeder.com/api/data/psml.html
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            title="Rules for title_configuration documents">

  <!--
    Set of rules applying to the document properties
  -->
  <sch:pattern name="Properties">
    <sch:let name="URI" value="'/ps/oxford/collection/documents/title_configuration_codes.psml'"/>
    <sch:let name="code-list-document" value="document( $URI )" />
    <sch:let name="lic-type-list" value="$code-list-document//fragment[@id='lic-type']"/>
  
  <!-- Section "title-config" -->
    <sch:rule context="property[@name='title-config-id']">
      <sch:assert test="matches(@value, 'OB\d{3}')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'OBXXX'.      
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='title-config-goto-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule>      
    <sch:rule context="property[@name='title-config-type']">
      <sch:assert test="@value='ola' or @value='oli'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'ola' or 'oli'.
      </sch:assert>
    </sch:rule>
    
  <!-- Section "update-tab" -->
    <sch:rule context="property[@name='update-tab-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='update-tab-prompt-date']">
      <sch:assert test="@value='' or @value castable as xs:date">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be YYYYMMDD or YYYY-MM-DD.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='update-tab-content']">
      <sch:assert test="@value='' or not(xref/@unresolved) and xref='message-text.psml'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to file 'message-text.psml'.
      </sch:assert>
    </sch:rule>
    
  <!-- Section "content" -->
    <sch:rule context="property[@name='content-tab-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule>    
    <sch:rule context="property[@name='content-tab-section1-alertpane-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='content-tab-section1-master']">
      <sch:assert test="@value='' or not(xref/@unresolved) and xref='master-chunk.psml'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to file 'master-chunk.psml'.
      </sch:assert>
    </sch:rule>        
    <sch:rule context="property[@name='content-tab-section2-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    
  <!-- Section "rich-assets" -->
    <sch:rule context="property[@name='rich-assets-tab-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule>    
    <sch:rule context="property[@name='rich-assets-tab-master']">
      <sch:assert test="@value='' or not(xref/@unresolved) and xref='master-rich-asset.psml'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to file 'master-rich-asset.psml'.
      </sch:assert>
    </sch:rule>
    
  <!-- Section "assess-tab" -->
    <sch:rule context="property[@name='assess-tab-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='assess-tab-predefined-test-master']">
      <sch:assert test="@value='' or not(xref/@unresolved) and xref='master-predefined-test.psml'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to file 'master-predefined-test.psml'.
      </sch:assert>
    </sch:rule>  
    <sch:rule context="property[@name='assess-tab-questionbank-master']">
      <sch:assert test="@value='' or not(xref/@unresolved) and xref='master-questionbank.psml'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to file 'master-questionbank.psml'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='assess-available-test-type']">
      <sch:assert test="@count and matches(@count,'[0-9n]+')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' : value display format is not correct.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='assess-available-test-type']/value">
      <sch:let name="assess-available-test-type-list" value="$code-list-document//fragment[@id='assess-available-test-type']"/>
      <sch:assert test="$assess-available-test-type-list//item=current()">
      Fragment '<sch:value-of select="../../@id"/>' - Property '<sch:value-of select="../@name"/>' value '<sch:value-of select="current()"/>' is not valid. The valid value should be <sch:value-of select="$assess-available-test-type-list/list"/>.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='assess-tab-acknowledgement']">
      <sch:assert test="@value='' or not(xref/@unresolved)">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link.
      </sch:assert>
    </sch:rule>
    
  <!-- Section "update1" -->
    <sch:rule context="property[@name='update1-available-lic-type']">
      <sch:assert test="@count and matches(@count,'[0-9n]+')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' : value display format is not correct.
      </sch:assert>
    </sch:rule>
    
  <!-- Section "update2" -->
    <sch:rule context="property[@name='update2-available-lic-type']">
      <sch:assert test="@count and matches(@count,'[0-9n]+')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' : value display format is not correct.
      </sch:assert>
    </sch:rule>
    
  <!-- Section "notes" -->
    <sch:rule context="property[@name='notes-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    
    
  <!-- Section "classmgmnt" -->
    <sch:rule context="property[@name='classmgmnt-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    
  <!-- Section "obook" -->
    <sch:rule context="property[@name='obook-css']">
      <sch:assert test="@value='' or not(xref/@unresolved) and ends-with(xref, '.css')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to css file.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='obook-js']">
      <sch:assert test="@value='' or not(xref/@unresolved) and ends-with(xref, '.js')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to js file.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='obook-search-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='obook-txtresize-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='obook-dictool-available-option']">
      <sch:let name="obook-dictool-available-option-list" value="$code-list-document//fragment[@id='obook-dictool-available-option']"/> 
      <sch:assert test="$obook-dictool-available-option-list//item = @value">
        Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be <sch:value-of select="$obook-dictool-available-option-list/list//item"/>.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='obook-answer-export-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='obook-answer-email-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='obook-print-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='obook-menu-glossary-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    
  <!-- Section "obook-pdf-download-opt1" -->
    <sch:rule context="property[@name='obook-pdf-download-opt1-available-lic-type']">
      <sch:assert test="@count and matches(@count,'[0-9n]+')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' : value display format is not correct.
      </sch:assert>
    </sch:rule>
  
  <!-- Section "obook-pdf-download-opt2" -->
    <sch:rule context="property[@name='obook-pdf-download-opt2-available-lic-type']">
      <sch:assert test="@count and matches(@count,'[0-9n]+')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' : value display format is not correct.
      </sch:assert>
    </sch:rule>
  
  <!-- Section "obook-alt-version1" -->
    <sch:rule context="property[@name='obook-alt-version1-available-lic-type']">
      <sch:assert test="@count and matches(@count,'[0-9n]+')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' : value display format is not correct.
      </sch:assert>
    </sch:rule>
  
  <!-- Section "obook-alt-version2" -->
    <sch:rule context="property[@name='obook-alt-version2-available-lic-type']">
      <sch:assert test="@count and matches(@count,'[0-9n]+')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' : value display format is not correct.
      </sch:assert>
    </sch:rule>
         
  <!-- Section "assess" -->
    <sch:rule context="property[@name='assess-css']">
      <sch:assert test="@value='' or not(xref/@unresolved) and ends-with(xref, '.css')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to css file.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='assess-js']">
      <sch:assert test="@value='' or not(xref/@unresolved) and ends-with(xref, '.js')">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to js file.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='assess-txtresize-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='assess-dictool-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='assess-answer-export-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='assess-answer-email-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='assess-print-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    
   <!-- Section "extras-dashboard" -->
     <sch:rule context="property[@name='dashboard-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='dashboard-chunk-view-default']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='extras-tab-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    <sch:rule context="property[@name='extras-tab-references']">
      <sch:assert test="@value='' or not(xref/@unresolved) and xref='extra_references.psml'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be a resolved xref link to file 'extra_references.psml'.
      </sch:assert>
    </sch:rule>
    <sch:let name="extras-inter-obook-type" value="$code-list-document//properties-fragment[@id='extras-inter-obook-type']"/>
    <sch:rule context="property[@name='extras-inter-obook-A']">      
      <sch:assert test="$extras-inter-obook-type//property[@name='extras-inter-obook-A']/@value=@value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$extras-inter-obook-type//property[@name='extras-inter-obook-A']/@value"/>'
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='extras-inter-obook-B']">      
      <sch:assert test="$extras-inter-obook-type//property[@name='extras-inter-obook-B']/@value=@value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$extras-inter-obook-type//property[@name='extras-inter-obook-B']/@value"/>'
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='extras-inter-obook-C']">      
      <sch:assert test="$extras-inter-obook-type//property[@name='extras-inter-obook-C']/@value=@value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$extras-inter-obook-type//property[@name='extras-inter-obook-C']/@value"/>'
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='extras-inter-obook-D']">      
      <sch:assert test="$extras-inter-obook-type//property[@name='extras-inter-obook-D']/@value=@value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$extras-inter-obook-type//property[@name='extras-inter-obook-D']/@value"/>'
      </sch:assert>
    </sch:rule>
    
  <!-- Section "dictionary" -->
    <sch:rule context="property[@name='dictionary-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    
  <!-- Section "myextras" -->
    <sch:rule context="property[@name='myextras-available-bool']">
      <sch:assert test="@value='Yes' or @value='No'">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value '<sch:value-of select="@value"/>' is not valid. The valid value should be 'Yes' or 'No'.
      </sch:assert>
    </sch:rule> 
    
  <!-- Section "all labels" -->
    <sch:rule context="property[@name='content-tab-section1-label']">
      <sch:let name="content-tab-section1-labels" value="$code-list-document//fragment[@id='content-tab-section1-labels']"/>
      <sch:assert test="$content-tab-section1-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$content-tab-section1-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='content-tab-section2-label']">
      <sch:let name="content-tab-section2-labels" value="$code-list-document//fragment[@id='content-tab-section2-labels']"/>
      <sch:assert test="$content-tab-section2-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$content-tab-section2-labels/list"/>'.
      </sch:assert>
    </sch:rule>    
    <sch:rule context="property[@name='assess-tab-label']">
      <sch:let name="assess-tab-labels" value="$code-list-document//fragment[@id='assess-tab-labels']"/>
      <sch:assert test="$assess-tab-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$assess-tab-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='update1-label']">
      <sch:let name="update1-labels" value="$code-list-document//fragment[@id='update1-labels']"/>
      <sch:assert test="$update1-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$update1-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='update2-label']">
      <sch:let name="update2-labels" value="$code-list-document//fragment[@id='update2-labels']"/>
      <sch:assert test="$update2-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$update2-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='rich-assets-tab-label']">
      <sch:let name="rich-assets-tab-labels" value="$code-list-document//fragment[@id='rich-assets-tab-labels']"/>
      <sch:assert test="$rich-assets-tab-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$rich-assets-tab-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='notes-label']">
      <sch:let name="notes-labels" value="$code-list-document//fragment[@id='notes-labels']"/>
      <sch:assert test="$notes-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$notes-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='classmgmnt-label']">
      <sch:let name="classmgmnt-labels" value="$code-list-document//fragment[@id='classmgmnt-labels']"/>
      <sch:assert test="$classmgmnt-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$classmgmnt-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='extras-tab-label']">
      <sch:let name="extras-tab-labels" value="$code-list-document//fragment[@id='extras-tab-labels']"/>
      <sch:assert test="$extras-tab-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$extras-tab-labels/list"/>'.
      </sch:assert>
    </sch:rule>
    <sch:rule context="property[@name='myextras-label']">
      <sch:let name="myextras-labels" value="$code-list-document//fragment[@id='myextras-labels']"/>
      <sch:assert test="$myextras-labels//item = @value">
      Fragment '<sch:value-of select="../@id"/>' - Property '<sch:value-of select="@name"/>' value is not valid. The valid value should be '<sch:value-of select="$myextras-labels/list"/>'.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  
  </sch:schema>
