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
component displayname="Vendor Order Receiver" entityname="SlatwallVendorOrderReceiver" table="SlatwallVendorOrderReceiver" persistent="true" accessors="true" output="false" extends="BaseEntity" discriminatorcolumn="fulfillmentMethodID" {
	
	// Persistent Properties
	property name="vendorOrderReceiverID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="vendorOrderReceiverType" cfc="Type" fieldtype="many-to-one" fkcolumn="vendorOrderReceiverTypeID";
	property name="boxCount"  ormtype="integer";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	property name="vendorOrderReceiverItems" singularname="vendorOrderReceiverItem" cfc="VendorOrderReceiverItem" fieldtype="one-to-many" fkcolumn="vendorOrderReceiverID" cascade="all-delete-orphan" inverse="true";
	
	public VendorOrderReceiver function init(){
	   // set default collections for association management methods
	   if(isNull(variables.vendorOrderReceiverItems)) {
	       variables.vendorOrderReceiverItems = [];
	   }    
	   
		// Set the default order type as purchase order
		if(isNull(variables.vendorOrderReceiverType)) {
			variables.vendorOrderReceiverType = getService("typeService").getTypeBySystemCode('vortPurchaseOrder');
		}
		
	   return Super.init();
	}
	
	/*public any function getTotalQuanityDelivered() {
		var totalDelivered = 0;
		for(var i=1; i<=arrayLen(getVendorOrderReceiverItems()); i++) {
			totalDelivered += getVendorOrderReceiverItems()[i].getQuantityDelivered();
		}
		return totalDelivered;
	}*/
   
    /******* Association management methods for bidirectional relationships **************/
	
	// Order (many-to-one)
	
	public void function setVendorOrder(required any VendorOrder) {
	   variables.vendorOrder = arguments.VendorOrder;
	   if(!arguments.VendorOrder.hasVendorOrderReceiver(this)) {
	       arrayAppend(arguments.vendorOrder.getVendorOrderReceivers(), this);
	   }
	}
	
	public void function removeVendorOrder(required any VendorOrder) {
       var index = arrayFind(arguments.vendorOrder.getVendorOrderReceivers(), this);
       if(index > 0) {
           arrayDeleteAt(arguments.VendorOrder.getVendorOrderReceivers(), index);
       }    
       structDelete(variables, "vendorOrder");
    }
    
	
	// VendorOrderReceiverItems (one-to-many)
	
	public void function addVendorOrderReceiverItem(required VendorOrderReceiverItem vendorOrderReceiverItem) {
	   arguments.vendorOrderReceiverItem.setVendorOrderReceiver(this);
	}
	
	public void function removeVendorOrderReceiverItem(required VendorOrderReceiverItem VendorOrderReceiverItem) {
	   arguments.vendorOrderReceiverItem.removeVendorOrderReceiver(this);
	}
    /************   END Association Management Methods   *******************/
}
