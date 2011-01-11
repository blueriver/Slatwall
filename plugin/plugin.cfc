component extends="mura.plugin.plugincfc" output="false" {

	variables.config="";
	variables.instance.extensionManager = application.classExtensionManager;

	public function init(any config) {
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
		ormReload();
		var settings = getSlatwallSettings();
		ClearOldAppContents(criteria=settings);
	}



	// Private Funtions
	
	private void function installORMSettings() {
		var settings = getSlatwallSettings();
		// Unescape
		settings = reReplace( settings, "<%=|=%>", "##", "all" );
		settings = reReplace( settings, "<%", "<", "all" );
		settings = reReplace( settings, "%>", ">", "all" );
		settings = reReplace( settings, "<~", "<!", "all" );
		// Remove/Cleanup any Slatwall code in the cfapplication file before apending new ORM code
		ClearOldAppContents(criteria=settings);
		// Append to file new ORM code
		var fileobj= fileOpen("#ExpandPath("/config/cfapplication.cfm")#", "append" );
		fileWriteLine(fileObj,"#settings#" );
		fileClose(fileobj);
		
	
	}
	
	// Searches cfapplication for Slatwall code and rewrites the file back 
	private void function ClearOldAppContents(required any criteria) {
	    // Get current cfapplication
		var FileData = FileRead("#ExpandPath("/config/cfapplication.cfm")#"); 
		// See if we have any Slatwall code that needs removing by matching below
		var data = REReplace(FileData, "\<!--- Slatwall Start ---\>.*?\<!--- Slatwall End ---\>", "", "ALL");
		// Remove only Slatwall code from the cfapplication.cfc
		var fileobj= fileOpen("#ExpandPath("/config/cfapplication.cfm")#", "write" );
		fileWriteLine(fileObj,"#data#" );
		fileClose(fileobj);
	}
	
	// Slatwall ORM settings file
	private  function getSlatwallSettings() {
		var settings = "";
		savecontent variable="settings" {
			include "ORMSettings.cfm";
		}	
		return settings; 
	}
// End cfc
}




