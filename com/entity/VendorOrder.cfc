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
component displayname="Vendor VendorOrder" entityname="SlatwallVendorOrder" table="SlatwallVendorOrder" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="vendorOrderID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="vendorOrderNumber" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties (Many-To-One)
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="vendorOrderType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorOrderTypeID";
	
	// Related Object Properties (One-To-Many)
	property name="vendorOrderItems" singularname="vendorOrderItem" cfc="VendorOrderItem" fieldtype="one-to-many" fkcolumn="vendorOrderItemID" inverse="true" cascade="all-delete-orphan";
	property name="vendorOrderDeliveries" singularname="vendorOrderDelivery" cfc="VendorOrderDelivery" fieldtype="one-to-many" inverse="true"  cascade="all-delete-orphan"; 
	
	// Non persistent properties
	property name="total" persistent="false" formatType="currency"; 
	property name="subTotal" persistent="false" formatType="currency"; 
	property name="taxTotal" persistent="false" formatType="currency"; 
	//property name="itemAmountTotal" persistent="false" formatType="currency" ; 
	//property name="fulfillmentAmountTotal" persistent="false" formatType="currency" ; 
	property name="orderAmountTotal" persistent="false" formatType="currency"; 
	property name="fulfillmentTotal" persistent="false" formatType="currency";
	
	public any function init() {
		if(isNull(variables.vendorOrderItems)) {
			variables.vendorOrderItems = [];
		}
		
		if(isNull(variables.vendorOrderDeliveries)) {
			variables.vendorOrderDeliveries = [];
		}
		
		// Set the default order type as purchase order
		if(isNull(variables.vendorOrderType)) {
			variables.vendorOrderType = getService("typeService").getTypeBySystemCode('votPurchaseOrder');
		}
		
		return super.init();
	}
	
	/*public numeric function getTotalItems() {
		return arrayLen(getVendorOrderItems());
	}*/
	
	// TODO: may need to refactor the next 4 methods to more efficient HQL
	/*public numeric function getTotalQuantity() {
		if(!structKeyExists(variables,"totalQuantity")) {
			var vendorOrderItems = getOrderItems();
			variables.totalQuantity = 0;
			for(var i=1; i<=arrayLen(vendorOrderItems); i++) {
				variables.totalQuantity += vendorOrderItems[i].getQuantity(); 
			}			
		}
		return variables.totalQuantity;
	}*/
	
	public numeric function getSubtotal() {
		return 999.99;
		
		var subtotal = 0;
		for(var i=1; i<=arrayLen(getVendorOrderItems()); i++) {
			subtotal += getVendorOrderItems()[i].getExtendedPrice();
		}
		return subtotal;
	}
	
	public numeric function getTaxTotal() {
		return 999.99;
		
		var taxTotal = 0;
		for(var i=1; i<=arrayLen(getVendorOrderItems()); i++) {
			taxTotal += getVendorOrderItems()[i].getTaxAmount();
		}
		return taxTotal;
	}
	
	public numeric function getItemAmountTotal() {
		return 999.99;
		
		var Total = 0;
		for(var i=1; i<=arrayLen(getVendorOrderItems()); i++) {
			Total += getVendorOrderItems()[i].getAmount();
		}
		return Total;
	}
	
	/*public numeric function getFulfillmentAmountTotal() {
		return 0;
	}
	
	public numeric function getVendorOrderAmountTotal() {
		return 0;
	}*/
	

	/*public numeric function getFulfillmentTotal() {
		var fulfillmentTotal = 0;
		for(var i=1; i<=arrayLen(getVendorOrderFulfillments()); i++) {
			fulfillmentTotal += getVendorOrderFulfillments()[i].getFulfillmentCharge();
		}
		return fulfillmentTotal;
	}*/
	
	public numeric function getTotal() {
		return 999.99;
		//return getSubtotal() + getTaxTotal() + getFulfillmentTotal();
	}
	
	public void function removeAllVendorOrderItems() {
		for(var i=arrayLen(getVendorOrderItems()); i >= 1; i--) {
			getVendorOrderItems()[i].removeVendorOrder(this);
		}
	}
	
	public boolean function isProductInVendorOrder(required any productID) {
		// TODO!
		return false;
	}
}
