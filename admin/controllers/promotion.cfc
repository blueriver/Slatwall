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
	
	public void function dashboard(required struct rc) {
		getFW().redirect("admin:promotion.list");
	}

	public void function detail(required struct rc) {
		param name="rc.promotionID" default="";
		param name="rc.edit" default="false";
		
		rc.promotion = getPromotionService().getPromotion(rc.promotionID,true);
		rc.promotionCodeSmartList = getPromotionService().getPromotionCodeSmartList(promotionID=rc.promotion.getPromotionID() ,data=rc);
		if(!rc.promotion.isNew()) {
			rc.itemTitle &= ": " & rc.promotion.getPromotionName();
		}
	}


    public void function create(required struct rc) {
		detail(arguments.rc);
		getFW().setView("admin:promotion.detail");
		rc.edit = true;
    }

	public void function edit(required struct rc) {
		detail(arguments.rc);
		getFW().setView("admin:promotion.detail");
		rc.edit = true;
	}
	 
    public void function list(required struct rc) {
		rc.promotions = getPromotionService().listPromotion();
    }

	public void function save(required struct rc) {
	   rc.promotion = getPromotionService().getPromotion(rc.promotionID,true);
	   rc.promotion = getPromotionService().save(rc.promotion,rc);
	   if(!getRequestCacheService().getValue("ormHasErrors")) {
	   		getFW().redirect(action="admin:promotion.list",querystring="message=admin.promotion.save_success");
		} else {
			rc.edit = true;
			rc.itemTitle = rc.promotion.isNew() ? rc.$.Slatwall.rbKey("admin.promotion.create") : rc.$.Slatwall.rbKey("admin.promotion.edit") & ": #rc.promotion.getPromotionName()#";
			rc.promotionCodeSmartList = getPromotionService().getPromotionCodeSmartList(promotionID=rc.promotion.getPromotionID() ,data=rc);
	   		getFW().setView(action="admin:promotion.detail");
		}
	}
	
	public void function delete(required struct rc) {
		var promotion = getPromotionService().getPromotion(rc.promotionID);
		var deleteResponse = getPromotionService().delete(promotion);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.promotion.delete_success");
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}	   
		getFW().redirect(action="admin:promotion.list",preserve="message,messagetype");
	}

	public void function deletePromotionCode(required struct rc) {
		var promotionCode = getPromotionService().getPromotionCode(rc.promotionCodeID);
		rc.promotionID = promotionCode.getPromotion().getPromotionID();
		var deleteResponse = getPromotionService().deletePromotionCode(promotionCode);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.promotion.deletePromotionCode_success");
		} else {
			rc.message = deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype = "error";
		}
		rc.edit = true;
		rc.promotion = getPromotionService().getPromotion(rc.promotionID,true);
		rc.promotionCodeSmartList = getPromotionService().getPromotionCodeSmartList(promotionID=rc.promotion.getPromotionID() ,data=rc);
		rc.itemTitle = rc.$.Slatwall.rbKey("admin.promotion.edit") & ": #rc.promotion.getPromotionName()#";
		getFW().redirect(action="admin:promotion.detail",querystring="promotionID=#rc.promotionID#",preserve="message,messagetype");
	}
	
	public void function deletePromotionReward(required struct rc) {
		var promotionReward = getPromotionService().getPromotionReward(rc.promotionRewardID);
		rc.promotionID = promotionReward.getPromotion().getPromotionID();
		var deleteResponse = getPromotionService().deletePromotionReward(promotionReward);
		if(!deleteResponse.hasErrors()) {
			rc.message = rbKey("admin.promotion.deletePromotionReward_success");
		} else {
			rc.message = deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype = "error";
		}
		rc.edit = true;
		rc.promotion = getPromotionService().getPromotion(rc.promotionID,true);
		rc.itemTitle = rc.$.Slatwall.rbKey("admin.promotion.edit") & ": #rc.promotion.getPromotionName()#";
		getFW().redirect(action="admin:promotion.detail",querystring="promotionID=#rc.promotionID#",preserve="message,messagetype");
	}
	
}
