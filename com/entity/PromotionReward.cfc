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
component displayname="Promotion Reward" entityname="SlatwallPromotionReward" table="SlatwallPromotionReward" persistent="true" extends="BaseEntity" discriminatorColumn="rewardType" {
	
	// Persistent Properties
	property name="promotionRewardID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormType="big_decimal";
	property name="amountType" ormType="string" formFieldType="select";
	property name="amountOff" ormType="big_decimal";
	property name="percentageOff" ormType="big_decimal";
	
	// Related Object Properties (many-to-one)
	property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
	
	// Special Related Discriminator Property
	property name="rewardType" length="255" insert="false" update="false";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";

	// Non-persistent entities
	property name="amountTypeOptions" persistent="false";
	property name="rewards" type="string" persistent="false";
		

	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAmountTypeOptions() {
		if(getRewardType() EQ "order") {
			return [
				{name=rbKey("define.amountOff"), value="amountOff"},
				{name=rbKey("define.percentageOff"), value="percentageOff"}
			];
		} else {
			return [
				{name=rbKey("define.amountOff"), value="amountOff"},
				{name=rbKey("define.percentageOff"), value="percentageOff"},
				{name=rbKey("define.fixedAmount"), value="amount"}
			];
		}
	}

	public string function getRewards() {
		if( !structKeyExists( variables,"rewards" ) ) {
			variables.rewards = "";
			if( getRewardType() eq "product" ) {
				var items = "";
				if( arrayLen(getSkus()) ) {
					items = listAppend(items,rbKey('entity.promotionRewardProduct.skus') & ": " & displaySkuCodes());
				}
				if( arrayLen(getProducts()) ) {
					items = listAppend(items,rbKey('entity.promotionRewardProduct.products') & ": " & displayProductNames());
				}
				if( arrayLen(getProductTypes()) ) {
					items = listAppend(items,rbKey('entity.promotionRewardProduct.productTypes') & ": " & displayProductTypeNames());
				}
				if( arrayLen(getBrands()) ) {
					items = listAppend(items,rbKey('entity.promotionRewardProduct.brands') & ": " & displayBrandNames());
				}
				if( arrayLen(getOptions()) ) {
					items = listAppend(items,rbKey('entity.promotionRewardProduct.options') & ": " & displayOptionNames());
				}
				if( len(items) == 0 ) {
					items = rbKey("define.all");
				}
			} else if( getRewardType() == "shipping" ) {
				if( arrayLen(getShippingMethods()) ) {
					items = displayShippingMethodNames();
				} else {
					items = rbKey("define.all");
				}
			} else if( getRewardType() == "order" ) {
				items = rbKey("define.na");
			}
			variables.rewards = items;	
		}
		return variables.rewards;
	}
	
	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion Period (many-to-one)
	public void function setPromotionPeriod(required any promotionPeriod) {
		variables.promotionPeriod = arguments.promotionPeriod;
		if(!arguments.promotionPeriod.hasPromotionReward(this)) {
			arrayAppend(arguments.promotionPeriod.getPromotionRewards(),this);
		}
	}
	public void function removePromotionPeriod(any promotionPeriod) {
	   if(!structKeyExists(arguments, "promotionPeriod")) {
	   		arguments.promotionPeriod = variables.promotionPeriod;
	   }
       var index = arrayFind(arguments.promotionPeriod.getPromotionRewards(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.promotionPeriod.getPromotionRewards(), index);
       }
       structDelete(variables,"promotionPeriod");
    }
    
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "rewards";
	}

	public boolean function isDeletable() {
		return !getPromotionPeriod().isExpired() && getPromotionPeriod().getPromotion().isDeletable();
	}
		
	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}