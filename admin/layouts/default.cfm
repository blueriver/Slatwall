<cfparam name="rc.section" default="" />
<cfsavecontent variable="local.adminLayout">
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
</cfoutput>