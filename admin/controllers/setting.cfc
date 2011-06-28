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
	property name="settingService" type="any";
	property name="addressService" type="any";
	property name="productService" type="any";
	property name="shippingService" type="any";
	property name="paymentService" type="any";
	property name="fulfillmentService" type="any";
	property name="formUtilities" type="any";
	property name="fileService" type="any";
	
	// Mura Service Injection
	property name="userManager" type="any";
	
	public void function dashboard() {
		getFW().redirect(action="admin:setting.detail");
	}
	
	// Global Settings
	public void function detail(required struct rc) {
		rc.edit = false;
		rc.allSettings = getSettingService().getSettings();
		rc.productTemplateOptions = getProductService().getProductTemplates(siteID=rc.$.event('siteid'));
	}
	
	public void function edit(required struct rc) {
		detail(rc);
		getFW().setView("admin:setting.detail");
		rc.edit = true;
	}
	
	public void function save(required struct rc) {
		for(var item in rc) {
			if(!isObject(item)) {
				var setting = getSettingService().getBySettingName(item);
				if(!setting.isNew()) {
					setting.setSettingValue(rc[item]);
					getSettingService().save(entity=setting);
				}
			}
		}
		
		getFW().redirect(action="admin:setting.detail", queryString="reload=true");
	}
	
	// User Permissions
	public void function detailpermissions(required struct rc) {
		param name="rc.edit" default="false";
		
		rc.muraUserGroups = getUserManager().getUserGroups();
		rc.permissionActions = getSettingService().getPermissionActions();
		rc.permissionSettings = getSettingService().getPermissions();
	}
	
	public void function editpermissions(required struct rc) {
		detailpermissions(arguments.rc);
		getFW().setView("admin:setting.detailpermissions");
		rc.edit = true;
	}
	
	public void function savepermissions(required struct rc) {
		param name="rc.muraUserGroupID" default="";
		
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
		getFW().redirect(action="admin:main.dashboard", queryString="reload=true");
	}
	
	// Shipping Services
	public void function detailShippingService(required struct rc) {
		param name="rc.edit" default="false";
		rc.shippingService = getSettingService().getByShippingServicePackage(rc.shippingServicePackage);
		local.serviceName = getMetaData(rc.shippingService)["displayName"];
		rc.itemTitle = rc.itemTitle & ": " & local.serviceName;
	}
	
	public void function editShippingService(required struct rc) {
		detailShippingService(rc);
		getFW().setView("admin:setting.detailshippingservice");
		rc.edit = true;
	}
	
	public void function saveShippingService(required struct rc) {
		rc.serviceProperties = getService("formUtilities").buildFormCollections(rc).shippingService;
		var response = getSettingService().saveShippingService(rc.shippingServicePackage,rc.serviceProperties);

		if( !response.hasErrors() ) {
			rc.message = rc.$.Slatwall.rbKey("admin.setting.saveShippingService_success");
			getFW().redirect(action="admin:setting.detailfulfillmentmethod", querystring="fulfillmentmethodid=shipping&reload=true", preserve="message");
		} else {
			rc.message = rc.$.Slatwall.rbKey("admin.setting.saveShippingService_error");
			rc.messageType = "error";
			rc.shippingService = response.getData();
			rc.errors = response.getErrorBean().getErrors();
			local.serviceName = getMetaData(rc.shippingService)["displayName"];
			rc.itemTitle = rc.$.Slatwall.rbKey("admin.setting.editshippingservice") & ": " & local.serviceName;
			rc.edit = true;
			getFW().setView(action="admin:setting.detailShippingService");
		}
	}
	
	// Shipping Methods
	public void function detailShippingMethod(required struct rc) {
		param name="rc.shippingMethodID" default="";
		param name="rc.edit" default="false";
		
		rc.shippingMethod = getSettingService().getShippingMethod(rc.shippingMethodID, true);
		
		rc.shippingServices = getSettingService().getShippingServices();
		rc.blankShippingRate = getShippingService().newShippingRate();
	}
	
	public void function deleteShippingMethod(required struct rc) {
		detailShippingMethod(rc);
		var deleteResponse = getSettingService().delete(rc.shippingMethod);
		
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.product.deleteShippingMethod_success");
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		getFW().redirect(action="admin:setting.detailfulfillmentmethod", queryString="fulfillmentmethodid=shipping&reload=true", preserve="message,messagetype");
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
		detailShippingMethod(rc);
		
		if(structKeyExists(rc,"shippingProvider") && rc.shippingProvider == "RateTable") {
			var formStruct = getFormUtilities().buildFormCollections(rc);
			if(structKeyExists(formStruct, "shippingRates")) {
				rc.shippingRates = formStruct.shippingRates;	
			}	
		}
		
		rc.shippingMethod = getShippingService().saveShippingMethod(entity=rc.shippingMethod, data=rc);

		if(!rc.shippingMethod.hasErrors()) {
			rc.message=rc.$.slatwall.rbKey("admin.setting.saveshippingmethod_success");
			getFW().redirect(action="admin:setting.detailfulfillmentmethod", querystring="fulfillmentmethodid=shipping&reload=true", preserve="message");
		} else {
			rc.itemTitle = rc.shippingMethod.isNew() ? rc.$.Slatwall.rbKey("admin.setting.createshippingmethod") : rc.$.Slatwall.rbKey("admin.setting.editshippingmethod") & ": #rc.shippingMethod.getShippingMethodName()#";
	   		rc.edit=true;
	   		getFW().setView(action="admin:setting.detailshippingmethod");
		}
	}
	
	
	// Payment Services
	public void function listPaymentServices(required struct rc) {
		rc.paymentServices = getSettingService().getPaymentServices();	
	}
	
	public void function detailPaymentService(required struct rc) {
		param name="rc.edit" default="false";
		
		rc.paymentService = getSettingService().getByPaymentServicePackage(rc.paymentServicePackage);
		local.serviceName = getMetaData(rc.paymentService)["displayName"];
		rc.itemTitle = rc.itemTitle & ": " & local.serviceName;
	}
	
	public void function editPaymentService(required struct rc) {
		detailPaymentService(rc);
		getFW().setView("admin:setting.detailPaymentService");
		rc.edit = true;
	}
	
	
	public void function savePaymentService(required struct rc) {
		rc.serviceProperties = getService("formUtilities").buildFormCollections(rc).paymentService;
		var response = getSettingService().savePaymentService(rc.paymentServicePackage,rc.serviceProperties);

		if( !response.hasErrors() ) {
			rc.message = rc.$.Slatwall.rbKey("admin.setting.savePaymentService_success");
			getFW().redirect(action="admin:setting.listPaymentServices", queryString="reload=true", preserve="message");
		} else {
			rc.message = rc.$.Slatwall.rbKey("admin.setting.savePaymentService_error");
			rc.messageType = "error";
			rc.paymentService = response.getData();
			rc.errors = response.getErrorBean().getErrors();
			local.serviceName = getMetaData(rc.paymentService)["displayName"];
			rc.itemTitle = rc.$.Slatwall.rbKey("admin.setting.editpaymentservice") & ": " & local.serviceName;
			rc.edit = true;
			getFW().setView(action="admin:setting.detailPaymentService");
		}
	}
	
	// Payment Methods
	public void function listPaymentMethods(required struct rc) {
		rc.paymentMethods = getSettingService().getPaymentMethods();	
	}

	public void function detailPaymentMethod(required struct rc) {
		param name="rc.paymentMethodID" default="";
		param name="rc.edit" default="false";
		
		rc.paymentMethod = getSettingService().getPaymentMethod(rc.paymentMethodID);
		if(isNull(rc.paymentMethod)) {
			getFW().redirect(action="admin:setting.listPaymentMethods");
		}
		rc.paymentServices = getSettingService().getPaymentServices();
		
		rc.allSettings = getSettingService().getSettings();
		
		rc.itemTitle = rc.itemTitle & ": " & rc.$.Slatwall.rbKey("admin.setting.paymentMethod." & rc.paymentMethod.getPaymentMethodID());
	}
	
	public void function editPaymentMethod(required struct rc) {
		detailPaymentMethod(rc);
		rc.edit = true;
		getFW().setView("admin:setting.detailPaymentMethod");
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
		rc.fulfillmentMethods = getSettingService().getFulfillmentMethods();	
	}

	public void function detailFulfillmentMethod(required struct rc) {
		param name="rc.fulfillmentMethodID" default="";
		param name="rc.edit" default="false";
		
		rc.fulfillmentMethod = getSettingService().getFulfillmentMethod(rc.fulfillmentMethodID);
		if(isNull(rc.fulfillmentMethod)) {
			getFW().redirect(action="admin:setting.listFulfillmentMethods");
		}	
		rc.itemTitle = rc.itemTitle & ": " & rc.$.slatwall.rbKey("admin.setting.fulfillmentMethod." & rc.fulfillmentMethod.getFulfillmentMethodID());
		
		rc.shippingMethods = getSettingService().getShippingMethods();
		rc.shippingServices = getSettingService().getShippingServices();
	}
	
	public void function editFulfillmentMethod(required struct rc) {
		detailFulfillmentMethod(rc);
		rc.edit = true;
		getFW().setView("admin:setting.detailFulfillmentMethod");
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
		
		var formStruct = getFormUtilities().buildFormCollections(rc);
		if(structKeyExists(formStruct, "addressZoneLocations")) {
			rc.addressZoneLocations = formStruct.addressZoneLocations;	
		}
		
		var wasNew = rc.addressZone.isNew();
		
		rc.addressZone = getSettingService().saveAddressZone(rc.addressZone, rc);
		
		if(rc.addressZone.hasErrors() || wasNew) {
			rc.edit = true;
			getFW().setView("admin:setting.detailaddresszone");
		} else {
			getFW().redirect(action="admin:setting.listaddresszones", querystring="message=admin.setting.saveaddresszone_success");
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
		var deleteResponse = getSettingService().delete(rc.addressZone);
		
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.product.deleteAddressZone_success");
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
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
	
	// Frontend Views
	public void function updateFrontendViews(required struct rc) {
		var baseSlatwallPath = "#expandPath("#application.configBean.getContext()#/")#plugins/Slatwall/frontend/views/"; 
		var baseSitePath = "#expandPath("#application.configBean.getContext()#/")##rc.$.event('siteid')#/includes/display_objects/custom/slatwall/";
		
		getFileService().duplicateDirectory(baseSlatwallPath,baseSitePath,true,true,".svn");
		getFW().redirect(action="admin:main");
	}
	
	// Tax Categories
	
	public void function listTaxCategories(required struct rc) {
		rc.taxCategories = getSettingService().listTaxCategory();
	}
	
	public void function detailTaxCategory(required struct rc) {
		param name="rc.taxCategoyID" default="";
		param name="rc.edit" default="false";
		
		rc.taxCategory = getSettingService().getTaxCategory(rc.taxCategoryID);
		rc.blankTaxCategoryRate = getSettingService().newTaxCategoryRate();
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
		
		rc.taxCategory = getSettingService().saveTaxCategory(rc.taxCategory, rc);
		
		if(structKeyExists(rc, "addRate") && rc.addRate) {
			var rate = getSettingService().newTaxCategoryRate();
			rate.setAddressZone(getAddressService().getAddressZone(rc.addressZoneID));
			rate.setTaxRate(rc.taxRate);
			rate = getSettingService().saveTaxCategoryRate(rate);
			if(!rate.hasErrors()) {
				rate.setTaxCategory(rc.taxCategory);
			}
		}
	}
}
