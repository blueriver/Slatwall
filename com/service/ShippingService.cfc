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
component extends="BaseService" persistent="false" accessors="true" output="false" {

	property name="addressService" type="any";
	property name="integrationService" type="any";

	public void function updateOrderFulfillmentShippingMethodOptions( required any orderFulfillment ) {
		
		// First we check to make sure that the getAddress() is not null
		if(!isNull(arguments.orderFulfillment.getAddress())) {
			
			// Container to hold all shipping integrations that are in all the usable rates
			var shippingIntegrations = [];
			
			// Look up shippingMethods to use based on the fulfillment method
			var smsl = arguments.orderFulfillment.getFulfillmentMethod().getShippingMethodsSmartList();
			smsl.addFilter('activeFlag', '1');
			var shippingMethods = smsl.getRecords();
			
			// Loop over all of the shipping methods & their rates for 
			for(var m=1; m<=arrayLen(shippingMethods); m++) {
				var shippingMethodRates = shippingMethods[m].getShippingMethodRates();
				for(var r=1; r<=arrayLen(shippingMethodRates); r++) {
					
					// check to make sure that this rate applies to the current orderFulfillment
					if(isShippingMethodRateUsable(shippingMethodRates[r], arguments.orderFulfillment.getAddress(), arguments.orderFulfillment.getSubtotal(), arguments.orderFulfillment.getTotalWeight())) {
						// Add any new shipping integrations in any of the rates the the shippingIntegrations array that we are going to query for rates later
						if(!isNull(shippingMethodRates[r].getIntegration()) && !arrayFind(shippingIntegrations, shippingMethodRates[r].getIntegration())) {
							arrayAppend(shippingIntegrations, shippingMethodRates[r].getIntegration());
						}
					}
				}
			}
			
		}
		
		// Loop over all of the shipping
		
	}
	
	public boolean function isShippingMethodRateUsable(required any shippingMethodRate, required any shipToAddress, required any shipmentWeight, required any shipmentItemPrice) {
		// Make sure that the address is in the address zone
		if(!isNull(arguments.shippingMethodRate.getAddressZone()) && !getAddressService().isAddressInZone(arguments.shipToAddress, arguments.shippingMethodRate.getAddressZone())) {
			return false;
		}
		
		// Make sure that the orderFulfillment Item Price is within the min and max of rate
		var lowerPrice = 0;
		var higherPrice = 100000000;
		if(!isNull(arguments.shippingMethodRate.getMinimumShipmentItemPrice())) {
			lowerPrice = arguments.shippingMethodRate.getMinimumShipmentItemPrice();
		}
		if(!isNull(arguments.shippingMethodRate.getMaximumShipmentItemPrice())) {
			higherPrice = arguments.shippingMethodRate.getMaximumShipmentItemPrice();
		}
		if(shipmentItemPrice lt lowerPrice || shipmentItemPrice gt higherPrice) {
			return false;
		}
		
		// Make sure that the orderFulfillment Total Weight is within the min and max of rate
		var lowerWeight = 0;
		var higherWeight = 100000000;
		if(!isNull(arguments.shippingMethodRate.getMinimumShipmentWeight())) {
			lowerWeight = arguments.shippingMethodRate.getMinimumShipmentWeight();
		}
		if(!isNull(arguments.shippingMethodRate.getMaximumShipmentWeight())) {
			higherWeight = arguments.shippingMethodRate.getMaximumShipmentWeight();
		}
		if(shipmentWeight lt lowerWeight || shipmentWeight gt higherWeight) {
			return false;
		}
		
		// If we have not returned false by now, then return true
		return true;
	}
	
}