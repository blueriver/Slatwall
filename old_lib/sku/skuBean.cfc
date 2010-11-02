<cfcomponent name="skuBean" output="false" extends="slat.lib.coreBean" hint="">
	
	<cfset variables.instance.SkuID=""/>
	<cfset variables.instance.ProductID=""/>
	<cfset variables.instance.SkuCode=""/>
	<cfset variables.instance.ImageID=""/>
	<cfset variables.instance.LivePrice= 0 />
	<cfset variables.instance.ListPrice= 0 />
	<cfset variables.instance.OriginalPrice= 0 />
	<cfset variables.instance.MiscPrice= 0 />
	<cfset variables.instance.QOH=0 />
	<cfset variables.instance.QC=0 />
	<cfset variables.instance.QOO=0 />
	<cfset variables.instance.QIA=0 />
	<cfset variables.instance.QEA=0 />
	<cfset variables.instance.NextOrderID="" />
	<cfset variables.instance.NextArrivalDate = "" />
	<cfset variables.instance.DaysToOrder = 0 />
	<cfset variables.instance.AdditionalDaysToShip = 0 />
	<cfset variables.instance.isTaxable = 0 />
	<cfset variables.instance.isDiscountable = 1 />
	<cfset variables.instance.NonInventoryItem = 0 />
	
	<cffunction name="init" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSkuID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.SkuID />
	</cffunction>
	<cffunction name="setSkuID" access="public" output="false">
		<cfargument name="SkuID" type="string" required="true" />
		<cfset variables.instance.SkuID = trim(arguments.SkuID) />
	</cffunction>

	<cffunction name="getProductID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ProductID />
	</cffunction>
	<cffunction name="setProductID" access="public" output="false">
		<cfargument name="ProductID" type="string" required="true" />
		<cfset variables.instance.ProductID = trim(arguments.ProductID) />
	</cffunction>
	
	<cffunction name="getSkuCode" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.SkuCode />
    </cffunction>
    <cffunction name="setSkuCode" access="private" output="false" hint="">
    	<cfargument name="SkuCode" type="string" required="true" />
    	<cfset variables.instance.SkuCode = trim(arguments.SkuCode) />
    </cffunction>
    
	
	<cffunction name="getImageID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.ImageID />
	</cffunction>
	<cffunction name="setImageID" access="public" output="false">
		<cfargument name="ImageID" type="string" required="true" />
		<cfset variables.instance.ImageID = trim(arguments.ImageID) />
	</cffunction>
	
	<cffunction name="getLivePrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.LivePrice />
	</cffunction>
	<cffunction name="setLivePrice" access="public" output="false">
		<cfargument name="LivePrice" type="numeric" required="true" />
		<cfset variables.instance.LivePrice = arguments.LivePrice />
	</cffunction>
	
	<cffunction name="getListPrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.ListPrice />
	</cffunction>
	<cffunction name="setListPrice" access="public" output="false">
		<cfargument name="ListPrice" type="numeric" required="true" />
		<cfset variables.instance.ListPrice = arguments.ListPrice />
	</cffunction>
	
	<cffunction name="getOriginalPrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.OriginalPrice />
	</cffunction>
	<cffunction name="setOriginalPrice" access="public" output="false">
		<cfargument name="OriginalPrice" type="numeric" required="true" />
		<cfset variables.instance.OriginalPrice = arguments.OriginalPrice />
	</cffunction>
	
	<cffunction name="getMiscPrice" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.MiscPrice />
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
		<cfset return = getQOH() - getQC() />
		<cfreturn return />
	</cffunction>
	
	<cffunction name="getQEA" returntype="numeric" access="public" output="false">
		<cfset return = getQIA() + getQOO() />
		<cfreturn return />
	</cffunction>
	
	<cffunction name="getNextOrderID" returntype="string" access="public" output="false">
		<cfreturn variables.instance.NextOrderID />
	</cffunction>
	<cffunction name="setNextOrderID" access="public" output="false">
		<cfargument name="NextOrderID" type="string" required="true" />
		<cfset variables.instance.NextOrderID = trim(arguments.NextOrderID) />
	</cffunction>
	
	<cffunction name="getNextArrivalDate" returntype="string" access="public" output="false">
		<cfreturn DateFormat(variables.instance.NextArrivalDate, "MM/DD/YYYY") />
	</cffunction>
	<cffunction name="setNextArrivalDate" access="public" output="false">
		<cfargument name="NextArrivalDate" type="string" required="true" />
		<cfset variables.instance.NextArrivalDate = trim(arguments.NextArrivalDate) />
	</cffunction>
	
	<cffunction name="getDaysToOrder" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.DaysToOrder />
	</cffunction>
	<cffunction name="setDaysToOrder" access="public" output="false">
		<cfargument name="DaysToOrder" type="numeric" required="true" />
		<cfset variables.instance.DaysToOrder = arguments.DaysToOrder />
	</cffunction>
	
	<cffunction name="getAdditionalDaysToShip" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.AdditionalDaysToShip />
	</cffunction>
	<cffunction name="setAdditionalDaysToShip" access="public" output="false">
		<cfargument name="AdditionalDaysToShip" type="numeric" required="true" />
		<cfset variables.instance.AdditionalDaysToShip = arguments.AdditionalDaysToShip />
	</cffunction>
	
	<cffunction name="getisTaxable" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.isTaxable />
	</cffunction>
	<cffunction name="setisTaxable" access="public" output="false">
		<cfargument name="isTaxable" type="numeric" required="true" />
		<cfset variables.instance.isTaxable = arguments.isTaxable />
	</cffunction>
	
	<cffunction name="getisDiscountable" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.isDiscountable />
	</cffunction>
	<cffunction name="setisDiscountable" access="public" output="false">
		<cfargument name="isDiscountable" type="numeric" required="true" />
		<cfset variables.instance.isDiscountable = arguments.isDiscountable />
	</cffunction>
	
	<cffunction name="getNonInventoryItem" returntype="numeric" access="public" output="false">
		<cfreturn variables.instance.NonInventoryItem />
	</cffunction>
	<cffunction name="setNonInventoryItem" access="private" output="false">
		<cfargument name="NonInventoryItem" type="numeric" required="true" />
		<cfset variables.instance.NonInventoryItem = trim(arguments.NonInventoryItem) />
	</cffunction>
	
	<cffunction name="getProduct" returntype="any" access="public" output="false">
		<cfif not isDefined('variables.instance.product')>
			<cfset variables.instance.product = application.slat.productManager.read(ProductID=variables.instance.ProductID) />
		</cfif>
		<cfreturn variables.instance.product /> 
	</cffunction>

	<cffunction name="getAttributesString" returntype="string" access="public" output="false">
		<cfargument name="ValueSeperator" default=": " />
		<cfargument name="AttributeSeperator" default=", " />
		<cfargument name="NoHTML" default=0 />
		<cfset AttributesString = "" />
		<cfset isFirst = 1 />
		
		<cfloop array="#variables.instance.Attributes#" index="I">
			<cfif I.Value neq "">
				<cfif not isFirst>
					<cfset AttributesString = "#AttributesString##arguments.AttributeSeperator#" />
				</cfif>
				<cfif NoHTML>
					<cfset AttributesString = '#AttributesString##I.Name##arguments.ValueSeperator##I.Value#' />
				<cfelse>
					<cfset AttributesString = '#AttributesString#<span class="attributename">#I.Name#</span>#arguments.ValueSeperator#<span class="attributevalue">#I.Value#</span>' />
				</cfif>
				<cfset isFirst = 0 />
			</cfif>
		</cfloop>
		
		<cfreturn AttributesString />
	</cffunction>

	<cffunction name="getEstimatedShipDate" access="public" output="false" retruntype="string">
		<cfset DaysToAdd = 0>
		
		<cfif getQIA() gt 0>
			<cfset ShipDate = DateFormat(now(),"MM/DD/YYYY") />
		<cfelseif getQEA() gt 0>
			<cfset ShipDate = DateFormat(getNextArrivalDate(), "MM/DD/YYYY") />
			<cfif ShipDate lt DateFormat(now(), "MM/DD/YYYY")>
				<cfset ShipDate =  DateFormat(now(), "MM/DD/YYYY") />
			</cfif>
			<cfset DaysToAdd = 3>
		<cfelse>
			<cfset ShipDate = DateFormat(now()+getDaysToOrder(),"MM/DD/YYYY") />
		</cfif>
		
		<cfset DaysToAdd = DaysToAdd + getAdditionalDaysToShip()>
		<cfset DaysAdded = 0 />
		
		<cfif ShipDate eq DateFormat(now(),"MM/DD/YYYY") and TimeFormat(now(),"HH:MM") gt "13:00" and DaysToAdd eq 0>
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
		<cfelse>
			<cfset ShipDate = DateFormat(ShipDate,"MM/DD/YYYY") />
		</cfif>
		
		<cfloop condition="#DaysToAdd# gt #DaysAdded# or #application.slat.ShippingManager.isShippingDate(ShipDate)# neq 1">
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
			<cfif application.slat.ShippingManager.isShippingDate(ShipDate)>
				<cfset DaysAdded = DaysAdded + 1>
			</cfif>
		</cfloop>
		
		<cfreturn ShipDate />
	</cffunction>
	
	<cffunction name="getEstimatedShipDateTest" access="public" output="false" retruntype="string">
		<cfset DaysToAdd = 0>
		
		<cfif getQIA() gt 0>
			<cfdump var="#getQIA()#" />
			<cfabort />
			<cfset ShipDate = DateFormat(now(),"MM/DD/YYYY") />
		<cfelseif getQEA() gt 0>
			<cfdump var="#getQEA()#" />
			<cfdump var="#getNextArrivalDate()#" />
			<cfabort />
			<cfset ShipDate = DateFormat(getNextArrivalDate(), "MM/DD/YYYY") />
			<cfif ShipDate lt DateFormat(now(), "MM/DD/YYYY")>
				<cfset ShipDate =  DateFormat(now(), "MM/DD/YYYY") />
			</cfif>
			<cfset DaysToAdd = 3>
		<cfelse>
			<cfset ShipDate = DateFormat(now()+getDaysToOrder(),"MM/DD/YYYY") />
		</cfif>
		
		<cfset DaysToAdd = DaysToAdd + getAdditionalDaysToShip()>
		<cfset DaysAdded = 0 />
		
		<cfif ShipDate eq DateFormat(now(),"MM/DD/YYYY") and TimeFormat(now(),"HH:MM") gt "13:00" and DaysToAdd eq 0>
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
		<cfelse>
			<cfset ShipDate = DateFormat(ShipDate,"MM/DD/YYYY") />
		</cfif>
		
		<cfloop condition="#DaysToAdd# gt #DaysAdded# or #application.slat.ShippingManager.isShippingDate(ShipDate)# neq 1">
			<cfset ShipDate = DateFormat(ShipDate+1,"MM/DD/YYYY") />
			<cfif application.slat.ShippingManager.isShippingDate(ShipDate)>
				<cfset DaysAdded = DaysAdded + 1>
			</cfif>
		</cfloop>
		
		<cfreturn ShipDate />
	</cffunction>
	
	<cffunction name="getSkuImage" returnType="string" output="false" access="public">
		<cfargument name="Size" default="L" />
		
		<cfset ThisImageSource = "" />
		
		<cfif arrayLen(variables.instance.Attributes) gt 1>
			<cfset ColorCode = "" />
			<cfset ColorCode = Replace(variables.instance.Attributes[2].Value, "/", "", "all") />
			<cfif fileExists(UCASE(ExpandPath("/prodimages/#getImageID()#-#ColorCode#-#arguments.Size#.jpg"))) and ThisImageSource eq "">
				<cfset ThisImageSource = "/prodimages/#getImageID()#-#ColorCode#-#arguments.Size#.jpg" />
			</cfif>
		</cfif>
		<cfif ThisImageSource eq "" and fileExists(UCASE(ExpandPath("/prodimages/#getImageID()#-DEFAULT-#arguments.Size#.jpg")))>
			<cfset ThisImageSource = "/prodimages/#getImageID()#-DEFAULT-#arguments.Size#.jpg" />
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
