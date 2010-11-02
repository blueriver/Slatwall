<cfcomponent output="false" name="productBean" hint="Container Object For Core Product Information">
	
	<cfset variables.instance = structnew() />
	<cfset variables.instance.ProductID="" />
	<cfset variables.instance.Active=0 />
	<cfset variables.instance.ProductCode="" />
	<cfset variables.instance.ProductName="" />
	<cfset variables.instance.BrandID="" />
	<cfset variables.instance.BrandName="" />
	<cfset variables.instance.DefaultImageID=""/>
	<cfset variables.instance.ProductDescription=""/>
	<cfset variables.instance.ProductExtendedDescription=""/>
	<cfset variables.instance.DateCreated="" />
	<cfset variables.instance.DateAddedToWeb="" />
	<cfset variables.instance.DateLastUpdated="" />
	<cfset variables.instance.DateFirstReceived="" />
	<cfset variables.instance.DateLastReceived="" />
	<cfset variables.instance.OnTermSale=0 />
	<cfset variables.instance.OnClearanceSale=0 />
	<cfset variables.instance.NonInventoryItem=0 />
	<cfset variables.instance.CallToOrder=0 />
	<cfset variables.instance.OnlyInStore=0 />
	<cfset variables.instance.DropShips=0 />
	<cfset variables.instance.AllowBackorder=0 />
	<cfset variables.instance.AllowPreorder=0 />
	<cfset variables.instance.Weight = "" />
	<cfset variables.instance.ProductYear = "" />
	<cfset variables.instance.Gender = "" />
	<cfset variables.instance.SizeChart = "" />
	<cfset variables.instance.Ingredients = "" />
	<cfset variables.instance.Material = "" />
	<cfset variables.instance.LivePrice= 0 />
	<cfset variables.instance.ListPrice= 0 />
	<cfset variables.instance.OriginalPrice= 0 />
	<cfset variables.instance.MiscPrice= 0 />
	<cfset variables.instance.QOH=0 />
	<cfset variables.instance.QC=0 />
	<cfset variables.instance.QOO=0 />
	
	<cfset variables.instance.ProductAttributes=arraynew(1) />
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProductID" returntype="string" access="public" output="false" hint="Primary Key That Represents Products">
		<cfreturn variables.instance.ProductID />
	</cffunction>
	
	<cffunction name="setProductID" access="private" output="false">
		<cfargument name="ProductID" type="string" required="true" />
		<cfset variables.instance.ProductID = trim(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="getActive" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.Active />
    </cffunction>
    <cffunction name="setActive" access="private" output="false" hint="">
    	<cfargument name="Active" type="numeric" required="true" />
    	<cfset variables.instance.Active = trim(arguments.Active) />
    </cffunction>
    
	<cffunction name="getProductCode" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ProductCode />
	</cffunction>
	
	<cffunction name="setProductCode" access="private" output="false">
		<cfargument name="ProductCode" type="String" required="true" />
		<cfset variables.instance.ProductCode = trim(arguments.ProductCode) />
	</cffunction>
	
	<cffunction name="getProductName" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ProductName />
	</cffunction>
	
	<cffunction name="setProductName" access="private" output="false">
		<cfargument name="ProductName" type="string" required="true" />
		<cfset variables.instance.ProductName = trim(arguments.ProductName) />
	</cffunction>
	
	<cffunction name="getBrandID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.BrandID />
	</cffunction>
	<cffunction name="setBrandID" access="private" output="false">
		<cfargument name="BrandID" type="string" required="true" />
		<cfset variables.instance.BrandID = trim(arguments.BrandID) />
	</cffunction>
	
	<cffunction name="getBrandName" returntype="string" access="public" output="false">
		<cfreturn variables.instance.BrandName />
	</cffunction>
	<cffunction name="setBrandName" access="private" output="false">
		<cfargument name="BrandName" type="string" required="true" />
		<cfset variables.instance.BrandName = trim(arguments.BrandName) />
	</cffunction>
	
	<cffunction name="getDefaultImageID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.DefaultImageID />
	</cffunction>
	
	<cffunction name="setDefaultImageID" access="private" output="false">
		<cfargument name="DefaultImageID" type="string" required="true" />
		<cfset variables.instance.DefaultImageID = trim(arguments.DefaultImageID) />
	</cffunction>

	<cffunction name="getProductDescription" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ProductDescription />
	</cffunction>
	
	<cffunction name="setProductDescription" access="private" output="false">
		<cfargument name="ProductDescription" type="string" required="true" />
		<cfset variables.instance.ProductDescription = trim(arguments.ProductDescription) />
	</cffunction>
	
	<cffunction name="getProductExtendedDescription" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ProductExtendedDescription />
	</cffunction>
	
	<cffunction name="setProductExtendedDescription" access="private" output="false">
		<cfargument name="ProductExtendedDescription" type="string" required="true" />
		<cfset variables.instance.ProductExtendedDescription = trim(arguments.ProductExtendedDescription) />
	</cffunction>
	
	<cffunction name="getDateCreated" returntype="string" access="public" output="false">
		<cfreturn variables.instance.DateCreated />
	</cffunction>
	
	<cffunction name="setDateCreated" access="private" output="false">
		<cfargument name="DateCreated" type="string" required="true" />
		<cfset variables.instance.DateCreated = trim(arguments.DateCreated) />
	</cffunction>
	
	<cffunction name="getDateAddedToWeb" returntype="string" access="public" output="false">
		<cfreturn variables.instance.DateAddedToWeb />
	</cffunction>
	
	<cffunction name="setDateAddedToWeb" access="private" output="false">
		<cfargument name="DateAddedToWeb" type="string" required="true" />
		<cfset variables.instance.DateAddedToWeb = trim(arguments.DateAddedToWeb) />
	</cffunction>
	
	<cffunction name="getDateLastUpdated" returntype="string" access="public" output="false">
		<cfreturn variables.instance.DateLastUpdated />
	</cffunction>
	
	<cffunction name="setDateLastUpdated" access="private" output="false">
		<cfargument name="DateLastUpdated" type="string" required="true" />
		<cfset variables.instance.DateLastUpdated = trim(arguments.DateLastUpdated) />
	</cffunction>
	
	<cffunction name="getDateFirstReceived" returntype="string" access="public" output="false">
		<cfreturn variables.instance.DateFirstReceived />
	</cffunction>
	<cffunction name="setDateFirstReceived" access="private" output="false">
		<cfargument name="DateFirstReceived" type="string" required="true" />
		<cfset variables.instance.DateFirstReceived = trim(arguments.DateFirstReceived) />
	</cffunction>
	
	<cffunction name="getDateLastReceived" returntype="string" access="public" output="false">
		<cfreturn variables.instance.DateLastReceived />
	</cffunction>
	<cffunction name="setDateLastReceived" access="private" output="false">
		<cfargument name="DateLastReceived" type="string" required="true" />
		<cfset variables.instance.DateLastReceived = trim(arguments.DateLastReceived) />
	</cffunction>
	
	<cffunction name="getOnTermSale" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.OnTermSale />
	</cffunction>
	<cffunction name="setOnTermSale" access="private" output="false">
		<cfargument name="OnTermSale" type="numeric" required="true" />
		<cfset variables.instance.OnTermSale = trim(arguments.OnTermSale) />
	</cffunction>
	
	<cffunction name="getOnClearanceSale" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.OnClearanceSale />
	</cffunction>
	<cffunction name="setOnClearanceSale" access="private" output="false">
		<cfargument name="OnClearanceSale" type="numeric" required="true" />
		<cfset variables.instance.OnClearanceSale = trim(arguments.OnClearanceSale) />
	</cffunction>

	<cffunction name="getNonInventoryItem" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.NonInventoryItem />
	</cffunction>
	<cffunction name="setNonInventoryItem" access="private" output="false">
		<cfargument name="NonInventoryItem" type="numeric" required="true" />
		<cfset variables.instance.NonInventoryItem = trim(arguments.NonInventoryItem) />
	</cffunction>
	
	<cffunction name="getCallToOrder" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.CallToOrder />
	</cffunction>
	<cffunction name="setCallToOrder" access="private" output="false">
		<cfargument name="CallToOrder" type="numeric" required="true" />
		<cfset variables.instance.CallToOrder = trim(arguments.CallToOrder) />
	</cffunction>
	
	<cffunction name="getOnlyInStore" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.OnlyInStore />
	</cffunction>
	<cffunction name="setOnlyInStore" access="private" output="false">
		<cfargument name="OnlyInStore" type="numeric" required="true" />
		<cfset variables.instance.OnlyInStore = trim(arguments.OnlyInStore) />
	</cffunction>
	
	<cffunction name="getDropShips" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.DropShips />
	</cffunction>
	<cffunction name="setDropShips" access="private" output="false">
		<cfargument name="DropShips" type="numeric" required="true" />
		<cfset variables.instance.DropShips = trim(arguments.DropShips) />
	</cffunction>
	
	<cffunction name="getAllowBackorder" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.AllowBackorder />
	</cffunction>
	<cffunction name="setAllowBackorder" access="private" output="false">
		<cfargument name="AllowBackorder" type="numeric" required="true" />
		<cfset variables.instance.AllowBackorder = trim(arguments.AllowBackorder) />
	</cffunction>
	
	<cffunction name="getAllowPreorder" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.AllowPreorder />
	</cffunction>
	<cffunction name="setAllowPreorder" access="private" output="false">
		<cfargument name="AllowPreorder" type="numeric" required="true" />
		<cfset variables.instance.AllowPreorder = trim(arguments.AllowPreorder) />
	</cffunction>
	
	<cffunction name="getWeight" returntype="string" access="public" output="false">
		<cfreturn variables.instance.Weight />
	</cffunction>
	<cffunction name="setWeight" access="private" output="false">
		<cfargument name="Weight" type="string" required="true" />
		<cfset variables.instance.Weight = trim(arguments.Weight) />
	</cffunction>

	<cffunction name="getProductYear" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ProductYear />
	</cffunction>
	<cffunction name="setProductYear" access="private" output="false">
		<cfargument name="ProductYear" type="string" required="true" />
		<cfset variables.instance.ProductYear = trim(arguments.ProductYear) />
	</cffunction>
	
	<cffunction name="getGender" returntype="string" access="public" output="false">
		<cfreturn variables.instance.Gender />
	</cffunction>
	<cffunction name="setGender" access="private" output="false">
		<cfargument name="Gender" type="string" required="true" />
		<cfset variables.instance.Gender = trim(arguments.Gender) />
	</cffunction>
	
	<cffunction name="getSizeChart" returntype="string" access="public" output="false">
		<cfreturn variables.instance.SizeChart />
	</cffunction>
	<cffunction name="setSizeChart" access="private" output="false">
		<cfargument name="SizeChart" type="string" required="true" />
		<cfset variables.instance.SizeChart = trim(arguments.SizeChart) />
	</cffunction>
	
	<cffunction name="getIngredients" returntype="string" access="public" output="false">
		<cfreturn variables.instance.Ingredients />
	</cffunction>
	<cffunction name="setIngredients" access="private" output="false">
		<cfargument name="Ingredients" type="string" required="true" />
		<cfset variables.instance.Ingredients = trim(arguments.Ingredients) />
	</cffunction>
	
	<cffunction name="getMaterial" returntype="string" access="public" output="false">
		<cfreturn variables.instance.Material />
	</cffunction>
	<cffunction name="setMaterial" access="private" output="false">
		<cfargument name="Material" type="string" required="true" />
		<cfset variables.instance.Material = trim(arguments.Material) />
	</cffunction>
	
	<cffunction name="getLivePrice" returntype="string" access="public" output="false">
		<cfargument name="format" default="$" />
		
		<cfset var return = 0 />
		
		<cfif arguments.format eq "$">
			<cfset return = DollarFormat(variables.instance.LivePrice) />
		<cfelseif arguments.format eq ".">
			<cfset return = JavaCast("float",variables.instance.LivePrice) /> 
		</cfif>
		
		<cfreturn return />
	</cffunction>
	<cffunction name="setLivePrice" access="public" output="false">
		<cfargument name="LivePrice" type="numeric" required="true" />
		<cfset variables.instance.LivePrice = arguments.LivePrice />
	</cffunction>
	
	<cffunction name="getListPrice" returntype="string" access="public" output="false">
		<cfargument name="format" default="$" />
		
		<cfset var return = 0 />
		
		<cfif arguments.format eq "$">
			<cfset return = DollarFormat(variables.instance.ListPrice) />
		<cfelseif arguments.format eq ".">
			<cfset return = JavaCast("float",variables.instance.ListPrice) /> 
		</cfif>
		
		<cfreturn return />
	</cffunction>
	<cffunction name="setListPrice" access="public" output="false">
		<cfargument name="ListPrice" type="numeric" required="true" />
		<cfset variables.instance.ListPrice = arguments.ListPrice />
	</cffunction>
	
	<cffunction name="getOriginalPrice" returntype="string" access="public" output="false">
		<cfargument name="format" default="$" />
		
		<cfset var return = 0 />
		
		<cfif arguments.format eq "$">
			<cfset return = DollarFormat(variables.instance.OriginalPrice) />
		<cfelseif arguments.format eq ".">
			<cfset return = JavaCast("float",variables.instance.OriginalPrice) /> 
		</cfif>
		
		<cfreturn return />
	</cffunction>
	<cffunction name="setOriginalPrice" access="public" output="false">
		<cfargument name="OriginalPrice" type="numeric" required="true" />
		<cfset variables.instance.OriginalPrice = arguments.OriginalPrice />
	</cffunction>
	
	<cffunction name="getMiscPrice" returntype="string" access="public" output="false">
		<cfargument name="format" default="$" />
		
		<cfset var return = 0 />
		
		<cfif arguments.format eq "$">
			<cfset return = DollarFormat(variables.instance.MiscPrice) />
		<cfelseif arguments.format eq ".">
			<cfset return = JavaCast("float",variables.instance.MiscPrice) /> 
		</cfif>
		
		<cfreturn return />
	</cffunction>
	<cffunction name="setMiscPrice" access="public" output="false">
		<cfargument name="MiscPrice" type="numeric" required="true" />
		<cfset variables.instance.MiscPrice = arguments.MiscPrice />
	</cffunction>

	<cffunction name="getQOH" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.QOH />
	</cffunction>
	<cffunction name="setQOH" access="public" output="false">
		<cfargument name="QOH" type="numeric" required="true" />
		<cfset variables.instance.QOH = trim(arguments.QOH) />
	</cffunction>
	
	<cffunction name="getQC" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.QC />
	</cffunction>
	<cffunction name="setQC" access="public" output="false">
		<cfargument name="QC" type="numeric" required="true" />
		<cfset variables.instance.QC = trim(arguments.QC) />
	</cffunction>
	
	<cffunction name="getQOO" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.QOO />
	</cffunction>
	<cffunction name="setQOO" access="public" output="false">
		<cfargument name="QOO" type="numeric" required="true" />
		<cfset variables.instance.QOO = trim(arguments.QOO) />
	</cffunction>
	
	<cffunction name="getQIA" returntype="numeric" access="public" output="false">
		<cfset var return = getQOH() - getQC() />
		<cfreturn return />
	</cffunction>
	
	<cffunction name="getQEA" returntype="numeric" access="public" output="false">
		<cfset var return = getQIA() + getQOO() />
		<cfreturn return />
	</cffunction>
	
	<cffunction name="getAttributes" returntype="array" access="public" output="false">
		<cfreturn variables.instance.ProductAttributes />
	</cffunction>
	<cffunction name="setAttributes" access="public" output="false">
		<cfargument name="Attributes" type="array" required="true" />
		<cfset variables.instance.ProductAttributes = arguments.Attributes />
	</cffunction>
	
	<cffunction name="set" returnType="void" output="false" access="package">
		<cfargument name="record" type="any" required="true">

		<cfset columnexists=1 />
		<cfset currentcolumn=1 />
		<cfset AttributeName="" />
		<cfset AttributeValue="" />
		<cfset RecordAttributes=arrayNew(1) />

		<cfif isquery(arguments.record)>
			
			<!--- Turn Attribute Columns Into Array --->
			<cfloop condition="columnexists eq 1">
				<cfif ListFindNoCase(record.ColumnList, "ATTR#currentcolumn#NAME")>
					<cfset AttributePair = structnew() />
					<cfset AttributePair.Name = evaluate("arguments.record.Attr#currentcolumn#Name") />
					<cfset AttributePair.Value = evaluate("arguments.record.Attr#currentcolumn#Value") />
					<cfset RecordAttributes[#currentcolumn#] = #AttributePair# />
					<cfset currentcolumn = currentcolumn + 1>
				<cfelse>
					<cfset columnexists = 0>
				</cfif>
			</cfloop>
			
			<cfset setAttributes(RecordAttributes) />
		
			<cfset setProductID(arguments.record.ProductID) />
			<cfset setActive(arguments.record.Active) />
			<cfset setProductCode(arguments.record.ProductCode) />
			<cfset setProductName(arguments.record.ProductName) />
			<cfset setBrandID(arguments.record.BrandID) />
			<cfset setBrandName(arguments.record.BrandName) />
			<cfset setDefaultImageID(arguments.record.DefaultImageID) />
			<cfset setProductDescription(arguments.record.ProductDescription) />
			<cfset setProductExtendedDescription(arguments.record.ProductExtendedDescription) />
			<cfset setDateCreated(arguments.record.DateCreated)/>
			<cfset setDateAddedToWeb(arguments.record.DateAddedToWeb)/>
			<cfset setDateLastUpdated(arguments.record.DateLastUpdated)/>
			<cfset setDateFirstReceived(arguments.record.DateFirstReceived)/>
			<cfset setDateLastReceived(arguments.record.DateLastReceived)/>
			<cfset setOnTermSale(arguments.record.OnTermSale)/>
			<cfset setOnClearanceSale(arguments.record.OnClearanceSale)/>
			<cfset setNonInventoryItem(arguments.record.NonInventoryItem)/>
			<cfset setCallToOrder(arguments.record.CallToOrder)/>
			<cfset setOnlyInStore(arguments.record.OnlyInStore)/>
			<cfset setDropShips(arguments.record.DropShips)/>
			<cfset setAllowBackorder(arguments.record.AllowBackorder)/>
			<cfset setAllowPreorder(arguments.record.AllowPreorder)/>
			<cfset setWeight(arguments.record.Weight) />
			<cfset setProductYear(arguments.record.ProductYear) />
			<cfset setGender(arguments.record.Gender) />
			<cfset setSizeChart(arguments.record.SizeChart) />
			<cfset setIngredients(arguments.record.Ingredients) />
			<cfset setMaterial(arguments.record.Material) />
			<cfset setLivePrice(arguments.record.LivePrice) />
			<cfset setListPrice(arguments.record.ListPrice) />
			<cfset setOriginalPrice(arguments.record.OriginalPrice) />
			<cfset setMiscPrice(arguments.record.MiscPrice) />
			<cfset setQOH(arguments.record.QOH) />
			<cfset setQC(arguments.record.QC) />
			<cfset setQOO(arguments.record.QOO) />
		<cfelseif isStruct(arguments.record)>
		
			<!--- Turn Attribute Columns Into Array --->
			<cfloop condition="columnexists eq 1">
				<cfif StructKeyExists(arguments.record,"Attr#currentcolumn#Name")>
					<cfset AttributePair = structnew() />
					<cfset AttributePair.Name = evaluate("arguments.record.Attr#currentcolumn#Name") />
					<cfset AttributePair.Value = evaluate("arguments.record.Attr#currentcolumn#Value") />
					<cfset RecordAttributes[#currentcolumn#] = #AttributePair# />
					<cfset currentcolumn = currentcolumn + 1>
				<cfelse>
					<cfset columnexists = 0>
				</cfif>
			</cfloop>
			
			<cfset setAttributes(RecordAttributes) />
		
			<cfloop collection="#arguments.record#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.record[prop])") />
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="getBrand" returntype="string" access="public" output="false">
		<cfif not isDefined('variables.instance.brand')>
			<cfset variables.instance.Brand = application.slat.brandManager.read(variables.instance.BrandID) />
		</cfif>
		<cfreturn variables.instance.Brand />
	</cffunction>

	<cffunction name="getSkusQuery" returnType="query" output="false" access="public">
		<cfreturn application.Slat.skuManager.getSkusByProductID(variables.instance.ProductID) />
	</cffunction>
	
	<cffunction name="getSkusIterator" returnType="any" output="false" access="public">
		<cfreturn application.slat.skuManager.getSkuIterator(getSkusQuery())>
	</cffunction>

	<cffunction name="getAttributeName" returnType="string" output="false" access="public">
		<cfargument name="AttributeID" type="numeric" required="true">
		<cfreturn variables.instance.ProductAttributes[arguments.AttributeID].Name />
	</cffunction>	

	<cffunction name="getAttributeValue" returnType="string" output="false" access="public">
		<cfargument name="AttributeID" type="numeric" required="true">
		<cfreturn variables.instance.ProductAttributes[arguments.AttributeID].Value />
	</cffunction>
	
	<cffunction name="getAttributeByName" returnType="string" output="false" access="public">
		<cfargument name="AttributeName" type="numeric" required="true">
		<cfset return ="" />
		
		<cfloop array="#variables.instance.ProductAttributes#" index="I">
			<cfif I.Name eq arguments.AttributeName>
				<cfset return = I.Value>
			</cfif>
		</cfloop>
		<cfreturn return />
	</cffunction>

	<cffunction name="getProductLink" returnType="string" output="false" access="public">
		<cfset ProductLink = "/index.cfm/product/?ProductID=#variables.instance.ProductID#" />
		<cfreturn ProductLink />
	</cffunction>
	
	<cffunction name="getHasMultipleColors" returnType="boolean" output="false" access="public">
		<cfreturn 0/>
	</cffunction>
	
	<cffunction name="getAvailableColors" returnType="string" output="false" access="public">
		<cfargument name="ColorAttributeID" default="2" />
		
		<cfset var SkusQuery = getSkusQuery() />
		<cfset variables.instance.AvailableColors = "">
		
		<cfloop query="SkusQuery">
			<cfif (SkusQuery.QOH - SkusQuery.QC) + QOO gt 0>
				<cfif not listFind(variables.instance.AvailableColors, "#SkusQuery.Attr2Value#")>
					<cfset variables.instance.AvailableColors = listAppend(variables.instance.AvailableColors, "#SkusQuery.Attr2Value#") />
				</cfif>
				
			</cfif>
		</cfloop>
	
		<cfreturn variables.instance.AvailableColors />
	</cffunction>

	<cffunction name="getProductCategoriesQuery" returnType="query" output="false" access="public">
		<cfif not isdefined('variables.instance.ProductContentQuery')>
			<cfset variables.instance.ProductContentQuery = application.Slat.productManager.getContentByProductID(variables.instance.ProductID) />
		</cfif>
		<cfreturn variables.instance.ProductContentQuery />
	</cffunction>
	
	<cffunction name="dspLivePriceOverList" returnType="string" output="false" access="public">
		<cfset LivePrice = getLivePrice(format=".") />
		<cfset ListPrice = getListPrice(format=".") />
		<cfif ListPrice gt LivePrice>
			<cfset DisplayPrice = "<span class='oldprice'>#DollarFormat(ListPrice)#</span>#DollarFormat(LivePrice)#" />
		<cfelse>
			<cfset DisplayPrice = "#DollarFormat(LivePrice)#" />
		</cfif>
		<cfreturn DisplayPrice />
	</cffunction>
	
	<cffunction name="getPriceSavings" returnType="string" output="false" access="public">
		<cfargument name="format" default="$" />
		
		<cfset LivePrice = getLivePrice(format=".") />
		<cfset ListPrice = getListPrice(format=".") />
		
		<cfif arguments.format eq "%" >
			<cfset return = 0 />
		<cfelseif arguments.format eq ".">
			<cfset return = ListPrice - LivePrice />
		<cfelse>
			<cfset return = "-#DollarFormat(ListPrice - LivePrice)#" />
		</cfif>

		<cfreturn return />
	</cffunction>
	
	<cffunction name="getProductRating" returnType="numeric" output="false" access="public">
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#"  username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			Select
				CONVERT(int, sum(tcontentratings.rate)) as SumOfRatings,
				CONVERT(int, count(tcontentratings.rate)) as NumberOfRatings
			From
				tcontentratings
			where
				siteid='default'
			  and
			  	contentid = 'ProductID_#variables.instance.ProductID#'
			group by
				contentid
		</cfquery>
		
		<cfif rs.recordcount>
			<cfset variables.instance.ProductRating = rs.SumOfRatings/rs.NumberOfRatings />
		<cfelse>
			<cfset variables.instance.ProductRating = 0>
		</cfif>
		
		<cfreturn variables.instance.ProductRating />
	</cffunction>

	<cffunction name="getUserProductRating" returnType="numeric" output="false" access="public">
		<cfargument name="userid" default="">
		
		<cfset variables.instance.UserProductRating = 0>
		<cfif userid neq "">
			<cfquery name="rs" datasource="#application.configBean.getDatasource()#"  username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				select
					tcontentratings.rate as rating
				from
					tcontentratings
				where
					siteID='default'
				  and
					contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="ProductID_#variables.instance.ProductID#"/>
				  and
					userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
			</cfquery>
			<cfif rs.recordcount>
				<cfset variables.instance.UserProductRating = rs.rating />
			</cfif>
		</cfif>
		
		<cfreturn variables.instance.UserProductRating />
	</cffunction>
	
	<cffunction name="dspAttributeGrid" returnType="string" output="false" access="public">
		<cfargument name="AttributesToInclude" required="True" />
		
		<cfset return = "">
		<cfset isfirst = 1>
		<cfloop list="#arguments.AttributesToInclude#" index="I">
			<cfif len(getAttributeValue(I))>
				<cfif isfirst>
					<cfset class = "#getAttributeName(I)# first">
					<cfset isfirst = 0>
				<cfelse>
					<cfset class = "#getAttributeName(I)#" />
				</cfif>
				<cfset return = "#return#<dl class='#class#'><dt>#getAttributeName(I)#</dt><dd>#getAttributeValue(I)#</dd></dl>" />
				
			</cfif>
		</cfloop>

		<cfreturn return />
	</cffunction>
	
	<cffunction name="getProductImage" returnType="string" output="false" access="public">
		<cfargument name="Size" default="L" />
		
		<cfset ThisImageSource = "" />
		
		<cfset ThisAvailableColors = "" />
		<cfset ThisAvailableColors = getAvailableColors() />
		<cfif listLen(ThisAvailableColors) gt 0>
			<cfset colorIndex = "">
			<cfloop list="ThisAvailableColors" index="colorIndex">
				<cfif fileExists(UCASE(ExpandPath("/prodimages/#getDefaultImageID()#-#colorIndex#-#arguments.Size#.jpg"))) and ThisImageSource eq "">
					<cfset ThisImageSource = "/prodimages/#getDefaultImageID()#-#colorIndex#-#arguments.Size#.jpg" />
				</cfif>
			</cfloop>
		</cfif>
		<cfif ThisImageSource eq "" and fileExists(UCASE(ExpandPath("/prodimages/#getDefaultImageID()#-DEFAULT-#arguments.Size#.jpg")))>
			<cfset ThisImageSource = "/prodimages/#getDefaultImageID()#-DEFAULT-#arguments.Size#.jpg" />
		</cfif>
		<cfif ThisImageSource eq "">
			<cfset ThisImageSource = "/prodimages/NoProductImage-#arguments.Size#.gif" />
		</cfif>
		<cfreturn ThisImageSource />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>