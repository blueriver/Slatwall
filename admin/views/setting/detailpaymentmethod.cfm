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
<cfparam name="rc.edit" type="boolean" default="false" />
<cfparam name="rc.paymentMethod" type="any" />
<cfparam name="rc.paymentIntegrations" type="array" />

<cfoutput>
	<div class="svoadmindetailpaymentmethod">
		<ul id="navTask">
			<cfif not rc.edit><cf_SlatwallActionCaller action="admin:setting.editPaymentMethod" querystring="paymentMethodID=#rc.paymentMethod.getPaymentMethodID()#" type="list"></cfif>
	    	<cf_SlatwallActionCaller action="admin:setting.listPaymentMethods" type="list">
		</ul>
		
		<cfif rc.edit>
			<form name="PaymentMethodEdit" action="#buildURL('admin:setting.savePaymentMethod')#" method="post">
				<input type="hidden" name="paymentMethodID" value="#rc.paymentMethod.getPaymentMethodID()#" />
		</cfif>
		
		<cfif not arrayLen(rc.paymentIntegrations)>
			<p>You need to configure a Payment Integration before you can configure this payment method. <cf_SlatwallActionCaller action="admin:integration.list" queryString="F:paymentReadyFlag=1"></p>
		<cfelse>
			<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
				<ul>
					<li><a href="##tabBasicSettings" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.setting.tab.basicsettings")#</span></a></li>	
					<li><a href="##tabWorkflowSettings" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.setting.tab.workflowsettings")#</span></a></li>
				</ul>
	
				<div id="tabBasicSettings">
					
					<dl class="oneColumn">
						<cf_SlatwallPropertyDisplay object="#rc.paymentMethod#" property="activeFlag" edit="#rc.edit#" first="true">
						<dt class="spdprovidergateway">
							#rc.$.slatwall.rbKey('entity.paymentMethod.providergateway')#
						</dt>
						<dd id="spdprovidergateway">
							<cfif rc.edit>
								<select id="providerGateway" name="providerGateway">
									<cfloop array="#rc.paymentIntegrations#" index="local.integration">
										<option value="#local.integration.getIntegrationPackage()#" <cfif rc.paymentMethod.getProviderGateway() eq local.integration.getIntegrationPackage()>selected="selected"</cfif>>#local.integration.getIntegrationName()#</option>
									</cfloop>
								</select>
							<cfelse>
								#rc.paymentMethod.getIntegration().getIntegrationName()#
							</cfif>
						</dd>
						<!--- include any payment method-specific settings --->
						<cfif fileExists(expandPath("admin/views/setting/paymentmethods/#lcase(rc.paymentMethod.getPaymentMethodID())#.cfm"))>
							#view("setting/paymentmethods/#lcase(rc.paymentMethod.getPaymentMethodID())#")#
						</cfif>
					</dl>	
				</div>
				
				<div id="tabWorkflowSettings">Under Construction.</div>
			</div>	
		</cfif>
		<cfif rc.edit>
				<div id="actionButtons" class="clearfix">
					<cf_SlatwallActionCaller action="admin:setting.listPaymentMethods" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
					<cf_SlatwallActionCaller action="admin:setting.savePaymentMethod" type="submit" class="button">
				</div>
			</form>
		</cfif>
	</div>
</cfoutput>
