<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfcomponent extends="HibachiDAO">
	
	<cffunction name="getEmailAddressNotInUseFlag" returntype="boolean" access="public">
		<cfargument name="emailAddress" required="true" type="string" />
		<cfargument name="accountID" type="string" />
		
		<cfif structKeyExists(arguments, "accountID")>
			<cfreturn not arrayLen(ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.accountEmailAddresses aea WHERE aea.emailAddress=:emailAddress AND a.accountID <> :accountID", {emailAddress=arguments.emailAddress, accountID=arguments.accountID})) />
		</cfif>
		<cfreturn not arrayLen(ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.accountEmailAddresses aea WHERE aea.emailAddress=:emailAddress", {emailAddress=arguments.emailAddress})) />
	</cffunction>
	
	<cffunction name="getInternalAccountAuthenticationsByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />
		
		<cfreturn ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.accountEmailAddresses aea WHERE aa.password is not null AND aa.integration.integrationID is null AND aea.emailAddress=:emailAddress", {emailAddress=arguments.emailAddress}) />
	</cffunction>
	
	<cffunction name="getAccountAuthenticationExists" returntype="any" access="public">
		<cfset var aaCount = ormExecuteQuery("SELECT count(aa.accountAuthenticationID) FROM SlatwallAccountAuthentication aa") />
		<cfreturn aaCount[1] gt 0 />
	</cffunction>
	
	<cffunction name="getAccountWithAuthenticationByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />
		
		<cfset var accounts = ormExecuteQuery("SELECT a FROM SlatwallAccount a WHERE EXISTS(SELECT aa.accountAuthenticationID FROM SlatwallAccountAuthentication aa WHERE aa.account.accountID = a.accountID) AND EXISTS(SELECT aea.emailAddress FROM SlatwallAccountEmailAddress aea WHERE aea.account.accountID = a.accountID AND aea.emailAddress = :emailAddress)", {emailAddress=arguments.emailAddress}) />
		<cfif arrayLen(accounts)>
			<cfreturn accounts[1] />
		</cfif>
	</cffunction>
	
	<cffunction name="getPasswordResetAccountAuthentication">
		<cfargument name="accountID" type="string" required="true" />
		
		<cfset var aaArray = ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa LEFT JOIN aa.integration i WHERE aa.account.accountID = :accountID and aa.expirationDateTime >= :now and aa.password is null and i.integrationID is null", {accountID=arguments.accountID, now=now()}) />
		
		<cfif arrayLen(aaArray)>
			<cfreturn aaArray[1] />
		</cfif>
	</cffunction>
	
	<cffunction name="removeAccountFromAuditProperties" returntype="void" access="public">
		<cfargument name="accountID" type="string" required="true" />
		
		<cfset var allTables = "" />
		<cfset var auditColumns = "" />
		<cfset var rs = "" />
		
		<cfdbinfo type="Tables" name="allTables" pattern="Slatwall%" />
		
		<cfloop query="allTables">
			<cfdbinfo type="Columns" table="#allTables.TABLE_NAME#" name="auditColumns" pattern="%ByAccountID" />
			
			<cfloop query="auditColumns">
				<cfquery name="rs">
					UPDATE
						#allTables.TABLE_NAME#
					SET
						#auditColumns.COLUMN_NAME# = null 
					WHERE
						#auditColumns.COLUMN_NAME# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountID#" /> 
				</cfquery>
			</cfloop>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="removeAccountFromAllSessions" returntype="void" access="public">
		<cfargument name="accountID" required="true"  />
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE SlatwallSession SET accountID = null, accountAuthenticationID = null WHERE accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountID#" />
		</cfquery>
	</cffunction>
	
	<cffunction name="mergeAccount" returntype="void" access="public">
		<cfargument name="newAccountID" type="string" required="true" />
		<cfargument name="oldAccountID" type="string" required="true" />
		
		<cfset var rs = "" />
		<cfset var tableInfo = "" />
		<cfdbinfo type="Tables" name="tableInfo">
		
		<cfloop query="#tableInfo#">
			<cfset var tableName = tableInfo.tableName />
			
			<cfif tableName neq "SlatwallAccount">
				<cfset var columnInfo = "" />
				<cfdbinfo type="Columns" table="#tableName#" name="columnInfo">
				
				<cfloop query="columnInfo">
					<cfset var columnName = columnInfo.columnName />
					
					<cfif listFindNoCase("accountID,createdByAccountID,modifiedByAccountID", columnName)>>
						<cfquery name="rs">
							UPDATE #tableName# SET #columnName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newAccountID#" /> WHERE #columnName# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldAccountID#" />
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
			
		</cfloop>
		
		<cfquery name="rs">
			DELETE FROM SlatwallAccount WHERE accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldAccountID#" />
		</cfquery>
	</cffunction>
</cfcomponent>
