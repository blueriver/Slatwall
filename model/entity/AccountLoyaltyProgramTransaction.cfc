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
component displayname="AccountLoyaltyProgramTransaction" entityname="SlatwallAccountLoyaltyProgramTransaction" table="SlatwallAccountLoyaltyProgramTransaction" persistent="true"  extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountLoyaltyProgramTransaction" {
	
	// Persistent Properties
	property name="accountLoyaltyProgramTransactionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="accruementType" ormType="string";
	property name="redemptionType" ormType="string";
	property name="pointsIn" ormType="integer";
	property name="pointsOut" ormType="integer";		
	property name="expirationDateTime" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="accountLoyaltyProgram" cfc="AccountLoyaltyProgram" fieldtype="many-to-one" fkcolumn="accountLoyaltyProgramID";
	property name="loyaltyProgramAccruement" cfc="LoyaltyProgramAccruement" fieldtype="many-to-one" fkcolumn="loyaltyProgramAccruementID";
	//property name="loyaltyProgramRedemption" cfc="LoyaltyProgramRedemption" fieldtype="many-to-one" fkcolumn="loyaltyProgramRedemptionID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAccruementTypeOptions() {
		return [
			{name=rbKey('entity.accountLoyaltyProgramAccruement.accruementType.itemFulfilled'), value="itemFulfilled"},
			{name=rbKey('entity.accountLoyaltyProgramAccruement.accruementType.orderClosed'), value="orderClosed"},
			{name=rbKey('entity.accountLoyaltyProgramAccruement.accruementType.fulfillmentMethodUsed'), value="fulfillmentMethodUsed"},
			{name=rbKey('entity.accountLoyaltyProgramAccruement.accruementType.enrollment'), value="enrollment"}
		];
	}
	
	public array function getRedemptionTypeOptions() {
		return [
			{name=rbKey('entity.accountLoyaltyProgramAccruement.redemptionType.productPurchase'), value="productPurchase"},
			{name=rbKey('entity.accountLoyaltyProgramAccruement.redemptionType.cashCouponCreation'), value="cashCouponCreation"},
			{name=rbKey('entity.accountLoyaltyProgramAccruement.redemptionType.priceGroupAssignment'), value="priceGroupAssignment"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// accountLoyaltyProgram (many-to-one)
	public void function setAccountLoyaltyProgram(required any accountLoyaltyProgram) {
		variables.accountLoyaltyProgram = arguments.accountLoyaltyProgram;
		if(isNew() or !arguments.accountLoyaltyProgram.hasAccountLoyaltyProgramTransaction( this )) {
			arrayAppend(arguments.accountLoyaltyProgram.getAccountLoyaltyProgramTransactions(), this);
		}
	}
	public void function removeAccountLoyaltyProgram(any accountLoyaltyProgram) {
	   if(!structKeyExists(arguments, "accountLoyaltyProgram")) {
	   		arguments.accountLoyaltyProgram = variables.accountLoyaltyProgram;
	   }
       var index = arrayFind(arguments.accountLoyaltyProgram.getAccountLoyaltyProgramTransactions(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.accountLoyaltyProgram.getAccountLoyaltyProgramTransactions(), index);
       }
       structDelete(variables,"accountLoyaltyProgram");
    }
    
    // loyaltyProgramAccruement (many-to-one)
	/*public void function setLoyaltyProgramAccruement(required any loyaltyProgramAccruement) {
		variables.loyaltyProgramAccruement = arguments.loyaltyProgramAccruement;
		if(isNew() or !arguments.loyaltyProgramAccruement.hasAccountLoyaltyProgramTransaction( this )) {
			arrayAppend(arguments.loyaltyProgramAccruement.getAccountLoyaltyProgramTransactions(), this);
		}
	}
	public void function removeLoyaltyProgramAccruement(any loyaltyProgramAccruement) {
	   if(!structKeyExists(arguments, "loyaltyProgramAccruement")) {
	   		arguments.loyaltyProgramAccruement = variables.loyaltyProgramAccruement;
	   }
       var index = arrayFind(arguments.loyaltyProgramAccruement.getAccountLoyaltyProgramTransactions(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.loyaltyProgramAccruement.getAccountLoyaltyProgramTransactions(), index);
       }
       structDelete(variables,"loyaltyProgramAccruement");
    }*/
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}