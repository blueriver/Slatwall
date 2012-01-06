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
	
	IMPORANT TO UNDERSTAN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	The SkuCache service & entity play an important role in allowing for productListing to be performant.
	Any time an entity is saved that impacts quantity, price, or settings or a given sku, there is a corisponding
	skuCache entity that needs to be updated.  The Entities that affect skuCache are as follows:
	
	OrderDeliveryItem
	OrderItem
	Product
	ProductType
	PromotionRewardProduct
	Sku
	StockAdjustmentItem
	StockReceiverItem
	VendorOrderItem

*/
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	public void function updateFromOrderDeliveryItem(required any orderDeliveryItem) {
		updateSkuCache(propertyList="qoh,qndoo", sku=arguments.orderDeliveryItem.getStock().getSku());
	}
	
	public void function updateFromOrderItem(required any orderItem) {
		updateSkuCache(propertyList="qndoo", sku=arguments.orderItem.getSku());
	}
	
	public void function updateFromProduct(required any product) {
		for(var i=1; i<=arrayLen(arguments.product.getSkus()); i++) {
			updateSkuCache(propertyList="all", sku=arguments.product.getSkus()[i]);	
		}
	}
	
	public void function updateFromProductType(required any productType) {
		updateSkuCache(propertyList="", sku="");
	}
	
	public void function updateFromPromotionRewardProduct(required any promotionRewardProduct) {
		updateSkuCache(propertyList="", sku="");
	}
	
	public void function updateFromSku(required any sku) {
		updateSkuCache(propertyList="", sku="");
	}
	
	public void function updateFromStockAdjustmentItem(required any stockAdjustmentItem) {
		updateSkuCache(propertyList="", sku="");
	}
	
	public void function updateFromStockReceiverItem(required any stockReceiverItem) {
		updateSkuCache(propertyList="", sku="");
	}
	
	public void function updateFromVendorOrderItem(required any vendorOrderItem) {
		updateSkuCache(propertyList="", sku="");
	}
	
	// This method is private on purpose... don't change it.
	private void function updateSkuCache(required string propertyList, required any sku) {
		
		var skuCache = this.getSkuCache(arguments.sku.getSkuID(), true);
		
		/*if(listFindNoCase(arguments.propertyList, "livePrice") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setLivePrice( arguments.sku.getLivePrice() );
		}*/
		if(listFindNoCase(arguments.propertyList, "qoh") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQOH( arguments.sku.getQOH() );
		}
		if(listFindNoCase(arguments.propertyList, "qosh") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQOSH( arguments.sku.getQOSH() );
		}
		if(listFindNoCase(arguments.propertyList, "qndoo") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQNDOO( arguments.sku.getQNDOO() );
		}
		if(listFindNoCase(arguments.propertyList, "qndorvo") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQNDORVO( arguments.sku.getQNDORVO() );
		}
		if(listFindNoCase(arguments.propertyList, "qndosa") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQNDOSA( arguments.sku.getQNDOSA() );
		}
		if(listFindNoCase(arguments.propertyList, "qnroro") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQNRORO( arguments.sku.getQNRORO() );
		}
		if(listFindNoCase(arguments.propertyList, "qnrovo") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQNROVO( arguments.sku.getQNROVO() );
		}
		if(listFindNoCase(arguments.propertyList, "qnrosa") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQNROSA( arguments.sku.getQNROSA() );
		}
		if(listFindNoCase(arguments.propertyList, "qmin") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQMIN( arguments.sku.getQMIN() );
		}
		if(listFindNoCase(arguments.propertyList, "qmax") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQMAX( arguments.sku.getQMAX() );
		}
		if(listFindNoCase(arguments.propertyList, "qhb") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQHB( arguments.sku.getQHB() );
		}
		if(listFindNoCase(arguments.propertyList, "qomin") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQOMIN( arguments.sku.getQOMIN() );
		}
		if(listFindNoCase(arguments.propertyList, "qomax") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQOMAX( arguments.sku.getQOMAX() );
		}
		if(listFindNoCase(arguments.propertyList, "qvomin") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQVOMIN( arguments.sku.getQVOMIN() );
		}
		if(listFindNoCase(arguments.propertyList, "qvomax") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setQVOMAX( arguments.sku.getQVOMAX() );
		}
		if(listFindNoCase(arguments.propertyList, "allowShippingFlag") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setAllowShippingFlag( arguments.sku.getProduct().getSetting("allowShippingFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "allowPreorderFlag") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setAllowPreorderFlag( arguments.sku.getProduct().getSetting("allowPreorderFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "allowBackorderFlag") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setAllowBackorderFlag( arguments.sku.getProduct().getSetting("allowBackorderFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "allowDropshipFlag") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setAllowDropshipFlag( arguments.sku.getProduct().getSetting("allowDropshipFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "callToOrderFlag") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setCallToOrderFlag( arguments.sku.getProduct().getSetting("callToOrderFlag") );
		}
		if(listFindNoCase(arguments.propertyList, "trackInventoryFlag") || arguments.propertyList == "all" || skuCache.isNew()) {
			skuCache.setTrackInventoryFlag( arguments.sku.getProduct().getSetting("trackInventoryFlag") );
		}

		// Sku goes last otherwise the isNew() methods above wouldn't work on truly new skus
		if(skuCache.isNew()) {
			skuCache.setSku( arguments.sku );
		}
		
		getDAO().save( skuCache );
	}
	
}