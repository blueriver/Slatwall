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
	
	<cffunction name="updateRecordSortOrder">
		<cfargument name="recordIDColumn" />
		<cfargument name="recordID" />
		<cfargument name="tableName" />
		<cfargument name="newSortOrder" />
		
		<cfset var rs = "" />
		
		<cflock timeout="60" name="updateSortOrder#arguments.tableName#">
			<cftransaction>
				<!--- Move everything after the record's old sortOrder down 1 --->
				<cfquery name="rs">
					UPDATE #tableName# SET sortOrder = sortOrder - 1 WHERE sortOrder > (SELECT sortOrder FROM #arguments.tableName# WHERE #recordIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recordID#" /> )
				</cfquery>
				
				<!--- Move everything including the existing record in the spot of the new sortOrder up 1 --->
				<cfquery name="rs">
					UPDATE #tableName# SET sortOrder = sortOrder + 1 WHERE sortOrder >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newSortOrder#" />
				</cfquery>
				
				<!--- Update the record with it's new sort order --->
				<cfquery name="rs">
					UPDATE #tableName# SET sortOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newSortOrder#" /> WHERE #recordIDColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recordID#" />
				</cfquery>
			</cftransaction>
		</cflock>
		
	</cffunction>
	
	<cffunction name="recordExists" returntype="boolean">
		<cfargument name="tableName" />
		<cfargument name="idColumn" />
		<cfargument name="idValue" />
		
		<cfset var sqlResult = "" />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="sqlResult"> 
			SELECT * FROM #arguments.tableName# WHERE #arguments.idColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.idValue#">
		</cfquery>
		
		<cfif sqlResult.recordCount>
			<cfreturn true />
		</cfif>
		
		<cfreturn false />
	</cffunction>
	
	<cffunction name="recordUpdate" returntype="void">
		<cfargument name="tableName" />
		<cfargument name="idColumn" />
		<cfargument name="idValue" />
		<cfargument name="updateColumns" />
		<cfargument name="updateValues" />
		<cfargument name="columnDataTypes" />
		
		<cfset var i = 1 />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="sqlResult">
			UPDATE
				#arguments.tableName#
			SET
				<cfloop from="1" to="#arrayLen(updateColumns)#" index="i">
					<cfif updateValues[i] eq "NULL">
						#updateColumns[i]# = <cfqueryparam cfsqltype="cf_sql_#columnDataTypes[i]#" value="" null="yes">
					<cfelse>
						#updateColumns[i]# = <cfqueryparam cfsqltype="cf_sql_#columnDataTypes[i]#" value="#updateValues[i]#">
					</cfif>
					<cfif arrayLen(updateColumns) gt i>,</cfif> 
				</cfloop>
			WHERE
				#arguments.idColumn# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.idValue#"> 
		</cfquery>
	</cffunction>
	
	<cffunction name="recordInsert" returntype="void">
		<cfargument name="tableName" />
		<cfargument name="insertColumns" />
		<cfargument name="insertValues" />
		<cfargument name="columnDataTypes" />
		
		<cfset var i = 1 />
		
		<cfquery datasource="#application.configBean.getDataSource()#" name="sqlResult"> 
			INSERT INTO	#arguments.tableName# (
				#arrayToList(insertColumns, ",")#
			) VALUES (
				<cfloop from="1" to="#arrayLen(insertValues)#" index="i">
					<cfif insertValues[i] eq "NULL">
						<cfqueryparam cfsqltype="cf_sql_#columnDataTypes[i]#" value="" null="yes">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_#columnDataTypes[i]#" value="#insertValues[i]#">
					</cfif>
					<cfif arrayLen(insertValues) gt i>,</cfif>
				</cfloop>
			)
		</cfquery>
	</cffunction>
	
	<!--- hint: This method is for doing validation checks to make sure a property value isn't already in use --->
	<cffunction name="isUniqueProperty">
		<cfargument name="propertyName" required="true" />
		<cfargument name="entity" required="true" />
		
		<cfset var property = arguments.entity.getPropertyMetaData( arguments.propertyName ).name />  
		<cfset var entityName = arguments.entity.getEntityName() />
		<cfset var entityID = arguments.entity.getPrimaryIDValue() />
		<cfset var entityIDproperty = arguments.entity.getPrimaryIDPropertyName() />
		<cfset var propertyValue = arguments.entity.getValueByPropertyIdentifier( arguments.propertyName ) />
		
		<cfset var results = ormExecuteQuery(" from #entityName# e where e.#property# = :propertyValue and e.#entityIDproperty# != :entityID", {propertyValue=propertyValue, entityID=entityID}) />
		
		<cfif arrayLen(results)>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />		
	</cffunction>

</cfcomponent>