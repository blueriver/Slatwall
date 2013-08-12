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
		<cfif findNoCase(local.lookupvalues[i],local.tables.table_name)>
			<cfset local.newTableName = replaceNoCase(local.newTableName,local.lookupvalues[i],local.newValues[i]) /> 
		</cfif>
	</cfloop>
	<cfif local.newTableName NEQ local.tables.table_name>
		<cfif this.ormSettings.dialect eq "MySQL">
			<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				RENAME TABLE #local.tables.table_name# TO #local.newTableName#
			</cfquery>
		<cfelse>
			<cfquery name="local.qryrenametable" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				EXEC sp_rename '#local.tables.table_name#','#local.newTableName#'
			</cfquery>
		</cfif>
	</cfif>
</cfloop>

<!--- change the long field names --->
<cfset local.lookupValues = ['SwAccountAuthentication.integrationAccessTokenExpiration','SwPaymentMethod.saveAccountPaymentMethodTransactionType','SwPaymentMethod.saveAccountPaymentMethodEncryptFlag','SwPaymentMethod.saveOrderPaymentTransactionType','SwPaymentMethod.placeOrderChargeTransactionType','SwPaymentMethod.placeOrderCreditTransactionType'] />
<cfset local.newValues = ['SwAccountAuthentication.integrationAccessTokenExp','SwPaymentMethod.saveAccountPaymentMethodTxType','SwPaymentMethod.saveAccPaymentMethodEncFlag','SwPaymentMethod.saveOrderPaymentTxType','SwPaymentMethod.placeOrderChargeTxType','SwPaymentMethod.placeOrderCreditTxType'] />

<cfloop from="1" to="#arrayLen(local.lookupValues)#" index="i">
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" table="#listFirst(local.lookupValues[i],'.')#" name="local.columns" />
	
	<cfloop query="local.columns">
		<cfif local.columns.column_name EQ listLast(local.lookupValues[i],'.')>
			<cfquery name="updateColumn" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				UPDATE #listFirst(local.lookupValues[i],'.')#
				SET #listLast(local.newValues[i],'.')# = #listLast(local.lookupValues[i],'.')#
			</cfquery>
			<cfquery name="dropColumn" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				ALTER TABLE #listFirst(local.lookupValues[i],'.')#
				DROP COLUMN #listLast(local.lookupValues[i],'.')#
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>

<!--- change long FK --->
<cfset local.lookupValues = ['SwAccess.subscriptionUsageBenefitAccountID','SwSubscriptionStatus.subscriptionStatusChangeReasonTypeID'] />
<cfset local.newValues = ['SwAccess.subsUsageBenefitAccountID','SwSubscriptionStatus.subsStatusChangeReasonTypeID'] />

<cfloop from="1" to="#arrayLen(local.lookupValues)#" index="i">
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" table="#listFirst(local.lookupValues[i],'.')#" name="local.columns" />
	
	<cfloop query="local.columns">
		<cfif local.columns.column_name EQ listLast(local.lookupValues[i],'.')>
			<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="index" table="#listFirst(local.lookupValues[i],'.')#" name="local.indexes" />
			<cfquery name="updateColumn" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				UPDATE #listFirst(local.lookupValues[i],'.')#
				SET #listLast(local.newValues[i],'.')# = #listLast(local.lookupValues[i],'.')#
			</cfquery>
			<cfquery name="getConstraint" dbtype="query">
				SELECT INDEX_NAME 
				FROM indexes
				WHERE COLUMN_NAME = '#listLast(local.lookupValues[i],'.')#'
			</cfquery>
			<cfif getConstraint.recordcount>
				<cfquery name="dropConstraint" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
					ALTER TABLE #listFirst(local.lookupValues[i],'.')#
					DROP <cfif this.ormSettings.dialect eq "MySQL">INDEX<cfelse>CONSTRAINT</cfif> #getConstraint.INDEX_NAME#
				</cfquery>
			</cfif>
			<cfquery name="dropColumn" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				ALTER TABLE #listFirst(local.lookupValues[i],'.')#
				DROP COLUMN #listLast(local.lookupValues[i],'.')#
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>

<!--- change long PK --->
<cfset local.lookupValues = ['SwSubscriptionUsageBenefitAccount.subscriptionUsageBenefitAccountID'] />
<cfset local.newValues = ['SwSubscriptionUsageBenefitAccount.subsUsageBenefitAccountID'] />

<cfloop from="1" to="#arrayLen(local.lookupValues)#" index="i">
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" table="#listFirst(local.lookupValues[i],'.')#" name="local.columns" />
	
	<cfloop query="local.columns">
		<cfif local.columns.column_name EQ listLast(local.lookupValues[i],'.')>
			<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="index" table="#listFirst(local.lookupValues[i],'.')#" name="local.indexes" />
			<cfquery name="updateColumn" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				UPDATE #listFirst(local.lookupValues[i],'.')#
				SET #listLast(local.newValues[i],'.')# = #listLast(local.lookupValues[i],'.')#
			</cfquery>
			<cfquery name="getConstraint" dbtype="query">
				SELECT INDEX_NAME 
				FROM indexes
				WHERE COLUMN_NAME = '#listLast(local.lookupValues[i],'.')#'
			</cfquery>
			<cfif getConstraint.recordcount>
				<cfquery name="dropConstraint" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
					ALTER TABLE #listFirst(local.lookupValues[i],'.')#
					DROP <cfif this.ormSettings.dialect eq "MySQL">INDEX<cfelse>CONSTRAINT</cfif> #getConstraint.INDEX_NAME#
				</cfquery>
			</cfif>
			<cfquery name="dropColumn" datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#">
				ALTER TABLE #listFirst(local.lookupValues[i],'.')#
				DROP COLUMN #listLast(local.lookupValues[i],'.')#
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>


<cflog file="Slatwall" text="General Log - Script v3_1 has run with no errors">
