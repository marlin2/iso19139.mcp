<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
		xmlns:app="http://www.deegree.org/app"
		xmlns:gco="http://www.isotc211.org/2005/gco"
		xmlns:gmd="http://www.isotc211.org/2005/gmd"
		xmlns:gml="http://www.opengis.net/gml"
		xmlns:wfs="http://www.opengis.net/wfs"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"		
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- 
			 This xslt should transform output from the WFS marlin database
	     feature type MarlinOrganisations
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
		<xsl:apply-templates select="app:MarlinOrganisations"/>
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

	<xsl:template match="app:MarlinOrganisations">
		<record uuid="urn:marlin.csiro.au:org:{app:organisation_id}">

			<!-- create gmd:name and gmd:contactInfo so that they can be used in:

			   responsibleParty/gmd:CI_Responsibility/gmd:party/gmd:CI_Organization 
		OR   responsibleParty/gmd:CI_Responsibility/gmd:party/gmd:CI_Individual 
		
						when building datasets and person records
				-->


			<!-- gmd:name organisation_name -->

			<fragment id="organisation_name" uuid="urn:marlin.csiro.au:org:{app:organisation_id}_organisation_name" title="name: {app:organisation_name}">
				<gco:CharacterString><xsl:value-of select="app:organisation_name"/></gco:CharacterString>
			</fragment>

			<!-- gmd:contactInfo - contact_info - mailing address -->

			<fragment id="contact_info_mailing_address" uuid="urn:marlin.csiro.au:org:{app:organisation_id}_contact_info_mailing_address" title="contact_mailing: {app:organisation_name}">
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
									<xsl:with-param name="value" select="normalize-space(concat(app:mail_address_1,' ',app:mail_address_2))"/>
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
                  <xsl:with-param name="value" select="app:country"/>
                </xsl:call-template>
							</gmd:country>
							<gmd:electronicMailAddress gco:nilReason="missing">
								<gco:CharacterString/>
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
			</fragment>

			<!-- gmd:contactInfo - contact_info - street address -->

			<xsl:if test="app:street_address_1">
			<fragment id="contact_info_street_address" uuid="urn:marlin.csiro.au:org:{app:organisation_id}_contact_info_street_address" title="contact street: {app:organisation_name}">
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
									<xsl:with-param name="value" select="normalize-space(concat(app:street_address_1,' ',app:street_address_2,' ',app:street_address_3))"/>
								</xsl:call-template>
							</gmd:deliveryPoint>
							<gmd:city>
								<xsl:call-template name="doStr">
                  <xsl:with-param name="value" select="normalize-space(concat(app:locality,' ',app:jurisdiction))"/>
                </xsl:call-template>
							</gmd:city>
							<gmd:administrativeArea>
								<xsl:call-template name="doStr">
                  <xsl:with-param name="value" select="app:state"/>
                </xsl:call-template>
							</gmd:administrativeArea>
							<gmd:postalCode>
								<xsl:call-template name="doStr">
                  <xsl:with-param name="value" select="app:postcode"/>
                </xsl:call-template>
							</gmd:postalCode>
							<gmd:country>
								<xsl:call-template name="doStr">
                  <xsl:with-param name="value" select="app:country"/>
                </xsl:call-template>
							</gmd:country>
							<gmd:electronicMailAddress gco:nilReason="missing">
								<gco:CharacterString/>
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
			</fragment>
			</xsl:if>

		</record>
	</xsl:template>


</xsl:stylesheet>
