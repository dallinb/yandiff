<?xml version="1.0" encoding="utf-8"?>
<!--
Copyright (c) 2008-2011, League of Crafty Programmers Ltd <info@locp.co.uk>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY LEAGUE OF CRAFTY PROGRAMMERS ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL LEAGUE OF CRAFTY PROGRAMMERS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 See http://code.google.com/p/yandiff for details.
-->

<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- ............... Set the VERSION here ....................... -->
<xsl:variable name="yandiff_xsl_version">1.3</xsl:variable>
<!-- ............................................................ -->

<xsl:template match="yandiff">
<html>
<head>
<title>yandiff report</title>
<style type="text/css">
/* stylesheet print */
@media print
{
 #menu { display:none; }

 h1 { font-size: 13pt; font-weight:bold; margin:4pt 0pt 0pt 0pt;
  padding:0; }

 h2 { font-size: 12pt; font-weight:bold; margin:3pt 0pt 0pt 0pt; padding:0; }

 h3 { font-size: 9pt; font-weight:bold; margin:1pt 0pt 0pt 20pt; padding:0; }

 p,ul { font-size: 9pt; margin:1pt 0pt 8pt 40pt; padding:0; text-align:left; }

 li { font-size: 9pt; margin:0; padding:0; text-align:left; }

 table { margin:1pt 0pt 8pt 40pt; border:0px; width:90% }

 td { border:0px; border-top:1px solid black; font-size: 9pt; }

 .head td { border:0px; font-weight:bold; font-size: 9pt; }
}

