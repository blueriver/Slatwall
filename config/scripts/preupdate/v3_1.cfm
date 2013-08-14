<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />

<!--- Rename DB Table --->
<cfset local.lookupValues = ['Slatwall','PromotionReward','PromotionQualifier','SubscriptionUsage','SubscriptionBenefit','Exclusion','Excluded','PriceGroupRateExcludedProductType','PromoRewardEligiblePriceGroup','PromoRewardShippingAddressZone','PromoQualShippingAddressZone'] />
<cfset local.newValues = ['Sw','PromoReward','PromoQual','SubsUsage','SubsBenefit','Excl','Excl','PriceGrpRateExclProductType','PromoRewardEligiblePriceGrp','PromoRewardShipAddressZone','PromoQualShipAddressZone'] />
<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="local.tables" />

<!--- loop through all the table --->
<cfloop query="local.tables">
	<cfset local.newTableName = local.tables.table_name /> 
	<!--- loop through all the string in name that needs to get replaced --->
	<cfloop from="1" to="#arrayLen(local.lookupvalues)#" index="i">
		<cfif findNoCase(local.lookupvalues[i],local.newTableName)>
			<cfset local.newTableName = replaceNoCase(local.newTableName,local.lookupvalues[i],local.newValues[i]) /> 
		</cfif>
	</cfloop>
	<cfif local.newTableName NEQ local.tables.table_name>
		<cfif this.ormSettings.dialect eq "MySQL">
			<cftry>
			<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				RENAME TABLE #local.tables.table_name# TO #local.newTableName#
			</cfquery>
			<cfcatch><cfdump var="#local.tables.table_name#" /><cfdump var="#local.newTableName#" abort /></cfcatch>
			</cftry>
		<cfelse>
			<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				EXEC sp_rename '#local.tables.table_name#','#local.newTableName#'
			</cfquery>
		</cfif>
	</cfif>
</cfloop>

<cflog file="Slatwall" text="General Log - Preupdate Script v3_1 has run with no errors">
