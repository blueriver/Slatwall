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
	property name="promotionService" type="any";
	property name="productService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:pricing.listpromotions");
	}
	
	public void function detailpromotion(required struct rc) {
		param name="rc.promotionID" default="";
		param name="rc.promotionRewardID" default="";
		param name="rc.promotionQualifierID" default="";
		param name="rc.promotionRewardExclusionID" default="";
		param name="rc.promotionQualifierExclusionID" default="";
		param name="rc.edit" default="false";
		
		// Get the promotion from the DB, and return a new promotion if necessary
		rc.promotion = getPromotionService().getPromotion(rc.promotionID, true);
		rc.promotionRewardProduct = getPromotionService().getPromotionRewardProduct(rc.promotionRewardID, true);
		rc.promotionRewardShipping = getPromotionService().getPromotionRewardShipping(rc.promotionRewardID, true);
		rc.promotionRewardOrder = getPromotionService().getPromotionRewardOrder(rc.promotionRewardID, true);
		rc.promotionQualifierProduct = getPromotionService().getPromotionQualifierProduct(rc.promotionQualifierID, true);
		rc.promotionQualifierFulfillment = getPromotionService().getPromotionQualifierFulfillment(rc.promotionQualifierID, true);
		rc.promotionQualifierOrder = getPromotionService().getPromotionQualifierOrder(rc.promotionQualifierID, true);
		rc.PromotionRewardExclusion = getPromotionService().getPromotionRewardExclusion(rc.promotionRewardExclusionID, true);
		rc.PromotionQualifierExclusion = getPromotionService().getPromotionQualifierExclusion(rc.promotionQualifierExclusionID, true);
		
		if(!rc.promotion.isNew()) {
			rc.itemTitle &= ": " & rc.promotion.getPromotionName();
		}
	}


    public void function createpromotion(required struct rc) {
    	edit( rc );
    }

	public void function editpromotion(required struct rc) {
		param name="rc.promotionID" default="";
		param name="rc.promotionRewardID" default="";
		param name="rc.promotionQualifierID" default="";
		param name="rc.promotionRewardExclusionID" default="";
		param name="rc.promotionQualifierExclusionID" default="";
		
		detail(rc);
		rc.edit = true;
		getFW().setView("admin:promotion.detail");
		
	}
	 
    public void function listpromotions(required struct rc) {
		rc.promotions = getPromotionService().listPromotion();
    }

	public void function savepromotion(required struct rc) {
		param name="rc.promotionID" default="";
		param name="rc.promotionRewardID" default="";
		param name="rc.promotionRewardExclusionID" default="";
		param name="rc.savePromotionRewardProduct" default="false";
		param name="rc.savePromotionRewardShipping" default="false";
		param name="rc.savePromotionRewardOrder" default="false";
		param name="rc.savePromotionQualifierProduct" default="false";
		param name="rc.savePromotionQualifierFulfillment" default="false";
		param name="rc.savePromotionQualifierOrder" default="false";
		param name="rc.savePromotionRewardExclusion" default="false";
		param name="rc.savePromotionQualifierExclusion" default="false";
		
		detail(rc);
		// Call the promotion service save method (this is standard)
		rc.promotion = getPromotionService().savePromotion(rc.promotion, rc);
		
		// If no errors, then redirect to the list page, otherwise go back to edit
		if(!rc.promotion.hasErrors()) {
			rc.message="admin.promotion.save_success";
			if(rc.savePromotionRewardProduct || rc.savePromotionRewardShipping || rc.savePromotionRewardOrder) {
				getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotion.getPromotionID()#",preserve="message");	
			} else if ( rc.savePromotionQualifierProduct || rc.savePromotionQualifierFulfillment || rc.savePromotionQualifierOrder ) {
				getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotion.getPromotionID()###tabPromotionQualifiers",preserve="message");	
			} else if ( rc.savePromotionRewardExclusion ) {
				getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotion.getPromotionID()###tabPromotionRewardExclusions",preserve="message");	
			} else if ( rc.savePromotionQualifierExclusion ) {
				getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotion.getPromotionID()###tabPromotionQualifierExclusions",preserve="message");	
			} else {
				getFW().redirect(action="admin:promotion.list",preserve="message");
			}
		} else {
			// If one of the sub-options had the error, then find out which one and populate it
			if(rc.promotion.hasError("promotionRewards")) {
				for(var i=1; i<=arrayLen(rc.promotion.getPromotionRewards()); i++) {
					var thisReward = rc.promotion.getPromotionRewards()[i];
					if(thisReward.hasErrors() && thisReward.getRewardType() == "product") {
						rc.promotionRewardProduct = thisReward;
					} else if(thisReward.hasErrors() && thisReward.getRewardType() == "shipping") {
						rc.promotionRewardShipping = thisReward;
					}
				}
			}
			rc.edit = true;
			rc.itemTitle = rc.promotion.isNew() ? rc.$.Slatwall.rbKey("admin.promotion.create") : rc.$.Slatwall.rbKey("admin.promotion.edit") & ": #rc.promotion.getPromotionName()#";
			getFW().setView(action="admin:promotion.detail");
		}
	}
	
	public void function deletepromotion(required struct rc) {
		
		var promotion = getPromotionService().getPromotion(rc.promotionID);
		
		var deleteOK = getPromotionService().deletePromotion(promotion);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.promotion.delete_success");
		} else {
			rc.message = rbKey("admin.promotion.delete_error");
			rc.messagetype="error";
		}
			   
		getFW().redirect(action="admin:promotion.list",preserve="message,messagetype");
	}

	public void function deletePromotionCode(required struct rc) {
		
		var promotionCode = getPromotionService().getPromotionCode(rc.promotionCodeID);
		rc.promotionID = promotionCode.getPromotion().getPromotionID();
		
		var deleteOK = getPromotionService().deletePromotionCode(promotionCode);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.promotion.deletePromotionCode_success");
		} else {
			rc.message = rbKey("admin.promotion.deletePromotionCode_error");
			rc.messagetype = "error";
		}
		
		getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotionID#",preserve="message,messagetype");
	}
	
	public void function deletePromotionReward(required struct rc) {
		
		var promotionReward = getPromotionService().getPromotionReward(rc.promotionRewardID);
		rc.promotionID = promotionReward.getPromotion().getPromotionID();
		
		var deleteOK = getPromotionService().deletePromotionReward(promotionReward);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.promotion.deletePromotionReward_success");
		} else {
			rc.message = rbKey("admin.promotion.deletePromotionReward_error");
			rc.messagetype = "error";
		}
		
		getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotionID#",preserve="message,messagetype");
	}
	
	public void function deletePromotionRewardExclusion(required struct rc) {
		
		var promotionRewardExclusion = getPromotionService().getPromotionRewardExclusion(rc.promotionRewardExclusionID);
		rc.promotionID = promotionRewardExclusion.getPromotion().getPromotionID();
		
		var deleteOK = getPromotionService().deletePromotionRewardExclusion(promotionRewardExclusion);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.promotion.deletePromotionRewardExclusion_success");
		} else {
			rc.message = rbKey("admin.promotion.deletePromotionRewardExclusion_error");
			rc.messagetype = "error";
		}
		
		getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotionID###tabPromotionRewardExclusions",preserve="message,messagetype");
	}
	
	public void function deletePromotionQualifier(required struct rc) {
		
		var promotionQualifier = getPromotionService().getPromotionQualifier(rc.promotionQualifierID);
		rc.promotionID = promotionQualifier.getPromotion().getPromotionID();
		
		var deleteOK = getPromotionService().deletePromotionQualifier(promotionQualifier);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.promotion.deletePromotionQualifier_success");
		} else {
			rc.message = rbKey("admin.promotion.deletePromotionQualifier_error");
			rc.messagetype = "error";
		}
		
		getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotionID###tabPromotionQualifiers",preserve="message,messagetype");
	}
	
	public void function deletePromotionQualifierExclusion(required struct rc) {
		
		var promotionQualifierExclusion = getPromotionService().getPromotionQualifierExclusion(rc.promotionQualifierExclusionID);
		rc.promotionID = promotionQualifierExclusion.getPromotion().getPromotionID();
		
		var deleteOK = getPromotionService().deletePromotionQualifierExclusion(promotionQualifierExclusion);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.promotion.deletePromotionQualifierExclusion_success");
		} else {
			rc.message = rbKey("admin.promotion.deletePromotionQualifierExclusion_error");
			rc.messagetype = "error";
		}
		
		getFW().redirect(action="admin:promotion.edit",querystring="promotionID=#rc.promotionID###tabPromotionQualifierExclusions",preserve="message,messagetype");
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
    	getFW().setView("admin:pricegroup.detailpricegroup");  
	}
	

	public void function savePriceGroup(required struct rc) {
		editPriceGroup(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		var wasNew = rc.priceGroup.isNew();
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
					getFW().redirect(action="admin:priceGroup.editPriceGroup", querystring="pricegroupid=#rc.pricegroup.getPriceGroupID()#", preserve="message");
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
						break;
					}
				}
			}
			rc.edit = true;
			rc.itemTitle = rc.PriceGroup.isNew() ? rc.$.Slatwall.rbKey("admin.pricegroup.createPriceGroup") : rc.$.Slatwall.rbKey("admin.pricegroup.editPriceGroup") & ": #rc.pricegroup.getPriceGroupName()#";
			getFW().setView(action="admin:priceGroup.detailpricegroup");
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

}
