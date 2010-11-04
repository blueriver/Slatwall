<cfcomponent displayname="Product" table="slatproduct" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="ProductID" fieldtype="id" generator="guid" />
	
	<cfproperty name="Active" type="boolean" default=true hint="As Products Get Old, They would be marked as Not Active" />
	<cfproperty name="ManufactureDiscontinued" default=false type="boolean" hint="This property can determine if a product can still be ordered by a vendor or not" />
	<cfproperty name="ShowOnWebRetail" default=false type="boolean" hint="Should this product be sold on the web retail Site" />
	<cfproperty name="ShowOnWebWholesale" default=false type="boolean" hint="Should this product be sold on the web wholesale Site" />
	<cfproperty name="NonInventoryItem" default=false type="boolean" />
	<cfproperty name="CallToOrder" default=false type="boolean" />
	<cfproperty name="InStoreOnly" default=false type="boolean" />
	<cfproperty name="AllowPreorder" default=false type="boolean" hint="" />
	<cfproperty name="AllowBackorder" default=false type="boolean" />
	<cfproperty name="AllowDropship" default=false type="boolean" />
	<cfproperty name="ProductName" type="string" default="" hint="Primary Notation for the Product to be Called By" />
	<cfproperty name="ProductCode" type="string" default="" hint="Product Code, Typically used for Manufacturer Coded" />
	<cfproperty name="ProductDescription" type="string" default="" hint="HTML Formated description of the Product" />
	<cfproperty name="ProductYear" type="string" default="" />
	<cfproperty name="MadeInCountryCode" type="string" default="" />
	<cfproperty name="ShippingWeight" type="numeric" default=0 hint="This Weight is used to calculate shipping charges, gets overridden by sku Shipping Weight" />
	<cfproperty name="PublishedWeight" type="numeric" default=0 hint="This Weight is used for display purposes on the website, gets overridden by sku Published Weight" />
	<cfproperty name="DateCreated" type="date" default="" />
	<cfproperty name="DateLastUpdated" type="date" default="" />

		
	<!--- Related and Nested Objects --->
	<cfproperty name="Brand" cfc="brand" fieldtype="many-to-one" fkcolumn="BrandID" cascade="all" inverse="true" fetch="join"  />
	<cfproperty name="Skus" cfc="sku" fieldtype="one-to-many" fkcolumn="ProductID" type="array" cascade="all" inverse="true" /> 
	<cfproperty name="GenderType" cfc="type" fieldtype="many-to-one" fkcolumn="TypeID" cascade="all" inverse="true" />
	
	<!--- Non Persistant Properties --->
	<cfproperty name="OnTermSale" persistent=false type="boolean" />
	<cfproperty name="OnClearanceSale" persistent=false type="boolean" />
	<cfproperty name="DateFirstReceived" persistent=false type="date" />
	<cfproperty name="DateLastReceived" persistent=false type="date" />
	<cfproperty name="LivePrice" persistent="false" type="numeric" />
	<cfproperty name="OriginalPrice" persistent="false" type="numeric"  />
	<cfproperty name="ListPrice" persistent="false" type="numeric" />
	<cfproperty name="QOH" persistent="false" type="numeric" />
	<cfproperty name="QC" persistent="false" type="numeric" />
	<cfproperty name="QOO" persistent="false" type="numeric" />
	<cfproperty name="WebRetailQOH" persistent="false" type="numeric" />
	<cfproperty name="WebRetailQC" persistent="false" type="numeric" />
	<cfproperty name="WebRetailQOO" persistent="false" type="numeric" />
	<cfproperty name="WebWholesaleQOH" persistent="false" type="numeric" />
	<cfproperty name="WebWholesaleQC" persistent="false" type="numeric" />
	<cfproperty name="WebWholesaleQOO" persistent="false" type="numeric" />
	
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
