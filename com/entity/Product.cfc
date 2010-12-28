component displayname="Product" entityname="SlatwallProduct" table="SlatwallProduct" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="productID" type="string" fieldtype="id" generator="guid";
	property name="active" type="boolean" default=true persistent=true displayname="Active" hint="As Products Get Old, They would be marked as Not Active";
	property name="filename" type="string" default="" persistent=true displayname="File Name" hint="This is the name that is used in the URL string";
	property name="template" type="string" default="" persistent=true displayname="Design Template" hint="This is the Template to use for product display";
	property name="productName" type="string" default="" persistent=true displayname="Product Name" hint="Primary Notation for the Product to be Called By";
	property name="productCode" type="string" default="" persistent=true displayname="Product Code" hint="Product Code, Typically used for Manufacturer Coded";
	property name="productDescription" type="string" default="" persistent=true displayname="Product Description" hint="HTML Formated description of the Product";
	property name="productYear" type="numeric" default=0 persistent=true displayname="Product Year" hint="Products specific model year if it has one";
	property name="manufactureDiscontinued"	type="boolean" default=false persistent=true displayname="Manufacture Discounted" hint="This property can determine if a product can still be ordered by a vendor or not";
	property name="showOnWebRetail"	type="boolean" default=false persistent=true displayname="Show On Web Retail" hint="Should this product be sold on the web retail Site";
	property name="showOnWebWholesale" type="boolean" default=false persistent=true displayname="Show On Web Wholesale" hint="Should this product be sold on the web wholesale Site";
	property name="nonInventoryItem" type="boolean" default=false persistent=true displayname="Non-Inventory Item";
	property name="callToOrder" type="boolean" default=false persistent=true displayname="Call To Order";
	property name="allowShipping" type="boolean" default=true persistent=true displayname="Allow Shipping";
	property name="allowPreorder" type="boolean" default=true persistent=true displayname="Allow Pre-Orders" hint="";
	property name="allowBackorder" type="boolean" default=false persistent=true displayname="Allow Backorders";
	property name="allowDropship" type="boolean" default=false persistent=true displayname="Allow Dropship";
	property name="shippingWeight" type="numeric" default=0 persistent=true hint="This Weight is used to calculate shipping charges, gets overridden by sku Shipping Weight";
	property name="publishedWeight" type="numeric" default=0 persistent=true hint="This Weight is used for display purposes on the website, gets overridden by sku Published Weight";
	property name="dateCreated" type="date" default="" persistent=true displayname="Date Create";
	property name="dateLastUpdated"	type="date" default="" persistent=true displayname="Date Last Updated";
	
	// Related Object Properties
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID" cascade="all" inverse=true;
	property name="skus" type="array" cfc="sku" fieldtype="one-to-many" fkcolumn="productID" cascade="all" inverse=true;
	property name="genderType" cfc="Type" fieldtype="many-to-one" fkcolumn="typeID" cascade="all" inverse=true;
	property name="madeInCountry" cfc="Country" fieldtype="many-to-one" fkcolumn="countryID" cascade="all" inverse=true;
	
	// Non-Persistant Properties
	property name="gender" type="string" persistent=false;
	property name="title" type="string" persistent=false;
	property name="productURL" type="string" persistent=false;
	property name="onTermSale" type="boolean" persistent=false;
	property name="onClearanceSale" type="boolean" persistent=false;
	property name="dateFirstReceived" type="date" persistent=false;
	property name="dateLastReceived" type="date" persistent=false;
	property name="livePrice" type="numeric" persistent=false;
	property name="originalPrice" type="numeric" persistent=false;
	property name="listPrice" type="numeric" persistent=false;
	property name="QOH" type="numeric" persistent=false;
	property name="QC" type="numeric" persistent=false;
	property name="QOO" type="numeric" persistent=false;
	property name="webRetailQOH" type="numeric" persistent=false;
	property name="webRetailQC" type="numeric" persistent=false;
	property name="webRetailQOO" type="numeric" persistent=false;
	property name="webWholesaleQOH" type="numeric" persistent=false;
	property name="webWholesaleQC" type="numeric" persistent=false;
	property name="webWholesaleQOO" type="numeric" persistent=false;
	
	// Related Object Helpers
	public any function getBrand() {
		if(!isDefined("variables.brand")) {
			variables.brand = getService(service="BrandService").getNewEntity();
		}
		return variables.brand;
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
		return variables.skus;
	}
	
	// Non-Persistant Helpers
	public string function getGender() {
		if(!isDefined(variables.gender)) {
			variables.gender = getGenderType().getType();
		}
		return variables.gender;
	}
	
	public string function getTitle() {
		return "#getBrand().getBrandName()# #getProductYear()# #getProductName()#";
	}
	
	public string function getProductURL() {
		return "/index.cfm/sp/#getFilename()#";
	}	
}