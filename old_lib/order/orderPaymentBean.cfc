<cfcomponent output="false" name="orderPaymentBean" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cfset variables.instance = structnew() />
	<cfset variables.instance.Amount = 0 />
	<cfset variables.instance.Type = "" />
	<cfset variables.instance.PayerName = "" />
	<cfset variables.instance.CardNumber = "" />
	<cfset variables.instance.SecurityCode = "" />
	<cfset variables.instance.PreAuthorizedAmount = 0 />
	<cfset variables.instance.PreAuthorizationCode = "" />
	<cfset variables.instance.ChargedAmount = 0 />
	<cfset variables.instance.ChargedTransactionCode = "" />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getType" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.Type />
    </cffunction>
    <cffunction name="setType" access="private" output="false" hint="">
    	<cfargument name="Type" type="string" required="true" />
    	<cfset variables.instance.Type = trim(arguments.Type) />
    </cffunction>
	
	<cffunction name="getPayerName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PayerName />
    </cffunction>
    <cffunction name="setPayerName" access="private" output="false" hint="">
    	<cfargument name="PayerName" type="string" required="true" />
    	<cfset variables.instance.PayerName = trim(arguments.PayerName) />
    </cffunction>
    
    <cffunction name="getCardNumber" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CardNumber />
    </cffunction>
    <cffunction name="setCardNumber" access="private" output="false" hint="">
    	<cfargument name="CardNumber" type="string" required="true" />
    	<cfset variables.instance.CardNumber = trim(arguments.CardNumber) />
    </cffunction>
	
	<cffunction name="getSecurityCode" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.SecurityCode />
    </cffunction>
    <cffunction name="setSecurityCode" access="private" output="false" hint="">
    	<cfargument name="SecurityCode" type="string" required="true" />
    	<cfset variables.instance.SecurityCode = trim(arguments.SecurityCode) />
    </cffunction>
	
	<cffunction name="getExpectedAmount" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.ExpectedAmount />
    </cffunction>
    <cffunction name="setExpectedAmount" access="private" output="false" hint="">
    	<cfargument name="ExpectedAmount" type="numeric" required="true" />
    	<cfset variables.instance.ExpectedAmount = trim(arguments.ExpectedAmount) />
    </cffunction>
    
    <cffunction name="getPreAuthorizedAmount" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.PreAuthorizedAmount />
    </cffunction>
    <cffunction name="setPreAuthorizedAmount" access="private" output="false" hint="">
    	<cfargument name="PreAuthorizedAmount" type="numeric" required="true" />
    	<cfset variables.instance.PreAuthorizedAmount = trim(arguments.PreAuthorizedAmount) />
    </cffunction>
	
	<cffunction name="getPreAuthorizationCode" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.PreAuthorizationCode />
    </cffunction>
    <cffunction name="setPreAuthorizationCode" access="private" output="false" hint="">
    	<cfargument name="PreAuthorizationCode" type="string" required="true" />
    	<cfset variables.instance.PreAuthorizationCode = trim(arguments.PreAuthorizationCode) />
    </cffunction>
	
	<cffunction name="getChargedAmount" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.ChargedAmount />
    </cffunction>
    <cffunction name="setChargedAmount" access="private" output="false" hint="">
    	<cfargument name="ChargedAmount" type="numeric" required="true" />
    	<cfset variables.instance.ChargedAmount = trim(arguments.ChargedAmount) />
    </cffunction>
    
    <cffunction name="getChargedTransactionCode" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.ChargedTransactionCode />
    </cffunction>
    <cffunction name="setChargedTransactionCode" access="private" output="false" hint="">
    	<cfargument name="ChargedTransactionCode" type="string" required="true" />
    	<cfset variables.instance.ChargedTransactionCode = trim(arguments.ChargedTransactionCode) />
    </cffunction>

</cfcomponent>