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
component displayname="Promotion Qualifier Exclusion" entityname="SlatwallPromotionQualifierExclusion" table="SlatwallPromotionQualifierExclusion" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="promotionQualifierExclusionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Related Entities
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	
	// Related Object Properties (many-to-many)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExclusionBrand" fkcolumn="promotionQualifierExclusionID" inversejoincolumn="brandID";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExclusionOption" fkcolumn="promotionQualifierExclusionID" inversejoincolumn="optionID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExclusionSku" fkcolumn="promotionQualifierExclusionID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExclusionProduct" fkcolumn="promotionQualifierExclusionID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExclusionProductType" fkcolumn="promotionQualifierExclusionID" inversejoincolumn="productTypeID";
	property name="productContent" cfc="PromotionQualifierExclusionProductContent" fieldtype="one-to-many" fkcolumn="promotionQualifierExclusionID" cascade="all-delete-orphan" inverse="true";
	property name="productCategories" singularname="productCategory" cfc="PromotionQualifierExclusionProductCategory" fieldtype="one-to-many" fkcolumn="promotionQualifierExclusionID" cascade="all-delete-orphan" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";

	public any function init() {

		if(isNull(variables.brands)) {
			variables.brands = [];
		}
		if(isNull(variables.options)) {
			variables.options = [];
		}
		if(isNull(variables.skus)) {
			variables.skus = [];
		}
		if(isNull(variables.products)) {
			variables.products = [];
		}	   
		if(isNull(variables.productTypes)) {
			variables.productTypes = [];
		}
		if(isNull(variables.productContent)) {
			variables.productContent = [];
		}
		if(isNull(variables.productCategories)) {
			variables.productCategories = [];
		}
		return Super.init();
	}

	
	// ========= Association management methods for bidirectional relationships ============
	
	// Promotion (many-to-one)
	
	public void function setPromotion(required Promotion promotion) {
		variables.promotion = arguments.promotion;
		if(!arguments.promotion.hasPromotionQualifier(this)) {
			arrayAppend(arguments.promotion.getPromotionQualifiers(),this);
		}
	}
	
	public void function removePromotion(Promotion promotion) {
	   if(!structKeyExists(arguments,"promotion")) {
	   		arguments.promotion = variables.promotion;
	   }
       var index = arrayFind(arguments.promotion.getPromotionQualifiers(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.promotion.getPromotionQualifiers(), index);
       }
       structDelete(variables,"promotion");
    }
    
	// brand (many-to-many)
	
	public void function addBrand(required any Brand) {
		if(arguments.Brand.isNew() || !hasBrand(arguments.Brand)) {
			// first add brand to this qualifier
			arrayAppend(this.getBrands(),arguments.Brand);
			//add this qualifier to the brand
			arrayAppend(arguments.Brand.getPromotionQualifierExclusions(),this);
		}
	}
    
    public void function removeBrand(required any Brand) {
       // first remove the brand from this qualifier
       if(this.hasBrand(arguments.Brand)) {
	       var index = arrayFind(this.getBrands(),arguments.Brand);
	       if(index>0) {
	           arrayDeleteAt(this.getBrands(),index);
	       }
	      // then remove this qualifier from the brand
	       var index = arrayFind(arguments.Brand.getPromotionQualifierExclusions(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.Brand.getPromotionQualifierExclusions(),index);
	       }
	   }
    }	

	// options (many-to-many)
	
	public void function addOption(required any Option) {
		if(arguments.Option.isNew() || !hasOption(arguments.Option)) {
			// first add option to this qualifier
			arrayAppend(this.getOptions(),arguments.Option);
			//add this qualifier to the option
			arrayAppend(arguments.Option.getPromotionQualifierExclusions(),this);
		}
	}
    
    public void function removeOption(required any Option) {
       // first remove the option from this qualifier
       if(this.hasOption(arguments.Option)) {
	       var index = arrayFind(this.getOptions(),arguments.Option);
	       if(index>0) {
	           arrayDeleteAt(this.getOptions(),index);
	       }
	      // then remove this qualifier from the option
	       var index = arrayFind(arguments.Option.getPromotionQualifierExclusions(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.Option.getPromotionQualifierExclusions(),index);
	       }
	   }
    }

	// sku (many-to-many)
	
	public void function addSku(required any Sku) {
		if(arguments.Sku.isNew() || !hasSku(arguments.Sku)) {
			// first add sku to this qualifier
			arrayAppend(this.getSkus(),arguments.Sku);
			//add this qualifier to the sku
			arrayAppend(arguments.sku.getPromotionQualifierExclusions(),this);
		}
	}
    
    public void function removeSku(required any sku) {
       // first remove the sku from this qualifier
       if(this.hasSku(arguments.sku)) {
	       var index = arrayFind(this.getSkus(),arguments.sku);
	       if(index>0) {
	           arrayDeleteAt(this.getSkus(),index);
	       }
	      // then remove this qualifier from the sku
	       var index = arrayFind(arguments.sku.getPromotionQualifierExclusions(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.sku.getPromotionQualifierExclusions(),index);
	       }
	   }
    }
    
	// product (many-to-many)
	
	public void function addProduct(required any product) {
		if(arguments.product.isNew() || !hasProduct(arguments.product)) {
			// first add product to this qualifier
			arrayAppend(this.getProducts(),arguments.product);
			//add this qualifier to the product
			arrayAppend(arguments.product.getPromotionQualifierExclusions(),this);
		}
	}
    
    public void function removeProduct(required any product) {
       // first remove the product from this qualifier
       if(this.hasProduct(arguments.product)) {
	       var index = arrayFind(this.getProducts(),arguments.product);
	       if(index>0) {
	           arrayDeleteAt(this.getProducts(),index);
	       }
	      // then remove this qualifier from the product
	       var index = arrayFind(arguments.product.getPromotionQualifierExclusions(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.product.getPromotionQualifierExclusions(),index);
	       }
	   }
    }
    
	// productType (many-to-many)
	
	public void function addProductType(required any ProductType) {
		if(arguments.ProductType.isNew() || !hasProductType(arguments.ProductType)) {
			// first add productType to this qualifier
			arrayAppend(this.getProductTypes(),arguments.ProductType);
			//add this qualifier to the productType
			arrayAppend(arguments.ProductType.getPromotionQualifierExclusions(),this);
		}
	}
    
    public void function removeProductType(required any ProductType) {
       // first remove the productType from this qualifier
       if(this.hasProductType(arguments.ProductType)) {
	       var index = arrayFind(this.getProductTypes(),arguments.ProductType);
	       if(index>0) {
	           arrayDeleteAt(this.getProductTypes(),index);
	       }
	      // then remove this qualifier from the productType
	       var index = arrayFind(arguments.ProductType.getPromotionQualifierExclusions(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.ProductType.getPromotionQualifierExclusions(),index);
	       }
	   }
    }
    
	// ProductContent (one-to-many)    

	public void function addProductContent(required any productContent) {    
	   arguments.productContent.setPromotionQualifierExclusion(this);    
	}    
	    
	public void function removeProductContent(required any productContent) {    
	   arguments.productContent.removePromotionQualifierExclusion(this);    
	}
	
	// productCategory (one-to-many)

	public void function addProductCategory(required any productCategory) {
	   arguments.productCategory.setPromotionQualifierExclusion(this);
	}
	
	public void function removeProductCategory(required any productCategory) {
	   arguments.productCategory.removePromotionQualifierExclusion(this);
	}

    
   // ============   END Association Management Methods   =================
	
	public any function getProductsOptions() {
		if(!structKeyExists(variables, "productsOptions")) {
			var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallProduct");
			smartList.addSelect(propertyIdentifier="productName", alias="name");
			smartList.addSelect(propertyIdentifier="productID", alias="value");
			smartList.addFilter(propertyIdentifier="activeFlag", value=1);
			smartList.addOrder("productName|ASC");
			variables.productsOptions = smartList.getRecords();
		}
		return variables.productsOptions;
	}
	
	public array function getProductContentOptions() {
		var productContentOptions = [];
		var productPages = getService("productService").getProductPages(siteID=$.event('siteid'));
		
		while( productPages.hasNext() ) {
			local.thisProductPage = productPages.next();
			arrayAppend( productContentOptions, {name=local.thisProductPage.getTitle(),value=listChangeDelims(local.thisProductPage.getPath(),' ')} );
		}
		return productContentOptions;
	}
	
	public array function getProductCategoriesOptions() {
		var productCategoriesOptions = [];
		// get mura categories
		var categories = getService("productService").getMuraCategories(siteID=$.event('siteid'), parentID=$.slatwall.setting("product_rootProductCategory"));
		
		for( var i=1;i<=categories.recordCount;i++ ) {
			local.thisCategoryPath = replace(categories.path[i],"'","","all");
			local.thisCategoryPath = replace(local.thisCategoryPath,","," ","all");
			arrayAppend( productCategoriesOptions, {name=categories.name[i],value=local.thisCategoryPath} );
		}
		return productCategoriesOptions;
	}

	public string function displayBrandNames() {
		var brandNames = "";
		for( var i=1; i<=arrayLen(this.getBrands());i++ ) {
			brandNames = listAppend(brandNames, " " & this.getBrands()[i].getBrandName());
		}
		return brandNames;
	}
	
	public string function displayOptionNames() {
		var optionNames = "";
		for( var i=1; i<=arrayLen(this.getOptions());i++ ) {
			optionNames = listAppend(optionNames, " " & this.getOptions()[i].getOptionName());
		}
		return optionNames;
	}
	
	public string function displayProductTypeNames() {
		var productTypeNames = "";
		for( var i=1; i<=arrayLen(this.getProductTypes());i++ ) {
			productTypeNames = listAppend(productTypeNames, " " & this.getProductTypes()[i].getProductTypeName());
		}
		return productTypeNames;
	}

	public string function displayProductNames() {
		var productNames = "";
		for( var i=1; i<=arrayLen(this.getProducts());i++ ) {
			productNames = listAppend(productNames, " " & this.getProducts()[i].getProductName());
		}
		return productNames;
	}
	
	public string function displaySkuCodes() {
		var skuCodes = "";
		for( var i=1; i<=arrayLen(this.getSkus());i++ ) {
			skuCodes = listAppend(skuCodes, " " & this.getSkus()[i].getSkuCode());
		}
		return skuCodes;
	}

	public string function displayProductCategoryNames() {
		var names = "";
		for( var i=1; i<=arrayLen(this.getProductCategories());i++ ) {
			local.thisCategoryName = $.getBean("category").loadBy( categoryID=getProductCategories()[i].getCategoryID() ).getName();
			names = listAppend(names,local.thisCategoryName);
		}
		return names;
	}
	
	public string function displayProductPageNames() {
		var names = "";
		for( var i=1; i<=arrayLen(this.getProductContent());i++ ) {
			local.thisPageTitle = $.getBean("content").loadBy( contentID=getProductContent()[i].getContentID() ).getTitle();
			names = listAppend(names,local.thisPageTitle);
		}
		return names;
	}

	public string function getProductTypeIDs() {
		var productTypeIDs = "";
		for( var i=1; i<=arrayLen(this.getProductTypes());i++ ) {
			productTypeIDs = listAppend(productTypeIDs,this.getProductTypes()[i].getProductTypeID());
		}
		return productTypeIDs;
	}
	
	public string function getProductIDs() {
		var productIDs = "";
		for( var i=1; i<=arrayLen(this.getProducts());i++ ) {
			productIDs = listAppend(productIDs,this.getProducts()[i].getProductID());
		}
		return productIDs;
	}
	
	public string function getSkuIDs() {
		var skuIDs = "";
		for( var i=1; i<=arrayLen(this.getSkus());i++ ) {
			skuIDs = listAppend(skuIDs,this.getSkus()[i].getSkuID());
		}
		return skuIDs;
	}
	
	public string function getCategoryPaths() {
		var paths = "";
		for( var i=1; i<=arrayLen(this.getProductCategories());i++ ) {
			paths = listAppend(paths,replace( this.getProductCategories()[i].getCategoryPath(),","," ","all"));
		}
		return paths;
	}
	
	public string function getContentPaths() {
		var paths = "";
		for( var i=1; i<=arrayLen(this.getProductContent());i++ ) {
			paths = listAppend(paths,replace( this.getProductContent()[i].getContentPath(),","," ","all"));
		}
		return paths;
	}

	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}