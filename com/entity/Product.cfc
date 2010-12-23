component displayname="Product" entityname="SlatProduct" table="slatproduct" persistent="true" extends="slat.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="productID" type="string" fieldtype="id" generator="guid";
	property name="active" type="boolean" default=true persistent=true displayname="Active" hint="As Products Get Old, They would be marked as Not Active";
	property name="filename" type="string" default="" persistent=true displayname="File Name" hint="This is the name that is used in the URL string";
	property name="template" type="string" default="" persistent=true displayname="Design Template" hint="This is the Template to use for product display";
	property name="productName" type="string" default="" persistent=true displayname="Product Name" hint="Primary Notation for the Product to be Called By";
	property name="productCode" type="string" default="" persistent=true displayname="Product Code" hint="Product Code, Typically used for Manufacturer Coded";
	property name="productDescription" type="string" default="" persistent=true displayname="Product Description" hint="HTML Formated description of the Product";
	property name="productYear" type="string" default="" persistent=true displayname="Product Year" hint="Products specific model year if it has one";
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
	property name="brand" type="array" cfc="brand" fieldtype="many-to-one" fkcolumn="BrandID" cascade="all" inverse=true;
	property name="skus" type="array" cfc="sku" fieldtype="one-to-many" fkcolumn="ProductID" cascade="all" inverse=true;
	property name="genderType" type="array" cfc="type" fieldtype="many-to-one" fkcolumn="TypeID" cascade="all" inverse=true;
	property name="madeInCountry" type="array" cfc="country" fieldtype="many-to-one" fkcolumn="CountryID" cascade="all" inverse=true;
	
	// Non-Persistant Properties
	property name="gender" type="string" persistent=false;
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
	
	// Non-Persistant Accessors
	public string function getGender() {
		if(!isDefined(variables.gender)) {
			variables.gender = getGenderType().getType();
		}
		return variables.gender;
	}
}
/*
	
	<!--- Nested Object Getters --->
	<cffunction name="getBrand">
		<cfargument name="BrandID" />
		<cfif not isDefined('variables.Brand')>
			<cfif isDefined('arguments.BrandID')>
				<cfset variables.Brand = getService("brandService").getByID(arguments.BrandID) />
			<cfelse>
				<cfset variables.Brand = entityNew('brand') />
			</cfif>
		</cfif>
		<cfreturn variables.Brand />
	</cffunction>
	
	<cffunction name="getGenderType">
		<cfargument name="GenderTypeID">
		<cfif not isDefined('variables.GenderType')>
			<cfif isDefined('arguments.GenderTypeID')>
				<cfset variables.GenderType = getService("typeService").getByID(argumnets.GenderTypeID) />
			<cfelse>
				<cfset variables.GenderType = entityNew('type') />
			</cfif>
		</cfif>
		<cfreturn variables.GenderType />
	</cffunction>
	
	<cffunction name="getSkus">
		<cfif not isDefined('variables.Skus')>
			<cfset variables.Skus = getService("skuService").getByProductID(getProductID()) />
		</cfif>
		<cfreturn variables.Skus />
	</cffunction>
	
	<!--- Non Persistant Getters / Setters --->
	<cffunction name="getQOH" returntype="numeric" access="public" output="false" hint="">
		<cfif not isDefined('variables.QOH')>
			<cfset variables.QOH = 0 />
		</cfif>
    	<cfreturn variables.QOH />
    </cffunction>
    <cffunction name="setQOH" access="private" output="false" hint="">
    	<cfargument name="QOH" type="numeric" required="true" />
    	<cfset variables.QOH = arguments.QOH />
    </cffunction>
    
	<!--- HELPER SET FUNCTIONS --->
	<cffunction name="setAllQuantities">
		<cfset var Skus = getSkus(getProductID()) />
		<cfset var Sku = "" />
		<cfset var TotalQOH = 0 />
		<cfset var TotalQC = 0 />
		<cfset var TotalQOO = 0 />
		<cfset var TotalWebRetailQOH = 0 />
		<cfset var TotalWebRetailQC = 0 />
		<cfset var TotalWebRetailQOO = 0 />
		<cfset var TotalWebWholesaleQOH = 0 />
		<cfset var TotalWebWholesaleQC = 0 />
		<cfset var TotalWebWholesaleQOO = 0 />
		<cfloop array="Skus" index="Sku">
			<cfset TotalQOH = TotalQOH + Skug.getQOH() />
			<cfset TotalQC = TotalQC + Skug.getQC() />
			<cfset TotalQOO = TotalQOO + Skug.getQOO() />
			<cfset TotalWebRetailQOH = TotalWebRetailQOH + Skug.getQOH />
			<cfset TotalWebRetailQC = TotalQOH + Skug.getQOH />
			<cfset TotalWebRetailQOO = TotalQOH + Skug.getQOH />
			<cfset TotalWebWholesaleQOH = TotalQOH + Skug.getQOH />
			<cfset TotalWebWholesaleQC = TotalQOH + Skug.getQOH />
			<cfset TotalWebWholesaleQOO = TotalQOH + Skug.getQOH />
		</cfloop>
	</cffunction>
		
	<!--- HELPER GET FUNCTIONS --->
	<cffunction name="getGender">
		<cfreturn getGenderType().getType() />
	</cffunction>
	
	<cffunction name="getTitle">
		<cfreturn "#getBrand().getBrandName()# #getProductYear()# #getProductName()#" />
	</cffunction>
	
	<cffunction name="getProductURL">
		<cfreturn "/index.cfm/sp/#getFilename()#" />
	</cffunction>
</cfcomponent>
*/