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

component accessors="true" output="false" displayname="FedEx" implements="Slatwall.shippingServices.ShippingInterface" {

	// Custom Properties that need to be set by the end user
	property name="accountNo" displayname="FedEx Account Number" type="string";
	property name="password" displayname="FedEx Password" type="string";
	property name="transactionKey" displayname="FedEx Transaction Key" type="string";
	property name="meterNo" displayname="FedEx Meter Number" type="string";
	property name="sandbox" displayname="Use Sandbox?" type="boolean" default="false";
	
	// Variables Saved in this application scope, but not set by end user
	variables.fedExRatesV7 = "";

	public any function init() {
		// Insert Custom Logic Here 
		variables.fedExRatesV7 = new FedexRates_v7();
		variables.shippingMethods = {
			FIRST_OVERNIGHT="First Overnight",
			PRIORITY_OVERNIGHT="Priority Overnight",
			STANDARD_OVERNIGHT="Standard Overnight",
			FEDEX_2_DAY="2 Day",
			FEDEX_EXPRESS_SAVER="Express Saver",
			FEDEX_GROUND="Ground",
			INTERNATIONAL_ECONOMY="International Economy",
			INTERNATIONAL_PRIORITY="International Priority"
		};
		return this;
	}
	
	public Slatwall.com.utility.shipping.RatesResponseBean function getRates(required any orderShipping) {
		var ratesResponseBean = new com.utility.shipping.RatesResponseBean();
		
		// Insert Custom Logic Here
		
		return ratesResponseBean;
	}
	
	public Slatwall.com.utility.shipping.TrackingResponseBean function getTracking(required string trackingNumber) {
		var trackingResponseBean = new com.utility.shipping.TrackingResponseBean();
		
		// Insert Custom Logic Here
		
		return trackingResponseBean;
	}
	
	public Slatwall.com.utility.shipping.ShipmentResponseBean function createShipment(required any orderShipment) {
		var shipmentResponseBean = new com.utility.shipping.ShipmentResponseBean();
		
		// Insert Custom Logic Here
		
		return shipmentResponseBean;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
}
