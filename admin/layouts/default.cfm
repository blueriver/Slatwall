<cfoutput>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
	#application.pluginManager.renderAdminToolBar()#
	<script type="text/javascript">
		var slat_pluginid = #getPluginConfig().getPluginID()#;
	</script>
	<script language="Javascript" type="text/javascript" src="/plugins/#getPluginConfig().getDirectory()#/js/jquery.js"></script>
	<script language="Javascript" type="text/javascript" src="/plugins/#getPluginConfig().getDirectory()#/js/slatwall.js"></script>
	<script language="Javascript" type="text/javascript" src="/plugins/#getPluginConfig().getDirectory()#/js/fw1AjaxAdapter.js"></script>
	<link rel="stylesheet" type="text/css" href="/admin/css/admin.css" />
	<link rel="stylesheet" type="text/css" href="/plugins/#getPluginConfig().getDirectory()#/css/slatwall_admin.css" />
	<link rel="stylesheet" type="text/css" href="/plugins/#getPluginConfig().getDirectory()#/css/slatwall.css" />
</head>
<body>
	#view('utility/toolbar')#
	<div class="admincontainer">
		<h1>Page Title</h1>
		#body#
	</div>
</body>
</html>
</cfoutput>