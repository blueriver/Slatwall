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

	// Common functionalty of Add/Edit/View
	public void function detail(required struct rc) {
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

	public void function save(required struct rc) {
		// Populate either a brand new PriceGroup and PriceGroupRate in the rc, or pulls them based on the provided ID. Does NOT populate based on RC.
		detail(rc);
		
		var wasNew = rc.PriceGroup.isNew();
		
		// save() does an RC -> Entity population, and flags the entities to be saved.
		rc.priceGroup = getPriceGroupService().save(rc.priceGroup, rc);
		
		param name="rc.addPriceGroupRate" default="false";
		param name="rc.priceGroupRateId" default="";
		
		if(rc.priceGroup.hasErrors() || wasNew) {
			rc.edit = true;
			getFW().setView("admin:priceGroup.detail");
			rc.message="admin.pricegroup.savepricegroup_nowaddrates";	
		} else {
			// If adding or editing a price group
			if(rc.addPriceGroupRate EQ "true" OR rc.priceGroupRateId NEQ "") {
				// Since the value field posted (in RC) does not directly match the properties of the PriceGroupRate entity (percentageOff, amountOff, amount), map the posted priceGroupRateType and priceGroupRateValue from the form to the three amount fields in the entity, which will then be automatically loaded into the entity by populate().
				rc.percentageOff = rc.amountOff = rc.amount = "";
				if(rc.priceGroupRateType EQ "percentageOff")
					rc["PriceGroupRate.percentageOff"] = rc.priceGroupRateValue;
				else if(rc.priceGroupRateType EQ "amountOff")
					rc["PriceGroupRate.amounOff"] = rc.priceGroupRateValue;
				else if(rc.priceGroupRateType EQ "amount")
					rc["PriceGroupRate.amount"] = rc.priceGroupRateValue;
				else
					throw("Unacceptable value for priceGroupRateType (#rc.priceGroupRateType#)");
					
					
				// Populates and validates entity
				getPriceGroupService().savePriceGroupRate(rc.PriceGroupRate);	
				
				/* Everythign bellow might need to go! */	
					
					
					
				// rc.priceGroupRate is created by detail(). Will contain either new PriceGroupRate entity, or one from the DB if editing. populate() fills entity with values based on RC (form post).
				rc.priceGroupRate.populate(rc);	

				param name="rc.globalFlag" default="0";
				param name="rc.productIds" default="";
				param name="rc.productTypeIds" default="";
				param name="rc.SKUIds" default="";
				param name="rc.excludedProductIds" default="";
				param name="rc.excludedProductTypeIds" default="";
				param name="rc.excludedSKUIds" default="";
				
				// If PriceGroupRate is "global" then zero out the id lists. If we are editing a product that was switched from non-global to global, then the "set" methods will erase the many-to-many.  Otherwise populate the contents of the multiselects
				if(rc.globalFlag EQ 1){
					rc.productIds = "";
					rc.productTypeIds = "";
					rc.SKUIds = "";
					rc.excludedProductIds = "";
					rc.excludedProductTypeIds = "";
					rc.excludedSKUIds = "";
				}
				
				/*--------- TEMPORARY until Greg writes generic hander in populate() --------- */
				// Included
				var productArr = []; 
				for(var i=1; i LTE ListLen(rc.ProductIds); i++)
					arrayAppend(productArr, getProductService().getProduct(ListGetAt(rc.ProductIds, i)));
				rc.PriceGroupRate.setProducts(productArr);
				
				var productTypeArr = []; 
				for(var i=1; i LTE ListLen(rc.ProductTypeIds); i++)
					arrayAppend(productTypeArr, getProductService().getProductType(ListGetAt(rc.ProductTypeIds, i)));
				rc.PriceGroupRate.setProductTypes(productTypeArr);
				
				var skuArr = []; 
				for(var i=1; i LTE ListLen(rc.SkuIds); i++)
					arrayAppend(skuArr, getProductService().getSku(ListGetAt(rc.SkuIds, i)));
				rc.PriceGroupRate.setSkus(skuArr);
				
				// Excluded
				var excludedProductArr = []; 
				for(var i=1; i LTE ListLen(rc.ExcludedProductIds); i++)
					arrayAppend(excludedProductArr, getProductService().getProduct(ListGetAt(rc.ExcludedProductIds, i)));
				rc.PriceGroupRate.setExcludedProducts(excludedProductArr);
				
				var excludedProductTypeArr = []; 
				for(var i=1; i LTE ListLen(rc.ExcludedProductTypeIds); i++)
					arrayAppend(excludedProductTypeArr, getProductService().getProductType(ListGetAt(rc.ExcludedProductTypeIds, i)));
				rc.PriceGroupRate.setExcludedProductTypes(excludedProductTypeArr);
				
				var excludedSkuArr = []; 
				for(var i=1; i LTE ListLen(rc.ExcludedSkuIds); i++)
					arrayAppend(excludedSkuArr, getProductService().getSku(ListGetAt(rc.ExcludedSkuIds, i)));
				rc.PriceGroupRate.setExcludedSkus(excludedSkuArr);
				
				// If we have added this PriceGroupRate, not edited, then add it to the PriceGroup
				if(rc.addPriceGroupRate EQ "true")
					rc.priceGroup.addPriceGroupRate(rc.priceGroupRate);
	
				getFW().redirect(action="admin:priceGroup.detail", querystring="message=admin.pricegroup.savepricegrouprate_success&priceGroupId=#rc.PriceGroup.getPriceGroupId()#");
			} else {
				getFW().redirect(action="admin:priceGroup.list", querystring="message=admin.pricegroup.savepricegroup_success");	
			}
			
			
		}
	}
	
	public void function delete(required struct rc) {
		
		detail(rc);
		
		var deleteOK = getPriceGroupService().delete(rc.priceGroup);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.pricegroup.delete_success");
		} else {
			rc.message = rbKey("admin.pricegroup.delete_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:priceGroup.list", preserve="message,messagetype");
	}
	
	public void function deletePriceGroupRate(required struct rc) {
		detail(rc);
		
		var priceGroupRate = getPriceGroupService().getPriceGroupRate(rc.priceGroupRateId);

		//priceGroupRate.removePriceGroup(rc.priceGroup);

		rc.priceGroup.removePriceGroupRate(priceGroupRate);
		priceGroupRate.removePriceGroup(rc.priceGroup);
		
		rc.edit = true;
		getFW().setView("admin:pricegroup.detail");
	}
}
