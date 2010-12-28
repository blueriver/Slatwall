<cfoutput>
	Update Database Start
	#application.slatwall.dbUpdate.update(ConfigDirectory="#expandPath( '#application.slatsettings.getSetting('PluginPath')#/config' )#")#
	Update Database End
</cfoutput>