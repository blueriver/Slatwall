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
component displayname="Subscription Benefit" entityname="SlatwallSubscriptionBenefit" table="SlatwallSubscriptionBenefit" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="subscriptionBenefitID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="subscriptionBenefitName" ormtype="string";
	property name="priceGroupQuantity" ormtype="integer";
	property name="promotionQuantity" ormtype="integer";
	property name="categoryQuantity" ormtype="string";
	property name="contentQuantity" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="accessCodeType" cfc="Type" fieldtype="many-to-one" fkcolumn="accessCodeTypeID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	property name="priceGroups" singularname="priceGroup" cfc="PriceGroup" type="array" fieldtype="many-to-many" linktable="SlatwallSubscriptionBenefitPriceGroup" fkcolumn="subscriptionBenefitID" inversejoincolumn="priceGroupID" cascade="all";
	property name="promotions" singularname="promotion" cfc="Promotion" type="array" fieldtype="many-to-many" linktable="SlatwallSubscriptionBenefitPromotion" fkcolumn="subscriptionBenefitID" inversejoincolumn="promotionID" cascade="all";
	property name="categories" singularname="category" cfc="Category" type="array" fieldtype="many-to-many" linktable="SlatwallSubscriptionBenefitCategory" fkcolumn="subscriptionBenefitID" inversejoincolumn="categoryID" cascade="all";
	property name="content" cfc="Content" type="array" fieldtype="many-to-many" linktable="SlatwallSubscriptionBenefitContent" fkcolumn="subscriptionBenefitID" inversejoincolumn="contentID" cascade="all";
		
	// Remote Properties
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties

	public Promotion function init(){
		// set default collections for association management methods
		if(isNull(variables.priceGroups)){
		   variables.priceGroups = [];
		}
		if(isNull(variables.promotions)){
		   variables.promotions = [];
		}
		return super.init();
	}
	
    public array function getAccessCodeTypeOptions() {
		if(!structKeyExists(variables, "accessCodeTypeOptions")) {
			var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallType");
			smartList.addSelect(propertyIdentifier="type", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType_systemCode", value="subscriptionAccessCodeType");
			smartList.addOrder("type|ASC");
			variables.accessCodeTypeOptions = smartList.getRecords();
			arrayPrepend(variables.accessCodeTypeOptions,{name=rbKey("define.none"),value=""});
		}
		return variables.accessCodeTypeOptions;
    }
    
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}