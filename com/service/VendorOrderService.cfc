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
	
	property name="addressService";
	property name="taxService";
	property name="DAO";
	
	public any function getVendorOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallVendorOrder";
		
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);	
		smartList.addKeywordProperty(propertyIdentifier="vendorOrderNumber", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="vendor_vendorName", weight=4);	
		smartList.joinRelatedProperty("SlatwallVendorOrder","vendor");
		
		return smartList;
	}
	
	/*public any function saveVendorOrder(required any vendorOrder, struct data={}) {
		
		// Call the super.save() method to do the base populate & validate logic
		arguments.vendorOrder = super.save(entity=arguments.vendorOrder, data=arguments.data);
		
		// If the vendorOrder has not been placed yet, loop over the vendorOrderItems to remove any that have a qty of 0
		if(arguments.vendorOrder.getStatusCode() == "ostNotPlaced") {
			for(var i=arrayLen(arguments.vendorOrder.getVendorOrderItems()); i>=1; i--) {
				if(arguments.vendorOrder.getVendorOrderItems()[i].getQuantity() < 1) {
					arguments.vendorOrder.removeVendorOrderItem(arguments.vendorOrder.getVendorOrderItems()[i]);
				}
			}	
		}
		
		// Recalculate the vendorOrder amounts for tax and promotions
		recalculateVendorOrderAmounts(arguments.vendorOrder);
		
		return arguments.vendorOrder;
	}*/
	
	public any function searchVendorOrders(struct data={}) {
		//set keyword and vendorOrderby
		var params = {
			keyword = arguments.data.keyword,
			vendorOrderBy = arguments.data.vendorOrderBy
		};
		// pass rc params (for paging) to smartlist
		structAppend(params,arguments.data);
		
		// date range (start or end) have been submitted 
		if(len(trim(arguments.data.vendorOrderDateStart)) > 0 || len(trim(arguments.data.vendorOrderDateEnd)) > 0) {
			var dateStart = arguments.data.vendorOrderDateStart;
			var dateEnd = arguments.data.vendorOrderDateEnd;
			
			// if either the start or end date is blank, default them to a long time ago or now(), respectively
 			if(len(trim(arguments.data.vendorOrderDateStart)) == 0) {
 				dateStart = createDateTime(30,1,1,0,0,0);
 			} else if(len(trim(arguments.data.vendorOrderDateEnd)) == 0) {
 				dateEnd = now();
 			}
 			// make sure we have valid datetimes
 			if(isDate(dateStart) && isDate(dateEnd)) {
 				// since were comparing to datetime objects, I'll add 85,399 seconds to the end date to make sure we get all vendorOrders on the last day of the range (only if it was entered)
				if(len(trim(arguments.data.vendorOrderDateEnd)) > 0) {
					dateEnd = dateAdd('s',85399,dateEnd);	
				}
				params['R:createdDateTime'] = "#dateStart#,#dateEnd#";
 			} else {
 				arguments.data.message = #arguments.data.$.slatwall.rbKey("admin.vendorOrder.search.invaliddates")#;
 				arguments.data.messagetype = "warning";
 			}
		}

		return getVendorOrderSmartList(params);
	}
	
	
	public any function getStockForSkuAndLocation(required any skuID, required any locationID){
		return getDAO().getStockForSkuAndLocation(arguments.skuID, arguments.locationID);
	}
	
	public any function isProductInVendorOrder(required any productID, required any vendorOrderID){
		return getDAO().isProductInVendorOrder(arguments.productID, arguments.vendorOrderID);
	}
	
	public any function getQuantityOfStockAlreadyOnOrder(required any vendorOrderID, required any stockID) {
		return getDAO().getQuantityOfStockAlreadyOnOrder(arguments.vendorOrderId, arguments.stockID);
	}
	
	
	/*public void function addVendorOrderItem(required any vendorOrder, required any sku, numeric quantity=1) {
		
		var vendorOrderItems = arguments.vendorOrder.getVendorOrderItems();
		var itemExists = false;
		
		// If there are no product customizations then we can check for the vendorOrder item already existing.
		if(!structKeyExists(arguments, "customizatonData") || !structKeyExists(arguments.customizatonData, "attribute")) {
			// Check the existing vendorOrder items and increment quantity if possible.
			for(var i = 1; i <= arrayLen(vendorOrderItems); i++) {
				if(vendorOrderItems[i].getSku().getSkuID() == arguments.sku.getSkuID() && vendorOrderItems[i].getVendorOrderFulfillment().getVendorOrderFulfillmentID() == arguments.vendorOrderFulfillment.getVendorOrderFulfillmentID()) {
					itemExists = true;
					vendorOrderItems[i].setQuantity(vendorOrderItems[i].getQuantity() + arguments.quantity);
					vendorOrderItems[i].getVendorOrderFulfillment().vendorOrderFulfillmentItemsChanged();
				}
			}
		}
		
		// If the sku doesn't exist in the vendorOrder, then create a new vendorOrder item and add it
		if(!itemExists) {
			var newItem = this.newVendorOrderItem();
			newItem.setSku(arguments.sku);
			newItem.setQuantity(arguments.quantity);
			newItem.setVendorOrder(arguments.vendorOrder);
			newItem.setVendorOrderFulfillment(arguments.vendorOrderFulfillment);
			newItem.setPrice(arguments.sku.getLivePrice());
			
			// Check for product customization
			if(structKeyExists(arguments, "customizatonData") && structKeyExists(arguments.customizatonData, "attribute")) {
				var pcas = arguments.sku.getProduct().getAttributeSets(['astProductCustomization']);
				for(var i=1; i<=arrayLen(pcas); i++) {
					var attributes = pcas[i].getAttributes();
					for(var a=1; a<=arrayLen(attributes); a++) {
						if( structKeyExists(arguments.customizatonData.attribute,attributes[a].getAttributeID()) ) {
							var av = this.newVendorOrderItemAttributeValue();
							av.setAttribute(attributes[a]);
							av.setAttributeValue(arguments.customizatonData.attribute[attributes[a].getAttributeID()]);
							av.setVendorOrderItem(newItem);
						}
					}
				}
			}
		}
		
		// Recalculate the vendorOrder amounts for tax and promotions
		recalculateVendorOrderAmounts(arguments.vendorOrder);
		
		save(arguments.vendorOrder);
	}
	
	public void function removeVendorOrderItem(required any vendorOrder, required string vendorOrderItemID) {
		
		// Loop over all of the items in this vendorOrder
		for(var i=1; i<=arrayLen(arguments.vendorOrder.getVendorOrderItems()); i++) {
			
			// Check to see if this item is the same ID as the one passed in to remove
			if(arguments.vendorOrder.getVendorOrderItems()[i].getVendorOrderItemID() == arguments.vendorOrderItemID) {
				
				// Actually Remove that Item
				arguments.vendorOrder.removeVendorOrderItem( arguments.vendorOrder.getVendorOrderItems()[i] );
			}
		}
	}*/
	
	
	
	/*public any function saveVendorOrderFulfillment(required any vendorOrderFulfillment, struct data={}) {
		
		arguments.vendorOrderFulfillment.populate(arguments.data);
		
		// If fulfillment method is shipping do this
		if(arguments.vendorOrderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == "shipping") {
			// define some variables for backward compatibility
			param name="data.saveAccountAddress" default="0";
			param name="data.saveAccountAddressName" default="";
			param name="data.addressIndex" default="0";  
			
			// Get Address
			if(data.addressIndex != 0){
				var address = getAddressService().getAddress(data.accountAddresses[data.addressIndex].address.addressID,true);
				var newAddressDataStruct = data.accountAddresses[data.addressIndex].address;
			} else {	
				var address = getAddressService().getAddress(data.shippingAddress.addressID,true);
				var newAddressDataStruct = data.shippingAddress;
			}
			
			// Populate Address And check if it has changed
			var serializedAddressBefore = address.getSimpleValuesSerialized();
			address.populate(newAddressDataStruct);
			var serializedAddressAfter = address.getSimpleValuesSerialized();
			
			if(serializedAddressBefore != serializedAddressAfter) {
				arguments.vendorOrderFulfillment.removeShippingMethodAndMethodOptions();
				getTaxService().updateVendorOrderAmountsWithTaxes(arguments.vendorOrderFulfillment.getVendorOrder());
			}
			
			// if address needs to get saved in account
			if(data.saveAccountAddress == 1 || data.addressIndex != 0){
				// new account address
				if(data.addressIndex == 0){
					var accountAddress = getAddressService().newAccountAddress();
				} else {
					//Existing address
					var accountAddress = getAddressService().getAccountAddress(data.accountAddresses[data.addressIndex].accountAddressID,true);
				}
				accountAddress.setAddress(address);
				accountAddress.setAccount(arguments.vendorOrderFulfillment.getVendorOrder().getAccount());
				
				// Figure out the name for this new account address, or update it if needed
				if(data.addressIndex == 0) {
					if(structKeyExists(data, "saveAccountAddressName") && len(data.saveAccountAddressName)) {
						accountAddress.setAccountAddressName(data.saveAccountAddressName);
					} else {
						accountAddress.setAccountAddressName(address.getname());	
					}	
				} else if (structKeyExists(data, "accountAddresses") && structKeyExists(data.accountAddresses[data.addressIndex], "accountAddressName")) {
					accountAddress.setAccountAddressName(data.accountAddresses[data.addressIndex].accountAddressName);
				}
				
				arguments.vendorOrderFulfillment.removeShippingAddress();
				arguments.vendorOrderFulfillment.setAccountAddress(accountAddress);
			} else {
				// Set the address in the vendorOrder Fulfillment as shipping address
				arguments.vendorOrderFulfillment.setShippingAddress(address);
				arguments.vendorOrderFulfillment.removeAccountAddress();
			}
			
			// Validate & Save Address
			address.validate(context="full");
			
			address = getAddressService().saveAddress(address);
			
			// Check for a shipping method option selected
			if(structKeyExists(arguments.data, "vendorOrderShippingMethodOptionID")) {
				var methodOption = this.getVendorOrderShippingMethodOption(arguments.data.vendorOrderShippingMethodOptionID);
				
				// Verify that the method option is one for this fulfillment
				if(!isNull(methodOption) && arguments.vendorOrderFulfillment.hasVendorOrderShippingMethodOption(methodOption)) {
					// Update the vendorOrderFulfillment to have this option selected
					arguments.vendorOrderFulfillment.setShippingMethod(methodOption.getShippingMethod());
					arguments.vendorOrderFulfillment.setFulfillmentCharge(methodOption.getTotalCharge());
				}
				
			}
			
			// Validate the vendorOrder Fulfillment
			arguments.vendorOrderFulfillment.validate();
			if(!getRequestCacheService().getValue("ormHasErrors")){
				getDAO().flushORMSession();
			}
		}
		
		// Save the vendorOrder Fulfillment
		return getDAO().save(arguments.vendorOrderFulfillment);
	}*/
	
	
	
}
