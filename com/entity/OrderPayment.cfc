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
component displayname="Order Payment" entityname="SlatwallOrderPayment" table="SlatwallOrderPayment" persistent="true" output="false" accessors="true" extends="BaseEntity" discriminatorcolumn="paymentMethodID" {
	
	// Persistent Properties
	property name="orderPaymentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormtype="big_decimal" notnull="true";
	
	// Related Object Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	
	// Special Related Discriminator Property
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID" length="32" insert="false" update="false";
	property name="paymentMethodID" length="255" insert="false" update="false";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	public any function init() {
		if(isNull(variables.amount)) {
			variables.amount = 0;
		}
		return super.init();
	}
	
	// Helper method that gets overriden by payment method-specific orderpayment entities
	public numeric function getAmountReceived() {
		return getAmount();
	}
	
	public numeric function getAmountAuthorized() {
		return getAmount();
	}
	
    /******* Association management methods for bidirectional relationships **************/
	

	// Order (many-to-one)
	
	public void function setOrder(required Order Order) {
	   variables.Order = arguments.order;
	   if(!arguments.order.hasOrderPayment(this)) {
	       arrayAppend(arguments.order.getOrderPayments(),this);
	   }
	}
	
	public void function removeOrder(required Order Order) {
       var index = arrayFind(arguments.order.getOrderPayments(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.order.getOrderPayments(),index);
       }    
       structDelete(variables,"order");
    }
	
    /************   END Association Management Methods   *******************/
	
}
