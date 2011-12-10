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

<cfoutput>
	
	<cf_SlatwallPropertyDisplay object="#rc.account#" property="priceGroups" edit="#rc.edit#" />
	<!---
	<table id="PriceGroupList" class="listing-grid stripe" style="width:50%;">
		<tr>
			<th>#rc.$.Slatwall.rbKey("entity.pricegroup.name")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.pricegroup.enabledOnAccount")#</th>
		</tr>
		<cfloop array="#rc.priceGroups#" index="local.priceGroup">

			<tr>
				<td>#local.priceGroup.getPriceGroupName()#</td>
				<td>
					<cfif rc.edit>
						<input type="checkbox" name="priceGroupIdsAssigned" value="#local.priceGroup.getPriceGroupId()#" <cfif rc.Account.isPriceGroupAssigned(local.priceGroup.getPriceGroupId())>checked="checked"</cfif> /></td>
					<cfelse>
						#rc.Account.isPriceGroupAssigned(local.priceGroup.getPriceGroupId())#
					</cfif>
				</td>
			</tr>

		</cfloop>
	</table>
	--->
</cfoutput>