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
		structDelete(session, "slatwallSession");
		// Clear out cfapplication file
	    ClearOldAppContents();
		ormReload();
	}
	
	// Private Funtions
	private void function installORMSettings() {
			
		// Clear out old Slatwall data
		ClearOldAppContents();
		
		// Check if install/update needs to remove comments
		if (#variables.config.getSetting( 'ORMpreference' )#){
			var includeStr = "<cfinclude template='/plugins/Slatwall/config/cfapplication.cfm'>";
		} else {
			var includeStr = "<!--- <cfinclude template='/plugins/Slatwall/config/cfapplication.cfm'> --->";
		}
		
		// Append to file new ORM code
		var fileobj= fileOpen("#ExpandPath("/config/cfapplication.cfm")#", "append");
		fileWriteLine(fileObj,"#includeStr#" );
		fileClose(fileobj);
	
	}
	
	private void function ClearOldAppContents() {
	    // Get current cfapplication file and all its settings
		var FileData = FileRead("#ExpandPath("/config/cfapplication.cfm")#"); 
		// See if we have any Slatwall code that needs removing from this file
		var	data = REReplace(FileData, "<cfinclude template='/plugins/Slatwall/config/cfapplication.cfm'>", "", "ALL");
		// Remove ONLY Slatwall code from the cfapplication.cfc file
		var fileobj= fileOpen("#ExpandPath("/config/cfapplication.cfm")#", "write" );
		fileWriteLine(fileObj,"#data#" );
		fileClose(fileobj);
	}
	
	// This is a temporary function to fix the bug that ORM has where it can't setup char(35) as a datatype
	private void function temporaryORMBugFix() {
		var fixQuery = new Query();
		fixQuery.setDataSource(application.configBean.getDatasource());
		fixQuery.setUsername(application.configBean.getUsername());
		fixQuery.setPassword(application.configBean.getPassword());
		if(application.configBean.getDbType() == "mysql") {
			fixQuery.setSql("
				ALTER TABLE tusers DROP PRIMARY KEY;
			");
		} else {
			fixQuery.setSql("
				ALTER TABLE tusers DROP CONSTRAINT PK_tusers;
			");
		}
		fixQuery.execute();
		fixQuery.setSql("
			ALTER TABLE tusers ALTER COLUMN UserID varchar(35) NOT NULL;
		");
		fixQuery.execute();
		fixQuery.setSql("
			ALTER TABLE tusers ADD CONSTRAINT PK_tusers PRIMARY KEY (UserID);
		");
		fixQuery.execute();
	}
	
	private boolean function updateData() {
		var dataPopulator = new Slatwall.com.utility.DataPopulator();
		return dataPopulator.loadDataFromXMLDirectory(xmlDirectory = ExpandPath("/plugins/Slatwall/config/DBData"));
	}
	
}