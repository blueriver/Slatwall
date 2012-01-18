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
component displayname="Shipping Method" entityname="SlatwallShippingMethod" table="SlatwallShippingMethod" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="shippingMethodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="shippingMethodName" ormtype="string";
	property name="shippingProvider" ormtype="string";
	property name="shippingProviderMethod" ormtype="string";
	property name="shippingRateIncreasePercentage" ormtype="big_decimal";
	property name="shippingRateIncreaseDollar" ormtype="big_decimal";
	property name="useRateTableFlag" ormtype="boolean";
	property name="activeFlag" ormtype="boolean";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties (Many-to-One)
	property name="eligibleAddressZone" cfc="AddressZone" fieldtype="many-to-one" fkcolumn="eligibleAddressZoneID";
	
	// Related Object Properties (One-to-Many)
	property name="shippingRates" singularname="shippingRate" cfc="ShippingRate" fieldtype="one-to-many" fkcolumn="shippingMethodID" inverse="true" cascade="all-delete-orphan";
	property name="orderFulfillments" singularname="orderFulfillment" cfc="OrderFulfillmentShipping" fieldtype="one-to-many" fkcolumn="shippingMethodID" inverse="true";
	
	// Related Object Properties (Many-to-Many)
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardShipping" fieldtype="many-to-many" linktable="SlatwallPromotionRewardShippingShippingMethod" fkcolumn="shippingMethodID" inversejoincolumn="promotionRewardID" inverse="true";

	public any function init() {
		if(isNull(variables.activeFlag)) {
			variables.activeFlag = 1;
		}
		if(isNull(variables.shippingRates)) {
			variables.shippingRates = [];
		}
		if(isNull(variables.useRateTableFlag)) {
			variables.useRateTableFlag = false;
		}
		
		return super.init();
	}
	
	public any function getEligibleAddressZoneOptions() {
		if(!structKeyExists(variables, "limitedAddressZoneOptins")) {
			var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallAddressZone");
			smartList.addSelect(propertyIdentifier="addressZoneName", alias="name");
			smartList.addSelect(propertyIdentifier="addressZoneID", alias="value"); 
			smartList.addOrder("addressZoneName|ASC");
			variables.limitedAddressZoneOptins = smartList.getRecords();
			arrayPrepend(variables.limitedAddressZoneOptins, {value="", name=rbKey('define.all')});
		}
		return variables.limitedAddressZoneOptins;
	}
	
	public any function getIntegration() {
		if(!isNull(getShippingProvider()) && getShippingProvider() neq "Other" && getShippingProvider() neq "") {
			return getService("integrationService").getIntegrationByIntegrationPackage( getShippingProvider() );	
		}
	}
	
	public any function getShippingProviderMethodName() {
		var integration = getIntegration();
		
		if(isNull(integration)) {
			return rbKey("admin.order.detail.shippingProvider.ratetable");
		} else {
			return integration.getIntegrationCFC('shipping').getShippingMethods()[ getShippingProviderMethod() ];
		}
	}

	/******* Association management methods for bidirectional relationships **************/
	
	// Shipping Rate (one-to-many)
	
	public void function addShippingRate(required any shippingRate) {    
	   arguments.shippingRate.setShippingMethod(this);    
	}    
	    
	public void function removeShippingRate(required any shippingRate) {    
	   arguments.shippingRate.removeShippingMethod(this);    
	}
	
	// PromotionRewards (many-to-many)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.addShippingMethod(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeShippingMethod(this);
	}
	
	/******* End: Association management methods for bidirectional relationships **************/
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
