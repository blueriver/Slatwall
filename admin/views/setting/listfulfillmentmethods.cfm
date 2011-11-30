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

<cfparam name="rc.fulfillmentMethods" type="array" />

<cfoutput>
	<div class="svoadminListFulfillmentMethods">
		<ul id="navTask">
	    	<cf_SlatwallActionCaller action="admin:setting.listFulfillmentMethods" type="list">
		</ul>
		
		<table id="fulfillmentMethodList" class="listing-grid stripe">
			<tr>
				<th class="varWidth">#rc.$.Slatwall.rbKey("admin.setting.listFulfillmentMethods")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.fulfillmentMethod.activeFlag")#</th>
				<th>&nbsp;</th>
			</tr>
				
			<cfloop array="#rc.fulfillmentMethods#" index="local.thisFulfillmentMethod">
				<tr>
					<cfset local.fulfillmentMethodMetaData = getMetaData(local.thisFulfillmentMethod) />
					<td class="varWidth"><a href="#buildURL(action='admin:setting.detailfulfillmentmethod',querystring='fulfillmentmethodID=#local.thisFulfillmentMethod.getFulfillmentMethodID()#')#">#$.Slatwall.rbKey("admin.setting.fulfillmentMethod." & local.thisFulfillmentMethod.getFulfillmentMethodID())#</a></td>
					<td>
						<cfif local.thisFulfillmentMethod.getActiveFlag()>
							<img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.ui.check_green.png" with="16" height="16" alt="#rc.$.Slatwall.rbkey('sitemanager.yes')#" title="#rc.$.Slatwall.rbkey('sitemanager.yes')#" />
						<cfelse>
							<img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.ui.cross_red.png" with="16" height="16" alt="#rc.$.Slatwall.rbkey('sitemanager.no')#" title="#rc.$.Slatwall.rbkey('sitemanager.no')#" />
						</cfif>
					</td>
					<td class="administration">
						<ul class="two">
							<cf_SlatwallActionCaller action="admin:setting.detailFulfillmentMethod" querystring="fulfillmentMethodID=#local.thisFulfillmentMethod.getFulfillmentMethodID()#" class="detail" type="list">
							<cf_SlatwallActionCaller action="admin:setting.editFulfillmentMethod" querystring="fulfillmentMethodID=#local.thisFulfillmentMethod.getFulfillmentMethodID()#" class="edit" type="list">
						</ul> 						
					</td>
				</tr>
			</cfloop>
		</table>
	</div>
</cfoutput>
