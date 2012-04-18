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
		getFW().redirect("admin:pricing.listpromotion");
	}

	public void function createPromotion() {
		param name="rc.promotionID" default="";
		rc.edit = "true";
		rc.promotion = getPromotionService().getPromotion(rc.promotionID,true);
		if( rc.promotion.isNew() ) {
			rc.promotionPeriod = getPromotionService().newPromotionPeriod();
		}

		getFW().setView( "admin:pricing.detailpromotion" );
	}

	public void function createPromotionRewardProduct(required struct rc) {
		rc.promotionreward = getPromotionService().newPromotionRewardProduct();
		if( structKeyExists(rc,"promotionperiodID") ) {
			rc.promotionperiod = getPromotionService().getPromotionperiod( rc.promotionPeriodID );
		}
		rc.saveAction = "admin:pricing.savepromotionrewardproduct";
		rc.cancelAction = "admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards";
		rc.edit = true;
		getFW().setView("admin:pricing.detailpromotionreward");
	}

	public void function createPromotionRewardShipping(required struct rc) {
		rc.promotionreward = getPromotionService().newPromotionRewardShipping();
		if( structKeyExists(rc,"promotionperiodID") ) {
			rc.promotionperiod = getPromotionService().getPromotionperiod( rc.promotionPeriodID );
		} 		 
		rc.saveAction = "admin:pricing.savepromotionrewardshipping";
		rc.cancelAction = "admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards";
		rc.edit = true;
		getFW().setView("admin:pricing.detailpromotionreward");
	}
	
	public void function createPromotionRewardOrder(required struct rc) {
		rc.promotionreward = getPromotionService().newPromotionRewardOrder();
		if( structKeyExists(rc,"promotionperiodID") ) {
			rc.promotionperiod = getPromotionService().getPromotionperiod( rc.promotionPeriodID );
		}
		rc.saveAction = "admin:pricing.savepromotionrewardorder";
		rc.cancelAction = "admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards";
		rc.edit = true;
		getFW().setView("admin:pricing.detailpromotionreward");
	}

	public void function createPromotionQualifierProduct(required struct rc) {
		rc.promotionQualifier = getPromotionService().newPromotionQualifierProduct();
		if( structKeyExists(rc,"promotionperiodID") ) {
			rc.promotionperiod = getPromotionService().getPromotionperiod( rc.promotionPeriodID );
		}
		rc.saveAction = "admin:pricing.savepromotionqualifierproduct";
		rc.cancelAction = "admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionqualifiers";
		rc.edit = true;
		getFW().setView("admin:pricing.detailpromotionqualifier");
	}

	public void function createPromotionQualifierFulfillment(required struct rc) {
		rc.promotionQualifier = getPromotionService().newPromotionQualifierFulfillment();
		if( structKeyExists(rc,"promotionperiodID") ) {
			rc.promotionperiod = getPromotionService().getPromotionperiod( rc.promotionPeriodID );
		} 		 
		rc.saveAction = "admin:pricing.savepromotionqualifierfulfillment";
		rc.cancelAction = "admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionqualifiers";
		rc.edit = true;
		getFW().setView("admin:pricing.detailpromotionqualifier");
	}
	
	public void function createPromotionQualifierOrder(required struct rc) {
		rc.promotionQualifier = getPromotionService().newPromotionQualifierOrder();
		if( structKeyExists(rc,"promotionperiodID") ) {
			rc.promotionperiod = getPromotionService().getPromotionperiod( rc.promotionPeriodID );
		}
		rc.saveAction = "admin:pricing.savepromotionqualifierorder";
		rc.cancelAction = "admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID###tabpromotionqualifiers";
		rc.edit = true;
		getFW().setView("admin:pricing.detailpromotionqualifier");
	}

}
