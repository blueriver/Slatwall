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
	
	public numeric function calculateSkuPriceBasedOnCurrentAccount(required any sku) {
		return calculateSkuPriceBasedOnAccount(sku=arguments.sku, account=getSessionService().getCurrent().getAccount());
	}
	
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
	
	public numeric function calculateSkuPriceBasedOnPriceGroupRate(required any sku, required any priceGroupRate) {
		var newPrice = arguments.sku.getPrice();
			
		if(!isNull(arguments.priceGroupRate.getPercentageOff())) {
			var newPrice = arguments.sku.getPrice() - (arguments.sku.getPrice() * (arguments.priceGroupRate.getPercentageOff() / 100));
		} else if (!isNull(arguments.priceGroupRate.getAmountOff())) {
			var newPrice = arguments.sku.getPrice() - arguments.priceGroupRate.getAmountOff();
		} else if (!isNull(arguments.priceGroupRate.getAmount())) {
			var newPrice = arguments.priceGroupRate.getAmount();
		}
		
		return newPrice;
	}
	
	public any function getRateForSkuBasedOnPriceGroup(required any sku, required any priceGroup) {
		
		var returnRate = javaCast("null","");
		
		// This allows for the Rate to come from a parent PriceGroup, if it isn't defined at this price group level
		if(!isNull(arguments.priceGroup.getParentPriceGroup())) {
			returnRate = getRateForSkuBasedOnPriceGroup(sku=arguments.sku, priceGroup=arguments.priceGroup.getParentPriceGroup());
		}
		
		// Loop over each of the rates, and determine which one the sku applies to
		for(var i=1; i<=arrayLen(arguments.priceGroup.getPriceGroupRates()); i++) {
			
			// Assign the priceGroup rate of the loop to a var so that it is easier to ref.
			var thisPriceGroupRate = arguments.priceGroup.getPriceGroupRates()[i];
			
			// This chunk of logic just determines if the sku applies to this rate.
			if(thisPriceGroupRate.getGlobalFlag()) {
				// If no returnRate has been setup yet, or this new rate is better than the existing returnRate then update the returnRate
				if(isNull(returnRate) || calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=returnRate) > calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=thisPriceGroupRate)) {
					returnRate = thisPriceGroupRate;	
				}
			} else {
				
				// Check skus, products & productTypes to see if this sku is included in this rate
				if(thisPriceGroupRate.hasSku(arguments.sku)) {
					// If no returnRate has been setup yet, or this new rate is better than the existing returnRate then update the returnRate
					if(isNull(returnRate) || calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=returnRate) > calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=thisPriceGroupRate)) {
						returnRate = thisPriceGroupRate;	
					}
				} else if (thisPriceGroupRate.hasProduct(arguments.sku.getProduct())) {
					// If no returnRate has been setup yet, or this new rate is better than the existing returnRate then update the returnRate
					if(isNull(returnRate) || calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=returnRate) > calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=thisPriceGroupRate)) {
						returnRate = thisPriceGroupRate;	
					}
				} else {
					var currentProductType = sku.getProduct().getProductType();
					
					while (!isNull(currentProductType)) {
						if(thisPriceGroupRate.hasProductType(currentProductType)) {
							// If no returnRate has been setup yet, or this new rate is better than the existing returnRate then update the returnRate
							if(isNull(returnRate) || calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=returnRate) > calculateSkuPriceBasedOnPriceGroupRate(sku=arguments.sku, rate=thisPriceGroupRate)) {
								returnRate = thisPriceGroupRate;
							}
							break;
						}
						currentProductType = currentProductType.getParentProductType();
					}
				}
				
			}
		}
		
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
