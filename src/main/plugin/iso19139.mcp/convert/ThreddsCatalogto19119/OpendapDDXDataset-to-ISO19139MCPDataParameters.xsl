<?xml version="1.0" encoding="UTF-8"?>
<!--  Mapping between netcdfDatasetInfo and MCP dataParameters -->
<xsl:stylesheet version="2.0" 
										xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gts="http://www.isotc211.org/2005/gts"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:srv="http://www.isotc211.org/2005/srv"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:util="java:java.util.UUID"
                    xmlns:ddx="http://xml.opendap.org/ns/DAP2"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:xlink="http://www.w3.org/1999/xlink"
										exclude-result-prefixes="util">

	<!-- ==================================================================== -->
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
	
	<!-- ==================================================================== -->

	<xsl:template match="*">
	
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<mcp:dataParameters>
			<mcp:DP_DataParameters>

			<xsl:for-each select="ddx:Array">
				<mcp:dataParameter>
					<mcp:DP_DataParameter>

						<!-- short name -->

						<mcp:parameterName>
							<mcp:DP_ParameterName>
								<mcp:name>
									<gco:CharacterString><xsl:value-of select="@name"/></gco:CharacterString>
								</mcp:name>
								<mcp:type>
									<mcp:DP_TypeCode codeList="http://bluenet3.antcrc.utas.edu.au/mcp/resources/Codelist/gmxCodelists.xml#DP_TypeCode" codeListValue="shortName"/>
								</mcp:type>
								<mcp:usedInDataset>
									<gco:Boolean>true</gco:Boolean>
								</mcp:usedInDataset>
							</mcp:DP_ParameterName>
						</mcp:parameterName>

						<!-- long name -->

						<xsl:if test="ddx:Attribute/@name='long_name'">
							<mcp:parameterName>
								<mcp:DP_ParameterName>
									<mcp:name>
										<gco:CharacterString><xsl:value-of select="ddx:Attribute[@name='long_name']/ddx:value"/></gco:CharacterString>
									</mcp:name>
									<mcp:type>
										<mcp:DP_TypeCode codeList="http://bluenet3.antcrc.utas.edu.au/mcp/resources/Codelist/gmxCodelists.xml#DP_TypeCode" codeListValue="longName"/>
									</mcp:type>
									<mcp:usedInDataset>
										<gco:Boolean>false</gco:Boolean>
									</mcp:usedInDataset>
								</mcp:DP_ParameterName>
							</mcp:parameterName>
						</xsl:if>

						<!-- units -->

						<xsl:if test="ddx:Attribute/@name='units'">
							<mcp:parameterUnits>
								<mcp:DP_UnitsName>
									<mcp:name>
										<gco:CharacterString><xsl:value-of select="ddx:Attribute[@name='units']/ddx:value"/></gco:CharacterString>
									</mcp:name>
									<mcp:type>
										<mcp:DP_TypeCode codeList="http://bluenet3.antcrc.utas.edu.au/mcp/resources/Codelist/gmxCodelists.xml#DP_TypeCode" codeListValue="shortName"/>
									</mcp:type>
									<mcp:usedInDataset>
										<gco:Boolean>true</gco:Boolean>
									</mcp:usedInDataset>
								</mcp:DP_UnitsName>
							</mcp:parameterUnits>
						</xsl:if>

						<!-- description (we'll use the long name here) -->

						<xsl:if test="ddx:Attribute/@name='long_name'">
							<mcp:parameterDescription>
								<gco:CharacterString><xsl:value-of select="ddx:Attribute[@name='long_name']/ddx:value"/></gco:CharacterString>
							</mcp:parameterDescription>
						</xsl:if>

					</mcp:DP_DataParameter>
				</mcp:dataParameter>

			</xsl:for-each>
			</mcp:DP_DataParameters>
		</mcp:dataParameters>

	</xsl:template>
	
	<!-- ============================================================================= -->

</xsl:stylesheet>
