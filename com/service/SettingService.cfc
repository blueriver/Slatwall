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
component extends="BaseService" persistent="false" output="false" {
	
	property name="variables.settings" type="struct";
	property name="variables.permissions" type="struct";
	property name="variables.shippingMethods" type="struct";
	property name="variables.shippingServices" type="struct";
	property name="variables.paymentMethods" type="struct";
	property name="variables.paymentServices" type="struct";
	property name="variables.permissionActions" type="struct";
	
	public void function reloadConfiguration() {
		var settingsList = list();
		var shippingMethodsList = list(entityName="SlatwallShippingMethod");
		var paymentMethodsList = list(entityName="SlatwallPaymentMethod");
		
		variables.permissions = {};
		variables.settings = {};
		variables.shippingMethods = {};
		variables.shippingServices = {};
		variables.paymentMethods = {};
		variables.paymentServices = {};
		
		getPermissionActions();
		getShippingServices();
		
		// Load Settings & Permissions
		for(var i = 1; i <= arrayLen(settingsList); i++) {
			if( listGetAt( settingsList[i].getSettingName(), 1, "_") == "permission") {
				// Set the permission value in the permissions scop 
				variables.permissions[ settingsList[i].getSettingName() ] = settingsList[i];
			} else if ( listGetAt( settingsList[i].getSettingName(), 1, "_") == "shippingservice") {
				// Inject the value into the shipping service
				var shippingServiceName = listGetAt( settingsList[i].getSettingName(), 2, "_");
				if( structKeyExists(variables.shippingServices, shippingServiceName) ) {
					// This is where you stopped greg
				}
			} else if ( listGetAt( settingsList[i].getSettingName(), 1, "_") == "paymentservice") {
				// Inject the value into the payment service
			} else {
				// Set the global setting value in the settings scope
				variables.settings[ settingsList[i].getSettingName() ] = settingsList[i];	
			}
		}
		
		// Load Shipping Methods
		for(var i = 1; i <= arrayLen(shippingMethodsList); i++) {
			variables.shippingMethods[ shippingMethodsList[i].getShippingMethodID() ] = shippingMethodsList[i];
		}
		
		// Load Payment Methods
		for(var i = 1; i <= arrayLen(paymentMethodsList); i++) {
			variables.paymentMethods[ paymentMethodsList[i].getPaymentMethodsID() ] = paymentMethodsList[i];
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
	
	public struct function getShippingMethods(boolean reload=false) {
		if(!structKeyExists(variables, "shippingMethods") || arguments.reload == true) {
			reloadConfiguration();
		}
		return variables.shippingMethods;
	}
	
	public struct function getPaymentMethods(boolean reload=false) {
		if(!structKeyExists(variables, "paymentMethods") || arguments.reload == true) {
			reloadConfiguration();
		}
		return variables.paymentMethods;
	}
	
	public any function getSettingValue(required string settingName) {
		return variables.settings[ arguments.settingName ].getSettingValue();
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
			return getNewEntity();	
		}
	}
	
	public any function getByPermissionName(required string permissionName) {
		if(structKeyExists(variables.permissions, arguments.permissionName)) {
			return variables.permissions[ arguments.permissionName ];
		} else {
			return getNewEntity();	
		}
	}
	
	public struct function getPermissionActions(boolean reload=false) {
		if(!structKeyExists(variables, "permissionActions") || arguments.reload) {
			variables.permissionActions = structNew();
			var dirLocation = ExpandPath("/plugins/Slatwall/admin/controllers");
			var dirList = directoryList( dirLocation );
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
	
	public struct function getShippingServices(boolean reload=false) {
		if(!structKeyExists(variables, "shippingServices") || arguments.reload) {
			variables.shippingServices = arrayNew(1);
			var dirLocation = ExpandPath("/plugins/Slatwall/shippingServices");
			var dirList = directoryList( dirLocation );
			for(var i=1; i<= arrayLen(dirList); i++) {
				var serviceName = Replace(listGetAt(dirList[i],listLen(dirList[i],"\/"),"\/"),".cfc","");
				var service = createObject("component", "Slatwall.shippingServices.#serviceName#.Service");
				variables.shippingServices[ "#serviceName#" ] = service;
			}
		}
		return variables.shippingServices;
	}
	
	public struct function getPaymentServices(boolean reload=false) {
		if(!structKeyExists(variables, "paymentServices") || arguments.reload) {
			variables.paymentServices = arrayNew(1);
			var dirLocation = ExpandPath("/plugins/Slatwall/paymentServices");
			var dirList = directoryList( dirLocation );
			for(var i=1; i<= arrayLen(dirList); i++) {
				var serviceName = Replace(listGetAt(dirList[i],listLen(dirList[i],"\/"),"\/"),".cfc","");
				var service = createObject("component", "Slatwall.paymentServices.#serviceName#.Service");
				variables.paymentServices[ "#serviceName#" ] = service;
			}
		}
		return variables.paymentServices;
	}
	
}
