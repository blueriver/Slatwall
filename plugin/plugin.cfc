component extends="mura.plugin.plugincfc" output="false" { 

	variables.config="";
	variables.instance.extensionManager = application.classExtensionManager;

	public void function init(any config) {
		variables.config = arguments.config;
	}
	
	// On install
	public void function install() {
		application.appInitialized=false;
		installORMSettings();
		ormReload();
	}
	
	// On update
	public void function update() {
		application.appInitialized=false;
		installORMSettings();
		ormReload();
	}
	// On delete
	public void function delete() {
		// Clear out cfapplication file
	    ClearOldAppContents();
		ormReload();
	}
	
	// Private Funtions
	private void function installORMSettings() {
		var settings = getSlatwallSettings();
		// Unescape
		settings = reReplace( settings, "<%=|=%>", "##", "all" );
		settings = reReplace( settings, "<%", "<", "all" );
		settings = reReplace( settings, "%>", ">", "all" );
		settings = reReplace( settings, "<~", "<!", "all" );
		
		// Check if install/update needs to remove comments
		if (#variables.config.getSetting( 'ORMpreference' )#){
			settings = reReplace( settings, "<!--- Remove this line", " ", "all" );
			settings = reReplace( settings, "Remove this line --->", " ", "all" );
		}
		
		// Create ORM file that will be included
		FileWrite("#ExpandPath("/plugins/Slatwall_#variables.config.getPluginID()#/cfapplication.cfm")#", "#settings#");
		
		// Clear out old Slatwall data
		ClearOldAppContents();

		var includeStr = "<cfinclude template='/plugins/Slatwall_#variables.config.getPluginID()#/cfapplication.cfm'>";
	    // Append to file new ORM code
		var fileobj= fileOpen("#ExpandPath("/config/cfapplication.cfm")#", "append" );
		fileWriteLine(fileObj,"#includeStr#" );
		fileClose(fileobj);
	
	}
	
	private void function ClearOldAppContents() {
	    // Get current cfapplication file and all its settings
		var FileData = FileRead("#ExpandPath("/config/cfapplication.cfm")#"); 
		// See if we have any Slatwall code that needs removing from this file
		var data = REReplace(FileData, "<cfinclude template='/plugins/Slatwall_#variables.config.getPluginID()#/cfapplication.cfm'>", "", "ALL");
		// Remove ONLY Slatwall code from the cfapplication.cfc file
		var fileobj= fileOpen("#ExpandPath("/config/cfapplication.cfm")#", "write" );
		fileWriteLine(fileObj,"#data#" );
		fileClose(fileobj);
	}	
	
	// Slatwall ORM settings file
	private any function getSlatwallSettings() {
		var settings = "";
		savecontent variable="settings" {
			include "ORMSettings.cfm";
		}	
		return settings; 
	}
	


	
// End cfc
}













