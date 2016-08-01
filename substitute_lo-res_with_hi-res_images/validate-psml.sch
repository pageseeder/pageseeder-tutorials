<?xml version="1.0" encoding="UTF-8"?>
<?xar Schematron?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2" >
        <sch:title>Validation for importing docx as PSXML</sch:title>
        <sch:ns prefix="w" uri="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>
        <sch:ns prefix="r" uri="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
        <sch:ns prefix="ve" uri="http://schemas.openxmlformats.org/markup-compatibility/2006" />
        <sch:ns prefix="o" uri="urn:schemas-microsoft-com:office:office"/>
        <sch:ns prefix="r" uri="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/> 
        <sch:ns prefix="m" uri="http://schemas.openxmlformats.org/officeDocument/2006/math" /> 
        <sch:ns prefix="v" uri="urn:schemas-microsoft-com:vml" />
        <sch:ns prefix="wp" uri="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" />
        <sch:ns prefix="w10" uri="urn:schemas-microsoft-com:office:word" />
        <sch:ns prefix="w" uri="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>
        <sch:ns prefix="wne" uri="http://schemas.microsoft.com/office/word/2006/wordml"/>
        
    <!-- 
        ==========================================================================
        This schema validates docx for importing as PSXML.
        
        @author Hugo Inacio
        @version 17 March 2014
    
        ==========================================================================
     -->
    
    <sch:pattern id="Tables">
		<sch:rule context="table">
		   <sch:assert test="(count(./row[1]/cell[not(@colspan)]) +( if (./row[1]/cell[@colspan]/@colspan) then sum(./row[1]/cell[@colspan]/@colspan) else 0) ) &lt; 64"  flag="error">Word cannot handle tables with more than 63 columns total number: <sch:value-of select="(count(./row[1]/cell[not(@colspan)]) + ( if (./row[1]/cell[@colspan]/@colspan) then sum(./row[1]/cell[@colspan]/@colspan) else 0)) "/></sch:assert>
		</sch:rule>
    </sch:pattern>
</sch:schema>
