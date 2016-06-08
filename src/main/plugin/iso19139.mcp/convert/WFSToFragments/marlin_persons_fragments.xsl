<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
		xmlns:app="http://www.deegree.org/app"
		xmlns:gco="http://www.isotc211.org/2005/gco"
		xmlns:gmd="http://www.isotc211.org/2005/gmd"
		xmlns:gml="http://www.opengis.net/gml"
		xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
		xmlns:wfs="http://www.opengis.net/wfs"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"		
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- 
			 This xslt transforms output from the WFS marlin database
	     feature type MarlinPersons to ISO XML fragments
	 -->

	<xsl:template match="wfs:FeatureCollection">
		<xsl:message>Processing <xsl:value-of select="@numberOfFeatures"/></xsl:message>
		<records>
			<xsl:if test="boolean( ./@timeStamp )">
				<xsl:attribute name="timeStamp">
					<xsl:value-of select="./@timeStamp"></xsl:value-of>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="boolean( ./@lockId )">
				<xsl:attribute name="lockId">
					<xsl:value-of select="./@lockId"></xsl:value-of>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="gml:featureMember"/>
		</records>
	</xsl:template>

	<xsl:template match="*[@xlink:href]" priority="20">
		<xsl:variable name="linkid" select="substring-after(@xlink:href,'#')"/>
		<xsl:apply-templates select="//*[@gml:id=$linkid]"/>
	</xsl:template>

	<xsl:template match="gml:featureMember">
		<xsl:apply-templates select="app:MarlinPersons"/>
	</xsl:template>

	<xsl:template name="doStr">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="normalize-space($value)=''">
        <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
				<gco:CharacterString/>
			</xsl:when>
			<xsl:otherwise>
				<gco:CharacterString><xsl:value-of select="$value"/></gco:CharacterString>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="app:organisation">
		<xsl:apply-templates select="app:MarlinOrganisations"/>
	</xsl:template>

	<xsl:template match="app:MarlinOrganisations">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="app:MarlinPersons">
		<record uuid="urn:marlin.csiro.au:person:{app:person_id}">

			<xsl:variable name="org">
				<xsl:if test="app:organisation">
					<xsl:apply-templates select="app:organisation"/>
				</xsl:if>
			</xsl:variable>

			<!-- create fragment

			   mcp:party/mcp:CI_Organisation 

				 with:
				 	 mcp:name = organisation name (xlink using organisation_id)
					 mcp:contactInfo = organisation CI_Contact (xlink using 
					                                         organisation_id)
				   mcp:individual/mcp:CI_Individual using 
					         app:surname+app:firstname
									 app:position_name and 
					 				 app:email

				-->


			<!-- gmd:party/CI_Organisation -->

			<fragment id="person_organisation" uuid="urn:marlin.csiro.au:person:{app:person_id}_person_organisation" title="{concat(app:surname,', ',app:given_names,'@',$org/app:MarlinOrganisations/app:organisation_name)}">
				<mcp:CI_Organisation>

					<!-- gmd:name organisation_name -->
					<xsl:choose>
						<xsl:when test="app:organisation_id!='-1'">
					<mcp:name xlink:href="local://xml.metadata.get?uuid=urn:marlin.csiro.au:org:{app:organisation_id}_organisation_name"/>
					<!-- gmd:contactInfo organisation_contact_info_mailing_address -->
					<xsl:if test="$org/app:MarlinOrganisations/app:mail_address_1">
						<mcp:contactInfo xlink:href="local://xml.metadata.get?uuid=urn:marlin.csiro.au:org:{app:organisation_id}_contact_info_mailing_address"/>
					</xsl:if>

					<!-- gmd:contactInfo organisation_contact_info_street_address -->
					<xsl:if test="$org/app:MarlinOrganisations/app:street_address_1">
						<mcp:contactInfo xlink:href="local://xml.metadata.get?uuid=urn:marlin.csiro.au:org:{app:organisation_id}_contact_info_street_address"/>
					</xsl:if>

						</xsl:when>
						<xsl:otherwise>
					<mcp:name>
						<xsl:call-template name="doStr">
							<xsl:with-param name="value" select="'Unknown organisation'"/>
						</xsl:call-template>
					</mcp:name>
						</xsl:otherwise>
					</xsl:choose>

		<!-- mcp:individual/mcp:CI_Individual -->
		<mcp:individual>
			<mcp:CI_Individual>
				<!-- gmd:name surname, given_names -->
				<mcp:name>
					<gco:CharacterString><xsl:value-of select="concat(app:surname,', ',app:given_names)"/></gco:CharacterString>
				</mcp:name>

	<xsl:choose>
		<xsl:when test="normalize-space(app:mail_address_1)!=''">

			<mcp:contactInfo>
				<gmd:CI_Contact>
					<gmd:phone>
						<gmd:CI_Telephone>
							<gmd:voice>
								<xsl:call-template name="doStr">
									<xsl:with-param name="value" select="app:telephone"/>
								</xsl:call-template>
							</gmd:voice>
							<gmd:facsimile>
								<xsl:call-template name="doStr">
									<xsl:with-param name="value" select="app:facsimile"/>
								</xsl:call-template>
							</gmd:facsimile>
						</gmd:CI_Telephone>
					</gmd:phone>
					<gmd:address>
						<gmd:CI_Address>
							<gmd:deliveryPoint>
								<xsl:call-template name="doStr">
									<xsl:with-param name="value" select="app:mail_address_1"/>
								</xsl:call-template>
							</gmd:deliveryPoint>
							<gmd:city>
								<xsl:call-template name="doStr">
           				<xsl:with-param name="value" select="app:mail_locality"/>
         				</xsl:call-template>
							</gmd:city>
							<gmd:administrativeArea>
								<xsl:call-template name="doStr">
           				<xsl:with-param name="value" select="app:mail_state"/>
         				</xsl:call-template>
							</gmd:administrativeArea>
							<gmd:postalCode>
								<xsl:call-template name="doStr">
           				<xsl:with-param name="value" select="app:mail_postcode"/>
         				</xsl:call-template>
							</gmd:postalCode>
							<gmd:country>
								<xsl:call-template name="doStr">
           				<xsl:with-param name="value" select="''"/>
         				</xsl:call-template>
							</gmd:country>
							<gmd:electronicMailAddress>
								<xsl:call-template name="doStr">
           				<xsl:with-param name="value" select="app:email"/>
         				</xsl:call-template>
							</gmd:electronicMailAddress>
						</gmd:CI_Address>
     			</gmd:address>
					<!-- add an online resource here if web address given -->
					<xsl:if test="app:web_address">
		 				<gmd:onlineResource>
		 					<gmd:CI_OnlineResource>
								<gmd:linkage>
									<gmd:URL><xsl:value-of select="app:web_address"/></gmd:URL>
								</gmd:linkage>
								<gmd:protocol>
									<gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
								</gmd:protocol>
								<gmd:description>
									<gco:CharacterString>Web address for organisation <xsl:value-of select="app:organisation_name"/></gco:CharacterString>
								</gmd:description>
		 					</gmd:CI_OnlineResource>
		 				</gmd:onlineResource>
					</xsl:if>
     		</gmd:CI_Contact>
			</mcp:contactInfo>
		</xsl:when>
		<xsl:when test="normalize-space(app:email)!=''">
			<mcp:contactInfo>
				<gmd:CI_Contact>
					<gmd:address>
						<gmd:CI_Address>
							<gmd:electronicMailAddress>
								<xsl:call-template name="doStr">
           				<xsl:with-param name="value" select="app:email"/>
         				</xsl:call-template>
							</gmd:electronicMailAddress>
						</gmd:CI_Address>
     			</gmd:address>
				</gmd:CI_Contact>
			</mcp:contactInfo>
		</xsl:when>
	</xsl:choose>

					<mcp:positionName>
						<xsl:call-template name="doStr">
							<xsl:with-param name="value" select="app:position_name"/>
						</xsl:call-template>
					</mcp:positionName>
				</mcp:CI_Individual>
			</mcp:individual>
		</mcp:CI_Organisation>
	</fragment>

	</record>
	</xsl:template>


</xsl:stylesheet>
