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
								<xsl:apply-templates select="people" />
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
	<xsl:template match="people">
		<table width="640" cellpadding="0" cellspacing="0" class="defaultHeight">
			<tr>
				<td colspan="2" class="heading">- <xsl:value-of select="//title" /> -</td>
			</tr>
			<!--tr>
				<td class="dob">As of <xsl:value-of select="people/@as-of"/></td>
			</tr-->
			<xsl:apply-templates select="person">
				<xsl:sort select="@name" />
			</xsl:apply-templates>
		</table>
	</xsl:template>
	<xsl:template match="person">
		<tr>
			<td class="cvSubHead"><xsl:value-of select="@name"/>[<xsl:value-of select="@dob"/>]</td>
			<td class="cvSubBody"><xsl:value-of select="plan"/></td>
		</tr>
		<tr>
			<td>&#160;</td>
			<td>&#160;</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
