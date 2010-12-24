<cfoutput>
	<script language="Javascript" type="text/javascript" src="/plugins/#application.Slatwall.pluginConfig.getDirectory()#/js/jquery.js"></script>
	<script language="Javascript" type="text/javascript" src="/plugins/#application.Slatwall.pluginConfig.getDirectory()#/js/slatwall.js"></script>
	<script language="Javascript" type="text/javascript" src="/plugins/#application.Slatwall.pluginConfig.getDirectory()#/js/fw1AjaxAdapter.js"></script>
	<link rel="stylesheet" type="text/css" href="/plugins/#application.slatwall.pluginConfig.getDirectory()#/css/slatwall.css" />
	<cfif isUserInRole('S2')>
		#variables.fw.view('admin:utility/toolbar')#
	</cfif>
</cfoutput>