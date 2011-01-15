<cfparam name="rc.section" default="" />
<!---<cfsavecontent variable="local.adminLayout">
<cfoutput>
	<script type="text/javascript">
		var slat_pluginid = #getPluginConfig().getPluginID()#;
	</script>
	<script language="Javascript" type="text/javascript" src="/plugins/#getPluginConfig().getDirectory()#/js/slatwall.js"></script>
	<script language="Javascript" type="text/javascript" src="/plugins/#getPluginConfig().getDirectory()#/js/fw1AjaxAdapter.js"></script>
	<link rel="stylesheet" type="text/css" href="/admin/css/admin.css" />
	<link rel="stylesheet" type="text/css" href="/plugins/#getPluginConfig().getDirectory()#/css/slatwall_admin.css" />
	<link rel="stylesheet" type="text/css" href="/plugins/#getPluginConfig().getDirectory()#/css/slatwall.css" />
	<img class="slatwallLogo" src="/plugins/#getPluginConfig().getDirectory()#/images/slatwall_logo.png" height="33" width="200" alt="Slatwall Ecommerce" />
	#view('utility/toolbar')#
	<h2>#getPluginConfig().getPackage()#<cfif len(rc.section)> - #rc.Section#</cfif></h2>
		#body#
</cfoutput>
</cfsavecontent>
<cfoutput>
#rc.$.getBean("pluginManager").renderAdminTemplate(body=local.adminLayout,pageTitle=getPluginConfig().getName(),jslib="jquery")#
</cfoutput>--->
<cfoutput>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
	<script type="text/javascript">
		var slat_pluginid = #getPluginConfig().getPluginID()#;
	</script>
	<script language="Javascript" type="text/javascript" src="/admin/js/jquery/jquery.js"></script>
	<script language="Javascript" type="text/javascript" src="/admin/js/jquery/jquery-ui.js"></script>
	<script language="Javascript" type="text/javascript" src="/plugins/#getPluginConfig().getDirectory()#/js/slatwall.js"></script>
	<script language="Javascript" type="text/javascript" src="/plugins/#getPluginConfig().getDirectory()#/js/fw1AjaxAdapter.js"></script>
	<link rel="stylesheet" type="text/css" href="/admin/css/admin.css" />
	<link rel="stylesheet" type="text/css" href="/admin/css/jquery/default/jquery.ui.all.css" />
	<link rel="stylesheet" type="text/css" href="/plugins/#getPluginConfig().getDirectory()#/css/slatwall_admin.css" />
	<link rel="stylesheet" type="text/css" href="/plugins/#getPluginConfig().getDirectory()#/css/slatwall.css" />
	<script type="text/javascript">
	var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
	var context='#application.configBean.getContext()#';
	var themepath='#application.settingsManager.getSite(session.siteID).getThemeAssetPath()#';
	var rb='#lcase(session.rb)#';
	var sessionTimeout=#evaluate("application.configBean.getValue('sessionTimeout') * 60")#;
	</script>
	#session.dateKey#
	<script type="text/javascript">
		jQuery(document).ready(function(){setDatePickers(".datepicker",dtLocale);setTabs(".tabs",0);setHTMLEditors();setAccordions(".accordion",0)});
	</script>
</head>
<body>
	#application.pluginManager.renderAdminToolBar("jquery",true)#
	#view('utility/toolbar')#
	<div class="admincontainer">
		<img class="slatwallLogo" src="/plugins/#getPluginConfig().getDirectory()#/images/slatwall_logo.png" height="33" width="200" alt="Slatwall Ecommerce" />
		<h2>#getPluginConfig().getPackage()#<cfif len(rc.section)> - #rc.Section#</cfif></h2>
		#body#
	</div>
</body>
</html>
</cfoutput>