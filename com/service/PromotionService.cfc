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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	public any function save(required any Promotion,required struct data) {
		// populate bean from values in the data Struct
		arguments.Promotion.populate(arguments.data);
		
		if(structKeyExists(arguments.data.structuredData,"promotionCodes")){
			savePromotionCodes(arguments.promotion,arguments.data.structuredData.promotionCodes);
		}
		if(structKeyExists(arguments.data.structuredData,"promotionRewards")){
			savePromotionRewards(arguments.promotion,arguments.data.structuredData.promotionRewards);
		}
		
		arguments.Promotion = super.save(arguments.Promotion);
		
		return arguments.Promotion;
	}
	
	public any function delete(required any Promotion){
		if( arguments.Promotion.isAssgined() ) {
			getValidationService().setError(entity=arguments.Promotion,errorName="delete",rule="isAssigned");
		}
		return Super.delete(arguments.Promotion);
	}
	
	public any function getPromotionCodeSmartList(string promotionID, struct data={}){
		arguments.entityName = "SlatwallPromotionCode";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		if( structKeyExists(arguments,"promotionID") ) {
			smartList.addFilter(propertyIdentifier="promotion_promotionID", value=arguments.promotionID);
		}
		
		return smartList;
	}
	
	public any function deletePromotionCode(required any promotionCode) {
		if(arguments.promotionCode.isAssigned() == true) {
			getValidationService().setError(entity=arguments.promotionCode,errorname="delete",rule="isAssigned");	
		}
		if(!arguments.promotionCode.hasErrors()) {
			arguments.promotionCode.removePromotion(arguments.promotionCode.getPromotion());
		}
		var deleted = Super.delete(arguments.promotionCode);
		return deleted;
	}
	
	public void function savePromotionCodes(required any promotion, required array promotionCodes){
		var promotionCodeList = "";
		for(var promotionCodeData in arguments.promotionCodes){
			var promotionCode = this.getPromotionCode(promotionCodeData.promotionCodeID,true);
			if(promotionCode.isNew()){
				promotionCode.setPromotion(arguments.promotion);
			}
			promotionCode = savePromotionCode(promotionCode,promotionCodeData,promotionCodeList);
			promotionCodeList = listAppend(promotionCodeList,promotionCode.getPromotionCodeID());
		}
	}
	
	public any function savePromotionCode(required any promotionCode, required struct data, string promotionCodeList){
		arguments.promotionCode.populate(arguments.data);
		if(isNull(arguments.promotionCode.getPromotionCode()) || arguments.promotionCode.getPromotionCode() == ""){
			arguments.promotionCode.setPromotionCode(createUUID());
		}
		if(structKeyExists(arguments,"promotionCodeList")) {
			validatePromotionCode(arguments.promotionCode,arguments.promotionCodeList);
		} else {
			validatePromotionCode(arguments.promotionCode);
		}
		if(!getService("requestCacheService").getValue("ormHasErrors")){
			arguments.promotionCode = super.save(arguments.promotionCode);
		}
		return arguments.promotionCode;
	}
	
	public void function validatePromotionCode( required any promotionCode, string promotionCodeList ) {
		var isDuplicate = false;
		// first check if there was a duplicate among the PromotionCodes that are being created with this one
		if(structKeyExists(arguments,"promotionCodeList")) {
			isDuplicate = listFindNoCase( arguments.promotionCodeList, arguments.promotionCode.getPromotionCode() );
		}
		// then check the database (only if a duplicate wasn't already found)
		if( isDuplicate == false ) {
			isDuplicate = getDAO().isDuplicateProperty("promotionCode", arguments.promotionCode);
		}
		var promotionCodeError = getValidationService().validateValue(rule="assertFalse",objectValue=isDuplicate,objectName="promotionCode",message=rbKey("entity.promotionCode.promotionCode_validateUnique"));
		if( !structIsEmpty(promotionCodeError) ) {
			arguments.promotionCode.addError(argumentCollection=promotionCodeError);
			getService("requestCacheService").setValue("ormHasErrors", true);
		}
	}
	
	public void function savePromotionRewards(required any promotion, required array promotionRewards){
		for(var promotionRewardData in arguments.promotionRewards){
			var promotionReward = this.getPromotionRewardProduct(promotionRewardData.promotionRewardID,true);
			if(promotionReward.isNew()){
				promotionReward.setPromotion(arguments.promotion);
			}
			promotionReward = savePromotionReward(promotionReward,promotionRewardData);
		}
	}
	
	public any function savePromotionReward(required any promotionReward, required struct data){
		arguments.promotionReward.populate(arguments.data);
		validatePromotionReward(arguments.promotionReward);
		arguments.promotionReward = super.save(arguments.promotionReward);
		return arguments.promotionReward;
	}
	
	public void function validatePromotionReward( required any promotionReward ) {
		var reward = arguments.promotionReward.getItemRewardQuantity() & arguments.promotionReward.getItemPercentageOff() & arguments.promotionReward.getItemAmountOff() & arguments.promotionReward.getItemAmount();
		if(trim(reward) EQ ""){
			getValidationService().setError(entity=arguments.promotionReward,errorName="Reward",rule="required");
		}
	}

	public any function deletePromotionReward(required any promotionReward) {
		//TODO: are we assigning the reward anywhere or is it save to delete it anytime
		/*if(arguments.promotionReward.isAssigned() == true) {
			getValidationService().setError(entity=arguments.promotionReward,errorname="delete",rule="isAssigned");	
		}*/
		if(!arguments.promotionReward.hasErrors()) {
			arguments.promotionReward.removePromotion(arguments.promotionReward.getPromotion());
		}
		var deleted = Super.delete(arguments.promotionReward);
		return deleted;
	}
	
}
