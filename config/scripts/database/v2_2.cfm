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

<cfset local.scriptHasErrors = false />

<!--- Update payment methods to use the new paymentIntegrationID value instead of provider gateway --->
<cftry>
	<cfdbinfo datasource="#application.configBean.getDataSource()#" type="Columns" table="SlatwallPaymentMethod" name="local.infoColumns" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			* 
		FROM
			infoColumns
		WHERE
			COLUMN_NAME = 'providerGateway'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			UPDATE
				SlatwallPaymentMethod
			SET
				paymentIntegrationID = (SELECT integrationID FROM SlatwallIntegration WHERE SlatwallIntegration.integrationPackage = SlatwallPaymentMethod.providerGateway)
			WHERE
				paymentIntegrationID IS NULL
			  AND
			  	providerGateway IS NOT NULL
		</cfquery>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="General Log - Update fulfillmentMethodID on SlatwallOrderFulfillment Has Error">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v2_2 had errors when running">
	<cfthrow detail="Part of Script v2_2 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v2_2 has run with no errors">
</cfif>