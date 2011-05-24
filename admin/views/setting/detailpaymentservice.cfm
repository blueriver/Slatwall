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

<cfparam name="rc.edit" />
<cfparam name="rc.paymentServicePackage" />
<cfparam name="rc.paymentService" />
<!--- holder for setting values if coming back from a failed validation --->
<cfparam name="rc.settingsStruct" default="#structNew()#" />

<cfset local.serviceMeta = getMetaData(rc.paymentService) />

<cfoutput>
	<div class="svoadminsettingdetailPaymentService">
		<ul id="navTask">
	    	<cf_ActionCaller action="admin:setting.listPaymentMethods" type="list">
			<cf_ActionCaller action="admin:setting.listPaymentServices" type="list">
		</ul>
		
		<cfif structKeyExists(rc.SettingsStruct,"errors") and len(rc.SettingsStruct.errors) gt 0>
			<ul class="error">
				<cfloop list="#rc.settingsStruct.errors#" index="local.thisError">
					<li>#local.thisError#</li>
				</cfloop>
			</ul>
		</cfif>
		
		<cfif rc.edit>
			<form name="savePaymentService" method="post" action="#buildURL(action='admin:setting.savePaymentService')#">
				<input type="hidden" name="paymentServicePackage" value="#rc.paymentServicePackage#" />
		</cfif>
		<cfif structKeyExists(local.serviceMeta, "properties")>
			<dl>
				<cfloop array="#local.serviceMeta.properties#" index="local.property">
					
					<!--- Get The Property Title --->
					<cfset local.propertyTitle = "" />
					<cfif structKeyExists(local.property, "displayName")>
						<cfset local.propertyTitle = local.property.displayName />
					<cfelse>
						<cfset local.propertyTitle = local.property.name />
					</cfif>
					<cfset local.thisFieldName = "paymentService_#rc.paymentServicePackage#_#local.property.name#" />
					<cfset local.thisPropertyValue = structKeyExists(rc.settingsStruct,local.property.name) ? rc.settingsStruct[local.property.name] : "" />
					<cf_PropertyDisplay object="#rc.paymentService#" fieldName="#local.thisFieldName#" property="#local.property.name#" title="#local.propertyTitle#" value="#local.thisPropertyValue#" edit="#rc.edit#">
					<!--- look for validation metadata for the property --->
					<cfloop collection="#local.property#" item="local.thisAttrib">
						<cfif local.thisAttrib.toLowerCase().startsWith("validate")>
							<cfset local.thisRule = right(local.thisAttrib,len(local.thisAttrib)-8) />
							<cfset local.thisRuleCriteria = local.property[local.thisAttrib] />
							<input type="hidden" name="validate_#local.thisFieldName#" value="#local.thisRule#<cfif len(local.thisRuleCriteria)>_#local.thisRuleCriteria#</cfif>" />
						</cfif>
					</cfloop> 	
				</cfloop>
			</dl>
		</cfif>
		<cfif rc.edit>
			<cf_ActionCaller action="admin:setting.listPaymentServices" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_ActionCaller action="admin:setting.savePaymentService" type="submit" class="button">
			</form>
		</cfif>
	</div>
</cfoutput>

