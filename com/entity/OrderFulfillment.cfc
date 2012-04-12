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
component displayname="Order Fulfillment" entityname="SlatwallOrderFulfillment" table="SlatwallOrderFulfillment" persistent=true accessors=true output=false extends="BaseEntity" {
	
	// Persistent Properties
	property name="orderFulfillmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="fulfillmentCharge" ormtype="big_decimal" default=0;
	
	// Related Object Properties (many-to-one)
	property name="accountAddress" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="accountAddressID";
	property name="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-one" fkcolumn="fulfillmentMethodID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="shippingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	
	// Related Object Properties (one-to-many)
	property name="orderFulfillmentItems" singularname="orderFulfillmentItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all" inverse="true";
	property name="appliedPromotions" singularname="appliedPromotion" cfc="OrderFulfillmentAppliedPromotion" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";
	property name="fulfillmentShippingMethodOptions" singularname="fulfillmentShippingMethodOption" cfc="ShippingMethodOption" fieldtype="one-to-many" fkcolumn="orderFulfillmentID" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="subTotal" type="numeric" persistent="false";
	property name="taxAmount" type="numeric" persistent="false";
	property name="totalShippingWeight" type="numeric" persistent="false";
	property name="shippingMethodOptions" type="array" persistent="false";
	property name="accountAddressOptions" type="array" persistent="false";
	
	public any function init() {
		if(isNull(variables.orderFulfillmentItems)) {
			variables.orderFulfillmentItems = [];
		}
		if(isNull(variables.orderShippingMethodOptions)) {
			variables.orderShippingMethodOptions = [];
		}
		
		return super.init();
	}
	
	public any function getFulfillmentMethodType() {
		return getFulfillmentMethod().getFulfillmentMethodType();
	}
	
	public void function removeAccountAddress() {
		structDelete(variables, "AccountAddress");
	}

	public void function removeShippingAddress() {
		structDelete(variables, "ShippingAddress");
	}
	
	public boolean function isProcessable() {
		
		// Check to make sure that there are more than 0 items in this fulfillment
		if(!arrayLen(getOrderFulfillmentItems())) {
			return false;
		}
		
		// If this fulfillmentMethodType is shipping, there are a handful of other things we need to check
		if(getFulfillmentMethodType() eq "shipping") {
			if(isNull(getAddress())) {
				return false;
			} else {
				getAddress().validate(context="full");
				if(getAddress().hasErrors()) {
					return false;
				}
			}
			
			if(isNull(getShippingMethod())) {
				return false;
			}
			
			if(!getService("shippingService").verifyShippingMethodRate( this )) {
				return false;
			}
		}
		
		return true;
	}
	
	
	public numeric function getDiscountAmount() {
    	return 0;
    }
    
	public numeric function getDiscountTotal() {
		return getDiscountAmount() + getItemDiscountAmountTotal();
	}
    
	public numeric function getShippingCharge() {
		return getFulfillmentCharge();
	}
	
	
	// Helper method to return either the shippingAddress or accountAddress to be used
    public any function getAddress(){
    	if(!isNull(getShippingAddress())){
    		return getShippingAddress();
    	} else if(!isNull(getAccountAddress())) {
    		return getAccountAddress().getAddress();
    	} else {
    		return ;
    	}
    }

	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getSubTotal() {
  		if( !structKeyExists(variables,"subTotal") ) {
	    	variables.subTotal = 0;
	    	var items = getOrderFulfillmentItems();
	    	for( var i=1; i<=arrayLen(items); i++ ) {
	    		variables.subTotal += items[i].getExtendedPrice();
	    	}			
  		}
    	return variables.subTotal;
    }
    
    public numeric function getTaxAmount() {
    	if( !structkeyExists(variables, "taxAmount") ) {
    		variables.taxAmount = 0;
	    	var items = getOrderFulfillmentItems();
	    	for( var i=1; i<=arrayLen(items); i++ ) {
	    		variables.taxAmount += items[i].getTaxAmount();
	    	}
    	}
    	return variables.taxAmount;
    }
    
    
   	public numeric function getItemDiscountAmountTotal() {
   		if(!structKeyExists(variables, "itemDiscountAmountTotal")) {
   			variables.itemDiscountAmountTotal = 0;
   			for(var i=1; i<=arrayLen(getOrderFulfillmentItems()); i++) {
				variables.itemDiscountAmountTotal += getOrderFulfillmentItems()[i].getDiscountAmount();
			}
   		}
		return variables.itemDiscountAmountTotal;
	}
    
    public numeric function getQuantityUndelivered() {
    	if(!structKeyExists(variables,"quantityUndelivered")) {
    		variables.quantityUndelivered = 0;
    		var items = getOrderFulfillmentItems();
    		for(var i=1; i<=arrayLen(items);i++) {
    			variables.quantityUndelivered += items[i].getQuantityUndelivered();
    		}
    	}
    	return variables.quantityUndelivered;
    }
    
    public any function getShippingMethodOptions() {
    	if( !structKeyExists(variables, "shippingMethodOptions")) {
    		// Set the options to a new array
    		variables.shippingMethodOptions = [];
    		
    		// If there aren't any shippingMethodOptions available, then try to populate this fulfillment
    		if( !arrayLen(variables.orderShippingMethodOptions) ) {
    			getService("shippingService").updateOrderShippingMethodOptions( this );
    		}
    		
    		// At this point they have either been populated just before, or there were already options
    		if( arrayLen(variables.orderShippingMethodOptions) ) {
    			variables.shippingMethodOptions = [];	
    		}
    	}
    	return variables.shippingMethodOptions; 
    }
    
    public any function getAccountAddressOptions() {
    	if( !structKeyExists(variables, "accountAddressOptions")) {
    		var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallAccountAddress");
			smartList.addSelect(propertyIdentifier="accountAddressName", alias="name");
			smartList.addSelect(propertyIdentifier="accountAddressID", alias="value"); 
			smartList.addFilter(propertyIdentifier="account_accountID",value=this.getOrder().getAccount().getAccountID(),fetch="false");
			smartList.addOrder("accountAddressName|ASC");
			variables.accountAddressOptions = smartList.getRecords();
		}
		return variables.accountAddressOptions;
	}
	
	public numeric function getTotalShippingWeight() {
    	if( !structKeyExists(variables, "totalShippingWeight") ) {
	    	variables.totalShippingWeight = 0;
	    	var items = getOrderFulfillmentItems();
	    	for( var i=1; i<=arrayLen(items); i++ ) {
	    		var convertedWeight = getService("measurementUnitService").convertWeightToGlobalWeightUnit(items[i].getSku().setting('skuShippingWeight'), items[i].getSku().setting('skuShippingWeightUnitCode'));
	    		variables.totalShippingWeight += (convertedWeight * items[i].getQuantity());
	    	}			
  		}
    	return variables.totalShippingWeight;
    }
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}