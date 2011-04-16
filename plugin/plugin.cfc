/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="mura.plugin.plugincfc" output="false" { 

	variables.config="";
	variables.instance.extensionManager = application.classExtensionManager;

	public void function init(any config) {
		variables.config = arguments.config;
	}
	
	// On install
	public void function install() {
		application.appInitialized=false;
		setUpClassExtension();
		installORMSettings();
		ormReload();
	}
	
	// On update
	public void function update() {
		application.appInitialized=false;
		setUpClassExtension();
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
	
	private void function setUpClassExtension() {
		var assignedSites = variables.config.getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			local.thisSiteID = assignedSites["siteID"][i];
			local.thisSubType = application.classExtensionManager.getSubTypeBean();
			local.thisSubType.set( {
				type = "Page",
				subType = "SlatwallProductListing",
				siteID = local.thisSiteID
			} );
			// we load the subType (in case it already exists) before it's saved
			local.thisSubType.load();
			var isNewSubType = len(local.thisSubType.getSubTypeID()) ? false : true;
			local.thisSubType.save();
			// set up extendSet if the subtype didn't already exist
			if(isNewSubType) {
				// get the default extend set. this is automatically created for every subType
				local.thisExtendSet = local.thisSubType.getExtendSetByName( "Default" );
				// rename the extend set, set the subtypeID, and save it 
				local.thisExtendSet.set({
					name = "Slatwall Product Listing Attributes",
					subType = local.thisSubType.getSubTypeID()
				});
				local.thisExtendSet.save();
				// create a new attribute for the "default" extend set
				// getAttributeBy Name will look for it and if not found give me a new bean to use 
				local.thisAttribute = local.thisExtendSet.getAttributeByName("productsPerPage");
				local.thisAttribute.set({
					label = "Products Per Page",
					type = "TextBox",
					validation = "numeric",
					defaultValue = "16"
				});
				local.thisAttribute.save();
			}
		}
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
}
