<cfcomponent displayname="Product" table="slatproduct" persistent="true" extends="slat.com.entity.baseEntity">
	
	<!--- Standard Persistant Properties --->
	<cfproperty name="ProductID"				type="uuid" fieldtype="id" generator="uuid" />
	<cfproperty name="Active" 					type="boolean" default=true displayname="Active" hint="As Products Get Old, They would be marked as Not Active" />
	<cfproperty name="ProductName"				type="string" default="" displayname="Product Name" hint="Primary Notation for the Product to be Called By" />
	<cfproperty name="ProductCode"				type="string" default="" displayname="Product Code" hint="Product Code, Typically used for Manufacturer Coded" />
	<cfproperty name="ProductDescription"		type="string" default="" displayname="Product Description" hint="HTML Formated description of the Product" />
	<cfproperty name="ProductYear"				type="string" default="" displayname="Product Year" hint="Products specific model year if it has one" />
	<cfproperty name="ManufactureDiscontinued" 	type="boolean" default=false displayname="Manufacture Discounted" hint="This property can determine if a product can still be ordered by a vendor or not" />
	<cfproperty name="ShowOnWebRetail"			type="boolean" default=false displayname="Show On Web Retail" hint="Should this product be sold on the web retail Site" />
	<cfproperty name="ShowOnWebWholesale"		type="boolean" default=false displayname="Show On Web Wholesale" hint="Should this product be sold on the web wholesale Site" />
	<cfproperty name="NonInventoryItem"			type="boolean" default=false displayname="Non-Inventory Item" />
	<cfproperty name="CallToOrder"				type="boolean" default=false displayname="Call To Order" />
	<cfproperty name="AllowShipping"			type="boolean" default=true displayname="Allow Shipping" />
	<cfproperty name="AllowPreorder"			type="boolean" default=true displayname="Allow Pre-Orders" hint="" />
	<cfproperty name="AllowBackorder"			type="boolean" default=false displayname="Allow Backorders" />
	<cfproperty name="AllowDropship"			type="boolean" default=false displayname="Allow Dropship" />
	<cfproperty name="ShippingWeight"			type="numeric" default=0 hint="This Weight is used to calculate shipping charges, gets overridden by sku Shipping Weight" />
	<cfproperty name="PublishedWeight"			type="numeric" default=0 hint="This Weight is used for display purposes on the website, gets overridden by sku Published Weight" />
	<cfproperty name="DateCreated"				type="date" default="" displayname="Date Create" />
	<cfproperty name="DateLastUpdated"			type="date" default="" displayname="Date Last Updated" />
		
	<!--- Related and Nested Objects --->
	<cfproperty name="Brand"			type="array" cfc="brand" fieldtype="many-to-one" fkcolumn="BrandID" cascade="all" inverse="true" />
	<cfproperty name="Skus"				type="array" cfc="sku" fieldtype="one-to-many" fkcolumn="ProductID" cascade="all" inverse="true" /> 
	<cfproperty name="GenderType"		type="array" cfc="type" fieldtype="many-to-one" fkcolumn="TypeID" cascade="all" inverse="true" />
	<cfproperty name="MadeInCountry"	type="array" cfc="country" fieldtype="many-to-one" fkcolumn="CountryID" cascade="all" inverse="true" />
	
	<!--- Non Persistant Properties --->
	<cfproperty name="OnTermSale" 			type="boolean" persistent=false />
	<cfproperty name="OnClearanceSale" 		type="boolean" persistent=false />
	<cfproperty name="DateFirstReceived" 	type="date" persistent=false />
	<cfproperty name="DateLastReceived" 	type="date" persistent=false />
	<cfproperty name="LivePrice" 			type="numeric" persistent="false" />
	<cfproperty name="OriginalPrice"		type="numeric" persistent="false"  />
	<cfproperty name="ListPrice" 			type="numeric" persistent="false" />
	<cfproperty name="QOH" 					type="numeric" persistent="false" />
	<cfproperty name="QC" 					type="numeric" persistent="false" />
	<cfproperty name="QOO" 					type="numeric" persistent="false" />
	<cfproperty name="WebRetailQOH" 		type="numeric" persistent="false" />
	<cfproperty name="WebRetailQC" 			type="numeric" persistent="false" />
	<cfproperty name="WebRetailQOO" 		type="numeric" persistent="false" />
	<cfproperty name="WebWholesaleQOH" 		type="numeric" persistent="false" />
	<cfproperty name="WebWholesaleQC" 		type="numeric" persistent="false" />
	<cfproperty name="WebWholesaleQOO" 		type="numeric" persistent="false" />
	
	<!--- Nested Object Getters --->
	<cffunction name="getBrand">
		<cfargument name="BrandID" />
		<cfif not isDefined('variables.Brand')>
			<cfif isDefined('arguments.BrandID')>
				<cfset variables.Brand = variables.brandService.getByID(arguments.BrandID) />
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
				<cfset variables.GenderType = variables.typeService.getByID(argumnets.GenderTypeID) />
			<cfelse>
				<cfset variables.GenderType = entityNew('type') />
			</cfif>
		</cfif>
		<cfreturn variables.GenderType />
	</cffunction>
	
	<cffunction name="getSkus">
		<cfif not isDefined('variables.Skus')>
			<cfset variables.Skus = variables.skuService.getByProductID(getProductID()) />
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
	
	<cffunction name="getWebRetailLink">
		<cfreturn "/index.cfm/product/?ProductID?=#getProductID()#" />
	</cffunction>
</cfcomponent>
