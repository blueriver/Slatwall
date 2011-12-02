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
component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";
	property name="skuService" type="Slatwall.com.service.SkuService";
	property name="attributeService" type="Slatwall.com.service.AttributeService";
	property name="priceGroupService" type="Slatwall.com.service.PriceGroupService";
	property name="requestCacheService" type="Slatwall.com.service.RequestCacheService";
	property name="utilityTagService" type="Slatwall.com.service.UtilityTagService";
	property name="utilityORMService" type="Slatwall.com.service.UtilityORMService";
	
	public void function before(required struct rc) {
		param name="rc.productID" default="";
		param name="rc.keyword" default="";
		param name="rc.edit" default="false";
	}
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:product.list");
	}

    public void function create(required struct rc) {
		if(!structKeyExists(rc,"product") or !isObject(rc.product) or !rc.product.isNew()) {
			rc.product = getProductService().newProduct();
		}
		rc.optionGroups = getProductService().listOptionGroupOrderBySortOrder();
    }
	
	public void function detail(required struct rc) {
		param name="rc.edit" default="false";
		rc.product = getProductService().getProduct(rc.productID);
		if(!isNull(rc.product) ) {
			if(len(rc.product.getProductName())) {
				rc.itemTitle &= ": #rc.product.getProductName()#";
			}
		} else {
			getFW().redirect("admin:product.list");
		}
		rc.productPages = getProductService().getProductPages(siteID=rc.$.event('siteid'), returnFormat="nestedIterator");
		rc.attributeSets = rc.Product.getAttributeSets(["astProduct"]);
		rc.skuSmartList = getSkuService().getSkuSmartList(productID=rc.product.getProductID(), data=rc);
		rc.categories = getProductService().getMuraCategories(siteID=rc.$.event('siteid'), parentID=rc.$.slatwall.setting("product_rootProductCategory"));
		rc.priceGroups = getPriceGroupService().getPriceGroupSmartList();
	}
	
	public void function edit(required struct rc) {
		detail(rc);
		getFW().setView("admin:product.detail");
		rc.edit = true;
		param name="rc.Image" default="#getProductService().newImage()#";
	}

	public void function list(required struct rc) {
		if(!structKeyExists(rc, "orderBy")) {
			rc.orderBy = "productType_productTypeName|ASC,brand_brandName|ASC,productName|ASC";
		}
		rc.productSmartList = getProductService().getProductSmartList(data=rc);
	}
	
	public void function save(required struct rc) {
		param name="rc.productID" default="";
		
		
		
		
		// We are going to be flushing ORM, so we need to check if the product was new before that flush
		var productWasNew = true;
		
		// Load the product
		rc.product = getProductService().getProduct(rc.productID, true);
		
		// Set the wasNewProduct as fall if the product is not new
		if( !rc.product.isNew() ) {
			productWasNew = false;
		}
		
		
		// Attempt to Save Product
		rc.product = getProductService().saveProduct( rc.product, rc );
		
		
		// If the product doesn't have any errors then redirect to detail or list
		if(!rc.product.hasErrors()) {
			if( productWasNew ) {
				getFW().redirect(action="admin:product.edit",queryString="productID=#rc.product.getProductID()#");
			} else {
				getFW().redirect(action="admin:product.list");
			}
		}
		
		// This logic only runs if the product has errors.  If it was a new product show the create page, otherwise show the edit page
		if( productWasNew ) {
			create( rc );
			getFW().setView(action="admin:product.create");
		} else {
			edit( rc );
		}
	}
	
	public void function deleteImage(required struct rc) {
		var product = getProductService().getProduct(rc.productID);
		var image = getProductService().getImage(rc.imageID);
		if(!isNull(product) && !isNull(image)) {
			var removed = getProductService().removeAlternateImage(image,product);
			if(removed) {
				rc.message = rc.$.Slatwall.rbKey("admin.product.deleteImage_success");
			} else {
				rc.message = rc.$.Slatwall.rbKey("admin.product.deleteImage_error");
				rc.messageType = "error";
			}
			getFW().redirect(action="admin:product.detail&productID=#product.getProductID()#",preserve="message,messageType");		
		} else {
			getFW().redirect(action="admin:product.detail&productID=#product.getProductID()#");			
		}
	}
	
	public void function delete(required struct rc) {
		var product = getProductService().getProduct(rc.productID);
		
		var deleteOK = getProductService().deleteProduct(product);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.product.delete_success");
		} else {
			rc.message = rbKey("admin.product.delete_error");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:product.list",preserve="message,messageType");
	}
	
	// SKU actions
	
	public void function deleteSku(required struct rc) {
		
		var sku = getSkuService().getSku(rc.skuID);
		var productID = sku.getProduct().getProductID();
		
		var deleteOK = getSkuService().deleteSku( sku );
		
		if( deleteOK ) {
			rc.message = rbKey("admin.product.deleteSku_success");
		} else {
			rc.message = rbKey("admin.product.deleteSku_error");
			rc.messageType = "error";
		}
		
		getFW().redirect(action="admin:product.edit",querystring="productID=#productID#",preserve="message,messageType");
	}
	
	public void function uploadSkuImage(required struct rc) {
		rc.sku = getSkuService().getSku(rc.skuID);
		
		// upload the image and return the result struct if there was an upload
		if(structKeyExists(rc, "skuImageFile") && rc.skuImageFile != "") {
			var imageUploadResult = getUtilityTagService().cffile(action="upload", destination=getTempDirectory(), filefield="skuImageFile", accept="", nameconflict="makeUnique");
			
			//var temp = fileUpload(getTempDirectory(),"skuImageFile","","makeUnique");
			
			rc.uploadSuccess = getSkuService().processImageUpload(rc.sku, imageUploadResult);
			if(rc.uploadSuccess) {
				rc.message = rc.$.Slatwall.rbKey("admin.product.uploadSkuImage_success");
			} else {
				rc.message = rc.$.Slatwall.rbKey("admin.product.uploadSkuImage_error");
				rc.messagetype = "error";
			}
			getFW().redirect(action="admin:product.edit",querystring="productID=#rc.sku.getProduct().getProductID()#",preserve="message,messagetype");
		} 
	}
	
	//   Product Type actions      
		
	public void function createProductType(required struct rc) {
	   rc.edit=true;
	   rc.productType = getProductService().newProductType();
	   rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
	   getFW().setView("admin:product.detailproducttype");
	}
		
	public void function editProductType(required struct rc) {	
	   	rc.productType = getProductService().getProductType(rc.productTypeID);
		rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
	   	if(!isNull(rc.productType)) {
	   		rc.edit = true;
		   	rc.itemTitle &= ": " & rc.productType.getProductTypeName();
		   	getFW().setView("admin:product.detailproducttype");
	   	} else {
           	getFW().redirect("admin:product.listproducttypes");
		}
	}
	
	public void function listProductTypes(required struct rc) {
       rc.productTypes = getProductService().getProductTypeTree();
	}
	
	public void function detailProductType(required struct rc) {
		rc.productType = getProductService().getProductType(rc.productTypeID);
		rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
		if(isNull(rc.productType)) {
			getFW().redirect("admin:product.listProductTypes");
		} else {
			rc.itemTitle &= ": " & rc.productType.getProductTypeName();
		}
	}
	
	public void function saveProductType(required struct rc) {
		param name="rc.productTypeID" default="";
		
		rc.productType = getProductService().getProductType(rc.productTypeID, true);
		
		rc.productType = getProductService().saveProductType(rc.productType,rc);
		
		if(!rc.productType.hasErrors()) {
			// no errors, redirect to list with success message
			rc.message = "admin.product.saveproducttype_success";
		  	getFW().redirect(action="admin:product.listproducttypes",preserve="message");
		} else {
			// errors, so show edit view again
		  rc.edit = true;
		  rc.attributeSets = getAttributeService().getAttributeSets(["astProduct","astProductCustomization"]);
		  rc.itemTitle = rc.productType.isNew() ? rc.$.Slatwall.rbKey("admin.product.createProductType") : rc.$.Slatwall.rbKey("admin.product.editProductType") & ": #rc.productType.getProductTypeName()#";
		  getFW().setView(action="admin:product.detailproducttype");
        }
	}
	
	public void function deleteProductType(required struct rc) {
		
		var productType = getProductService().getProductType(rc.productTypeID);
		var deleteOK = getProductService().deleteProductType(productType);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.product.deleteProductType_success");
		} else {
			rc.message = rbKey("admin.product.deleteProductType_error");
			rc.messageType="error";
		}
		
		getFW().redirect(action="admin:product.listproducttypes",preserve="message,messageType");
	}

	public void function searchProductsByType(required struct rc) {
		rc.productList = getProductService().searchProductsByProductType(term=rc.term,productTypeID=rc.productTypeID);
	}
	
	public void function searchSkusByProductType(required struct rc) {
		if(structKeyExists(rc,"productTypeID") && rc.productTypeID != "0") {
			var productTypeIDs = getProductService().getChildProductTypeIDs(rc.productTypeID);
		} else {
			var productTypeIDs = "";
		}
		rc.skuList = getSkuService().searchSkusByProductType(term=rc.term,productTypeID=productTypeIDs);
	}
		
}
