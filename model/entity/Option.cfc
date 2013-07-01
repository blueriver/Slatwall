/*

    Slatwall - An Open Source eCommerce Platform
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
component displayname="Option" entityname="SlatwallOption" table="SwOption" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="optionService" hb_permission="optionGroup.options" {
	
	// Persistent Properties
	property name="optionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionCode" ormtype="string";
	property name="optionName" ormtype="string";
	property name="optionDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="sortOrder" ormtype="integer" sortContext="optionGroup";
	
	// Related Object Properties (many-to-one)
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";
	property name="defaultImage" cfc="Image" fieldtype="many-to-one" fkcolumn="defaultImageID";
	
	// Related Object Properties (one-to-many)
	property name="images" singularname="image" cfc="Image" type="array" fieldtype="one-to-many" fkcolumn="optionID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwSkuOption" fkcolumn="optionID" inversejoincolumn="skuID" inverse="true"; 
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SwPromoRewardOption" fkcolumn="optionID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionRewardExclusions" singularname="promotionRewardExclusion" cfc="PromotionReward" type="array" fieldtype="many-to-many" linktable="SwPromoRewardExclOption" fkcolumn="optionID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-many" linktable="SwPromoQualOption" fkcolumn="optionID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="promotionQualifierExclusions" singularname="promotionQualifierExclusion" cfc="PromotionQualifier" type="array" fieldtype="many-to-many" linktable="SwPromoQualExclOption" fkcolumn="optionID" inversejoincolumn="promotionQualifierID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	   
    public string function getImageDirectory() {
    	return getURLFromPath(setting('globalAssetsImageFolderPath')) & '/option/';
    }
    
    // ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Option Group (many-to-one)
	public void function setOptionGroup(required any optionGroup) {
		variables.optionGroup = arguments.optionGroup;
		if(isNew() or !arguments.optionGroup.hasOption( this )) {
			arrayAppend(arguments.optionGroup.getOptions(), this);
		}
	}
	public void function removeOptionGroup(any optionGroup) {
		if(!structKeyExists(arguments, "optionGroup")) {
			arguments.optionGroup = variables.optionGroup;
		}
		var index = arrayFind(arguments.optionGroup.getOptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.optionGroup.getOptions(), index);
		}
		structDelete(variables, "optionGroup");
	}
	
	// Skus (many-to-many - inverse)
	public void function addSku(required any sku) {
		arguments.sku.addOption( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeOption( this );
	}
	
	// Promotion Rewards (many-to-many - inverse)
	public void function addPromotionReward(required any promotionReward) {
		arguments.promotionReward.addOption( this );
	}
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removeOption( this );
	}
	
	// Promotion Reward Exclusions (many-to-many - inverse)    
	public void function addPromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.addExcludedOption( this );    
	}
	public void function removePromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.addExcludedOption( this );    
	}
	
	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addOption( this );
	}
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeOption( this );
	}	
	
	// Promotion Qualifier Exclusions (many-to-many - inverse)    
	public void function addPromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.addExcludedOption( this );    
	}
	public void function removePromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.addExcludedOption( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================

}