/* stylesheet screen */
@media screen {
 body { margin: 0px; background-color: #FFFFFF; color: #000000;
  text-align: center; }

 #container { text-align:left; margin: 10px auto; width: 90%; }

 h1 { font-family: Verdana, Helvetica, sans-serif; font-weight:bold;
  font-size: 14pt; color: #000000; background-color:#87CEFA;
  margin:10px 0px 0px 0px; padding:5px 4px 5px 4px; width: 100%;
  border:1px solid black; text-align: left; }

 h2 { font-family: Verdana, Helvetica, sans-serif; font-weight:bold;
  font-size: 11pt; color: #000000; margin:30px 0px 0px 0px; padding:4px;
  width: 100%; border:1px solid black; background-color:#F0F8FF;
  text-align: left; }

 h2.green { color: #000000; background-color:#CCFFCC; border-color:#006400; }

 h2.red { color: #000000; background-color:#FFCCCC; border-color:#8B0000; }

 h2.orange { color: #000000; background-color:#FFDDBB; border-color:#8B0000; }
   
 h3 { font-family: Verdana, Helvetica, sans-serif; font-weight:bold;
  font-size: 10pt; color:#000000; background-color: #FFFFFF; width: 75%;
  text-align: left; }

 p { font-family: Verdana, Helvetica, sans-serif; font-size: 8pt;
  color:#000000; background-color: #FFFFFF; width: 75%; text-align: left; }

 p i { font-family: "Courier New", Courier, mono; font-size: 8pt;
  color:#000000; background-color: #CCCCCC; }

 ul { font-family: Verdana, Helvetica, sans-serif; font-size: 8pt;
  color:#000000; background-color: #FFFFFF; width: 75%; text-align: left; }

 a { font-family: Verdana, Helvetica, sans-serif; text-decoration: none;
  font-size: 8pt; color:#000000; font-weight:bold; background-color: #FFFFFF;
  color: #000000; }

 li a { font-family: Verdana, Helvetica, sans-serif; text-decoration: none;
  font-size: 10pt; color:#000000; font-weight:bold; background-color: #FFFFFF;
  color: #000000; }

 a:hover { text-decoration: underline; }

 a.red { color:#8B0000; }

 a.orange { color: orange; }

 a.green { color:#006400; }

 table { width: 80%; border:0px; color: #000000; background-color: #000000;
  margin:10px; }

 tr { vertical-align:top; font-family: Verdana, Helvetica, sans-serif;
  font-size: 8pt; color:#000000; background-color: #D1D1D1; }

 tr.head { background-color: #E1E1E1; color: #000000; font-weight:bold; }

 tr.open { background-color: #CCFFCC; color: #000000; }

 tr.filtered { background-color: #FFDDBB; color: #000000; }

 tr.closed { background-color: #FFAFAF; color: #000000; }

 td { padding:2px; }

 .status { display:none; }

 #menu li { display: inline; margin: 0; padding: 0; list-style-type: none; }
}
</style>
</head>
<body>
 <h1>Yandiff</h1>

 <h2>Run Parameters</h2>

 <table border="1">
  <caption><h3>Yandiff Information</h3></caption>
  <tr>
   <td>Run Date</td>
   <td><xsl:value-of select="@rundate"/></td>
  </tr>
  <tr>
   <td>Version</td>
   <td><xsl:value-of select="@version"/></td>
  </tr>
  <tr>
   <td>Command Arguments</td>
   <td><i><xsl:value-of select="@command_line"/></i></td>
  </tr>
  <xsl:if test="parameters/@node_key">
   <tr>
    <td>Node Key</td>
    <td><xsl:value-of select="parameters/@node_key"/></td>
   </tr>
  </xsl:if>
 </table>

 <table border="1">
  <caption><h3>Baseline Information</h3></caption>
  <tr>
   <td>Run Date</td>
   <td><xsl:value-of select="parameters/baseline/scan_start"/></td>
  </tr>
  <tr>
   <td>Nmap Version</td>
   <td><xsl:value-of select="parameters/baseline/nmap_version"/></td>
  </tr>
  <tr>
   <td>Scan Arguments</td>
   <td><i><xsl:value-of select="parameters/baseline/scan_args"/></i></td>
  </tr>
 </table>

 <table border="1">
  <caption><h3>Observed Information</h3></caption>
  <tr>
   <td>Run Date</td>
   <td><xsl:value-of select="parameters/observed/scan_start"/></td>
  </tr>
  <tr>
   <td>Nmap Version</td>
   <td><xsl:value-of select="parameters/observed/nmap_version"/></td>
  </tr>
  <tr>
   <td>Scan Arguments</td>
   <td><i><xsl:value-of select="parameters/observed/scan_args"/></i></td>
  </tr>
 </table>

 <xsl:if test="parameters/@nmap_version_warning">
  <p style="color: orange">Warning: Nmap version mismatch between the baseline
  and the observed scan.</p>
 </xsl:if>

 <h2>Host Summary</h2>

 <xsl:if test="new">
  <p><b>New</b>:
  <xsl:for-each select="new">
   <xsl:apply-templates select="host"/>
  </xsl:for-each>
  </p>
 </xsl:if>

 <xsl:if test="missing">
  <p><b>Missing</b>:
  <xsl:for-each select="missing">
   <xsl:apply-templates select="host"/>
  </xsl:for-each>
  </p>
 </xsl:if>

 <xsl:if test="changed">
  <p><b>Changed</b>:
  <xsl:for-each select="changed">
   <xsl:apply-templates select="host"/>
  </xsl:for-each>
  </p>
 </xsl:if>

 <xsl:if test="new">
  <h2>New</h2>

  <xsl:for-each select="new/host">
   <xsl:element name="a">
    <xsl:attribute name="name">
     <xsl:value-of select="translate(@ip_addr, '.', '_') " />
    </xsl:attribute>
   </xsl:element>

   <xsl:choose>
    <xsl:when test="@status = 'up'">
     <h2 class="green">
      <xsl:value-of select="@ip_addr"/>
      <xsl:if test="@mac_addr">
       , <xsl:value-of select="@mac_addr"/>
      </xsl:if>
      <xsl:if test="@hostname">
       (<xsl:value-of select="@hostname"/>)
      </xsl:if>
      - <xsl:value-of select="@status"/>
     </h2>
    </xsl:when>
    <xsl:otherwise>
     <h2 class="red">
      <xsl:value-of select="@ip_addr"/>
      <xsl:if test="@hostname">
       / <xsl:value-of select="@hostname"/>
      </xsl:if>
      (<xsl:value-of select="@status"/>)
     </h2>
    </xsl:otherwise>
   </xsl:choose>

   <table border="1">
    <tr>
     <th>Port</th>
     <th>Protocol</th>
     <th>Status</th>
     <th>Name</th>
    </tr>

   <xsl:apply-templates select="service"/>

   </table>
  </xsl:for-each>

 </xsl:if>

 <xsl:if test="missing">
  <h2>Missing</h2>
  <ul>

  <xsl:for-each select="missing/host">
   <xsl:element name="a">
    <xsl:attribute name="name">
     <xsl:value-of select="translate(@ip_addr, '.', '_') " />
    </xsl:attribute>
   </xsl:element>
   <li><b><xsl:value-of select="@ip_addr"/>
      <xsl:if test="@mac_addr">
       , <xsl:value-of select="@mac_addr"/>
      </xsl:if>
      <xsl:if test="@hostname">
       (<xsl:value-of select="@hostname"/>)
      </xsl:if>
   </b></li>
  </xsl:for-each>
  </ul>
 </xsl:if>

 <xsl:if test="changed">
  <h2>Changed</h2>

  <xsl:for-each select="changed/host">
   <xsl:element name="a">
    <xsl:attribute name="name">
     <xsl:value-of select="translate(@ip_addr, '.', '_') " />
    </xsl:attribute>
   </xsl:element>
   <xsl:choose>
    <xsl:when test="@status = 'up'">
     <h2 class="green">
      <xsl:value-of select="@ip_addr"/>
      <xsl:if test="@mac_addr">
       , <xsl:value-of select="@mac_addr"/>
      </xsl:if>
      <xsl:if test="@hostname">
       (<xsl:value-of select="@hostname"/>)
      </xsl:if>
      - <xsl:value-of select="@status"/>
     </h2>
    </xsl:when>
    <xsl:otherwise>
     <h2 class="red">
      <xsl:value-of select="@ip_addr"/>
      <xsl:if test="@mac_addr">
       , <xsl:value-of select="@mac_addr"/>
      </xsl:if>
      <xsl:if test="@hostname">
       (<xsl:value-of select="@hostname"/>)
      </xsl:if>
      - <xsl:value-of select="@status"/>
     </h2>
    </xsl:otherwise>
   </xsl:choose>

   <table border="1">
    <tr>
     <th>Change Type</th>
     <th>Port</th>
     <th>Protocol</th>
     <th>Status</th>
     <th>Name</th>
    </tr>

    <xsl:for-each select="new_services">
     <xsl:apply-templates select="service"/>
    </xsl:for-each>

    <xsl:for-each select="missing_services">
     <xsl:apply-templates select="service"/>
    </xsl:for-each>

    <xsl:for-each select="changed_services">
     <xsl:apply-templates select="service"/>
    </xsl:for-each>
   </table>
   <xsl:if test="os">
    <xsl:apply-templates select="os"/>
   </xsl:if>
  </xsl:for-each>
 </xsl:if>

 <sub>
  Yandiff stylesheet version: <xsl:value-of select="$yandiff_xsl_version" />
  &lt;<a href = 
  "http://code.google.com/p/yandiff">http://code.google.com/p/yandiff</a>&gt;
 </sub>
</body>
</html>
</xsl:template>

<xsl:template match="host">
   &lt;<xsl:element name="a">
   <xsl:if test="name(parent::node()) = 'new'">
    <xsl:attribute name="class">green</xsl:attribute>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'missing'">
    <xsl:attribute name="class">red</xsl:attribute>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'changed'">
    <xsl:attribute name="class">orange</xsl:attribute>
   </xsl:if>
   <xsl:attribute name="href">
    #<xsl:value-of select="translate(@ip_addr, '.', '_') "/>
   </xsl:attribute>
    <xsl:value-of select="@ip_addr"/><xsl:if test="@hostname"> /
    <xsl:value-of select="@hostname"/></xsl:if>
   </xsl:element>&gt;
</xsl:template>

<xsl:template match="os">
 <p><b>OS:</b>
  <ul>
   <li>Baseline: <xsl:value-of select="@baseline"/></li>
   <li>Observed: <xsl:value-of select="@observed"/></li>
  </ul>
 </p>
</xsl:template>

<xsl:template match="service">
<xsl:choose>
 <xsl:when test="@status = 'open'">
  <tr class="open">
   <xsl:if test="name(parent::node()) = 'new_services'">
    <td>New</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'missing_services'">
    <td>Missing</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'changed_services'">
    <td>Changed</td>
   </xsl:if>
   <td><xsl:value-of select="@portid"/></td>
   <td><xsl:value-of select="@proto"/></td>
   <xsl:choose>
    <xsl:when test="@previous">
     <td><xsl:value-of select="@status"/> (previously <xsl:value-of
      select="@previous"/>)</td>
    </xsl:when>
    <xsl:otherwise>
     <td><xsl:value-of select="@status"/></td>
    </xsl:otherwise>
   </xsl:choose>
   <td><xsl:value-of select="@name"/></td>
  </tr>
 </xsl:when>
 <xsl:when test="@status = 'closed'">
  <tr class="closed">
   <xsl:if test="name(parent::node()) = 'new_services'">
    <td>New</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'missing_services'">
    <td>Missing</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'changed_services'">
    <td>Changed</td>
   </xsl:if>
   <td><xsl:value-of select="@portid"/></td>
   <td><xsl:value-of select="@proto"/></td>
   <xsl:choose>
    <xsl:when test="@previous">
     <td><xsl:value-of select="@status"/> (previously <xsl:value-of
      select="@previous"/>)</td>
    </xsl:when>
    <xsl:otherwise>
     <td><xsl:value-of select="@status"/></td>
    </xsl:otherwise>
   </xsl:choose>
   <td><xsl:value-of select="@name"/></td>
  </tr>
 </xsl:when>
 <xsl:when test="@status = 'filtered'">
  <tr class="filtered">
   <xsl:if test="name(parent::node()) = 'new_services'">
    <td>New</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'missing_services'">
    <td>Missing</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'changed_services'">
    <td>Changed</td>
   </xsl:if>
   <td><xsl:value-of select="@portid"/></td>
   <td><xsl:value-of select="@proto"/></td>
   <xsl:choose>
    <xsl:when test="@previous">
     <td><xsl:value-of select="@status"/> (previously <xsl:value-of
      select="@previous"/>)</td>
    </xsl:when>
    <xsl:otherwise>
     <td><xsl:value-of select="@status"/></td>
    </xsl:otherwise>
   </xsl:choose>
   <td><xsl:value-of select="@name"/></td>
  </tr>
 </xsl:when>
 <xsl:otherwise>
  <tr>
   <xsl:if test="name(parent::node()) = 'new_services'">
    <td>New</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'missing_services'">
    <td>Missing</td>
   </xsl:if>
   <xsl:if test="name(parent::node()) = 'changed_services'">
    <td>Changed</td>
   </xsl:if>
   <td><xsl:value-of select="@portid"/></td>
   <td><xsl:value-of select="@proto"/></td>
   <xsl:choose>
    <xsl:when test="@previous">
     <td><xsl:value-of select="@status"/> (previously <xsl:value-of
      select="@previous"/>)</td>
    </xsl:when>
    <xsl:otherwise>
     <td><xsl:value-of select="@status"/></td>
    </xsl:otherwise>
   </xsl:choose>
   <td><xsl:value-of select="@name"/></td>
  </tr>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
