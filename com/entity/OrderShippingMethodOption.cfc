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
component displayname="Order Shipping Method Option" entityname="SlatwallOrderShippingMethodOption" table="SlatwallOrderShippingMethodOption" persistent=true accessors=true output=false extends="BaseEntity" {

	property name="orderShippingMethodOptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="totalCost" ormtype="float";
	property name="estimatedArrivalDate" ormtype="date";
	
	property name="orderShipping" cfc="OrderShipping" fieldtype="many-to-one" fkcolumn="orderShippingID";
	property name="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-one" fkcolumn="shippingMethodID";
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Order Shipping (many-to-one)
	public void function setOrderShipping(required OrderShipping orderShipping) {
		variables.orderShipping = arguments.orderShipping;
		if(isNew() || !arguments.orderShipping.hasOrderShippingMethodOption(this)) {
			arrayAppend(arguments.orderShipping.getOrderShippingMethodOptions(),this);
		}
	}
	
	public void function removeOrderShipping(OrderShipping orderShipping) {
	   if(!structKeyExists(arguments,"orderShipping")) {
	   		arguments.orderShipping = variables.orderShipping;
	   }
       var index = arrayFind(arguments.order.getOrderShippingMethodOptions(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.order.getOrderShippingMethodOptions(), index);
       }
       structDelete(variables,"orderShipping");
    }
    
    /******* END Association management methods */ 
	
}