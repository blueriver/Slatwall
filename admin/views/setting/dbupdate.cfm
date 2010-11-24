<cfoutput>
	Update Database Start
	#application.slat.dbUpdate.update(ConfigDirectory="#expandPath( '#application.slatsettings.getSetting('PluginPath')#/config' )#")#
	Update Database End
</cfoutput>