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
component displayname="Attribute Value" entityname="SlatwallAttributeValue" table="SlatwallAttributeValue" persistent="true" output="false" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="attributeValueID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="attributeValue" ormtype="string" length="4000";
	
	// Related Object Properties (many-to-one)
	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID" lazy="false" fetch="join";  // Lazy is turned off because any time we get an attributeValue we also want the attribute
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	
	// Quick Lookup Properties
	property name="attributeID" length="32" insert="false" update="false";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Attribute (many-to-one)
	public void function setAttribute(required any attribute) {
		variables.attribute = arguments.attribute;
		if(isNew() or !arguments.attribute.hasAttributeValue( this )) {
			arrayAppend(arguments.attribute.getAttributeValues(), this);
		}
	}
	public void function removeAttribute(any attribute) {
		if(!structKeyExists(arguments, "attribute")) {
			arguments.attribute = variables.attribute;
		}
		var index = arrayFind(arguments.attribute.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.attribute.getAttributeValues(), index);
		}
		structDelete(variables, "attribute");
	}
	
	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasAttributeValue( this )) {
			arrayAppend(arguments.account.getAttributeValues(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getAttributeValues(), index);
		}
		structDelete(variables, "account");
	}
	
	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasAttributeValue( this )) {
			arrayAppend(arguments.orderItem.getAttributeValues(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getAttributeValues(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasAttributeValue( this )) {
			arrayAppend(arguments.product.getAttributeValues(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getAttributeValues(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getAttributeValues(), index);
		}
		structDelete(variables, "product");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  ========================= 
}
