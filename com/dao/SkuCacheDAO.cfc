<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent extends="BaseDAO">
	
	<cffunction name="getNextSalePriceExpirationDateTime">
		
		<cfset var rs = "" />
		
		<cfquery name="rs">
			SELECT
				MIN(salePriceExpirationDateTime) as 'nextExpiration'
			FROM
				SlatwallSkuCache
		</cfquery>
		<cfreturn rs.nextExpiration />
	</cffunction>
	
	<cffunction name="getExpiredSkuCacheSkus">
		
		<cfset var rs = "" />
		
		<cfquery name="rs">
			SELECT
				skuID
			FROM
				SlatwallSkuCache
			WHERE
				skuCacheExpirationDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		</cfquery>
		<cfreturn rs.nextExpiration />
	</cffunction>
	
	<cffunction name="updateSkuCache">
		<cfargument name="skuID" type="string" required="true">
		<cfargument name="values" type="struct" required="true">
		
		<cfset var rs = "" />
		<cfset var updateResult = "" />
		
		<cfset var columnName = "" />
		<cfset var loopCount = 0 />
		
		<cfset var bitColumns = "allowBackorderFlag,allowDropshipFlag,allowPreorderFlag,allowShippingFlag,callToOrderFlag,trackInventoryFlag" />
		<cfset var dateTimeColumns = "salePriceExpirationDateTime" />
		<cfset var decimalColumns = "salePrice" />
		<cfset var integerColumns = "qoh,qosh,qndoo,qndorvo,qndosa,qnroro,qnrovo,qnrosa,quantityHeldBack,shippingWeight" />
		
		<cfquery name="rs" result="updateResult">
			UPDATE
				SlatwallSkuCache
			SET
				<cfloop collection="#arguments.values#" item="columnName">
					<cfif listFindNoCase(bitColumns, columnName)>
						#columnName# = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.values[ columnName ]#">,
					<cfelseif listFindNoCase(dateTimeColumns, columnName)>
						#columnName# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.values[ columnName ]#">,
					<cfelseif listFindNoCase(decimalColumns, columnName)>
						#columnName# = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.values[ columnName ]#">,
					<cfelseif listFindNoCase(integerColumns, columnName)>
						#columnName# = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.values[ columnName ]#">,
					</cfif>
				</cfloop>
				modifiedDateTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			WHERE
				skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
		</cfquery>
		
		<cfif not updateResult.recordCount>
			<cfquery name="rs" result="updateResult">
				INSERT INTO	SlatwallSkuCache (
					<cfloop collection="#arguments.values#" item="columnName">
						#columnName#,
					</cfloop>
					createdDateTime
				) VALUES (
					<cfloop collection="#arguments.values#" item="columnName">
						<cfif listFindNoCase(bitColumns, columnName)>
							<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.values[ columnName ]#">,
						<cfelseif listFindNoCase(dateTimeColumns, columnName)>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.values[ columnName ]#">,
						<cfelseif listFindNoCase(decimalColumns, columnName)>
							<cfqueryparam cfsqltype="cf_sql_decimal" value="#arguments.values[ columnName ]#">,
						<cfelseif listFindNoCase(integerColumns, columnName)>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.values[ columnName ]#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					</cfloop>
				)
			</cfquery>
		</cfif>
		
	</cffunction>
</cfcomponent>