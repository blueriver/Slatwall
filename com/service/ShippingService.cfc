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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	property name="settingService" type="any";

	public any function saveShippingMethod(required any entity, struct data) {
		if( structKeyExists(arguments, "data") && structKeyExists(arguments.data,"shippingRates") ) {
			for(var i=1; i<=arrayLen(arguments.data.shippingRates); i++) {	
				if( len(arguments.data.shippingRates[i].shippingRateID) > 0 ) {
					var rate = this.getShippingRate(arguments.data.shippingRates[i].shippingRateID);
					rate.populate(data=arguments.data.shippingRates[i]);
		         } else {
		         	var rate = this.newShippingRate();
		         	rate.populate(data=arguments.data.shippingRates[i]);
		         	arguments.entity.addShippingRate(rate);
		         }
			}
		}
		return save(argumentcollection=arguments);
	}
	
	public array function populateOrderShippingMethodOptions(required any orderShipping) {
		var shippingMethods = getDAO().list(entityName="SlatwallShippingMethod");
		var shippingProviders = [];
		var providerRateResponseBeans = [];
		var methodOptions = [];
		
		// Loop over all methods and organize them by provider
		for(var i=1; i<=arrayLen(shippingMethods); i++) {
			if(!arrayFind(shippingProviders, shippingMethods[i].getShippingProvider())) {
				arrayAppend(shippingProviders, shippingMethods[i].getShippingProvider());
			}
		}
		
		// Loop over Shipping Providers
		for(var p=1; p<=arrayLen(shippingProviders); p++) {
			
			// Get Provider Service
			var providerService = getSettingService().getByShippingServicePackage(shippingProviders[p]);
			
			// Query the Provider For Rates
			var ratesResponseBean = providerService.getRates(arguments.orderShipping);
			
			// Loop Over Shipping Methods
			for(var m=1; m<=arrayLen(shippingMethods); m++) {
				
				// Check the method to see if it is from this provider
				if(shippingProviders[p] == shippingMethods[m].getShippingProvider()) {
					
					// Loop over the rates return by the provider to match with a shipping method
					for(var r=1; r<=arrayLen(ratesResponseBean.getMethodRateResponseBeans()); r++) {
						if(ratesResponseBean.getMethodRateResponseBeans()[r].getShippingProviderMethod() == shippingMethods[m].getShippingProviderMethod()) {
							var option = this.newOrderShippingMethodOption();
							option.setShippingMethod(shippingMethods[m]);
							option.setTotalCost(ratesResponseBean.getMethodRateResponseBeans()[r].getTotalCost());
							option.setEstimatedArrivalDate(ratesResponseBean.getMethodRateResponseBeans()[r].getEstimatedArrivalDate());
							option.setOrderShipping(arguments.orderShipping);
							getDAO().save(option);
						}
					}
				}
			}
		}
		
		return methodOptions;
	}
}