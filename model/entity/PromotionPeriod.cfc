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
component displayname="Promotion Period" entityname="SlatwallPromotionPeriod" table="SlatwallPromotionPeriod" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="promotion.promotionPeriods" {
	
	// Persistent Properties
	property name="promotionPeriodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="startDateTime" ormtype="timestamp";
	property name="endDateTime" ormtype="timestamp";
	property name="maximumUseCount" ormtype="integer" notnull="false" hb_formatType="custom";
	property name="maximumAccountUseCount" ormtype="integer" notnull="false" hb_formatType="custom";
	
	// Related Object Properties (many-to-one)
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	
	// Related Object Properties (one-to-many)   
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="one-to-many" fkcolumn="promotionPeriodID" cascade="all-delete-orphan" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="one-to-many" fkcolumn="promotionPeriodID" cascade="all-delete-orphan" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
 	// Non-persistent properties
	property name="currentFlag" type="boolean" persistent="false"; 
 
 
 	public boolean function isCurrent() {
		var currentDateTime = now();
		return getStartDateTime() <= currentDateTime && getEndDateTime() > currentDateTime;
	}
	
	public boolean function isExpired() {
		return isDate(getEndDateTime()) && getEndDateTime() < now();
	}
	
	public boolean function isDeletable () {
		return !isExpired() && getPromotion().isDeletable();
	}
	
	public string function getSimpleRepresentation() {
		return getPromotion().getPromotionName();
	}

	public any function getMaximumUseCountFormatted() {
		if(isNull(getMaximumUseCount()) || !isNumeric(getMaximumUseCount()) || getMaximumUseCount() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumUseCount();
	}
	
	public any function getMaximumAccountUseCountFormatted() {
		if(isNull(getMaximumAccountUseCount()) || !isNumeric(getMaximumAccountUseCount()) || getMaximumAccountUseCount() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumAccountUseCount();
	}

	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion (many-to-one)    
	public void function setPromotion(required any promotion) {    
		variables.promotion = arguments.promotion;    
		if(isNew() or !arguments.promotion.hasPromotionPeriod( this )) {    
			arrayAppend(arguments.promotion.getPromotionPeriods(), this);    
		}    
	}    
	public void function removePromotion(any promotion) {    
		if(!structKeyExists(arguments, "promotion")) {    
			arguments.promotion = variables.promotion;    
		}    
		var index = arrayFind(arguments.promotion.getPromotionPeriods(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.account.getPromotionPeriods(), index);    
		}    
		structDelete(variables, "promotion");    
	}
	
	// Promotion Rewards (one-to-many)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.setPromotion(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removePromotion(this);
	}
	
	// Promotion Qualifiers (one-to-many)    
	public void function addPromotionQualifier(required any promotionQualifier) {    
		arguments.promotionQualifier.setPromotion( this );    
	}    
	public void function removePromotionQualifier(required any promotionQualifier) {    
		arguments.PromotionQualifier.removePromotion( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	
	// ============ START: Non-Persistent Property Methods =================
	
	public boolean function getCurrentFlag() {
		if(!structKeyExists(variables, "currentFlag")) {
			variables.currentFlag = true;
			if( ( !isNull(getStartDateTime()) && getStartDateTime() > now() ) || ( !isNull(getEndDateTime()) && getEndDateTime() < now() ) ) {
				variables.currentFlag = false;
			}	
		}
		
		return variables.currentFlag;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	
}