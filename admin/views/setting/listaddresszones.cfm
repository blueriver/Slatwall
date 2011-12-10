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
<cfparam name="rc.addressZones" type="array" />


<cfoutput>
	<div class="svoadminsettinglistshippingzones">
		<ul id="navTask">
	    	<cf_SlatwallActionCaller action="admin:setting.createaddresszone" type="list">
		</ul>
		
		<table class="listing-grid stripe">
			<tr>
				<th class="varWidth">#rc.$.slatwall.rbKey("entity.addresszone.addresszonename")#</th>
				<th class="administration">&nbsp;</th>
			</tr>
			<cfloop array="#rc.addressZones#" index="local.addressZone">
				<tr>
					<td class="varWidth">#local.addressZone.getAddressZoneName()#</td>
					<td class="administration">
						<ul class="three">
							<cf_SlatwallActionCaller action="admin:setting.detailaddresszone" querystring="addressZoneID=#local.addressZone.getAddressZoneID()#" class="detail" type="list">
							<cf_SlatwallActionCaller action="admin:setting.editaddresszone" querystring="addressZoneID=#local.addressZone.getAddressZoneID()#" class="edit" type="list">
							<cf_SlatwallActionCaller action="admin:setting.deleteaddresszone" querystring="addressZoneID=#local.addressZone.getAddressZoneID()#" class="delete" type="list" disabled="#local.addressZone.isDeletable()#" disabledText="#rc.$.Slatwall.rbKey('entity.addressZone.delete_validateIsAssigned')#" confirmRequired="true">
						</ul>
					</td>
				</tr>
			</cfloop>
		</table>
	</div>
</cfoutput>