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
	
	IMPORANT TO UNDERSTAN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	The SkuCache service & entity play an important role in allowing for productListing to be performant.
	Any time an entity is saved that impacts quantity, price, or settings or a given sku, there is a corisponding
	skuCache entity that needs to be updated.  The Entities that affect skuCache are as follows:
	
	Sku
	Product
	ProductType
	
	OrderItem
	VendorOrderItem
	StockAdjustmentItem
	
	OrderDeliveryItem
	VendorOrderDeliveryItem
	StockAdjustmentDeliveryItem
	
	PromotionRewardProduct
	
	StockReceiverItem

*/
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	// Injected properties from coldspring
	property name="skuService" type="any";

	variables.skusToUpdate = [];
	variables.updatingSkus = [];
	variables.nextSalePriceExpirationDateTime = "";
	
	public void function updateFromOrderItem(required any orderItem) {
		updateFromSku(sku=arguments.orderItem.getSku(), propertyList="qndoo,qnroro");
	}
	
	public void function updateFromVendorOrderItem(required any vendorOrderItem) {
		updateFromSku(sku=arguments.vendorOrderItem.getStock().getSku(), propertyList="qndorvo,qnrovo");
	}
	
	public void function updateFromStockAdjustmentItem(required any stockAdjustmentItem) {
		if(!isNull(arguments.stockAdjustmentItem.getFromStock())) {
			updateFromSku(sku=arguments.stockAdjustmentItem.getFromStock().getSku(), propertyList="qoh,qndosa");
		}
		if(!isNull(arguments.stockAdjustmentItem.getToStock())) {
			updateFromSku(sku=arguments.stockAdjustmentItem.getToStock().getSku(), propertyList="qoh,qnrosa");
		}
	}
	
	public void function updateFromOrderDeliveryItem(required any orderDeliveryItem) {
		updateFromSku(sku=arguments.orderDeliveryItem.getStock().getSku(), propertyList="qoh,qndoo");
	}
	
	public void function updateFromVendorOrderDeliveryItem(required any vendorOrderDeliveryItem) {
		updateFromSku(sku=arguments.vendorOrderDeliveryItem.getStock().getSku(), propertyList="qoh,qndovo");
	}
	
	public void function updateFromStockAdjustmentDeliveryItem(required any stockAdjustmentDeliveryItem) {
		updateFromSku(sku=arguments.stockAdjustmentDeliveryItem.getStock().getSku(), propertyList="qoh,qndosa");
	}
	
	public void function updateFromStockReceiverItem(required any stockReceiverItem) {
		updateFromSku(sku=arguments.stockReceiverItem.getStock().getSku(), propertyList="qoh,qnroro,qnrovo,qnrosa,qndosa");
	}
	
	public void function updateFromPromotionRewardProduct(required any promotionRewardProduct) {
		// Loop over Brands on this Promotion Reward and update the related product skus
		for(var b=1; b<=arrayLen(arguments.promotionRewardProduct.getBrands()); b++) {
			for(var p=1; p<=arrayLen(arguments.promotionRewardProduct.getBrands()[b].getProducts()); p++) {
				updateFromProduct(product=arguments.promotionRewardProduct.getBrands()[b].getProducts()[p], propertyList="salePrice,salePriceExpirationDateTime");
			}
		}
		
		// Loop over Options on this Promotion Reward and update the related skus
		for(var o=1; o<=arrayLen(arguments.promotionRewardProduct.getOptions()); o++) {
			for(var s=1; s<=arrayLen(arguments.promotionRewardProduct.getOptions()[o].getSkus()); s++) {
				updateFromSku(sku=arguments.promotionRewardProduct.getOptions()[o].getSkus()[s], propertyList="salePrice,salePriceExpirationDateTime");
			}
		}
		
		// Loop over ProductTypes on this Promotion Reward and update the related product skus
		for(var pt=1; pt<=arrayLen(arguments.promotionRewardProduct.getProductTypes()); pt++) {
			updateFromProductType(productType=arguments.promotionRewardProduct.getProductTypes()[pt], propertyList="salePrice,salePriceExpirationDateTime");
		}
		
		// Loop over Products on this Promotion Reward and update their skus
		for(var p=1; p<=arrayLen(arguments.promotionRewardProduct.getProducts()); p++) {
			updateFromProduct(product=arguments.promotionRewardProduct.getProducts()[p], propertyList="salePrice,salePriceExpirationDateTime");
		}
		
		// Loop over Skus on this Promotion Reward and update them
		for(var s=1; s<=arrayLen(arguments.promotionRewardProduct.getSkus()); s++) {
			updateFromSku(sku=arguments.promotionRewardProduct.getSkus()[s], propertyList="salePrice,salePriceExpirationDateTime");
		}
	}
	
	
	public void function updateFromProductType(required any productType, string propertyList="allowBackorderFlag,allowDropshipFlag,allowPreorderFlag,allowShippingFlag,callToOrderFlag,displayTemplate,quantityHeldBack,quantityMinimum,quantityMaximum,quantityOrderMinimum,quantityOrderMaximum,shippingWeight,trackInventoryFlag") {
		// Loop over all products this productType and add call the updateFromProduct method
		for(var p=1; p<=arrayLen(arguments.productType.getProducts()); p++) {
			updateFromProduct(arguments.productType.getProducts()[p]);
		}
		// Loop over all child productTypes and call this method on them (recursion)
		for(var c=1; c<=arrayLen(arguments.productType.getChildProductTypes()); c++) {
			updateFromProductType(arguments.productType.getChildProductTypes()[c]);	
		}
	}
	
	public void function updateFromProduct(required any product, string propertyList="allowBackorderFlag,allowDropshipFlag,allowPreorderFlag,allowShippingFlag,callToOrderFlag,displayTemplate,quantityHeldBack,quantityMinimum,quantityMaximum,quantityOrderMinimum,quantityOrderMaximum,shippingWeight,trackInventoryFlag") {
		// Loop over the skus of the product and add to skuCache
		for(var s=1; s<=arrayLen(arguments.product.getSkus()); s++) {
			updateFromSku(sku=arguments.product.getSkus(), propertyList=arguments.propertyList);
		}
	}
	
	
	// This is the only updateXXX method that should touch the variables.skusToUpdate
	public void function updateFromSku(required any sku, string propertyList="allowBackorderFlag,allowDropshipFlag,allowPreorderFlag,allowShippingFlag,callToOrderFlag,displayTemplate,quantityHeldBack,quantityMinimum,quantityMaximum,quantityOrderMinimum,quantityOrderMaximum,shippingWeight,trackInventoryFlag") {
		arrayAppend(variables.skusToUpdate, {skuID=arguments.sku.getSkuID(), propertyList=arguments.propertyList});	
	}
	
	// This gets called on every request
	public void function executeSkuCacheUpdates() {
		if(variables.nextSalePriceExpirationDateTime == "") {
			variables.nextSalePriceExpirationDateTime = getDAO().getNextSalePriceExpirationDateTime();
		}
		if(variables.nextSalePriceExpirationDateTime < now()) {
			// TODO: Impliment this
			// get list of skuID's with nextSalePriceExpiration < now
			// add those skuID's to the array
		}
		
		if(arrayLen(variables.skusToUpdate)) {
			lock timeout="60" scope="Application" {
				if(arrayLen(variables.skusToUpdate)) {
					variables.updatingSkus = duplicate(variables.skusToUpdate);
					variables.skusToUpdate = [];
					thread action="run" name="updateSkuCache-#createUUID()#" {
						try {
							for(var i=arrayLen(variables.updatingSkus); i>=1; i--) {
								updateSkuCache(propertyList=variables.updatingSkus[i]["propertyList"], skuID=variables.updatingSkus[i]["skuID"]);
								getDAO().flushORMSession();
								logSlatwall("Sku Cache Updated For: #variables.updatingSkus[i]["skuID"]#");
							}
						} catch(any e) {
							for(var a=1; a<=arrayLen(variables.updatingSkus); a++) {
								arrayAppend(variables.skusToUpdate, variables.updatingSkus[a]);	
							}
							variables.nextSalePriceExpirationDateTime = getDAO().getNextSalePriceExpirationDateTime();
							rethrow;
						}
						variables.nextSalePriceExpirationDateTime = getDAO().getNextSalePriceExpirationDateTime();
					}
				}
			}
		}
	}
	
	// This method is private on purpose... don't change it.
	private void function updateSkuCache(required string propertyList, required string skuID) {
		
		var skuCache = this.getSkuCache(arguments.skuID, true);
		var sku = getSkuService().getSku(arguments.skuID, true);
		
		
		if(listFindNoCase(arguments.propertyList, "salePrice") || skuCache.isNew()) {
			skuCache.setSalePrice( sku.getSalePrice() );
		}
		if(listFindNoCase(arguments.propertyList, "salePriceExpirationDateTime") || skuCache.isNew()) {
			skuCache.setSalePriceExpirationDateTime( sku.getSalePriceExpirationDateTime() );
		}
		if(listFindNoCase(arguments.propertyList, "qoh") || skuCache.isNew()) {
			skuCache.setQOH( sku.getQuantity("QOH") );
		}
		if(listFindNoCase(arguments.propertyList, "qosh") || skuCache.isNew()) {
			skuCache.setQOSH( sku.getQuantity("QOSH") );
		}
		if(listFindNoCase(arguments.propertyList, "qndoo") || skuCache.isNew()) {
			skuCache.setQNDOO( sku.getQuantity("QNDOO") );
		}
		if(listFindNoCase(arguments.propertyList, "qndorvo") || skuCache.isNew()) {
			skuCache.setQNDORVO( sku.getQuantity("QNDORVO") );
		}
		if(listFindNoCase(arguments.propertyList, "qndosa") || skuCache.isNew()) {
			skuCache.setQNDOSA( sku.getQuantity("QNDOSA") );
		}
		if(listFindNoCase(arguments.propertyList, "qnroro") || skuCache.isNew()) {
			skuCache.setQNRORO( sku.getQuantity("QNRORO") );
		}
		if(listFindNoCase(arguments.propertyList, "qnrovo") || skuCache.isNew()) {
			skuCache.setQNROVO( sku.getQuantity("QNROVO") );
		}
		if(listFindNoCase(arguments.propertyList, "qnrosa") || skuCache.isNew()) {
			skuCache.setQNROSA( sku.getQuantity("QNROSA") );
		}
		if(listFindNoCase(arguments.propertyList, "allowShippingFlag") || skuCache.isNew()) {
			skuCache.setAllowShippingFlag( sku.getSetting("allowShippingFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "allowPreorderFlag") || skuCache.isNew()) {
			skuCache.setAllowPreorderFlag( sku.getSetting("allowPreorderFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "allowBackorderFlag") || skuCache.isNew()) {
			skuCache.setAllowBackorderFlag( sku.getSetting("allowBackorderFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "allowDropshipFlag") || skuCache.isNew()) {
			skuCache.setAllowDropshipFlag( sku.getSetting("allowDropshipFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "callToOrderFlag") || skuCache.isNew()) {
			skuCache.setCallToOrderFlag( sku.getSetting("callToOrderFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "displayTemplate") || skuCache.isNew()) {
			skuCache.setQuantityHeldBack( sku.getSetting("displayTemplate") );
		}
		if(listFindNoCase(arguments.propertyList, "quantityHeldBack") || skuCache.isNew()) {
			skuCache.setQuantityHeldBack( sku.getSetting("quantityHeldBack") );
		}
		if(listFindNoCase(arguments.propertyList, "quantityMinimum") || skuCache.isNew()) {
			skuCache.setQuantityMinimum( sku.getSetting("quantityMinimum") );
		}
		if(listFindNoCase(arguments.propertyList, "quantityMaximum") || skuCache.isNew()) {
			skuCache.setQuantityMaximum( sku.getSetting("quantityMaximum") );
		}
		if(listFindNoCase(arguments.propertyList, "quantityOrderMinimum") || skuCache.isNew()) {
			skuCache.setQuantityOrderMinimum( sku.getSetting("quantityOrderMinimum") );
		}
		if(listFindNoCase(arguments.propertyList, "quantityOrderMaximum") || skuCache.isNew()) {
			skuCache.setQuantityOrderMaximum( sku.getSetting("quantityOrderMaximum") );
		}
		if(listFindNoCase(arguments.propertyList, "shippingWeight") || skuCache.isNew()) {
			skuCache.setShippingWeight( sku.getSetting("shippingWeight") );
		}
		if(listFindNoCase(arguments.propertyList, "trackInventoryFlag") || skuCache.isNew()) {
			skuCache.setTrackInventoryFlag( sku.getProduct().getSetting("trackInventoryFlag") );
		}
		
		// Sku goes last otherwise the isNew() methods above wouldn't work on truly new skus
		if(skuCache.isNew()) {
			skuCache.setSku( sku );
		}
		
		getDAO().save( skuCache );
	}
	
}