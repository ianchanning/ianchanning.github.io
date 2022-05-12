<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template name="leftMenu">
		<a href="bcd.htm">BCD Test</a>
		<xsl:element name="br" />
		<a href="cv.htm">CV</a>
		<xsl:element name="br" />
		<a href="da_plan.xml">Da Plan</a>
		<xsl:element name="br" />
		<a href="links.xml">Links</a>
	</xsl:template>
	<xsl:template name="rightMenu">
		last modified:
		<script language="Javascript">
			var dateModified = document.lastModified;
			document.write( document.lastModified );
		</script>.
	</xsl:template>
</xsl:stylesheet>