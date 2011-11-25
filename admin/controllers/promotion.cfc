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
	property name="promotionService" type="any";
	property name="requestCacheService" type="any";
	property name="settingService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:promotion.list");
	}

	public void function detail(required struct rc) {
		param name="rc.promotionID" default="";
		param name="rc.edit" default="false";
		
		// Get the promotion
		rc.promotion = getPromotionService().getPromotion(rc.promotionID,true);
		
		// Put the promotion ID in the data so that the SmartList works
		rc["F:promotion.promotionID"] = rc.promotion.getPromotionID();
		
		// Get a smart list of Promotion Codes for the view
		rc.promotionCodeSmartList = getPromotionService().getPromotionCodeSmartList(data=rc);
		
		if(!rc.promotion.isNew()) {
			rc.itemTitle &= ": " & rc.promotion.getPromotionName();
		}
	}


    public void function create(required struct rc) {
    	edit( rc );
    }

	public void function edit(required struct rc) {
		
		detail(arguments.rc);
		getFW().setView("admin:promotion.detail");
		rc.edit = true;
		
		// Set up additional values that the view needs when in edit mode
		rc.productTypeTree = getService("ProductService").getProductTypeTree();
		rc.brands = getService("BrandService").listBrandorderByBrandName();
		rc.optionGroups = getService("optionService").listOptionGroup();
		rc.shippingMethods = getSettingService().listShippingMethod();
		
	}
	 
    public void function list(required struct rc) {
		rc.promotions = getPromotionService().listPromotion();
    }

	public void function save(required struct rc) {
		
		// Get the promotion from the DB, and return a new promotion if necessary
		rc.promotion = getPromotionService().getPromotion(rc.promotionID,true);
		
		// Call the promotion service save method (this is standard)
		rc.promotion = getPromotionService().savePromotion(rc.promotion,rc);
		
		// If no errors, then redirect to the list page, otherwise go back to edit
		if(!rc.promotion.hasErrors()) {
			getFW().redirect(action="admin:promotion.list",querystring="message=admin.promotion.save_success");
		} else {
			edit( rc );
		}
	}
	
	public void function delete(required struct rc) {
		
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
		
		getFW().redirect(action="admin:promotion.detail",querystring="promotionID=#rc.promotionID#",preserve="message,messagetype");
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
		
		getFW().redirect(action="admin:promotion.detail",querystring="promotionID=#rc.promotionID#",preserve="message,messagetype");
	}
	
}
