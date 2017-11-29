<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="#all">
  
  <xsl:include href="layout.xsl"/>
  <xsl:include href="evaluate.xsl"/>
  
  
  <!-- 
    Load the schema configuration for the editor.
      -->
  <xsl:template name="get-iso19139.mcp-configuration">
    <xsl:copy-of select="document('config-editor.xml')"/>
  </xsl:template>


	<!-- The main dispatch point - process in iso19139.mcp mode first,
	     if we get something then use that otherwise process in iso19139
			 mode -->
  <xsl:template name="dispatch-iso19139.mcp">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="overrideLabel" as="xs:string" required="no" select="''"/>

		<!-- process in iso19139 mode - but we can override any templates
		     defined for iso19139 by importing that stylesheet into our
				 mcp stylesheet - that way the iso19139 templates will have
				 a lower priority than ours -->
    <xsl:apply-templates mode="mode-iso19139" select="$base">
     	<xsl:with-param name="overrideLabel" select="$overrideLabel"/>
    	<xsl:with-param name="schema" select="$schema"/>
    	<xsl:with-param name="labels" select="$iso19139.mcplabels"/>
    </xsl:apply-templates>

  </xsl:template>

</xsl:stylesheet>
