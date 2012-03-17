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
component extends="BaseController" output="false" accessors="true" {
	
	// Slatwall Service Injection		
	property name="addressService" type="any";
	property name="attributeService" type="any";
	property name="dataService" type="any";
	property name="fulfillmentService" type="any";
	property name="integrationService" type="any";
	property name="locationService" type="any";
	property name="productService" type="any";
	property name="paymentService" type="any";
	property name="roundingRuleService" type="any";
	property name="settingService" type="any";
	property name="shippingService" type="any";
	property name="skuCacheService" type="any";
	property name="taxService" type="any";
	property name="termService" type="any";
	property name="updateService" type="any";
	property name="utilityFormService" type="any";
	property name="utilityFileService" type="any";
	
	public void function default() {
		getFW().redirect(action="admin:setting.detailsetting");
	}
	
	// Global Settings
	public void function detailsetting(required struct rc) {
		rc.edit = false;
		rc.allSettings = getSettingService().getSettings();
		rc.productTemplateOptions = getProductService().getProductTemplates(siteID=rc.$.event('siteid'));
		
		rc.shippingWeightUnitCodeOptions = getSettingService().getMeaurementUnitOptions(measurementType="weight");
		rc.customIntegrations = getIntegrationService().listIntegrationFilterByCustomActiveFlag(1);
		
		var rootCategoryID = rc.$.slatwall.setting("product_rootProductCategory");
		if(rootCategoryID == "0") {
			rc.rootCategory = rc.$.slatwall.rbKey("define.all");
		} else {
			rc.rootCategory = getCMSBean("categoryManager").read(categoryID=rootCategoryID).getName();
		}
	}
	
	public void function editsetting(required struct rc) {
		detail(rc);
		getFW().setView("admin:setting.detailsetting");
		rc.edit = true;
	}
	
	public void function savesetting(required struct rc) {
		for(var item in rc) {
			if(!isObject(item)) {
				var setting = getSettingService().getBySettingName(item);
				if(!setting.isNew()) {
					setting.setSettingValue(rc[item]);
					getSettingService().save(entity=setting);
				}
			}
		}
		getSettingService().reloadConfiguration();
		getFW().redirect(action="admin:setting.detail");
	}
	
	// User Permissions
	public void function detailpermissions(required struct rc) {
		param name="rc.edit" default="false";
		
		// TODO: remove direct reference to mura userManager 
		rc.cmsUserGroups = getCMSBean("userManager").getUserGroups();
		rc.permissionActions = getSettingService().getPermissionActions();
		rc.permissionSettings = getSettingService().getPermissions();
	}
	
	public void function editpermissions(required struct rc) {
		detailpermissions(arguments.rc);
		getFW().setView("admin:setting.detailpermissions");
		rc.edit = true;
	}
	
	public void function savepermissions(required struct rc) {
		param name="rc.cmsUserGroupID" default="";
		
		for(var item in rc) {
			if(!isObject(item)) {
				if(left(item,10) == "permission") {
					var setting = getSettingService().getByPermissionName(item);
					if(setting.isNew()) {
						setting.setSettingName(item);	
					}
					setting.setSettingValue(rc[item]);
					getSettingService().save(entity=setting);
				}
			}
		}
		getFW().redirect(action="admin:main.default", queryString="reload=true");
	}
	
	// Shipping Methods
	public void function detailShippingMethod(required struct rc) {
		param name="rc.shippingMethodID" default="";
		param name="rc.edit" default="false";
		
		rc.shippingMethod = getSettingService().getShippingMethod(rc.shippingMethodID, true);
		rc.shippingIntegrations = getIntegrationService().listIntegration({shippingActiveFlag=1});

		rc.blankShippingRate = getShippingService().newShippingRate();
	}
	
	public void function deleteShippingMethod(required struct rc) {
		detailShippingMethod(rc);
		
		var deleteOK = getSettingService().deleteShippingMethod(rc.shippingMethod);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.setting.deleteShippingMethod_success");
		} else {
			rc.message = rbKey("admin.setting.deleteShippingMethod_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:setting.detailfulfillmentmethod", queryString="fulfillmentmethodid=shipping&edit=true", preserve="message,messagetype");
	}
	
	public void function createShippingMethod(required struct rc) {
		editShippingMethod(rc);
	}
	
	public void function editShippingMethod(required struct rc) {
		detailShippingMethod(rc);
		getFW().setView("admin:setting.detailshippingmethod");
		rc.edit = true;
	}
	
	public void function saveShippingMethod(required struct rc) {
		param name="rc.addRate" default="false";
		
		detailShippingMethod(rc);
		
		var errorsExist = false;
		var wasNew = rc.shippingMethod.isNew();
				
		if(structKeyExists(rc, "shippingProvider") && rc.shippingProvider == "Other") {
			rc.shippingMethod.setUseRateTableFlag(true);
		}
		
		rc.shippingMethod = getShippingService().saveShippingMethod(entity=rc.shippingMethod, data=rc);
		
		if(rc.shippingMethod.hasErrors()) {
			errorsExist = true;
		} else {
			if(rc.addRate) {
				var rate = getSettingService().newShippingRate();
				rate.setShippingMethod(rc.shippingMethod);
				rate = getSettingService().saveShippingRate(rate, rc);
				
				if(rate.hasErrors()) {
					errorsExist = true;
					rate.removeShippingMethod(rc.shippingMethod);
					rc.blankShippingRate = rate;
				}
			}
		}
		
		if(!errorsExist) {
			rc.message=rc.$.slatwall.rbKey("admin.setting.saveshippingmethod_success");
			if(wasNew || rc.addRate) {
				rc.itemTitle = rc.shippingMethod.isNew() ? rc.$.Slatwall.rbKey("admin.setting.createshippingmethod") : rc.$.Slatwall.rbKey("admin.setting.editshippingmethod") & ": #rc.shippingMethod.getShippingMethodName()#";
	   			rc.edit=true;
				getFW().setView(action="admin:setting.detailshippingmethod");
			} else {
				getFW().redirect(action="admin:setting.detailfulfillmentmethod", querystring="fulfillmentmethodid=shipping&edit=true", preserve="message");	
			}
		} else {
			rc.itemTitle = rc.shippingMethod.isNew() ? rc.$.Slatwall.rbKey("admin.setting.createshippingmethod") : rc.$.Slatwall.rbKey("admin.setting.editshippingmethod") & ": #rc.shippingMethod.getShippingMethodName()#";
	   		rc.edit=true;
	   		getFW().setView(action="admin:setting.detailshippingmethod");
		}
	}
	
	public void function deleteShippingRate(required struct rc) {
		param name="rc.shippingRateID" default="";
		
		var rate = getSettingService().getShippingRate(rc.shippingRateID);
		
		var shippingMethodID = rate.getShippingMethod().getShippingMethodID();
		
		var deleteOK = getSettingService().delete(rate);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.setting.deleteShippingRate_success");
		} else {
			rc.message = rbKey("admin.setting.deleteShippingRate_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:setting.detailshippingmethod", querystring="shippingMethodID=#shippingMethodID#&edit=true", preserve="message,messagetype");
	}
	
	// Payment Methods
	public void function listPaymentMethods(required struct rc) {
		rc.paymentMethods = getSettingService().listPaymentMethod();	
	}

	public void function detailPaymentMethod(required struct rc) {
		param name="rc.paymentMethodID" default="";
		param name="rc.edit" default="false";
		
		rc.paymentMethod = getSettingService().getPaymentMethod(rc.paymentMethodID);
		if(isNull(rc.paymentMethod)) {
			getFW().redirect(action="admin:setting.listPaymentMethods");
		}
		rc.paymentIntegrations = getIntegrationService().listIntegration({paymentActiveFlag=1});
		
		for(var i=arrayLen(rc.paymentIntegrations); i>=1; i--) {
			if( ! listFind( rc.paymentIntegrations[i].getIntegrationCFC('payment').getPaymentMethods(), rc.paymentMethod.getPaymentMethodID() ) ) {
				arrayDeleteAt(rc.paymentIntegrations,i);
			}
		}
		
		rc.allSettings = getSettingService().getSettings();
		
		rc.itemTitle = rc.itemTitle & ": " & rc.$.Slatwall.rbKey("admin.setting.paymentMethod." & rc.paymentMethod.getPaymentMethodID());
	}
	
	public void function editPaymentMethod(required struct rc) {
		detailPaymentMethod(rc);
		rc.edit = true;
		getFW().setView("admin:setting.detailpaymentmethod");
	}
	
	public void function savePaymentMethod(required struct rc) {
		rc.paymentMethod = getSettingService().getPaymentMethod(rc.paymentMethodID, true);
		rc.paymentMethod = getPaymentService().savePaymentMethod(entity=rc.paymentMethod, data=rc);

		if(!rc.paymentMethod.hasErrors()) {
			getFW().redirect(action="admin:setting.listpaymentmethods", querystring="reload=true&message=#rc.$.Slatwall.rbKey('admin.setting.savepaymentmethod_success')#");
		} else {
			rc.paymentServices = getSettingService().getPaymentServices();
			rc.itemTitle = rc.$.Slatwall.rbKey("admin.setting.editpaymentmethod") & ": #rc.$.Slatwall.rbKey('rc.paymentMethod.getPaymentMethodID()')#";
	   		getFW().setView(action="admin:setting.editpaymentmethod");
		}
	}

	// Fulfillment Methods
	public void function listFulfillmentMethods(required struct rc) {
		rc.fulfillmentMethods = getSettingService().listFulfillmentMethod();	
	}

	public void function detailFulfillmentMethod(required struct rc) {
		param name="rc.fulfillmentMethodID" default="";
		param name="rc.edit" default="false";
		
		rc.fulfillmentMethod = getSettingService().getFulfillmentMethod(rc.fulfillmentMethodID);
		if(isNull(rc.fulfillmentMethod)) {
			getFW().redirect(action="admin:setting.listfulfillmentmethods");
		}	
		rc.itemTitle = rc.itemTitle & ": " & rc.$.slatwall.rbKey("admin.setting.fulfillmentMethod." & rc.fulfillmentMethod.getFulfillmentMethodID());
		
		rc.shippingMethods = getSettingService().listShippingMethod();
		rc.shippingServices = getSettingService().getShippingServices();
	}
	
	public void function editFulfillmentMethod(required struct rc) {
		detailFulfillmentMethod(rc);
		rc.edit = true;
		getFW().setView("admin:setting.detailfulfillmentmethod");
	}
	
	public void function saveFulfillmentMethod(required struct rc) {
		rc.fulfillmentMethod = getSettingService().getFulfillmentMethod(rc.fulfillmentMethodID, true);
		//writeDump(rc.fulfillmentMethod);
		//abort;
		rc.fulfillmentMethod = getFulfillmentService().saveFulfillmentMethod(entity=rc.fulfillmentMethod, data=rc);

		if(!rc.fulfillmentMethod.hasErrors()) {
			getFW().redirect(action="admin:setting.listfulfillmentmethods", querystring="reload=true&message=#rc.$.Slatwall.rbKey('admin.setting.savefulfillmentmethod_success')#");
		} else {
			rc.itemTitle = rc.$.Slatwall.rbKey("admin.setting.editfulfillmentmethod") & ": #rc.$.Slatwall.rbKey('rc.fulfillmentMethod.getFulfillmentMethodID()')#";
	   		getFW().setView(action="admin:setting.editfulfillmentmethod");
		}
	}
		
	// Integrations Services
	
	/*
	// Address Zones
	public void function listAddressZones(required struct rc) {
		rc.addressZones = getSettingService().listAddressZone();
	}
	
	public void function detailAddressZone(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.edit" default="false";
		
		rc.addressZone = getSettingService().getAddressZone(rc.addressZoneID, true);
		rc.newAddress = getAddressService().newAddress();
	}
	
	public void function editAddressZone(required struct rc) {
		detailAddressZone(rc);
		getFW().setView("admin:setting.detailaddresszone");
		rc.edit = true;
	}
	
	public void function createAddressZone(required struct rc) {
		editAddressZone(rc);
	}
	
	public void function saveAddressZone(required struct rc) {
		detailAddressZone(rc);
		
		var wasNew = rc.addressZone.isNew();
		
		rc.addressZone = getSettingService().saveAddressZone(rc.addressZone, rc);
		
		if(rc.addressZone.hasErrors() || wasNew) {
			rc.edit = true;
			getFW().setView("admin:setting.detailaddresszone");
		} else {
			if(structKeyExists(arguments.rc, "addLocation") && arguments.rc.addLocation) {
				var newAddress = getAddressService().newAddress();
				newAddress.populate(rc);
				rc.addressZone.addAddressZoneLocation(newAddress);
				rc.edit = true;
				getFW().setView("admin:setting.detailaddresszone");
			} else {
				getFW().redirect(action="admin:setting.listaddresszones", querystring="message=admin.setting.saveaddresszone_success");	
			}
		}
	}
	
	public void function saveAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";
		
		// Check to see if it is already in rc because of taffy api
		if(isNull(rc.addressZone)) {
			rc.addressZone = getAddressService().getAddressZone(rc.addressZoneID);
		}
		
		if(!isNull(rc.addressZone)) {
			var address = getAddressService().getAddress(rc.addressID, true);
			address.populate(rc);
			rc.addressZone.addAddressZoneLocation(address);
		}
	}
	
	public void function deleteAddressZone(required struct rc) {
		
		detailAddressZone(rc);
		
		var deleteOK = getSettingService().deleteAddressZone(rc.addressZone);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.setting.deleteAddressZone_success");
		} else {
			rc.message = rbKey("admin.setting.deleteAddressZone_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:setting.listaddresszones", preserve="message,messagetype");
	}
	
	public void function deleteAddressZoneLocation(required struct rc) {
		detailAddressZone(rc);
		
		var address = getAddressService().getAddress(rc.addressID);
		
		rc.addressZone.removeAddressZoneLocation(address);
		rc.edit = true;
		getFW().setView("admin:setting.detailaddresszone");
	}
	*/
	// Frontend Views
	public void function detailViewUpdate(required struct rc) {
		
	}
	
	public void function updateFrontendViews(required struct rc) {
		
		var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
		var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#rc.$.event('siteid')#/includes/display_objects/custom/slatwall/"));
		
		getUtilityFileService().duplicateDirectory(baseSlatwallPath,baseSitePath,true,true,".svn");
		getFW().redirect(action="admin:main");
	}
	
	// Tax Categories
	
	public void function listTaxCategories(required struct rc) {
		rc.taxCategories = getTaxService().listTaxCategory();
	}
	
	public void function detailTaxCategory(required struct rc) {
		param name="rc.taxCategoryID" default="";
		param name="rc.edit" default="false";
		
		rc.taxCategory = getTaxService().getTaxCategory(rc.taxCategoryID);
		rc.newTaxCategoryRate = getTaxService().newTaxCategoryRate();
	}
	
	public void function editTaxCategory(required struct rc) {
		detailTaxCategory(rc);
		rc.edit = true;
		getFW().setView("admin:setting.detailtaxcategory");
	}
	
	public void function createTaxCategory(required struct rc) {
		detailTaxCategory(rc);
		rc.edit = true;
		getFW().setView("admin:setting.detailtaxcategory");
		
	}
	
	public void function saveTaxCategory(required struct rc) {
		detailTaxCategory(rc);
		
		rc.edit = true;
		
		getFW().setView("admin:setting.detailtaxcategory");
		
		rc.taxCategory = getTaxService().saveTaxCategory(rc.taxCategory, rc);
		
		if(rc.taxCategory.hasErrors() && structKeyExists(rc, "addRate") && rc.addRate) {
			rc.newTaxCategoryRate = rc.taxCategory.getTaxCategoryRates()[arrayLen(rc.taxCategory.getTaxCategoryRates())];
		}
		
		if(!structKeyExists(rc, "addRate") || !rc.addRate) {
			getFW().redirect(action="admin:setting.listtaxcategories", preserve="message");	
		}
		
	}
	
	public void function deleteTaxCategoryRate(required struct rc) {
		param name="rc.taxCategoryRateID" default="";
		
		var rate = getSettingService().getTaxCategoryRate(rc.taxCategoryRateID);
		var taxCategoryID = rate.getTaxCategory().getTaxCategoryID();
		
		var deleteOK = getSettingService().deleteTaxCategoryRate(rate);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.setting.deleteTaxCategoryRate_success");
		} else {
			rc.message = rbKey("admin.setting.deleteTaxCategoryRate_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:setting.detailtaxcategory", querystring="taxCategoryID=#taxCategoryID#&edit=true", preserve="message,messagetype");
	}
	
	// DB Tool
	public void function deleteAllOrders(required struct rc) {
		param name="rc.confirmDelete" default="0";
		
		if(isBoolean(rc.confirmDelete) && rc.confirmDelete) {
			getDataService().deleteAllOrders();
		}
		
		getFW().redirect(action='admin:main.default');
	}
	
	public void function deleteAllProducts(required struct rc) {
		param name="rc.confirmDelete" default="0";
		param name="rc.deleteBrands" default="0";
		param name="rc.deleteProductTypes" default="0";
		param name="rc.deleteOptions" default="0";
		
		if(isBoolean(rc.confirmDelete) && rc.confirmDelete) {
			getDataService().deleteAllProducts(data=rc);
		}
		
		getFW().redirect(action='admin:main.default');
	}
	
	public void function importBundleData(required struct rc) {
		param name="rc.confirmImport" default="0";
		
		if(isBoolean(rc.confirmImport) && rc.confirmImport) {
			var bundleUtility = createObject("component", "Slatwall.plugin.bundleUtility");
			bundleUtility.fromBundle(pluginConfig = getPluginConfig());
		}
		
		getFW().redirect(action='admin:main.default');
	}
	
	// slatwall update
	public void function detailSlatwallUpdate(required struct rc) {
		
		var versions = getUpdateService().getAvailableVersions();
		rc.availableDevelopVersion = versions.develop;
		rc.availableMasterVersion = versions.master;
		
		rc.currentVersion = getPluginConfig().getApplication().getValue('SlatwallVersion');
		if(find("-", rc.currentVersion)) {
			rc.currentBranch = "develop";
		} else {
			rc.currentBranch = "master";
		}
		
	}
	
	public void function updateSlatwall(required struct rc) {
		getUpdateService().update(branch=rc.updateBranch);
		rc.message = rbKey("admin.setting.updateslatwall_success");
		getFW().redirect(action="admin:setting.detailslatwallupdate?reload=true", preserve="message");	
	}
	
	public void function updateSkuCache(required struct rc) {
		getSkuCacheService().updateAllSkus();
		rc.message = rbKey("admin.setting.updateSkuCache_success");
		getFW().redirect(action="admin:main.default", preserve="message");	
	}
	
	public void function updateProductCache(required struct rc) {
		getSkuCacheService().updateAllProducts();
		rc.message = rbKey("admin.setting.updateProductCache_success");
		getFW().redirect(action="admin:main.default", preserve="message");	
	}
	
	public void function listAttributeSets(required struct rc) {
        rc.attributeSetSmartList = getAttributeService().getAttributeSetSmartList();
    }
    
	public void function createAttributeSet(required struct rc) {
		rc.edit = true;
		getFW().setView("admin:attribute.detailattributeset");
		
		rc.attributeSet = getAttributeService().newAttributeSet();
		rc.attribute = getAttributeService().newAttribute();
	}
	
	public void function editAttributeSet(required struct rc) {
		param name="rc.attributeSetID" default="";
		param name="rc.attributeID" default="";
		
		rc.edit = true;
		getFW().setView("admin:attribute.detailattributeset");
		
		rc.attributeSet = getAttributeService().getAttributeSet(rc.attributeSetID);
		rc.attribute = getAttributeService().getAttribute(rc.attributeID, true);
		
		if(isNull(rc.attributeSet)) {
			getFW().redirect(action="admin:attribute.listAttributeSets");
		}
	}
	
	public void function saveAttributeSet(required struct rc) {
		param name="rc.attributeSetID" default="";
		param name="rc.populateSubProperties" default="false";
		
		rc.attributeSet = getAttributeService().getAttributeSet(rc.attributeSetID, true);
		rc.attribute = getAttributeService().newAttribute();
		
		rc.attributeSet = getAttributeService().saveAttributeSet(rc.attributeSet, rc);
		
		if(!rc.attributeSet.hasErrors()) {
			rc.message=rc.$.Slatwall.rbKey("admin.attribute.saveAttributeSet_success");
			if(rc.populateSubProperties) {
				getFW().redirect(action="admin:attribute.editAttributeSet",querystring="attributeSetID=#rc.attributeSet.getAttributeSetID()#",preserve="message");	
			} else {
				getFW().redirect(action="admin:attribute.listAttributeSets",preserve="message");
			}
		} else {
			// If one of the attributes had the error, then find out which one and populate it
			if(rc.attributeSet.hasError("attributes")) {
				for(var i=1; i<=arrayLen(rc.attributeSet.getAttributes()); i++) {
					if(rc.attributeSet.getAttributes()[i].hasErrors()) {
						rc.attribute = rc.attributeSet.getAttributes()[i];
					}
				}
			}
			rc.edit = true;
			rc.itemTitle = rc.AttributeSet.isNew() ? rc.$.Slatwall.rbKey("admin.attribute.createAttributeSet") : rc.$.Slatwall.rbKey("admin.attribute.editAttributeSet") & ": #rc.attributeSet.getAttributeSetName()#";
			getFW().setView(action="admin:attribute.detailattributeset");
		}
	}
	
	public void function deleteAttributeSet(required struct rc) {
		param name="rc.attributeSetID" default="";
		
		var attributeSet = getAttributeService().getAttributeSet(rc.attributeSetID);
		
		var deleteOK = getAttributeService().deleteAttributeSet(attributeSet);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.attributeSet.deleteAttributeSet_success");
		} else {
			rc.message = rbKey("admin.attributeSet.deleteAttributeSet_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:attribute.listAttributeSets", preserve="message,messagetype");
	}
	
	public void function deleteAttribute(required struct rc) {
		param name="rc.attributeID" default="";
		param name="rc.attributeSetID" default="";
		
		var attribute = getAttributeService().getAttribute(rc.attributeID);
		
		var deleteOK = getAttributeService().deleteAttribute(attribute);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.attribute.deleteAttribute_success");
		} else {
			rc.message = rbKey("admin.attribute.deleteAttribute_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:attribute.editAttributeSet", queryString="attributeSetID=#rc.attributeSetID#", preserve="message,messagetype");
	}
	
	public void function deleteAttributeOption(required struct rc) {
		param name="rc.attributeOptionID" default="";
		param name="rc.attributeSetID" default="";
		param name="rc.attributeID" default="";
		
		var attributeOption = getAttributeService().getAttributeOption(rc.attributeOptionID);
		
		var deleteOK = getAttributeService().deleteAttributeOption(attributeOption);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.attribute.deleteAttributeOption_success");
		} else {
			rc.message = rbKey("admin.attribute.deleteAttributeOption_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:attribute.editAttributeSet", queryString="attributeSetID=#rc.attributeSetID#&attributeID=#rc.attributeID#", preserve="message,messagetype");
	}
	
	/*
	public void function listLocations(required struct rc) {
        param name="rc.orderBy" default="locationId|ASC";
        
        rc.locationSmartList = getLocationService().getLocationSmartList(data=arguments.rc);  
    }
    
    public void function detailLocation(required struct rc) {
    	param name="rc.locationID" default="";
    	param name="rc.edit" default="false";
    	
    	rc.location = getLocationService().getLocation(rc.locationID);
    	
    	if(isNull(rc.location)) {
    		getFW().redirect(action="admin:location.listLocations");
    	}
    }
    
    public void function createLocation(required struct rc) {
    	editLocation(rc);
	}
    
    public void function editLocation(required struct rc) {
    	param name="rc.locationID" default="";
    	param name="rc.locationRateID" default="";
    	
    	rc.location = getLocationService().getLocation(rc.locationID, true);
    	
    	rc.edit = true; 
    	getFW().setView("admin:location.detaillocation");  
	}
	

	public void function saveLocation(required struct rc) {
		editLocation(rc);

		var wasNew = rc.Location.isNew();

		
		// this does an RC -> Entity population, and flags the entities to be saved.
		rc.location = getLocationService().saveLocation(rc.location, rc);

		if(!rc.location.hasErrors()) {
			// If added or edited a Price Group Rate
			rc.message=rbKey("admin.location.savelocation_success");
			getFW().redirect(action="admin:location.listLocations", querystring="locationID=#rc.location.getLocationID()#", preserve="message");		
		} 
		else { 			
			rc.edit = true;
			rc.itemTitle = rc.Location.isNew() ? rc.$.Slatwall.rbKey("admin.location.createLocation") : rc.$.Slatwall.rbKey("admin.location.editLocation") & ": #rc.location.getLocationName()#";
			getFW().setView(action="admin:location.detaillocation");
		}	
	}
	
	public void function deleteLocation(required struct rc) {
		var location = getLocationService().getLocation(rc.locationId);
		var deleteOK = getLocationService().deleteLocation(location);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.location.deleteLocation_success");
		} else {
			rc.message = rbKey("admin.location.deleteLocation_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:location.listLocations", preserve="message,messagetype");
	}
	*/
	/*
	public void function detailroundingrule(required struct rc) {
		param name="rc.roundingRuleID" default="";
		param name="rc.edit" default="false";
		
		rc.roundingRule = getRoundingRuleService().getRoundingRule(rc.roundingRuleID,true);	
	}


    public void function createroundingrule(required struct rc) {
		edit(rc);
    }

	public void function editroundingrule(required struct rc) {
		detail(rc);
		getFW().setView("admin:roundingrule.detail");
		rc.edit = true;
	}
	
	 
    public void function listroundingrules(required struct rc) {	
		rc.roundingRules = getRoundingRuleService().listRoundingRule();
    }

	public void function saveroundingrule(required struct rc) {
		// Populate RoundingRule and RoundingRuleRate in the rc.
		detail(rc);
		
		rc.roundingRule = getRoundingRuleService().saveRoundingRule(rc.roundingRule, rc);
		
		// If the rounding rule doesn't have any errors then redirect to detail or list
		if(!rc.roundingRule.hasErrors()) {
			getFW().redirect(action="admin:roundingrule.list",queryString="message=admin.roundingrule.save_success");
		}
		
		// This logic only runs if the entity has errors.  If it was a new entity show the create page, otherwise show the edit page
   		rc.edit = true;
		rc.itemTitle = rc.roundingRule.isNew() ? rc.$.Slatwall.rbKey("admin.roundingRule.create") : rc.$.Slatwall.rbKey("admin.roundingRule.edit") & ": #rc.roundingRule.getBrandName()#";
   		getFW().setView(action="admin:roundingrule.detail");
	}
	
	public void function deleteroundingrule(required struct rc) {
		
		detail(rc);
		
		var deleteOK = getRoundingRuleService().deleteRoundingRule(rc.roundingRule);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.roundingrule.delete_success");
		} else {
			rc.message = rbKey("admin.roundingrule.delete_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:roundingrule.list", preserve="message,messagetype");
	}
	*/

	/*
	// Common functionalty of Add/Edit/View
	public void function detailterm(required struct rc) {
		param name="rc.termID" default="";
		param name="rc.edit" default="false";
		
		rc.term = getTermService().getTerm(rc.termID,true);	
	}

    public void function createterm(required struct rc) {
		edit(rc);
    }

	public void function editterm(required struct rc) {
		detail(rc);
		getFW().setView("admin:term.detail");
		rc.edit = true;
	}
	
    public void function listterm(required struct rc) {	
		rc.terms = getTermService().listTerm();
    }

	public void function saveterm(required struct rc) {
		// Populate Term in the rc.
		detail(rc);
		
		rc.term = getTermService().saveTerm(rc.term, rc);
		
		// If the term doesn't have any errors then redirect to detail or list
		if(!rc.term.hasErrors()) {
			getFW().redirect(action="admin:term.list",queryString="message=admin.term.save_success");
		}
		
		// This logic only runs if the entity has errors.  If it was a new entity show the create page, otherwise show the edit page
   		rc.edit = true;
		rc.itemTitle = rc.term.isNew() ? rc.$.Slatwall.rbKey("admin.term.create") : rc.$.Slatwall.rbKey("admin.term.edit") & ": #rc.term.getTermName()#";
   		getFW().setView(action="admin:term.detail");
	}
	
	public void function deleteterm(required struct rc) {
		
		detail(rc);
		
		var deleteOK = getTermService().deleteTerm(rc.term);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.term.delete_success");
		} else {
			rc.message = rbKey("admin.term.delete_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:term.list", preserve="message,messagetype");
	}
	*/
}
