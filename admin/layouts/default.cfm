<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.section" default="Slatwall" />
<cfparam name="rc.activeTab" default=0 />
<cfparam name="rc.activePanel" default=0 />
<cfparam name="rc.message" type="string" default="" />
<cfparam name="rc.messagetype" type="string" default="info" />

<!--- Add mura specific JS variables --->
<cfset getAssetWire().addJSVariable("htmlEditorType", application.configBean.getValue("htmlEditorType")) />
<cfset getAssetWire().addJSVariable("context", application.configBean.getContext()) />
<cfset getAssetWire().addJSVariable("themepath", application.settingsManager.getSite(session.siteID).getThemeAssetPath()) />
<cfset getAssetWire().addJSVariable("rb", lcase(session.rb)) />
<cfif isNumeric(application.configBean.getValue('sessionTimeout'))>
	<cfset getAssetWire().addJSVariable("sessionTimeout", application.configBean.getValue('sessionTimeout') * 60) />
<cfelse>
	<cfset getAssetWire().addJSVariable("sessionTimeout", 180) />
</cfif>
<cfset getAssetWire().addJSVariable("activeTab", rc.activeTab) />
<cfset getAssetWire().addJSVariable("activePanel", rc.activeTab) />
<cfset getAssetWire().addJSVariable("dtExample", DateFormat(now(), "MM/DD/YYYY")) />
<cfset getAssetWire().addJSVariable("dtCh", "/") />
<cfset getAssetWire().addJSVariable("dtFormat", [0,1,2]) />
<cfset getAssetWire().addJSVariable("dtLocale", "#session.dtLocale#") />

<cfoutput>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
    <title>#rc.sectionTitle# - #rc.itemTitle# &##124; Slatwall</title>
	<link rel="icon" href="#$.slatwall.getSlatwallRootPath()#/assets/images/favicon.png" type="image/png" />
	<link rel="shortcut icon" href="#$.slatwall.getSlatwallRootPath()#/assets/images/favicon.png" type="image/png" />
</head>
<body>
	#view("common:toolbar/menu")#
	<div id="header">
		<h1>Mura CMS</h1>
		<cfoutput>
		<a href="#buildURL('admin:main')#"><img class="slatwallLogo" src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.default.slatwall_logo.png" height="16" width="100" alt="Slatwall Ecommerce" /></a>
		<ul id="navUtility">
		    <li id="navSiteManager">
		    	<a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.list&siteid=#rc.$.event('siteid')#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a>
			</li>
		    <li id="navLogout">
		    	<a href="#application.configBean.getContext()#/admin/index.cfm?fuseaction=cLogin.logout">#application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a>
			</li>
		</ul>
		<p id="welcome">#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</p>
		</cfoutput>
		<p id="currentSite"><cf_SlatwallActionCaller text="#rc.sectionTitle#" action="#request.subsystem#:#request.section#" type="link"> &rarr; #rc.itemTitle#</p>
	</div>
	
	<div class="admincontainer">
		#view("admin:includes/message")#
		#body#
		<br class="clear" />
		<br class="clear" />
	</div>
<div id="alertDialog" title="Alert" style="display:none">
    <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span><span id="alertDialogMessage"></span></p>
</div>
<script type="text/javascript" language="javascript">
stripe('stripe');
</script>
</body>
</html>
</cfoutput>
