component displayname="Product" entityname="SlatwallProduct" table="SlatwallProduct" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="productID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="active" ormtype="boolean" default="true" displayname="Active" hint="As Products Get Old, They would be marked as Not Active";
	property name="filename" ormtype="string" default="" displayname="File Name" hint="This is the name that is used in the URL string";
	property name="template" ormtype="string" default="" displayname="Design Template" hint="This is the Template to use for product display";
	property name="productName" ormtype="string" default="" displayname="Product Name" validateRequired="Product Name Is Required" hint="Primary Notation for the Product to be Called By";
	property name="productCode" ormtype="string" default="" displayname="Product Code" validateRequired="Product Code Is Required" hint="Product Code, Typically used for Manufacturer Coded";
	property name="productDescription" ormtype="string" default="" displayname="Product Description" hint="HTML Formated description of the Product";
	property name="productYear" ormtype="int" default="" displayname="Product Year" hint="Products specific model year if it has one";
	property name="manufactureDiscontinued"	ormtype="boolean" default=false persistent=true displayname="Manufacture Discounted" hint="This property can determine if a product can still be ordered by a vendor or not";
	property name="showOnWeb" ormtype="boolean" default=false displayname="Show On Web Retail" hint="Should this product be sold on the web retail Site";
	property name="showOnWebWholesale" ormtype="boolean" default=false persistent=true displayname="Show On Web Wholesale" hint="Should this product be sold on the web wholesale Site";
	property name="nonInventory" ormtype="boolean" default=false displayname="Non-Inventory Item";
	property name="callToOrder" ormtype="boolean" default=false displayname="Call To Order";
	property name="allowShipping" ormtype="boolean" default=true displayname="Allow Shipping";
	property name="allowPreorder" ormtype="boolean" default=true displayname="Allow Pre-Orders" hint="";
	property name="allowBackorder" ormtype="boolean" default=false displayname="Allow Backorders";
	property name="allowDropship" ormtype="boolean" default="false" displayname="Allow Dropship";
	property name="shippingWeight" ormtype="float" default="0" hint="This Weight is used to calculate shipping charges, gets overridden by sku Shipping Weight";
	property name="publishedWeight" ormtype="float" default="0" hint="This Weight is used for display purposes on the website, gets overridden by sku Published Weight";
	property name="createdDateTime" ormtype="date" default="" displayname="Date Create";
	property name="lastUpdatedDateTime"	ormtype="date" default="" displayname="Date Last Updated";
	
	// Related Object Properties
	property name="brand" displayname="Brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="skus" type="array" cfc="sku" singularname="SKU" fieldtype="one-to-many" fkcolumn="productID" cascade="all" inverse=true;
	property name="productType" displayname="Product Type" validateRequired cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="genderType" cfc="Type" fieldtype="many-to-one" fkcolumn="typeID" cascade="all" inverse=true;
	property name="madeInCountry" cfc="Country" fieldtype="many-to-one" fkcolumn="countryCode";
	property name="categories" singularname="category" cfc="Category" fieldtype="many-to-many" linktable="SlatwallProductCategory" fkcolumn="productID" inversejoincolumn="categoryID";
	
	// Non-Persistant Properties
	property name="gender" type="string" persistent="false";
	property name="title" type="string" persistent="false";
	property name="onTermSale" type="boolean" persistent="false";
	property name="onClearanceSale" type="boolean" persistent="false";
	property name="dateFirstReceived" type="date" persistent="false";
	property name="dateLastReceived" type="date" persistent="false";
	property name="livePrice" type="numeric" persistent="false";
	property name="originalPrice" type="numeric" persistent="false";
	property name="listPrice" type="numeric" persistent="false";
	property name="qoh" type="numeric" persistent="false";
	property name="qc" type="numeric" persistent="false";
	property name="qexp" type="numeric" persistent="false";
	property name="webQOH" type="numeric" persistent="false";
	property name="webQC" type="numeric" persistent="false";
	property name="webQEXP" type="numeric" persistent="false";
	property name="webWholesaleQOH" type="numeric" persistent="false";
	property name="webWholesaleQC" type="numeric" persistent="false";
	property name="webWholesaleQEXP" type="numeric" persistent="false";
	
	// Related Object Helpers
	public any function getBrand() {
		if(!isDefined("variables.brand")) {
			variables.brand = getService(service="BrandService").getNewEntity();
		}
		return variables.brand;
	}
	
	public any function getBrandOptions() {
		if(!isDefined("variables.brandOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallBrand");
			smartList.addSelect(rawProperty="brandName", aliase="name");
			smartList.addSelect(rawProperty="brandID", aliase="id"); 
			smartList.addOrder("brandName|ASC");
			variables.brandOptions = smartList.getAllRecords();
		}
		return variables.brandOptions;
	}
	
    public any function getProductTypeOptions() {
        if(!structKeyExists(variables,"propertyTypeOptions")) {
            var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallProductType");
            smartList.addSelect(rawProperty="productType", aliase="name");
            smartList.addSelect(rawProperty="productTypeID", aliase="id");
			smartList.addOrder("productType|ASC");
            variables.propertyTypeOptions = smartList.getAllRecords();
        }
        return variables.propertyTypeOptions;
    }
	
	public array function getSkus() {
		if(!isDefined("variables.skus")) {
			variables.skus = arrayNew(1);
		}
		return variables.skus;
	}
	
	public any function getGenderType() {
		if(!isDefined("variables.genderType")) {
			variables.genderType = getService(service="TypeService").getNewEntity(); //get New Entity here should have a parent programing type ID set in the future.
		}
		return variables.genderType;
	}
	
	public any function getTemplateOptions() {
		if(!isDefined("variables.templateOptions")){
			variables.templateOptions = getService(service="ProductService").getProductTemplates();
		}
		return variables.templateOptions;
	}
	
	/**
	/* @hint associates this product with categories (Mura Content objects)
	*/
	public void function assignCategories(required string categoryID) {
		getService(service="ProductService").assignCategories(this,arguments.categoryID);
	}
	
	// Non-Persistant Helpers
	public string function getGender() {
		if(!isDefined("variables.gender")) {
			variables.gender = getGenderType().getType();
		}
		return variables.gender;
	}
	
	public string function getTitle() {
		return "#getBrand().getBrandName()# #getProductYear()# #getProductName()#";
	}
	
	public string function getProductURL(boolean generateAdmin=false) {
		return "/index.cfm/sp/#getFilename()#";
	}
	
	public string function getDefaultImagePath() {
		//TODO: Add image path info and determine where Images should be stored.
		return "";
	}
	
	public numeric function getQIA() {
		return getQOH() - getQC();
	}
	
	// Association management methods for bidirectional relationships
	
	public void function setProductType(required ProductType ProductType) {
	   variables.productType = arguments.ProductType;
	   if(isNew() or !arguments.ProductType.hasProduct(this)) {
	       arrayAppend(arguments.ProductType.getProducts(),this);
	   }
	}
	
	public void function removeProductType(required ProductType ProductType) {
       var index = arrayFind(arguments.ProductType.getProducts(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.ProductType.getProducts(),index);
       }    
       structDelete(variables,"productType");
    }
	
    public any function getProductTypeTree() {
        return getService("ProductService").getProductTypeTree();
    }
}
