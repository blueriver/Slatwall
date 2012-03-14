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
	
	IMPORANT TO UNDERSTAND !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	The SkuCache service & entity play an important role in allowing for productListing to be performant.
	Any time an entity is saved that impacts quantity, price, or settings or a given sku, there is a corresponding
	skuCache entity that needs to be updated.  The Entities that affect skuCache are as follows:
	
	Sku
	Product
	ProductType
	
	Order
	VendorOrderItem
	StockAdjustmentItem
	
	OrderDeliveryItem
	VendorOrderDeliveryItem
	StockAdjustmentDeliveryItem
	
	Promotion
	PromotionRewardProduct
	
	StockReceiverItem

*/
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	// Injected properties from coldspring
	property name="inventoryService" type="any";
	property name="promotionService" type="any";
	property name="skuService" type="any";
	property name="utilityTagService" type="any";
	
	variables.skusToUpdate = [];
	variables.productsToUpdate = [];
	variables.nextSalePriceExpirationDateTime = "";
	
	// These two methods get called from the settings controller when you want to rebuild the entire cache
	public void function updateAllSkus() {
		var skuQuery = getDAO().getSkuQuery();
		for(var i=1; i<=skuQuery.recordCount; i++) {
			updateSkuID(skuID=skuQuery["skuID"][i], propertyList="all");
		}
	}
	public void function updateAllProducts() {
		var productQuery = getDAO().getProductQuery();
		for(var i=1; i<=productQuery.recordCount; i++) {
			updateProductID(productID=productQuery["productID"][i], propertyList="all");
		}
	}
	
	// START: Methods Invoked preUpdate
	public void function updateFromOrder(required any order) {
		if(setting("advanced_useSkuCacheFlag")) {
			if(!listFindNoCase("ostNotPlaced,ostClosed,ostCanceled", arguments.order.getOrderStatusType().getSystemCode())) {
				for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
					updateFromSku(sku=arguments.order.getOrderItems()[i].getSku(), propertyList="qndoo,qnroro");
				}
			}
		}
	}
	
	public void function updateFromVendorOrderItem(required any vendorOrderItem) {
		if(setting("advanced_useSkuCacheFlag")) {
			updateFromSku(sku=arguments.vendorOrderItem.getStock().getSku(), propertyList="qndorvo,qnrovo");
		}
	}
	
	public void function updateFromStockAdjustmentItem(required any stockAdjustmentItem) {
		if(setting("advanced_useSkuCacheFlag")) {
			if(!isNull(arguments.stockAdjustmentItem.getFromStock())) {
				updateFromSku(sku=arguments.stockAdjustmentItem.getFromStock().getSku(), propertyList="qoh,qndosa");
			}
			if(!isNull(arguments.stockAdjustmentItem.getToStock())) {
				updateFromSku(sku=arguments.stockAdjustmentItem.getToStock().getSku(), propertyList="qoh,qnrosa");
			}
		}
	}
	
	public void function updateFromOrderDeliveryItem(required any orderDeliveryItem) {
		if(setting("advanced_useSkuCacheFlag")) {
			updateFromSku(sku=arguments.orderDeliveryItem.getStock().getSku(), propertyList="qoh,qndoo");
		}
	}
	
	public void function updateFromVendorOrderDeliveryItem(required any vendorOrderDeliveryItem) {
		if(setting("advanced_useSkuCacheFlag")) {
			updateFromSku(sku=arguments.vendorOrderDeliveryItem.getStock().getSku(), propertyList="qoh,qndovo");
		}
	}
	
	public void function updateFromStockAdjustmentDeliveryItem(required any stockAdjustmentDeliveryItem) {
		if(setting("advanced_useSkuCacheFlag")) {
			updateFromSku(sku=arguments.stockAdjustmentDeliveryItem.getStock().getSku(), propertyList="qoh,qndosa");
		}
	}
	
	public void function updateFromStockReceiverItem(required any stockReceiverItem) {
		if(setting("advanced_useSkuCacheFlag")) {
			updateFromSku(sku=arguments.stockReceiverItem.getStock().getSku(), propertyList="qoh,qnroro,qnrovo,qnrosa,qndosa");
		}
	}
	
	public void function updateFromPromotionRewardProduct(required any promotionRewardProduct) {
		if(setting("advanced_useSkuCacheFlag")) {
			// Loop over Brands on this Promotion Reward and update the related product skus
			for(var b=1; b<=arrayLen(arguments.promotionRewardProduct.getBrands()); b++) {
				for(var p=1; p<=arrayLen(arguments.promotionRewardProduct.getBrands()[b].getProducts()); p++) {
					updateFromProduct(product=arguments.promotionRewardProduct.getBrands()[b].getProducts()[p], propertyList="salePrice");
				}
			}
			
			// Loop over Options on this Promotion Reward and update the related skus
			for(var o=1; o<=arrayLen(arguments.promotionRewardProduct.getOptions()); o++) {
				for(var s=1; s<=arrayLen(arguments.promotionRewardProduct.getOptions()[o].getSkus()); s++) {
					updateFromSku(sku=arguments.promotionRewardProduct.getOptions()[o].getSkus()[s], propertyList="salePrice");
				}
			}
			
			// Loop over ProductTypes on this Promotion Reward and update the related product skus
			for(var pt=1; pt<=arrayLen(arguments.promotionRewardProduct.getProductTypes()); pt++) {
				updateFromProductType(productType=arguments.promotionRewardProduct.getProductTypes()[pt], propertyList="salePrice");
			}
			
			// Loop over Products on this Promotion Reward and update their skus
			for(var p=1; p<=arrayLen(arguments.promotionRewardProduct.getProducts()); p++) {
				updateFromProduct(product=arguments.promotionRewardProduct.getProducts()[p], propertyList="salePrice");
			}
			
			// Loop over Skus on this Promotion Reward and update them
			for(var s=1; s<=arrayLen(arguments.promotionRewardProduct.getSkus()); s++) {
				updateFromSku(sku=arguments.promotionRewardProduct.getSkus()[s], propertyList="salePrice");
			}
		}
	}
	
	public void function updateFromPromotion(required any promotion) {
		if(setting("advanced_useSkuCacheFlag")) {
			for(var i=1; i<=arrayLen(arguments.promotion.getPromotionRewards()); i++) {
				if(arguments.promotion.getPromotionRewards()[i].getClassName() == "PromotionRewardProduct") {
					updateFromPromotionRewardProduct(arguments.promotion.getPromotionRewards()[i]);
				}
			}
		}
	}
	
	
	public void function updateFromProductType(required any productType, string propertyList="allowBackorderFlag,allowDropshipFlag,allowPreorderFlag,allowShippingFlag,callToOrderFlag,displayTemplate,quantityHeldBack,quantityMinimum,quantityMaximum,quantityOrderMinimum,quantityOrderMaximum,shippingWeight,trackInventoryFlag") {
		if(setting("advanced_useSkuCacheFlag")) {
			// Loop over all products this productType and add call the updateFromProduct method
			for(var p=1; p<=arrayLen(arguments.productType.getProducts()); p++) {
				updateFromProduct(arguments.productType.getProducts()[p]);
			}
			// Loop over all child productTypes and call this method on them (recursion)
			for(var c=1; c<=arrayLen(arguments.productType.getChildProductTypes()); c++) {
				updateFromProductType(arguments.productType.getChildProductTypes()[c]);	
			}
		}
	}
	
	public void function updateFromProduct(required any product, string propertyList="salePrice,skuImageFileList,allowBackorderFlag,allowDropshipFlag,allowPreorderFlag,allowShippingFlag,callToOrderFlag,displayTemplate,quantityHeldBack,quantityMinimum,quantityMaximum,quantityOrderMinimum,quantityOrderMaximum,shippingWeight,trackInventoryFlag") {
		if(setting("advanced_useSkuCacheFlag")) {
			// Loop over the skus of the product and add to skuCache
			for(var s=1; s<=arrayLen(arguments.product.getSkus()); s++) {
				updateFromSku(sku=arguments.product.getSkus()[s], propertyList=arguments.propertyList);
			}
		}
		if(setting("advanced_useProductCacheFlag")) {
			updateProductID(productID=arguments.product.getProductID(), propertyList=arguments.propertyList);
		}
	}
	
	public void function updateFromSku(required any sku, string propertyList="salePrice,skuImageFileList,allowBackorderFlag,allowDropshipFlag,allowPreorderFlag,allowShippingFlag,callToOrderFlag,displayTemplate,quantityHeldBack,quantityMinimum,quantityMaximum,quantityOrderMinimum,quantityOrderMaximum,shippingWeight,trackInventoryFlag") {
		if(setting("advanced_useSkuCacheFlag")) {
			updateSkuID(skuID = arguments.sku.getSkuID(), propertyList=arguments.propertyList);
		}
		if(setting("advanced_useProductCacheFlag")) {
			updateProductID(productID = arguments.sku.getProduct().getProductID(), propertyList=arguments.propertyList);
		}
	}
	// END: Methods Invoked preUpdate
	
	
	// This is the only updateXXX method that should touch the variables.skusToUpdate
	public void function updateSkuID(required string skuID, string propertyList="all") {
		if(setting("advanced_useSkuCacheFlag")) {
			arrayAppend(variables.skusToUpdate, {skuID=arguments.skuID, propertyList=arguments.propertyList});
		}
	}
	
	// This is the only updateXXX method that should touch the variables.productsToUpdate
	public void function updateProductID(required string productID, string propertyList="all") {
		if(setting("advanced_useProductCacheFlag")) {
			arrayAppend(variables.productsToUpdate, {productID=arguments.productID, propertyList=arguments.propertyList});
		}
	}
	
	// This gets called on every request
	public void function executeSkuCacheUpdates() {
		
		if(setting("advanced_useSkuCacheFlag") && arrayLen(variables.skusToUpdate)) {
			updateSkuCache();
		}
		
		if(setting("advanced_useProductCacheFlag") && arrayLen(variables.productsToUpdate)) {
			updateProductCache();
		}
	}
	
	// This method is private on purpose... don't change it.
	private void function updateSkuCache() {
		
		var skusForThread = duplicate(variables.skusToUpdate);
		variables.skusToUpdate = [];
		
		thread action="run" name="updateSkuCache-#createUUID()#" updatingSkus="#skusForThread#" {
			logSlatwall("Thread for Sku Cache Update Started with #arrayLen(updatingSkus)# skus to update", true);
			var startTime = getTickCount();
			
			utilityTagService.cfsetting(requesttimeout=1000);
			
			var productSaleData = {};
			
			for(var i=1; i<=arrayLen(updatingSkus); i++) {
				var skuID = updatingSkus[i].skuID;
				var propertyList = updatingSkus[i].propertyList;
				
				var skuRecordQuery = getDAO().getSkuQuery( skuID );
				var skuCacheRecordQuery = getDAO().getSkuCacheQuery( skuID );
				
				// Make sure that this is a valid sku
				if(skuRecordQuery.recordcount) {
					
					// Check to see if there is a skuCache record yet, if not set the propertyList to "all"
					if(!skuCacheRecordQuery.recordcount) {
						propertyList = "all";
					}
					
					var data = {};
					
					if(listFindNoCase(propertyList, "salePrice") || propertyList == "all") {
						
						if(!structKeyExists(productSaleData, skuRecordQuery.productID)) {
							productSaleData[skuRecordQuery.productID] = getPromotionService().getSalePriceDetailsForProductSkus(productID = skuRecordQuery.productID);
						}
						
						if(structKeyExists(productSaleData[ skuRecordQuery.productID ], skuID)) {
							data.salePrice = productSaleData[ skuRecordQuery.productID ][ skuID ].salePrice;
							data.salePriceExpirationDateTime = productSaleData[ skuRecordQuery.productID ][ skuID ].salePriceExpirationDateTime;
						} else {
							data.salePrice = skuRecordQuery.price;
							data.salePriceExpirationDateTime = "NULL";
						}
					
					}
					if(listFindNoCase(propertyList, "qoh") || propertyList == "all") {
						data.qoh = getInventoryService().getQOH( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qosh") || propertyList == "all") {
						data.qosh = getInventoryService().getQOSH( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qndoo") || propertyList == "all") {
						data.qndoo = getInventoryService().getQNDOO( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qndorvo") || propertyList == "all") {
						data.qndorvo = getInventoryService().getQNDORVO( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qndosa") || propertyList == "all") {
						data.qndosa = getInventoryService().getQNDOSA( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qnroro") || propertyList == "all") {
						data.qnroro = getInventoryService().getQNRORO( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qnrovo") || propertyList == "all") {
						data.qnrovo = getInventoryService().getQNROVO( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qnrosa") || propertyList == "all") {
						data.qnrosa = getInventoryService().getQNROSA( skuID=skuID, skuRemoteID=skuRecordQuery.remoteID );
					}
					
					getDAO().updateSkuCache(skuID=skuID, data=data);
				}
			}
			
			var endTime = getTickCount();
			var duration = endTime - startTime;
			var durationSeconds = duration/1000;
			
			logSlatwall("Thread for Sku Cache Update Finished in #durationSeconds# Seconds", true);
		}
	}
	
	// This method is private on purpose... don't change it.
	private void function updateProductCache() {
		
		var productsForThread = duplicate(variables.productsToUpdate);
		variables.productsToUpdate = [];
		
		thread action="run" name="updateProductCache-#createUUID()#" updatingProducts="#productsForThread#" {
			logSlatwall("Thread for Product Cache Update Started with #arrayLen(updatingProducts)# products to update", true);
			var startTime = getTickCount();
			
			utilityTagService.cfsetting(requesttimeout=1000);
			
			for(var i=1; i<=arrayLen(updatingProducts); i++) {
				
				var productID = updatingProducts[i].productID;
				var propertyList = updatingProducts[i].propertyList;
				
				var productRecordQuery = getDAO().getProductQuery( productID );
				var productCacheRecordQuery = getDAO().getProductCacheQuery( productID );
				
				// Make sure that this is a valid sku
				if(productRecordQuery.recordcount) {
					
					// Check to see if there is a skuCache record yet, if not set the propertyList to "all"
					if(!productCacheRecordQuery.recordcount) {
						propertyList = "all";
					}
					
					var data = {};
					
					if(listFindNoCase(propertyList, "salePrice") || propertyList == "all") {
						
						var saleDetails = getPromotionService().getSalePriceDetailsForProductSkus(productID = productRecordQuery.productID);
						
						if(structKeyExists(saleDetails, productRecordQuery.defaultSkuID)) {
							data.salePrice = saleDetails[ productRecordQuery.defaultSkuID ].salePrice;
							data.salePriceExpirationDateTime = saleDetails[ productRecordQuery.defaultSkuID ].salePriceExpirationDateTime;
						} else {
							data.salePrice = productRecordQuery.price;
							data.salePriceExpirationDateTime = "NULL";
						}
					
					}
					if(listFindNoCase(propertyList, "skuImageFileList") || propertyList == "all") {
						data.skuImageFileList = "";
						
						var imageFileListQuery = getDAO().getUniqueProductSkuImageFiles( productID = productRecordQuery.productID);
						for(var ifq=1; ifq<=imageFileListQuery.recordCount; ifq++) {
							data.skuImageFileList = listAppend(data.skuImageFileList, imageFileListQuery["imageFile"][ifq]);
						}
					}
					if(listFindNoCase(propertyList, "qoh") || propertyList == "all") {
						data.qoh = getInventoryService().getQOH( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qosh") || propertyList == "all") {
						data.qosh = getInventoryService().getQOSH( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qndoo") || propertyList == "all") {
						data.qndoo = getInventoryService().getQNDOO( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qndorvo") || propertyList == "all") {
						data.qndorvo = getInventoryService().getQNDORVO( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qndosa") || propertyList == "all") {
						data.qndosa = getInventoryService().getQNDOSA( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qnroro") || propertyList == "all") {
						data.qnroro = getInventoryService().getQNRORO( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qnrovo") || propertyList == "all") {
						data.qnrovo = getInventoryService().getQNROVO( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					if(listFindNoCase(propertyList, "qnrosa") || propertyList == "all") {
						data.qnrosa = getInventoryService().getQNROSA( productID=productRecordQuery.productID, productRemoteID=productRecordQuery.remoteID );
					}
					
					getDAO().updateProductCache(productID=productID, data=data);
				}
			}
			
			var endTime = getTickCount();
			var duration = endTime - startTime;
			var durationSeconds = duration/1000;
			
			logSlatwall("Thread for Product Cache Update Finished in #durationSeconds# Seconds", true);
		}
	}
}
