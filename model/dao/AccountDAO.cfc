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
	
	<cffunction name="getInternalAccountAuthenticationsByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />
		
		<cfreturn ormExecuteQuery("SELECT aa FROM SlatwallAccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.accountEmailAddresses aea WHERE aa.password is not null AND aa.integration.integrationID is null AND aea.emailAddress=:emailAddress", {emailAddress=arguments.emailAddress}) />
	</cffunction>
	
	<cffunction name="getAccountAuthenticationExists" returntype="any" access="public">
		<cfset var aaCount = ormExecuteQuery("SELECT count(aa.accountAuthenticationID) FROM SlatwallAccountAuthentication aa") />
		<cfreturn aaCount[1] gt 0 />
	</cffunction>
	
	<cffunction name="removeAccountFromAllSessions" returntype="void" access="public">
		<cfargument name="accountID" required="true"  />
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE SlatwallSession SET accountID = null, accountAuthenticationID = null WHERE accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountID#" />
		</cfquery>
	</cffunction>
</cfcomponent>
