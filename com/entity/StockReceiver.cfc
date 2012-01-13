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
component displayname="Stock Receiver" entityname="SlatwallStockReceiver" table="SlatwallStockReceiver" persistent=true accessors=true output=false extends="BaseEntity" discriminatorcolumn="receiverType"  {
	
	
	// Persistent Properties
	property name="stockReceiverID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="packingSlipNumber" ormtype="string";
	property name="boxCount" ormtype="integer";
	
	// Related Object Properties (one-to-many)
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" fieldtype="one-to-many" fkcolumn="stockReceiverID" cascade="all-delete-orphan" inverse="true";
		
	// Discriminator (values: vendorOrder, order, stockAdjustment)
	property name="receiverType" insert="false" update="false";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
		
	public any function init(){
	   // set default collections for association management methods
	   if(isNull(variables.stockReceiverItems)) {
	       variables.stockReceiverItems = [];
	   }    

	   return Super.init();
	}
	
	// Not actually required for TPC implemention. Just providing type tracking for new entities.
	public void function setReceiverType(required string type) {
		var listAllowableTypes = "vendorOrder,order,stockAdjustment";
		
		if(ListFind(listAllowableTypes, arguments.type) == 0) {
			throw("The type (#arguments.type#) is not allowed! The allowed StockReceiver types are: #listAllowedTypes#");
		} else {
			variables.receiverType = arguments.type;
		}
	}
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Stock Receiver Items (one-to-many)
	public void function addStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.setStockReceiver( this );
	}
	public void function removeStockReceiverItem(required any stockReceiverItem) {
		arguments.stockReceiverItem.removeStockReceiver( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}