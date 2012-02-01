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
component displayname="Comment" entityname="SlatwallComment" table="SlatwallComment" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="commentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="comment" ormtype="string" length="4000";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	//property name="accounts" singularname="account" cfc="Account" type="array" fieldtype="many-to-many" linktable="SlatwallCommentAccount" fkcolumn="commentID" inversejoincolumn="accountID";
	//property name="brands" singularname="brand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SlatwallCommentBrand" fkcolumn="commentID" inversejoincolumn="brandID";
	property name="orders" singularname="order" cfc="Order" type="array" fieldtype="many-to-many" linktable="SlatwallCommentOrder" fkcolumn="commentID" inversejoincolumn="orderID";
	//property name="orderItems" singularname="orderItem" cfc="OrderItem" type="array" fieldtype="many-to-many" linktable="SlatwallCommentOrderItem" fkcolumn="commentID" inversejoincolumn="orderItemID";
	//property name="products" singularname="product" cfc="Product" type="array" fieldtype="many-to-many" linktable="SlatwallCommentProduct" fkcolumn="commentID" inversejoincolumn="productID";
	//property name="stockAdjustments" singularname="stockAdjustment" cfc="StockAdjustment" type="array" fieldtype="many-to-many" linktable="SlatwallCommentStockAdjustment" fkcolumn="commentID" inversejoincolumn="stockAdjustmentID";
	//property name="stockAdjustmentItems" singularname="stockAdjustmentItem" cfc="StockAdjustmentItem" type="array" fieldtype="many-to-many" linktable="SlatwallCommentStockAdjustmentItem" fkcolumn="commentID" inversejoincolumn="stockAdjustmentItemID";
	//property name="stockReceivers" singularname="stockReceiver" cfc="StockReceiver" type="array" fieldtype="many-to-many" linktable="SlatwallCommentStockReceiver" fkcolumn="commentID" inversejoincolumn="stockReceiverID";
	//property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" type="array" fieldtype="many-to-many" linktable="SlatwallCommentStockReceiverItem" fkcolumn="commentID" inversejoincolumn="stockReceiverItemID";
	//property name="vendors" singularname="vendor" cfc="Vendor" type="array" fieldtype="many-to-many" linktable="SlatwallCommentVendor" fkcolumn="commentID" inversejoincolumn="vendorID";
	//property name="vendorOrders" singularname="vendorOrder" cfc="VendorOrder" type="array" fieldtype="many-to-many" linktable="SlatwallCommentVendorOrder" fkcolumn="commentID" inversejoincolumn="vendorOrderID";
	//property name="vendorOrderItems" singularname="vendorOrderItem" cfc="VendorOrderItem" type="array" fieldtype="many-to-many" linktable="SlatwallCommentVendorOrderItem" fkcolumn="commentID" inversejoincolumn="vendorOrderItemID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	
	// Non-Persistent Properties

	public any function init() {
		if(isNull(variables.accounts)) {
			variables.accounts = [];
		}
		if(isNull(variables.brands)) {
			variables.brands = [];
		}
		if(isNull(variables.orders)) {
			variables.orders = [];
		}
		if(isNull(variables.orderItems)) {
			variables.orderItems = [];
		}
		if(isNull(variables.products)) {
			variables.products = [];
		}
		if(isNull(variables.stockAdjustments)) {
			variables.stockAdjustments = [];
		}
		if(isNull(variables.stockAdjustmentItems)) {
			variables.stockAdjustmentItems = [];
		}
		if(isNull(variables.stockReceivers)) {
			variables.stockReceivers = [];
		}
		if(isNull(variables.stockReceiverItems)) {
			variables.stockReceiverItems = [];
		}
		if(isNull(variables.vendors)) {
			variables.vendors = [];
		}
		if(isNull(variables.vendorOrders)) {
			variables.vendorOrders = [];
		}
		if(isNull(variables.vendorOrderItems)) {
			variables.vendorOrderItems = [];
		}
		
		return super.init();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preUpdate(struct oldData) {
		throw("You cannot update a comment because this would display a fundamental flaw in comment management.");
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}