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
	
	property name="sessionService" type="any";
	
	public any function savePriceGroupRate(required any priceGroupRate, struct data) {
		
		arguments.priceGroupRate = super.save(argumentcollection=arguments);
		
		// As long as this price group rate didn't have errors, then we can update all of the other rates for this given price group
		if(!arguments.priceGroupRate.hasErrors()) {
			
			var priceGroup = arguments.priceGroupRate.getPriceGroup();
			var rates = priceGroup.getPriceGroupRates();
			
			// Loop over all of the rates that aren't this one, and make sure that they don't have any of the productTypes, products, or skus of this one
			for(var i=1; i<=arrayLen(rates); i++) {
				if(rates[i].getPriceGroupRateID() != arguments.priceGroupRate.getPriceGroupRate()) {
					// Remove Product Types
					for(var pt=1; pt<=arrayLen(arguments.priceGroupRate.getProductTypes()); pt++) {
						rates[i].removeProductType(arguments.priceGroupRate.getProductTypes()[pt]);
					}
					// Remove Products
					for(var p=1; p<=arrayLen(arguments.priceGroupRate.getProducts()); p++) {
						rates[i].removeProduct(arguments.priceGroupRate.getProducts()[p]);
					}
					// Remove Skus
					for(var s=1; s<=arrayLen(arguments.priceGroupRate.getSkus()); s++) {
						rates[i].removeSku(arguments.priceGroupRate.getSkus()[s]);
					}
				}
			}
		}
	}
	
	// Helper method the delegates
	public numeric function calculateSkuPriceBasedOnCurrentAccount(required any sku) {
		return calculateSkuPriceBasedOnAccount(sku=arguments.sku, account=getSessionService().getCurrent().getAccount());
	}
	
	// Takes the account and runs any price groups applied through the calculation for best rate.
	public numeric function calculateSkuPriceBasedOnAccount(required any sku, required any account) {
		
		// Create a new array, and add the skus price as the first entry
		var prices = [sku.getPrice()];
		
		// Loop over each of the price groups of this account, and get the price based on that pricegroup
		for(var i=1; i<=arrayLen(account.getPriceGroups()); i++) {
			
			// Add this price groups price to the prices array
			arrayAppend(prices, calculateSkuPriceBasedOnPriceGroup(sku=arguments.sku, priceGroup=account.getPriceGroups()[i]));	
		}
		
		
		// Sort the array by lowest price
		arraySort(prices, "numeric", "asc");
		
		// Return the lowest price
		return prices[1];
	}
	
	// Simple method that gets the appopriate rate to use for this sku no matter where it comes from, and then calculates the correct value.  If no rate is found, it is just a passthough of sku.getPrice()
	public numeric function calculateSkuPriceBasedOnPriceGroup(required any sku, required any priceGroup) {
		
		// Figure out the rate for this particular sku
		var rate = getRateForSkuBasedOnPriceGroup(sku=arguments.sku, priceGroup=arguments.priceGroup);
		
		// If the sku is supposed to have this rate applied, then calculate the rate and apply
		if(!isNull(rate)) {
			return calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, priceGroupRate=rate);
		}
		
		// Return the sku price if there was no rate
		return sku.getPrice();
	}
	
	// This method will calculate the actual price of a sku based on a given price group rate
	public numeric function calculateSkuPriceBasedOnPriceGroupRate(required any sku, required any priceGroupRate) {
		
		// setup the new price as the old price in the event of a passthrough
		var newPrice = arguments.sku.getPrice();

		// calculate the new price bassed on whatever was set up.
		if(!isNull(arguments.priceGroupRate.getPercentageOff())) {
			var newPrice = arguments.sku.getPrice() - (arguments.sku.getPrice() * (arguments.priceGroupRate.getPercentageOff() / 100));
		} else if (!isNull(arguments.priceGroupRate.getAmountOff())) {
			var newPrice = arguments.sku.getPrice() - arguments.priceGroupRate.getAmountOff();
		} else if (!isNull(arguments.priceGroupRate.getAmount())) {
			var newPrice = arguments.priceGroupRate.getAmount();
		}
		
		//return the newPrice
		return newPrice;
	}
	
	// This method will return the rate that a given productType has based on a priceGroup, also this looks up to parent productTypes as well.
	public any function getRateForProductTypeBasedOnPriceGroup(required any productType, required any priceGroup) {
		
		// Setup a var'd value for returnRate but default it to null
		var returnRate = javaCast("null","");
		
		// Loop over rates to see if productType applies
		for(var i=1; i<=arrayLen(arguments.priceGroup.getPriceGroupRates()); i++) {
			
			// We need to look up the product type inheritence for parent product types here
			var currentProductType = arguments.productType;
			
			while (!isNull(currentProductType)) {
				// Check if this productType is applied in the rate
				if(arguments.priceGroup.getPriceGroupRates()[i].hasProductType(currentProductType)) {
					returnRate = arguments.priceGroup.getPriceGroupRates()[i];
					break;
				}
				
				// This sets the product type to the parent, so the while loop will run again
				currentProductType = currentProductType.getParentProductType();
			}
		}
		
		// If the rate is still null, then check the productType against the parent priceGroup which will check product and productType (this is done with recursion)
		if(isNull(returnRate) && !isNull(arguments.priceGroup.getParentPriceGroup())) {
			returnRate = getRateForProductTypeBasedOnPriceGroup(productType=arguments.productType, priceGroup=arguments.priceGroup.getParentPriceGroup());
		}
		
		// As long as the returnRate is not null, then return it.
		if(!isNull(returnRate)) {
			return returnRate;
		}
	}
	
	// This method will return the rate that a product has for a given price group
	public any function getRateForProductBasedOnPriceGroup(required any product, required any priceGroup) {
		
		// Setup a var'd value for returnRate but default it to null
		var returnRate = javaCast("null","");
		
		// Loop over rates to see if product applies
		for(var i=1; i<=arrayLen(arguments.priceGroup.getPriceGroupRates()); i++) {
			if (arguments.priceGroup.getPriceGroupRates()[i].hasProduct(arguments.product)) {
				returnRate = arguments.priceGroup.getPriceGroupRates()[i];
			}
		}
		
		// If the rate is still null, then check the productType
		if(isNull(returnRate)) {
			returnRate = getRateForProductTypeBasedOnPriceGroup(productType=arguments.product.getProductType(), priceGroup=arguments.priceGroup);
		}
		
		// If the rate is still null, then check the product against the parent priceGroup which will check product and productType (this is done with recursion)
		if(isNull(returnRate) && !isNull(arguments.priceGroup.getParentPriceGroup())) {
			returnRate = getRateForProductBasedOnPriceGroup(product=arguments.product, priceGroup=arguments.priceGroup.getParentPriceGroup());
		}
		
		// As long as the returnRate is not null, then return it.
		if(!isNull(returnRate)) {
			return returnRate;
		}
	}
	
	public any function getRateForSkuBasedOnPriceGroup(required any sku, required any priceGroup) {
		
		// Setup a var'd value for returnRate but default it to null
		var returnRate = javaCast("null","");
		
		// Loop over rates to see if sku applies
		for(var i=1; i<=arrayLen(arguments.priceGroup.getPriceGroupRates()); i++) {
			if (arguments.priceGroup.getPriceGroupRates()[i].hasSku(arguments.sku)) {
				returnRate = arguments.priceGroup.getPriceGroupRates()[i];
			}
		}
		
		// If the rate is still null, then check the product
		if(isNull(returnRate)) {
			returnRate = getRateForProductBasedOnPriceGroup(product=arguments.sku.getProduct(), priceGroup=arguments.priceGroup);
		}
		
		// If the rate is still null, then check the productType
		if(isNull(returnRate)) {
			returnRate = getRateForProductTypeBasedOnPriceGroup(productType=arguments.sku.getProduct().getProductType(), priceGroup=arguments.priceGroup);
		}
		
		// If the rate is still null, then check the sku against the parent priceGroup which will check product and productType (this is done with recursion)
		if(isNull(returnRate) && !isNull(arguments.priceGroup.getParentPriceGroup())) {
			returnRate = getRateForProductBasedOnPriceGroup(product=arguments.product, priceGroup=arguments.priceGroup.getParentPriceGroup());
		}
		
		// As long as the returnRate is not null, then return it.
		if(!isNull(returnRate)) {
			return returnRate;
		}
	}
	
	// This function has two optional arguments, newAmount and priceGroupRateId. Calling this function either other of these mutually exclusively determines the function's logic 
	public void function updatePriceGroupSKUSettings(required numeric skuId, required numeric priceGroupId, any newAmount="", any priceGroupRateId=""){
		
		dumpScreen(arguments);
		
		// If a priceGroupRateId was included, then check to see if we already have a SKU override for that rate. If not, add one in
		if(isNumeric(arguments.priceGroupRateId)){
			
			
		}
		
		// Else, if we have been provided a new amount, then see if a rate already exists in this price group with that amount add add the SKU there. If not, add that new rate, and then add the sku. 
		else if (isNumeric(arguments.newAmount)){
		
		}
	}
	
	// Produces a structure which is a struct of {[priceGroupId] = {name=[pricegroupname], pricegroupRates=}}
	public string function getPriceGroupDataJSON(){
		var local = {};
		var priceGroupData = {};
		var priceGroupSmartList = getDAO().getSmartList("PriceGroup");
	
		
		for(var i=1; i LTE arrayLen(priceGroupSmartList.getPageRecords()); i++){
			var thisPriceGroup = priceGroupSmartList.getPageRecords()[local.i];
			var priceGroupRates = [];

			for(var j=1; j LTE arrayLen(thisPriceGroup.getPriceGroupRates()); j++){
				var thisRate = thisPriceGroup.getPriceGroupRates()[j];
				var rateStruct = {
					id = thisRate.getPriceGroupRateId(),
					name = thisRate.getAmountRepresentation()
				};
				ArrayAppend(priceGroupRates, rateStruct);
			}
			
			var groupStruct = {
				priceGroupName = thisPriceGroup.getPriceGroupName(),
				priceGroupRates = priceGroupRates
			};	
			
			priceGroupData[thisPriceGroup.getPriceGroupId()] = groupStruct;
		}
		
		//dumpScreen(priceGroupData);	
		//dumpScreen(SerializeJSON(priceGroupData));
		return SerializeJSON(priceGroupData);
	}
			
}
