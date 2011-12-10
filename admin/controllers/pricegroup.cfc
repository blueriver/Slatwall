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

Notes: Test.

*/
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="priceGroupService" type="any";
	property name="productService" type="any";
	property name="requestCacheService" type="any";
	property name="settingService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:pricegroup.list");
	}
	
	public void function listPriceGroups(required struct rc) {
        param name="rc.orderBy" default="priceGroupId|ASC";
        
        rc.priceGroupSmartList = getPriceGroupService().getPriceGroupSmartList(data=arguments.rc);  
    }
    
    public void function detailPriceGroup(required struct rc) {
    	param name="rc.priceGroupID" default="";
    	param name="rc.edit" default="false";
    	
    	rc.priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID);
    	
    	if(isNull(rc.priceGroup)) {
    		getFW().redirect(action="admin:pricegroup.listPriceGroups");
    	}
    }
    
    public void function createPriceGroup(required struct rc) {
    	editPriceGroup(rc);
	}
    
    public void function editPriceGroup(required struct rc) {
    	param name="rc.priceGroupID" default="";
    	param name="rc.priceGroupRateID" default="";
    	
    	rc.priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID, true);
    	rc.priceGroupRate = getPriceGroupService().getPriceGroupRate(rc.priceGroupRateId, true);
    	
    	rc.edit = true; 
    	getFW().setView("admin:pricegroup.detailPriceGroup");  
	
	}
	

	public void function savePriceGroup(required struct rc) {
		editPriceGroup(rc);

		var wasNew = rc.PriceGroup.isNew();

		//dumpScreen(rc);
		
		// In order for the automated population / save logic to work, map certain fields in the RC to their matching entity fields
		/*if(StructKeyExists(rc, "priceGroupRateType") && rc.priceGroupRateType != ""){
			
			rc.PriceGroupRates[1].percentageOff = ] = 
			
			rc["PriceGroupRates[1].amounOff"] = rc["PriceGroupRates[1].amount"] = "";
			if(rc.priceGroupRateType EQ "percentageOff")
				rc["PRICEGROUPRATES[1].PERCENTAGEOFF"] = rc.priceGroupRateValue;
			else if(rc.priceGroupRateType EQ "amountOff")
				rc["PRICEGROUPRATES[1].AMOUNTOFF"] = rc.priceGroupRateValue;
			else if(rc.priceGroupRateType EQ "amount")
				rc["PRICEGROUPRATES[1].AMOUNT"] = rc.priceGroupRateValue;
			else
				throw("Unacceptable value for priceGroupRateType (#rc.priceGroupRateType#)");
		} */
		
		//dumpScreen(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		rc.priceGroup = getPriceGroupService().savePriceGroup(rc.priceGroup, rc);

		if(!rc.priceGroup.hasErrors()) {
			// If added or edited a Price Group Rate
			if(wasNew) {
				rc.message=rbKey("admin.pricegroup.savepricegroup_nowaddrates");
				getFW().redirect(action="admin:priceGroup.editPriceGroup", querystring="pricegroupid=#rc.pricegroup.getPriceGroupID()#", preserve="message");	
			} else {
				rc.message=rc.message=rbKey("admin.priceGroup.savepricegroup_success");
				
				// If the price group rate has changed during this edit, then stay on the details page, otherwise, list.
				if(rc.populateSubProperties)
					getFW().redirect(action="admin:priceGroup.detailPriceGroup", querystring="pricegroupid=#rc.pricegroup.getPriceGroupID()#", preserve="message");
				else
					getFW().redirect(action="admin:priceGroup.listPriceGroups", querystring="", preserve="message");
			}
			
		} 
		else { 			
			// If one of the rates had the error, then find out which one and populate it
			if(rc.pricegroup.hasError("priceGroupRates")) {
				for(var i=1; i<=arrayLen(rc.pricegroup.getPriceGroupRates()); i++) {
					if(rc.pricegroup.getPriceGroupRates()[i].hasErrors()) {
						rc.priceGroupRate = rc.pricegroup.getPriceGroupRates()[i];
					}
				}
			}
			rc.edit = true;
			rc.itemTitle = rc.PriceGroup.isNew() ? rc.$.Slatwall.rbKey("admin.pricegroup.createPriceGroup") : rc.$.Slatwall.rbKey("admin.pricegroup.editPriceGroup") & ": #rc.pricegroup.getPriceGroupName()#";
			getFW().setView(action="admin:priceGroup.detailPriceGroup");
		}	
	}
	
	public void function deletePriceGroup(required struct rc) {
		var priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupId);
		var deleteOK = getPriceGroupService().deletePriceGroup(priceGroup);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.pricegroup.deletePriceGroup_success");
		} else {
			rc.message = rbKey("admin.pricegroup.deletePriceGroup_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:priceGroup.listPriceGroups", preserve="message,messagetype");
	}
	
	/*
	
	var optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
		
		var deleteOK = getOptionService().deleteOptionGroup(optionGroup);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.optionGroup.delete_success");
		} else {
			rc.message = rbKey("admin.optionGroup.delete_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:option.listOptionGroups", preserve="message,messagetype");
	
	*/
	
	
	
	public void function deletePriceGroupRate(required struct rc) {
		var priceGroupRate = getPriceGroupService().getPriceGroupRate(rc.priceGroupRateId);
		var priceGroupId = priceGroupRate.getPriceGroup().getPriceGroupId();
		var deleteOK = getPriceGroupService().deletePriceGroupRate(priceGroupRate);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.pricegroup.deletePriceGroupRate_success");
		} else {
			rc.message = rbKey("admin.pricegroup.deletePriceGroupRate_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:pricegroup.editPriceGroup", querystring="priceGroupid=#priceGroupId#",preserve="message,messagetype");
		
	}
	
		// Common functionalty of Add/Edit/View
	/*public void function detail(required struct rc) {
		param name="rc.priceGroupID" default="";
		param name="rc.edit" default="false";
		
		rc.priceGroup = getPriceGroupService().getPriceGroup(rc.priceGroupID,true);
		
		// If we are editing a PriceGroupRate (rc contain a priceGroupRateId) then pull that one specifically, otherwise, pull a brand new entity (rc does not contain priceGorupRateId)
		param name="rc.priceGroupRateId" default="";
		rc.PriceGroupRate = getPriceGroupService().getPriceGroupRate(rc.priceGroupRateId, true);	
	}


    public void function create(required struct rc) {
		edit(rc);
    }

	public void function edit(required struct rc) {
		detail(rc);
		getFW().setView("admin:priceGroup.detail");
		rc.edit = true;
	}
	
	public void function editPriceGroupRate(required struct rc) {
		detail(rc);
		getFW().setView("admin:priceGroup.detail");
		rc.edit = true;
	}
	 
    public void function list(required struct rc) {	
		rc.priceGroups = getPriceGroupService().listPriceGroup();
    }
*/
}
