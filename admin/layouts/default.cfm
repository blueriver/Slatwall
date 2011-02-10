<cfparam name="rc.section" default="Slatwall" />
<cfparam name="rc.activeTab" default=0 />
<cfparam name="rc.activePanel" default=0 />
<cfoutput>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
    <title>#rc.section# &##124; Slatwall</title>
	<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/jquery/jquery.js?coreversion=#application.coreversion#"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui.js?coreversion=#application.coreversion#"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/jquery/jquery-ui-i18n.js?coreversion=#application.coreversion#"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/admin/js/admin.js?coreversion=#application.coreversion#"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/slatwall.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/fw1AjaxAdapter.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js"></script>
	<link href="#application.configBean.getContext()#/admin/css/admin.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<link href="#application.configBean.getContext()#/admin/css/jquery/default/jquery.ui.all.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
	<link href="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/css/slatwall_admin.css" rel="stylesheet" type="text/css" />
	<link href="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/css/slatwall.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript">
		var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
		var context='#application.configBean.getContext()#';
		var themepath='#application.settingsManager.getSite(session.siteID).getThemeAssetPath()#';
		var rb='#lcase(session.rb)#';
		var sessionTimeout=<cfif isNumeric(application.configBean.getValue('sessionTimeout'))>#evaluate("application.configBean.getValue('sessionTimeout') * 60")#<cfelse>180</cfif>;
	</script>
		#session.dateKey#
	<script type="text/javascript">
		jQuery(document).ready(function(){setDatePickers(".datepicker",dtLocale);setTabs(".tabs",#rc.activeTab#);setHTMLEditors();setAccordions(".accordion",#rc.activePanel#)});
	</script>
	#view( "product/head/productForm.js" )#
</head>
<body>
	<!---#application.pluginManager.renderAdminToolBar("jquery",true)#--->
	<div id="header">
		<a id="blueRiverLink" title="mura by blueRiver" target="_blank" href="http://blueriver.com"></a>
		<h1>Mura CMS</h1>
		#view("utility/header")#
		<img class="slatwallLogo" src="/plugins/#getPluginConfig().getDirectory()#/images/slatwall_logo.png" height="24" width="150" alt="Slatwall Ecommerce" />
	</div>
	#view('utility/toolbar')#
	<div class="admincontainer">
		<h2>#rc.sectionTitle#</h2>
		<h3>#rc.itemTitle#</h3>
		#body#
	</div>
</body>
</html>
</cfoutput>