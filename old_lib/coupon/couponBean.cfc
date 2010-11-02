<cfcomponent output="false" name="couponBean" hint="">
	
	<cfset variables.instance.CouponID=""/>
	<cfset variables.instance.CouponCode=""/>
	<cfset variables.instance.CouponTypeID=1/>
	<cfset variables.instance.Amount=0 />
	<cfset variables.instance.Description=""/>
	<cfset variables.instance.StartDate=""/>
	<cfset variables.instance.EndDate=""/>
	<cfset variables.instance.ValidDays="0" />
	<cfset variables.instance.MinimumCartItemsQuantity=0 />
	<cfset variables.instance.MinimumCartItemsValue=0 />
	<cfset variables.instance.SelectedProductsOnly=0 />
	<cfset variables.instance.OneUsePerCustomer=0 />
	<cfset variables.instance.OneUsePerSite=0 />
	
	<!--- 
		Coupon CouponTypeID
		
		1) % Off Item
		2) $ Off Item
		3) $ Off Order
		3) Activate Shipping Promotion
		4) Activate Multi-Buy Discount
		5) Activate Free Package Items 
	--->
	
	<cffunction name="init" access="public" output="false" returntype="Any">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getCouponID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CouponID />
    </cffunction>
    <cffunction name="setCouponID" access="private" output="false" hint="">
    	<cfargument name="CouponID" type="string" required="true" />
    	<cfset variables.instance.CouponID = trim(arguments.CouponID) />
    </cffunction>
    
    <cffunction name="getCouponCode" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CouponCode />
    </cffunction>
    <cffunction name="setCouponCode" access="private" output="false" hint="">
    	<cfargument name="CouponCode" type="string" required="true" />
    	<cfset variables.instance.CouponCode = trim(arguments.CouponCode) />
    </cffunction>
	
	<cffunction name="getCouponTypeID" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.CouponTypeID />
    </cffunction>
    <cffunction name="setCouponTypeID" access="private" output="false" hint="">
    	<cfargument name="CouponTypeID" type="numeric" required="true" />
    	<cfset variables.instance.CouponTypeID = trim(arguments.CouponTypeID) />
    </cffunction>
    
	<cffunction name="getAmount" returntype="any" access="public" output="false" hint="">
    	<cfreturn variables.instance.Amount />
    </cffunction>
    <cffunction name="setAmount" access="private" output="false" hint="">
    	<cfargument name="Amount" type="any" required="true" />
    	<cfset variables.instance.Amount = trim(arguments.Amount) />
    </cffunction>
    
	<cffunction name="getDescription" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Description />
    </cffunction>
    <cffunction name="setDescription" access="private" output="false" hint="">
    	<cfargument name="Description" type="string" required="true" />
    	<cfset variables.instance.Description = trim(arguments.Description) />
    </cffunction>
	
	<cffunction name="getStartDate" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.StartDate />
    </cffunction>
    <cffunction name="setStartDate" access="private" output="false" hint="">
    	<cfargument name="StartDate" type="string" required="true" />
    	<cfset variables.instance.StartDate = trim(arguments.StartDate) />
    </cffunction>
	
    <cffunction name="getEndDate" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.EndDate />
    </cffunction>
    <cffunction name="setEndDate" access="private" output="false" hint="">
    	<cfargument name="EndDate" type="string" required="true" />
    	<cfset variables.instance.EndDate = trim(arguments.EndDate) />
    </cffunction>
    
    <cffunction name="getValidDays" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.ValidDays />
    </cffunction>
    <cffunction name="setValidDays" access="private" output="false" hint="">
    	<cfargument name="ValidDays" type="string" required="true" />
    	<cfset variables.instance.ValidDays = trim(arguments.ValidDays) />
    </cffunction>
	
	<cffunction name="getMinimumCartItemsQuantity" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.MinimumCartItemsQuantity />
    </cffunction>
    <cffunction name="setMinimumCartItemsQuantity" access="private" output="false" hint="">
    	<cfargument name="MinimumCartItemsQuantity" type="numeric" required="true" />
    	<cfset variables.instance.MinimumCartItemsQuantity = trim(arguments.MinimumCartItemsQuantity) />
    </cffunction>
    
	<cffunction name="getMinimumCartItemsValue" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.MinimumCartItemsValue />
    </cffunction>
    <cffunction name="setMinimumCartItemsValue" access="private" output="false" hint="">
    	<cfargument name="MinimumCartItemsValue" type="numeric" required="true" />
    	<cfset variables.instance.MinimumCartItemsValue = trim(arguments.MinimumCartItemsValue) />
    </cffunction>
    
	<cffunction name="getSelectedProductsOnly" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.SelectedProductsOnly />
    </cffunction>
    <cffunction name="setSelectedProductsOnly" access="private" output="false" hint="">
    	<cfargument name="SelectedProductsOnly" type="numeric" required="true" />
    	<cfset variables.instance.SelectedProductsOnly = trim(arguments.SelectedProductsOnly) />
    </cffunction>
    
	<cffunction name="getOneUsePerCustomer" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.OneUsePerCustomer />
    </cffunction>
    <cffunction name="setOneUsePerCustomer" access="private" output="false" hint="">
    	<cfargument name="OneUsePerCustomer" type="numeric" required="true" />
    	<cfset variables.instance.OneUsePerCustomer = trim(arguments.OneUsePerCustomer) />
    </cffunction>
	
	<cffunction name="getOneUsePerSite" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.OneUsePerSite />
    </cffunction>
    <cffunction name="setOneUsePerSite" access="private" output="false" hint="">
    	<cfargument name="OneUsePerSite" type="numeric" required="true" />
    	<cfset variables.instance.OneUsePerSite = trim(arguments.OneUsePerSite) />
    </cffunction>
    
	<cffunction name="set" returnType="void" output="false" access="package">
		<cfargument name="record" type="any" required="true">

		<cfif isquery(arguments.record)>
			<cfset setCouponID(arguments.record.CouponID) />
			<cfset setCouponCode(arguments.record.CouponCode) />
			<cfset setCouponTypeID(arguments.record.CouponTypeID) />
			<cfset setAmount(arguments.record.Amount) />
			<cfset setDescription(arguments.record.Description) />
			<cfset setStartDate(arguments.record.StartDate) />
			<cfset setEndDate(arguments.record.EndDate) />
			<cfset setValidDays(arguments.record.ValidDays) />
			<cfset setMinimumCartItemsQuantity(arguments.record.MinimumCartItemsQuantity) />
			<cfset setMinimumCartItemsValue(arguments.record.MinimumCartItemsValue) />
			<cfset setSelectedProductsOnly(arguments.record.SelectedProductsOnly)/>
			<cfset setOneUsePerCustomer(arguments.record.OneUsePerCustomer)/>
			<cfset setOneUsePerSite(arguments.record.OneUsePerSite)/>
		<cfelseif isStruct(arguments.record)>
			<cfloop collection="#arguments.record#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.record[prop])") />
				</cfif>
			</cfloop>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>
