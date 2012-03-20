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

<cf_SlatwallTabGroup hide="#rc.fulfillmentMethod.isNew()#">
	<cf_SlatwallTab view="admin:setting/fulfillmentmethodtypes/shippingtabs/shippingmethods" />
</cf_SlatwallTabGroup>

<!---
<cfoutput>
	
	<cfif arrayLen(rc.shippingMethods) gt 0>
		<table id="shippingMethodList" class="listing-grid stripe">
			<tr>
				<th class="varWidth">#rc.$.Slatwall.rbKey("entity.shippingmethod.shippingmethodname")#</th>
				<th>&nbsp</th>
			</tr>
			<cfloop array="#rc.shippingMethods#" index="local.shippingMethod">
				<tr>
					<td class="varWidth">#local.shippingMethod.getShippingMethodName()#</td>
					<td class="administration">
						<cfif rc.edit>
							<ul class="three">
								<cf_SlatwallActionCaller action="admin:setting.detailshippingmethod" querystring="shippingMethodID=#local.shippingMethod.getShippingMethodID()#" class="detail" type="list">
								<cf_SlatwallActionCaller action="admin:setting.editshippingmethod" querystring="shippingMethodID=#local.shippingMethod.getShippingMethodID()#" class="edit" type="list">
								<cf_SlatwallActionCaller action="admin:setting.deleteshippingmethod" querystring="shippingMethodID=#local.shippingMethod.getShippingMethodID()#" class="delete" type="list" disabled="#local.shippingMethod.isNotDeletable()#" disabledText="#rc.$.Slatwall.rbKey('entity.shippingMethod.delete_validateIsDeletable')#" confirmRequired="true">
							</ul>
						<cfelse>
							<ul class="one">
								<cf_SlatwallActionCaller action="admin:setting.detailshippingmethod" querystring="shippingMethodID=#local.shippingMethod.getShippingMethodID()#" class="detail" type="list">
							</ul>
						</cfif>						
					</td>
				</tr>
			</cfloop>
		</table>
	</cfif>
	<cfif rc.edit>
		<cf_SlatwallActionCaller action="admin:setting.createshippingmethod" class="button">
	</cfif>
	<br />
	<br />
</cfoutput>
--->