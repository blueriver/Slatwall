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
component extends="BaseService" output="false" accessors="true"  {
	
	// Mura Service Injection
	property name="configBean" type="any";
	property name="contentManager" type="any";
	
	// Global Properties Set in Application Scope
	
	property name="settings" type="struct";
	property name="permissions" type="struct";
	property name="shippingMethods" type="struct";
	property name="shippingServices" type="struct";
	property name="paymentMethods" type="struct";
	property name="paymentServices" type="struct";
	property name="permissionActions" type="struct";
		
	public void function reloadConfiguration() {
		var settingsList = this.listSetting();
		
		variables.permissions = {};
		variables.settings = {};
		variables.shippingServices = {};
		variables.paymentServices = {};
		
		getPermissionActions();
		getShippingServices();
		getPaymentServices();
		
		// Load Settings & Permissions
		for(var i = 1; i <= arrayLen(settingsList); i++) {
			
			if( listFirst( settingsList[i].getSettingName(), "_") == "permission") {
				// Set the permission value in the permissions scop 
				variables.permissions[ settingsList[i].getSettingName() ] = settingsList[i];
			} else {
				// Set the global setting value in the settings scope
				variables.settings[ settingsList[i].getSettingName() ] = settingsList[i];	
			}
		}
		
	}
	
	public struct function getSettings(boolean reload=false) {
		if(!structKeyExists(variables, "settings") || arguments.reload == true) {
			reloadConfiguration();
		}
		return variables.settings;
	}
	
	public struct function getPermissions(boolean reload=false) {
		if(!structKeyExists(variables, "permissions") || arguments.reload == true) {
			reloadConfiguration();
		}
		return variables.permissions;
	}
	
	public any function getSettingValue(required string settingName) {
		if( structKeyExists(variables.settings,arguments.settingName) ) {
			return variables.settings[ arguments.settingName ].getSettingValue();
		} else {
			return "";
		}	
	}
	
	public any function getPermissionValue(required string permissionName) {
		if(structKeyExists(variables.permissions, arguments.permissionName)) {
			return variables.permissions[ arguments.permissionName ].getSettingValue();
		} else {
			return "";
		}
	}
	
	public any function getBySettingName(required string settingName) {
		if(structKeyExists(variables.settings, arguments.settingName)) {
			return variables.settings[ arguments.settingName ];
		} else {
			var setting = this.newSetting();
			setting.setSettingName(arguments.settingName);
			return	setting;
		}
	}
	
	public any function getByPermissionName(required string permissionName) {
		if(structKeyExists(variables.permissions, arguments.permissionName)) {
			return variables.permissions[ arguments.permissionName ];
		} else {
			return this.newSetting();	
		}
	}
	
	public struct function getPermissionActions(boolean reload=false) {
		if(!structKeyExists(variables, "permissionActions") || !structCount(variables.permissionActions) || arguments.reload) {
			variables.permissionActions = structNew();
			var dirLocation = expandPath("/plugins/Slatwall/admin/controllers");
			var dirList = directoryList(dirLocation,"false","name","*.cfc");
			for(var i=1; i<= arrayLen(dirList); i++) {
				var controllerName = Replace(listGetAt(dirList[i],listLen(dirList[i],"\/"),"\/"),".cfc","");
				var controller = createObject("component", "Slatwall.admin.controllers.#controllerName#");
				var controllerMetaData = getMetaData(controller);
				if(controllerName != "BaseController") {
					variables.permissionActions[ "#controllerName#" ] = arrayNew(1);
					for(var ii=1; ii <= arrayLen(controllerMetaData.functions); ii++) {
						if(FindNoCase("before", controllerMetaData.functions[ii].name) == 0 && FindNoCase("service", controllerMetaData.functions[ii].name) == 0 && FindNoCase("get", controllerMetaData.functions[ii].name) == 0 && FindNoCase("set", controllerMetaData.functions[ii].name) == 0 && FindNoCase("init", controllerMetaData.functions[ii].name) == 0 && FindNoCase("dashboard", controllerMetaData.functions[ii].name) == 0) {
							arrayAppend(variables.permissionActions[ "#controllerName#" ], controllerMetaData.functions[ii].name);
						}
					}
					arraySort(variables.permissionActions[ "#controllerName#" ], "textnocase", "asc" );
				}
			}
		}
		return variables.permissionActions;
	}

	public any function saveAddressZone(required any entity, struct data) {
		if( structKeyExists(arguments, "data") && structKeyExists(arguments.data,"addressZoneLocations") ) {
			for(var i in arguments.data.addressZoneLocations) {
				if(left(i,3) == "new" && len(i) >= 4) {
					var addressZoneLocation = newAddressZoneLocation();
					addressZoneLocation.populate(arguments.data.addressZoneLocations[i]);
					addressZoneLocation.setAddressZone(arguments.entity);
					arguments.entity.addAddressZoneLocation(addressZoneLocation);
				} else {
					var addressZoneLocation = this.getAddressZoneLocation(i);
					if(!isNull(addressZoneLocation)) {
						addressZoneLocation.populate(arguments.data.addressZoneLocations[i]);
						addressZoneLocation.setAddressZone(arguments.entity);
						arguments.entity.addAddressZoneLocation(addressZoneLocation);	
					}
				}
			}
		}
		return save(argumentcollection=arguments);
	}
	
	public struct function getMailServerSettings() {
		var config = getConfigBean();
		var settings = {};
		if(!config.getUseDefaultSMTPServer()) {
			settings = {
				server = config.getMailServerIP(),
				username = config.getMailServerUsername(),
				password = config.getMailServerPassword(),
				port = config.getMailServerSMTPPort(),
				useSSL = config.getMailServerSSL(),
				useTLS = config.getMailServerTLS()
			};
		}
		return settings;
	}
	
	// -------------- Start Mura Setup Functions
	public any function verifyMuraRequirements() {
		getService("logService").logMessage(message="Setting Service - verifyMuraRequirements - Started", generalLog=true);
		verifyMuraClassExtension();
		verifyMuraRequiredPages();
		verifyMuraFrontendViews();
		getService("logService").logMessage(message="Setting Service - verifyMuraRequirements - Finished", generalLog=true);
	}
	
	private void function verifyMuraClassExtension() {
		getService("logService").logMessage("Setting Service - verifyMuraClassExtension - Started");
		var assignedSites = getPluginConfig().getAssignedSites();
		
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			getService("logService").logMessage("Verify Mura Class Extension For Site ID: #assignedSites["siteID"][i]#");
			
			local.thisSiteID = assignedSites["siteID"][i];
			
			// Confirm that there is a SlatwallProductTemplate subtype
			local.productPageSubType = getConfigBean().getClassExtensionManager().getSubTypeBean();
			local.productPageSubType.set( {
				type = "Page",
				subType = "SlatwallProductTemplate",
				siteID = local.thisSiteID
			} );
			local.productPageSubType.load();
			local.productPageSubType.save();
			
			// Confirm that there is SlatwallProductListing subtype
			local.thisSubType = getConfigBean().getClassExtensionManager().getSubTypeBean();
			local.thisSubType.set( {
				type = "Page",
				subType = "SlatwallProductListing",
				siteID = local.thisSiteID
			} );
			local.thisSubType.load();
			local.thisSubType.save();
						
			// get the extend set for SlatwallProductListing, One is created if it doesn't already exist
			local.thisExtendSet = local.thisSubType.getExtendSetByName( "Slatwall Product Listing Attributes" );
			local.thisExtendSet.setSubTypeID(local.thisSubType.getSubTypeID());
			local.thisExtendSet.save();
			// create a new attribute for the extend set
			// getAttributeBy Name will look for it and if not found give me a new bean to use 
			// TODO: Internationalize attribute labels and hints
			local.thisAttribute = local.thisExtendSet.getAttributeByName("productsPerPage");
			local.thisAttribute.set({
				label = "Products Per Page",
				type = "TextBox",
				validation = "numeric",
				defaultValue = "10",
				orderNo = "1"
			});
			local.thisAttribute.save();
			
			local.thisAttribute = local.thisExtendSet.getAttributeByName("showSubPageProducts");
			local.thisAttribute.set({
				label = "Show Products Assigned to Sub Pages",
				hint = "If this is enabled, products assigned to any sub pages will also show up in this page.",
				type = "RadioGroup",
				defaultValue = "1",
				optionList="0^1",
				optionLabelList="No^Yes",
				orderNo="2"
			});
			local.thisAttribute.save();
			
			local.thisAttribute = local.thisExtendSet.getAttributeByName("excludefromAssignment");
			local.thisAttribute.set({
				label = "Exclude from Product Assignment",
				hint = "If this is enabled, products cannot be assigned directly to this page. This can be used to set up parent product listing pages but enforce assignment of products to subpages.",
				type = "RadioGroup",
				defaultValue = "0",
				optionList="0^1",
				optionLabelList="No^Yes",
				orderNo="3"
			});
			local.thisAttribute.save();
		}
		getService("logService").logMessage("Setting Service - verifyMuraClassExtension - Finished");
	}
	
	private void function verifyMuraRequiredPages() {
		getService("logService").logMessage("Setting Service - verifyMuraRequiredPages - Started");
		
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			getService("logService").logMessage("Verify Mura Required Pages For Site ID: #assignedSites["siteID"][i]#");
			var thisSiteID = assignedSites["siteID"][i];
			
			// Setup Shopping Cart Page
			var shoppingCartPage = getContentManager().getActiveContentByFilename(filename="shopping-cart", siteid=local.thisSiteID);
			if(shoppingCartPage.getIsNew()) {
				shoppingCartPage.setDisplayTitle("Shopping Cart");
				shoppingCartPage.setHTMLTitle("Shopping Cart");
				shoppingCartPage.setMenuTitle("Shopping Cart");
				shoppingCartPage.setIsNav(1);
				shoppingCartPage.setActive(1);
				shoppingCartPage.setApproved(1);
				shoppingCartPage.setIsLocked(1);
				shoppingCartPage.setParentID("00000000000000000000000000000000001");
				shoppingCartPage.setFilename("shopping-cart");
				shoppingCartPage.setSiteID(thisSiteID);
				shoppingCartPage.save();
			}
			
			
			// Setup Order Status Page
			var orderStatusPage = getContentManager().getActiveContentByFilename(filename="order-status", siteid=local.thisSiteID);
			if(orderStatusPage.getIsNew()) {
				orderStatusPage.setDisplayTitle("Order Status");
				orderStatusPage.setHTMLTitle("Order Status");
				orderStatusPage.setMenuTitle("Order Status");
				orderStatusPage.setIsNav(1);
				orderStatusPage.setActive(1);
				orderStatusPage.setApproved(1);
				orderStatusPage.setIsLocked(1);
				orderStatusPage.setParentID("00000000000000000000000000000000001");
				orderStatusPage.setFilename("order-status");
				orderStatusPage.setSiteID(thisSiteID);
				orderStatusPage.save();
			}
			
			
			// Setup Order Confirmation
			var orderConfirmationPage = getContentManager().getActiveContentByFilename(filename="order-confirmation", siteid=local.thisSiteID);
			if(orderConfirmationPage.getIsNew()) {
				orderConfirmationPage.setDisplayTitle("Order Confirmation");
				orderConfirmationPage.setHTMLTitle("Order Confirmation");
				orderConfirmationPage.setMenuTitle("Order Confirmation");
				orderConfirmationPage.setIsNav(0);
				orderConfirmationPage.setActive(1);
				orderConfirmationPage.setApproved(1);
				orderConfirmationPage.setIsLocked(1);
				orderConfirmationPage.setParentID("00000000000000000000000000000000001");
				orderConfirmationPage.setFilename("order-confirmation");
				orderConfirmationPage.setSiteID(thisSiteID);
				orderConfirmationPage.save();
			}
			
			// Setup My Account Page
			var myAccountPage = getContentManager().getActiveContentByFilename(filename="my-account", siteid=local.thisSiteID);
			if(myAccountPage.getIsNew()) {
				myAccountPage.setDisplayTitle("My Account");
				myAccountPage.setHTMLTitle("My Account");
				myAccountPage.setMenuTitle("My Account");
				myAccountPage.setIsNav(1);
				myAccountPage.setActive(1);
				myAccountPage.setApproved(1);
				myAccountPage.setIsLocked(1);
				//myAccountPage.setRestricted(1); This was disabled because we are going to manage login via the view
				myAccountPage.setParentID("00000000000000000000000000000000001");
				myAccountPage.setFilename("my-account");
				myAccountPage.setSiteID(thisSiteID);
				myAccountPage.save();
			}
			
			
			// Setup Checkout Page
			var checkoutPage = getContentManager().getActiveContentByFilename(filename="checkout", siteid=local.thisSiteID);
			if(checkoutPage.getIsNew()) {
				checkoutPage.setDisplayTitle("Checkout");
				checkoutPage.setHTMLTitle("Checkout");
				checkoutPage.setMenuTitle("Checkout");
				checkoutPage.setIsNav(1);
				checkoutPage.setActive(1);
				checkoutPage.setApproved(1);
				checkoutPage.setIsLocked(1);
				checkoutPage.setParentID("00000000000000000000000000000000001");
				checkoutPage.setFilename("checkout");
				checkoutPage.setSiteID(thisSiteID);
				checkoutPage.save();
			}
			
			// Setup Product Templates Page
			var productTemplate = getContentManager().getActiveContentByFilename(filename="default-product-template", siteid=local.thisSiteID);
			if(productTemplate.getIsNew()) {
				productTemplate.setDisplayTitle("Default Product Template");
				productTemplate.setHTMLTitle("Default Product Template");
				productTemplate.setMenuTitle("Default Product Template");
				productTemplate.setIsNav(0);
				productTemplate.setActive(1);
				productTemplate.setApproved(1);
				productTemplate.setIsLocked(0);
				productTemplate.setParentID("00000000000000000000000000000000001");
				productTemplate.setFilename("default-product-template");
				productTemplate.setSiteID(thisSiteID);
				productTemplate.setSubType("SlatwallProductTemplate");
				productTemplate.save();
			}
			
		}
		getService("logService").logMessage("Setting Service - verifyMuraRequiredPages - Finished");
	}
	
	private void function verifyMuraFrontendViews() {
		getService("logService").logMessage("Setting Service - verifyMuraFrontendViews - Started");
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			getService("logService").logMessage("Verify Mura Frontend Views For Site ID: #assignedSites["siteID"][i]#");
			
			var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
			var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#assignedSites["siteID"][i]#/includes/display_objects/custom/slatwall/"));
			
			getService("utilityFileService").duplicateDirectory(baseSlatwallPath,baseSitePath,false,true,".svn");
		}
		getService("logService").logMessage("Setting Service - verifyMuraFrontendViews - Finished");
	}
}
