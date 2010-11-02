<cfcomponent output="false" name="orderItemPriceDetailBean" hint="Container Object For Price Detail Information for Cart and Orders">
	
	<cfset variables.instance = structnew() />
	<cfset variables.instance.AdjustmentDetail = "" />
	<cfset variables.instance.AdjustmentType = "" />
	<cfset variables.instance.LivePrice = 0 />
	<cfset variables.instance.OriginalPrice = 0 />
	<cfset variables.instance.Price = 0 />
	
	<cffunction name="getAdjustmentDetail" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.AdjustmentDetail />
    </cffunction>
    <cffunction name="setAdjustmentDetail" access="private" output="false" hint="">
    	<cfargument name="AdjustmentDetail" type="string" required="true" />
    	<cfset variables.instance.AdjustmentDetail = trim(arguments.AdjustmentDetail) />
    </cffunction>
	
	<cffunction name="getAdjustmentType" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.AdjustmentType />
    </cffunction>
    <cffunction name="setAdjustmentType" access="private" output="false" hint="">
    	<cfargument name="AdjustmentType" type="string" required="true" />
    	<cfset variables.instance.AdjustmentType = trim(arguments.AdjustmentType) />
    </cffunction>
    
    <cffunction name="getLivePrice" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.LivePrice />
    </cffunction>
    <cffunction name="setLivePrice" access="private" output="false" hint="">
    	<cfargument name="LivePrice" type="numeric" required="true" />
    	<cfset variables.instance.LivePrice = trim(arguments.LivePrice) />
    </cffunction>
	
	<cffunction name="getOriginalPrice" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.OriginalPrice />
    </cffunction>
    <cffunction name="setOriginalPrice" access="private" output="false" hint="">
    	<cfargument name="OriginalPrice" type="numeric" required="true" />
    	<cfset variables.instance.OriginalPrice = trim(arguments.OriginalPrice) />
    </cffunction>
	
	<cffunction name="getPrice" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.Price />
    </cffunction>
    <cffunction name="setPrice" access="private" output="false" hint="">
    	<cfargument name="Price" type="numeric" required="true" />
    	<cfset variables.instance.Price = trim(arguments.Price) />
    </cffunction>
    
</cfcomponent>