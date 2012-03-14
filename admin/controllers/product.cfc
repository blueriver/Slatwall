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
	property name="attributeService" type="any";
	property name="brandService" type="any";
	property name="contentService" type="any";
	property name="locationService" type="any";
	property name="optionService" type="any";
	property name="productService" type="any";
	property name="priceGroupService" type="any";
	property name="requestCacheService" type="any";
	property name="skuService" type="any";
	property name="subscriptionService" type="any";
	property name="utilityTagService" type="any";
	property name="utilityORMService" type="any";
		
		
	
	public void function before(required struct rc) {
		param name="rc.productID" default="";
		param name="rc.keyword" default="";
		param name="rc.edit" default="false";
	}
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:product.listproducts");
	}

    public void function createProduct(required struct rc) {
		if(!structKeyExists(rc,"product") or !isObject(rc.product) or !rc.product.isNew()) {
			rc.product = getProductService().newProduct();
		}
		rc.optionGroups = getProductService().listOptionGroupOrderBySortOrder();
		rc.subscriptionTerms = getSubscriptionService().listSubscriptionTerm();
    }
	
	public void function detailproduct(required struct rc) {
		param name="rc.edit" default="false";
		rc.product = getProductService().getProduct(rc.productID);
		if(!isNull(rc.product) ) {
			if(len(rc.product.getProductName())) {
				rc.itemTitle &= ": #rc.product.getProductName()#";
			}
		} else {
			getFW().redirect("admin:product.listproducts");
		}
		//rc.productPages = getProductService().getProductPages(siteID=rc.$.event('siteid'), returnFormat="nestedIterator");
		//rc.categories = getProductService().getMuraCategories(siteID=rc.$.event('siteid'), parentID=rc.$.slatwall.setting("product_rootProductCategory"));
		rc.productPages = getContentService().listContent(data={siteID=rc.$.event('siteid')});
		rc.categories = getContentService().listCategory(data={siteID=rc.$.event('siteid')});
		
		rc.attributeSets = rc.Product.getAttributeSets(["astProduct"]);
		rc.skuSmartList = getSkuService().getSkuSmartList(productID=rc.product.getProductID(), data=rc);
		rc.priceGroupSmartList = getPriceGroupService().getPriceGroupSmartList();
		rc.subscriptionTerms = getSubscriptionService().listSubscriptionTerm();
	}
	
	public void function editproduct(required struct rc) {
		detailProduct(rc);
		
		rc.priceGroupDataJSON = getPriceGroupService().getPriceGroupDataJSON();
		
		getFW().setView("admin:product.detailproduct");
		rc.edit = true;
		param name="rc.image" default="#getProductService().newImage()#";
	}

	public void function listproducts(required struct rc) {
		if(!structKeyExists(rc, "orderBy")) {
			rc.orderBy = "productType_productTypeName|ASC,brand_brandName|ASC,productName|ASC";
		}
		rc.productSmartList = getProductService().getProductSmartList(data=rc);
	}
	
	public void function saveproduct(required struct rc) {
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
				getFW().redirect(action="admin:product.editproduct",queryString="productID=#rc.product.getProductID()#");
			} else {
				getFW().redirect(action="admin:product.listproducts");
			}
		}
		
		// This logic only runs if the product has errors.  If it was a new product show the create page, otherwise show the edit page
		if( productWasNew ) {
			createProduct( rc );
			rc.slatAction="admin:product.createproduct";
			getFW().setView(action="admin:product.createproduct");
		} else {
			editProduct( rc );
			rc.slatAction="admin:product.editproduct";
		}
	}
	
	public void function detailInventory(required struct rc) {
		param name="rc.productID" default="";
		
		rc.product = getProductService().getProduct(rc.productID);
		rc.locations = getLocationService().listLocation();
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


	public void function detailbrand(required struct rc) {
		param name="rc.brandID" default="";
		param name="rc.edit" default="false";
		
		rc.brand = getBrandService().getBrand(rc.brandID, true);
	}

    public void function createbrand(required struct rc) {
		detailbrand(arguments.rc);
		getFW().setView("admin:product.detailbrand");
		rc.edit = true;
    }

	public void function editbrand(required struct rc) {
		detailbrand(arguments.rc);
		getFW().setView("admin:product.detailbrand");
		rc.edit = true;
	}
	 
    public void function listbrands(required struct rc) {
		rc.brands = getBrandService().listBrandOrderByBrandName();
    }

	public void function savebrand(required struct rc) {
	   detailbrand(arguments.rc);
	   
	   rc.brand = getBrandService().saveBrand(rc.brand, rc);
	   
	   if(!rc.brand.hasErrors()) {
	   		getFW().redirect(action="admin:product.detailbrand",querystring="message=admin.brand.save_success");
		} else {
			rc.itemTitle = rc.brand.isNew() ? rc.$.Slatwall.rbKey("admin.brand.create") : rc.$.Slatwall.rbKey("admin.brand.edit") & ": #rc.brand.getBrandName()#";
	   		getFW().setView(action="admin:product.detailbrand");
	   		rc.edit = true;
		}
	}
	
	public void function deletebrand(required struct rc) {
		
		var brand = getBrandService().getBrand(rc.brandID);
		
		var deleteOK = getBrandService().deleteBrand(brand);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.brand.delete_success");
		} else {
			rc.message = rbKey("admin.brand.delete_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:brand.list",preserve="message,messagetype");
	}
	
	public void function listOptionGroups(required struct rc) {
        param name="rc.orderBy" default="sortOrder|ASC";
        
        rc.optionGroupSmartList = getOptionService().getOptionGroupSmartList(data=arguments.rc);
        
    }
    
    public void function detailOptionGroup(required struct rc) {
    	param name="rc.optionGroupID" default="";
    	param name="rc.edit" default="false";
    	
    	rc.optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
    	
    	if(isNull(rc.optionGroup)) {
    		getFW().redirect(action="admin:option.listOptionGroups");
    	}
    }
    
    public void function createOptionGroup(required struct rc) {
    	editOptionGroup(rc);
	}
    
    public void function editOptionGroup(required struct rc) {
    	param name="rc.optionGroupID" default="";
    	param name="rc.optionID" default="";
    	
    	rc.optionGroup = getOptionService().getOptionGroup(rc.optionGroupID, true);
    	rc.option = getOptionService().getOption(rc.optionID, true);
    	
    	rc.edit = true;
    	getFW().setView("admin:product.detailoptiongroup"); 
    }
    
    public void function saveOptionGroup(required struct rc) {
		editOptionGroup(rc);
		
		rc.optionGroup = getOptionService().saveOptionGroup(rc.optionGroup, rc);
		
		if(!rc.optionGroup.hasErrors()) {
			rc.message="admin.product.saveoptiongroup_success";
			if(rc.populateSubProperties) {
				getFW().redirect(action="admin:option.editOptionGroup",querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#",preserve="message");	
			} else {
				getFW().redirect(action="admin:option.listOptionGroups",preserve="message");
			}
		} else {
			// If one of the sub-options had the error, then find out which one and populate it
			if(rc.optionGroup.hasError("options")) {
				for(var i=1; i<=arrayLen(rc.optionGroup.getOptions()); i++) {
					if(rc.optionGroup.getOptions()[i].hasErrors()) {
						rc.option = rc.optionGroup.getOptions()[i];
					}
				}
			}
			rc.edit = true;
			rc.itemTitle = rc.OptionGroup.isNew() ? rc.$.Slatwall.rbKey("admin.option.createOptionGroup") : rc.$.Slatwall.rbKey("admin.option.editOptionGroup") & ": #rc.optionGroup.getOptionGroupName()#";
			getFW().setView(action="admin:product.detailoptiongroup");
		}
	}
	public void function deleteOptionGroup(required struct rc) {
		param name="rc.optionGroupID" default="";
		
		var optionGroup = getOptionService().getOptionGroup(rc.optionGroupID);
		
		var deleteOK = getOptionService().deleteOptionGroup(optionGroup);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.product.deleteoptiongroup_success");
		} else {
			rc.message = rbKey("admin.optionGroup.deleteoptiongroup_failure");
		}
		
		getFW().redirect(action="admin:product.listOptionGroups", preserve="message");
	}
	
	public void function deleteOption(required struct rc) {
		
		var option = getOptionService().getOption(rc.optionid);
		var optionGroupID = option.getOptionGroup().getOptionGroupID();
		var deleteOK = getOptionService().deleteOption(option);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.option.delete_success");
		} else {
			rc.message = rbKey("admin.option.delete_failure");
			rc.messagetype="error";
		}
		
		getFW().redirect(action="admin:product.editOptionGroup", querystring="optiongroupid=#optionGroupID#",preserve="message,messagetype");
	}
	
	public void function saveOptionGroupSort(required struct rc) {
		param name="rc.optionGroupIDs" default="";
		
		getOptionService().saveOptionGroupSort(rc.optionGroupIDs);
		getFW().redirect("admin:product.listoptiongroups");
	}
	
	public void function saveOptionSort(required struct rc) {
		param name="rc.optionIDs" default="";
		
		getOptionService().saveOptionSort(rc.optionIDs);
		getFW().redirect("admin:product.listoptiongroups");
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
	
	// Handler is called by modal dialog, to update the price group configuration on a specific SKU
	public void function updatePriceGroupSKUSettings(required struct rc) { 
		getService("PriceGroupService").updatePriceGroupSKUSettings(data = rc);
		
		rc.message = rbKey("admin.sku.updatepricegroupsettings_success");
		getFW().redirect(action="admin:product.edit", querystring="productID=#rc.productId#", preserve="message");
	}
	
	// Handler is called by modal dialog, to update the price of all SKUs
	public void function updateSKUPrices(required struct rc) {
		getSKUService().updateAllSKUPricesForProduct(rc.productId, rc.price);
		
		rc.message = rbKey("admin.sku.updateallprices_success");
		getFW().redirect(action="admin:product.edit", querystring="productID=#rc.productId#", preserve="message");
	}
	
	// Handler is called by modal dialog, to update the weights of all SKUs
	public void function updateSKUWeights(required struct rc) {
		getSKUService().updateAllSKUWeightsForProduct(rc.productId, rc.weight);
		
		rc.message = rbKey("admin.sku.updateallweights_success");
		getFW().redirect(action="admin:product.edit", querystring="productID=#rc.productId#", preserve="message");
	}
		
}



