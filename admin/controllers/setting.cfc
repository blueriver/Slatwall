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
	property name="productService" type="any";
	property name="shippingService" type="any";
	property name="paymentService" type="any";
	property name="formUtilities" type="any";
	
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
	public void function listShippingServices(required struct rc) {
		rc.shippingServices = getSettingService().getShippingServices();	
	}
	
	public void function detailShippingService(required struct rc) {
		param name="rc.edit" default="false";
		rc.shippingService = getSettingService().getByShippingServicePackage(rc.shippingServicePackage);
	}
	
	public void function editShippingService(required struct rc) {
		detailShippingService(rc);
		getFW().setView("admin:setting.detailshippingservice");
		rc.edit = true;
	}
	
	public void function saveShippingService(required struct rc) {
		for(var item in rc) {
			if(!isObject(item) && listGetAt(item,1,"_") == "shippingservice") {
				var setting = getSettingService().getBySettingName(item);
				setting.setSettingName(item);
				setting.setSettingValue(rc[item]);
				getSettingService().save(entity=setting);
			}
		}
		getFW().redirect(action="admin:setting.listshippingservices", queryString="reload=true");
	}
	
	// Shipping Methods
	public void function listShippingMethods(required struct rc) {
		rc.shippingMethods = getSettingService().getShippingMethods();
	}
	
	public void function detailShippingMethod(required struct rc) {
		param name="rc.shippingMethodID" default="";
		param name="rc.edit" default="false";
		
		rc.shippingMethod = getSettingService().getByID(rc.shippingMethodID, "SlatwallShippingMethod");
		if(isNull(rc.shippingMethod)) {
			rc.shippingMethod = getSettingService().getNewEntity("SlatwallShippingMethod");
		}
		
		rc.shippingServices = getSettingService().getShippingServices();
		rc.blankShippingRate = getShippingService().getNewEntity("SlatwallShippingRate");
	}
	
	public void function deleteShippingMethod(required struct rc) {
		detailShippingMethod(rc);
		var deleteResponse = getSettingService().delete(rc.shippingMethod);
		
		if(deleteResponse.getStatusCode()) {
			rc.message=deleteResponse.getMessage();
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		getFW().redirect(action="admin:setting.listshippingmethods", queryString="reload=true", preserve="message,messagetype");
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
		
		if(rc.shippingProvider == "RateTable") {
			var formStruct = getFormUtilities().buildFormCollections(rc);
			if(structKeyExists(formStruct, "shippingRates")) {
				rc.shippingRates = formStruct.shippingRates;	
			}	
		}
		
		rc.shippingMethod = getShippingService().saveShippingMethod(entity=rc.shippingMethod, data=rc);

		if(!rc.shippingMethod.hasErrors()) {
			getFW().redirect(action="admin:setting.listshippingmethods", querystring="reload=true&message=admin.setting.saveshippingmethod_success");
		} else {
			rc.itemTitle = rc.shippingMethod.isNew() ? rc.$.Slatwall.rbKey("admin.setting.createshippingmethod") : rc.$.Slatwall.rbKey("admin.setting.editshippingmethod") & ": #rc.shippingMethod.getShippingMethodName()#";
	   		getFW().setView(action="admin:setting.editshippingmethod");
		}
	}
	
	
	// Payment Services
	
	// Payment Methods
		
	// Integrations Services
	
	// Address Zones
	public void function listAddressZones(required struct rc) {
		rc.addressZones = getSettingService().list("SlatwallAddressZone");
	}
	
	public void function detailAddressZone(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.edit" default="false";
		
		rc.addressZone = getSettingService().getByID(rc.addressZoneID, "SlatwallAddressZone");
		if(isNull(rc.addressZone)) {
			rc.addressZone = getSettingService().getNewEntity("SlatwallAddressZone");
		}
		
		rc.countriesArray = getSettingService().list("SlatwallCountry");
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
		
		rc.addressZone = getSettingService().saveAddressZone(rc.addressZone, rc);
		
		if(!rc.addressZone.hasErrors()) {
			getFW().redirect(action="admin:setting.listaddresszones", querystring="message=admin.setting.saveaddresszone_success");
		} else {
			getFW().setView("admin:setting.detailaddresszone");
			rc.edit = true;
		}
	}
	
	public void function deleteAddressZone(required struct rc) {
		detailAddressZone(rc);
		var deleteResponse = getSettingService().delete(rc.addressZone);
		
		if(deleteResponse.getStatusCode()) {
			rc.message=deleteResponse.getMessage();
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:setting.listaddresszones", queryString="reload=true", preserve="message,messagetype");
	}	
}
