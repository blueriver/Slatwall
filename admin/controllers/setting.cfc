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
			
	property name="settingService" type="any";
	property name="userManager" type="any";
	property name="productService" type="any";
	
	public void function dashboard() {
		getFW().redirect(action="admin:setting.detail");
	}
	
	// Global Settings
	public void function detail(required struct rc) {
		rc.edit = false;
		rc.allSettings = getSettingService().getSettings();
		rc.productTemplateOptions = getProductService().getProductTemplates();
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
				if(setting.isNew() == false) {
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
		getSettingService().reloadConfiguration();
		getFW().redirect(action="admin:main.dashboard");
	}
	
	// Shipping Methods & Services
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
		getSettingService().reloadConfiguration();
		getFW().redirect(action="admin:setting.listshippingmethods", preserve="message,messagetype");
	}
	
	public void function createShippingMethod(required struct rc) {
		detailShippingMethod(rc);
		getFW().setView("admin:setting.detailshippingmethod");
		rc.edit = true;
	}
	
	public void function editShippingMethod(required struct rc) {
		detailShippingMethod(rc);
		getFW().setView("admin:setting.detailshippingmethod");
		rc.edit = true;
	}
	
	public void function saveShippingMethod(required struct rc) {
		detailShippingMethod(rc);
		rc.shippingMethod = getSettingService().save(rc.shippingMethod, rc);
		if(!rc.shippingMethod.hasErrors()) {
			getSettingService().reloadConfiguration();
	   		getFW().redirect(action="admin:setting.listshippingmethods", querystring="message=admin.setting.saveshippingmethod_success");
		} else {
			rc.itemTitle = rc.shippingMethod.isNew() ? rc.$.Slatwall.rbKey("admin.setting.createshippingmethod") : rc.$.Slatwall.rbKey("admin.setting.editshippingmethod") & ": #rc.shippingMethod.getShippingMethodName()#";
	   		getFW().setView(action="admin:setting.editshippingmethod");
		}
	}
	
	// Payment Methods & Services
	
	
	
	// Integrations Services
}
