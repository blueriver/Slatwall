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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="order";

	// Data Properties
	property name="accountPaymentMethodID" hb_rbKey="entity.accountPaymentMethod" hb_formFieldType="select";
	property name="newOrderPayment" cfc="OrderPayment" fieldType="many-to-one" persistent="false" fkcolumn="orderPaymentID";
	property name="accountAddressID" hb_rbKey="entity.accountAddress" hb_formFieldType="select";
	property name="saveAccountPaymentMethodFlag" hb_formFieldType="yesno";
	property name="saveAccountPaymentMethodName" hb_rbKey="entity.accountPaymentMethod.accountPaymentMethodName";
	
	// Cached Properties
	property name="accountPaymentMethodIDOptions";
	property name="paymentMethodIDOptions";
	property name="accountAddressIDOptions";
	
	public any function setupDefaults() {
		variables.accountAddressID = getAccountAddressIDOptions()[1]['value'];
		variables.accountPaymentMethodID = getAccountPaymentMethodIDOptions()[1]['value'];
	}
	
	public string function getAccountPaymentMethodID() {
		if(!structKeyExists(variables, "accountPaymentMethodID")) {
			variables.accountPaymentMethodID = "";
		}
		return variables.accountPaymentMethodID;
	}
	
	public array function getAccountPaymentMethodIDOptions() {
		if(!structKeyExists(variables, "accountPaymentMethodIDOptions")) {
			variables.accountPaymentMethodIDOptions = [];
			var pmArr = getOrder().getAccount().getAccountPaymentMethods();
			for(var i=1; i<=arrayLen(pmArr); i++) {
				if(!isNull(pmArr[i].getActiveFlag()) && pmArr[i].getActiveFlag()) {
					arrayAppend(variables.accountPaymentMethodIDOptions, {name=pmArr[i].getSimpleRepresentation(), value=pmArr[i].getAccountPaymentMethodID()});	
				}
			}
			arrayAppend(variables.accountPaymentMethodIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountPaymentMethodIDOptions;
	}
	
	public string function getAccountAddressID() {
		if(!structKeyExists(variables, "accountAddressID")) {
			variables.accountAddressID = "";
		}
		return variables.accountAddressID;
	}
	
	public array function getAccountAddressIDOptions() {
		if(!structKeyExists(variables, "accountAddressIDOptions")) {
			variables.accountAddressIDOptions = [];
			var aaArr = getOrder().getAccount().getAccountAddresses();
			for(var i=1; i<=arrayLen(aaArr); i++) {
				arrayAppend(variables.accountAddressIDOptions, {name=aaArr[i].getSimpleRepresentation(), value=aaArr[i].getAccountAddressID()});
			}
			arrayAppend(variables.accountAddressIDOptions, {name=rbKey('define.new'), value=""});
		}
		return variables.accountAddressIDOptions;
	}
	
	public any function getNewOrderPayment() {
		if(!structKeyExists(variables, "newOrderPayment")) {
			variables.newOrderPayment = getService("orderService").newOrderPayment();
		}
		return variables.newOrderPayment;
	}
	
	public boolean function getSaveAccountPaymentMethodFlag() {
		if(!structKeyExists(variables, "saveAccountPaymentMethodFlag")) {
			variables.saveAccountPaymentMethodFlag = 0;
		}
		return variables.saveAccountPaymentMethodFlag;
	}
	
}