<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:include href="menu.xsl" />
	<xsl:template match="/">
		<html>
			<head>
				<title>Minc - <xsl:value-of select="//title" /></title>
				<link href="Lib/minc.css" type="text/css" rel="stylesheet" />
			</head>
			<body>
				<table width="640" class="topTable">
					<tr>
						<td>
							<a href="index.htm">Minc</a><xsl:value-of select="//title" />&#160;<xsl:value-of select="//title/@description" /></td>
					</tr>
				</table>
				<table width="840" cellspacing="0" cellpadding="0" class="defaultHeight">
					<tbody>
						<tr>
							<td class="menuLeft">
								<xsl:call-template name="leftMenu" />
							</td>
							<td valign="top">
								<xsl:apply-templates select="links" />
							</td>
							<td class="menuRight">
								<xsl:call-template name="rightMenu" />
							</td>
						</tr>
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="links">
		<table width="640" cellspacing="0" cellpadding="0" class="defaultHeight">
			<tr>
				<td class="heading">
					<xsl:attribute name="colspan">
						<xsl:value-of select="count(/links/group)" />
					</xsl:attribute>
					- <xsl:value-of select="//title" /> -
				</td>
			</tr>
			<tr>
				<xsl:apply-templates select="group" />
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="group">
		<td valign="top">
			<table width="100%" cellspacing="0" cellpadding="0"> 
				<!--
				<xsl:attribute name="width">
					<xsl:value-of select="100 div count(/links/group)" />100%
				</xsl:attribute>
				-->
				<xsl:if test="a">
					<tr>
						<td class="cvSubHead"><xsl:value-of select="@title" /></td>
					</tr>
					<xsl:apply-templates select="a">
						<xsl:sort select="." />
					</xsl:apply-templates>
					<tr>
						<td>&#160;</td>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="subgroup" />	
			</table>
		</td>
	</xsl:template>
	<xsl:template match="subgroup">
			<tr>
				<td class="cvSubHead"><xsl:value-of select="../@title" /> | <xsl:value-of select="@title" /></td>
			</tr>
			<xsl:apply-templates select="a">
				<xsl:sort select="." />
			</xsl:apply-templates>
			<tr>
				<td>&#160;</td>
			</tr>
			<xsl:apply-templates select="subgroup" />
	</xsl:template>
	<xsl:template match="a">
		<tr>
			<td>
				<xsl:if test="contains(@href, '://')">
					[<xsl:copy-of select="." />]
				</xsl:if>
				<xsl:if test="not(contains(@href, '://'))">
					[<a href="http://{@href}">
						<xsl:value-of select="." />
					</a>]
				</xsl:if>
			</td>
		</tr> 
	</xsl:template>
</xsl:stylesheet>
