<?xml version="1.0" encoding="UTF-8" ?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:mcp="http://bluenet3.antcrc.utas.edu.au/mcp"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                version="2.0"
>

		<xsl:import href="../../iso19139/index-fields/index-subtemplate.xsl"/>

    <!--Contacts & Organisations-->
    <xsl:template mode="index" match="mcp:CI_Organisation">
        <xsl:param name="isoLangId"/>
        <xsl:param name="langId"/>
        <xsl:param name="locale"/>

        <xsl:variable name="org" select="normalize-space(mcp:name/gco:CharacterString)"/>
        <xsl:variable name="name" select="normalize-space(mcp:individual/mcp:CI_Individual/mcp:name/gco:CharacterString)"/>

        <Field name="_title" string="{if ($name != '') then concat($org, ' (', $name, ')') else $org}"
                       store="true" index="true"/>
        <Field name="orgName" string="{$org}" store="true" index="true"/>
        <Field name="orgNameTree" string="{$org}" store="true" index="true"/>
        <xsl:for-each select="*//mcp:contactInfo/*/gmd:address/*/gmd:electronicMailAddress/gco:CharacterString">
          <Field name="email" string="{.}" store="true" index="true"/>
        </xsl:for-each>

				<xsl:call-template name="subtemplate-common-fields"/>

    </xsl:template>

</xsl:stylesheet>
