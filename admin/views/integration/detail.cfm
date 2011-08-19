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

<cfparam name="rc.integration" />
<cfparam name="rc.edit" />

<cfoutput>
	<div class="svoadminintegrationdetail">
		<ul id="navTask">
			<cf_SlatwallActionCaller action="admin:integration.list" type="list">
			<cfif not rc.edit><cf_SlatwallActionCaller action="admin:integration.edit" queryString="integrationPackage=#rc.integration.getIntegrationPackage()#" type="list"></cfif>
		</ul>
		
		<cfif rc.edit>
			<form name="saveIntegration" method="post" action="#buildURL(action='admin:integration.save')#">
				<input type="hidden" name="integrationPackage" value="#rc.integration.getIntegrationPackage()#" />
		</cfif>
		
		<dl class="twoColumn">
			<cf_SlatwallPropertyDisplay object="#rc.integration#" property="integrationName" />
		</dl>
		
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all clear">
			<ul>
				<cfif rc.integration.getCustomReadyFlag()><li><a href="##tabCustom" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.integration.detail.tab.custom")#</span></a></li></cfif>
				<cfif rc.integration.getDataReadyFlag()><li><a href="##tabData" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.integration.detail.tab.data")#</span></a></li></cfif>
				<cfif rc.integration.getPaymentReadyFlag()><li><a href="##tabPayment" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.integration.detail.tab.payment")#</span></a></li></cfif>
				<cfif rc.integration.getShippingReadyFlag()><li><a href="##tabShipping" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.integration.detail.tab.shipping")#</span></a></li></cfif>
			</ul>
			<cfif rc.integration.getCustomReadyFlag()>
				<div id="tabCustom">
					<dl class="twoColumn">
						<cf_SlatwallPropertyDisplay object="#rc.integration#" property="customActiveFlag" edit="#rc.edit#" />
					</dl>
				</div>
			</cfif>
			<cfif rc.integration.getDataReadyFlag()>
				<div id="tabData">
					<dl class="twoColumn">
						<cf_SlatwallPropertyDisplay object="#rc.integration#" property="dataActiveFlag" edit="#rc.edit#" />
						
						<!--- Dynamic Settings --->
						<cfloop array="#rc.integration.getIntegrationCFCSettings('data')#" index="local.property">
							<cfset local.propertyTitle = "" />
							<cfif structKeyExists(local.property, "displayName")>
								<cfset local.propertyTitle = local.property.displayName />
							<cfelse>
								<cfset local.propertyTitle = local.property.name />
							</cfif>
							<cfset local.propertyEditType = "" />
							<cfif structKeyExists(local.property, "editType")>
								<cfset local.propertyEditType = local.property.editType />
							</cfif>
							<cf_SlatwallPropertyDisplay object="#rc.integration.getIntegrationCFC('data')#" fieldName="dataIntegration.#local.property.name#" property="#local.property.name#" title="#local.propertyTitle#" edit="#rc.edit#" editType="#local.propertyEditType#">
						</cfloop>
					</dl>
				</div>
			</cfif>
			<cfif rc.integration.getPaymentReadyFlag()>
				<div id="tabPayment">
					<dl class="twoColumn">
						<cf_SlatwallPropertyDisplay object="#rc.integration#" property="paymentActiveFlag" edit="#rc.edit#" />
						
						<!--- Dynamic Settings --->
						<cfloop array="#rc.integration.getIntegrationCFCSettings('payment')#" index="local.property">
							<cfset local.propertyTitle = "" />
							<cfif structKeyExists(local.property, "displayName")>
								<cfset local.propertyTitle = local.property.displayName />
							<cfelse>
								<cfset local.propertyTitle = local.property.name />
							</cfif>
							<cfset local.propertyEditType = "" />
							<cfif structKeyExists(local.property, "editType")>
								<cfset local.propertyEditType = local.property.editType />
							</cfif>
							<cf_SlatwallPropertyDisplay object="#rc.integration.getIntegrationCFC('payment')#" fieldName="paymentIntegration.#local.property.name#" property="#local.property.name#" title="#local.propertyTitle#" edit="#rc.edit#" editType="#local.propertyEditType#">
						</cfloop>
					</dl>
				</div>
			</cfif>
			<cfif rc.integration.getShippingReadyFlag()>
				<div id="tabShipping">
					<dl class="twoColumn">
						<cf_SlatwallPropertyDisplay object="#rc.integration#" property="shippingActiveFlag" edit="#rc.edit#" />
						
						<!--- Dynamic Settings --->
						<cfloop array="#rc.integration.getIntegrationCFCSettings('shipping')#" index="local.property">
							<cfset local.propertyTitle = "" />
							<cfif structKeyExists(local.property, "displayName")>
								<cfset local.propertyTitle = local.property.displayName />
							<cfelse>
								<cfset local.propertyTitle = local.property.name />
							</cfif>
							<cfset local.propertyEditType = "" />
							<cfif structKeyExists(local.property, "editType")>
								<cfset local.propertyEditType = local.property.editType />
							</cfif>
							<cf_SlatwallPropertyDisplay object="#rc.integration.getIntegrationCFC('shipping')#" fieldName="shippingIntegration.#local.property.name#" property="#local.property.name#" title="#local.propertyTitle#" edit="#rc.edit#" editType="#local.propertyEditType#">
						</cfloop>
					</dl>
				</div>
			</cfif>
		</div>
		<br class="clear" />
		<br class="clear" />
		<cfif rc.edit>
			<div id="actionButtons">
				<cf_SlatwallActionCaller action="admin:integration.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cf_SlatwallActionCaller action="admin:integration.save" type="submit" class="button">
			</form>
			</div>
		</cfif>
	</div>
</cfoutput>