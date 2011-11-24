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
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="priceGroupService" type="any";
	property name="requestCacheService" type="any";
	property name="settingService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:pricegroup.list");
	}

	// Common functionalty of Add/Edit/View
	public void function detail(required struct rc) {
		param name="rc.priceGroupID" default="";
		param name="rc.edit" default="false";
		
		rc.priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID,true);
		rc.priceGroupCodeSmartList = getPriceGroupService().getPriceGroupRateSmartList(priceGroupID=rc.priceGroup.getPriceGroupID() ,data=rc);
		if(!rc.priceGroup.isNew()) {
			rc.itemTitle &= ": " & rc.priceGroup.getPriceGroupName();
		}
	}


    public void function create(required struct rc) {
		rc.productTypeTree = getService("ProductService").getProductTypeTree();
		detail(arguments.rc);
		getFW().setView("admin:priceGroup.detail");
		rc.edit = true;
    }

	public void function edit(required struct rc) {
		rc.productTypeTree = getService("ProductService").getProductTypeTree();
		detail(arguments.rc);
		getFW().setView("admin:priceGroup.detail");
		rc.edit = true;
	}
	 
    public void function list(required struct rc) {	
		rc.priceGroups = getService("PriceGroupService").listPriceGroup();
    }

	public void function save(required struct rc) {
	   rc.priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID,true);
	   rc.priceGroup = getPriceGroupService().save(rc.priceGroup,rc);
	   if(!getRequestCacheService().getValue("ormHasErrors")) {
	   		getFW().redirect(action="admin:priceGroup.list",querystring="message=admin.priceGroup.save_success");
		} else {
			rc.edit = true;
			rc.itemTitle = rc.priceGroup.isNew() ? rc.$.Slatwall.rbKey("admin.priceGroup.create") : rc.$.Slatwall.rbKey("admin.priceGroup.edit") & ": #rc.priceGroup.getPriceGroupName()#";
			rc.priceGroupCodeSmartList = getPriceGroupService().getPriceGroupRateSmartList(priceGroupID=rc.priceGroup.getPriceGroupID() ,data=rc);
			rc.productTypeTree = getService("ProductService").getProductTypeTree();
			rc.shippingMethods = getSettingService().listShippingMethod();
	   		getFW().setView(action="admin:priceGroup.detail");
		}
	}
	
	public void function delete(required struct rc) {
		var priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID);
		var deleteResponse = getPriceGroupService().delete(priceGroup);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.priceGroup.delete_success");
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}	   
		getFW().redirect(action="admin:priceGroup.list",preserve="message,messagetype");
	}

	public void function deletePriceGroupRate(required struct rc) {
		var priceGroupCode = getPriceGroupService().getPriceGroupRate(rc.priceGroupCodeID);
		rc.priceGroupID = priceGroupCode.getPriceGroup().getPriceGroupID();
		var deleteResponse = getPriceGroupService().deletePriceGroupRate(priceGroupCode);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.priceGroup.deletePriceGroupRate_success");
		} else {
			rc.message = deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype = "error";
		}
		rc.edit = true;
		rc.priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID,true);
		rc.priceGroupCodeSmartList = getPriceGroupService().getPriceGroupRateSmartList(priceGroupID=rc.priceGroup.getPriceGroupID() ,data=rc);
		rc.itemTitle = rc.$.Slatwall.rbKey("admin.priceGroup.edit") & ": #rc.priceGroup.getPriceGroupName()#";
		getFW().redirect(action="admin:priceGroup.detail",querystring="priceGroupID=#rc.priceGroupID#",preserve="message,messagetype");
	}
	
	public void function deletePriceGroupReward(required struct rc) {
		var priceGroupReward = getPriceGroupService().getPriceGroupReward(rc.priceGroupRewardID);
		rc.priceGroupID = priceGroupReward.getPriceGroup().getPriceGroupID();
		var deleteResponse = getPriceGroupService().deletePriceGroupReward(priceGroupReward);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.priceGroup.deletePriceGroupReward_success");
		} else {
			rc.message = deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype = "error";
		}
		rc.edit = true;
		rc.priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID,true);
		rc.itemTitle = rc.$.Slatwall.rbKey("admin.priceGroup.edit") & ": #rc.priceGroup.getPriceGroupName()#";
		getFW().redirect(action="admin:priceGroup.detail",querystring="priceGroupID=#rc.priceGroupID#",preserve="message,messagetype");
	}
	
}
