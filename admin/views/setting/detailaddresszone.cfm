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
<cfparam name="rc.addressZone" type="any" />
<cfparam name="rc.newAddress" type="any" />
<cfparam name="rc.edit" type="boolean" /> 

<cfoutput>
	<div class="svoadminsettingdetailaddresszone">
		<ul id="navTask">
	    	<cf_SlatwallActionCaller action="admin:setting.listaddresszones" type="list">
			<cfif not rc.edit>
				<cf_SlatwallActionCaller action="admin:setting.editaddresszone" queryString="addressZoneID=#rc.addressZone.getAddressZoneID()#" type="list">
			</cfif>
		</ul>
		
		<cfif rc.edit>
			<form name="addressZone" action="#buildURL(action='admin:setting.saveaddresszone')#" method="post">
			<input type="hidden" name="addressZoneID" value="#rc.addressZone.getAddressZoneID()#" />
		</cfif>
		
		<dl class="twoColumn">
			<cf_SlatwallPropertyDisplay object="#rc.addressZone#" property="addressZoneName" edit="#rc.edit#" first="true">
		</dl>
		<cfif not rc.addressZone.isNew()>
			<strong>#$.slatwall.rbKey('entity.addresszone.addresszonelocations')#</strong>
		
			<table id="addressZoneLocations" class="listing-grid stripe">
				<thead>
					<tr>
						<th>#$.slatwall.rbKey('entity.address.countryCode')#</th>
						<th class="varWidth">#$.slatwall.rbKey('entity.address.city')#</th>
						<th>#$.slatwall.rbKey('entity.address.stateCode')#</th>
						<th>#$.slatwall.rbKey('entity.address.postalCode')#</th>
						<cfif rc.edit><th class="administration">&nbsp;</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#rc.addressZone.getAddressZoneLocations()#" index="local.address" >
						<tr>
							<td>#local.address.getCountry().getCountryName()#</td>
							<td class="varWidth">#local.address.getCity()#</td>
							<td>#local.address.getStateCode()#</td>
							<td>#local.address.getPostalCode()#</td>
							<cfif rc.edit>
							<td class="administration">
								<ul class="one">
									<cfif not local.address.isNew()>
										<cf_SlatwallActionCaller action="admin:setting.deleteaddresszonelocation" querystring="addressZoneID=#rc.addressZone.getAddressZoneID()#&addressID=#local.address.getAddressID()#" class="delete" type="list">
									</cfif>
								</ul>
							</td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cfif rc.edit>
				<strong>Add Location To Zone</strong>
				<cf_SlatwallAddressDisplay address="#entityNew('SlatwallAddress')#" edit="true" showName="false" showCompany="false" showStreetAddress="false" showStreet2Address="false" />
				<button type="submit" name="addLocation" value="true">Add Location</button><br /><br />
			</cfif>
		</cfif>
		<cfif rc.edit>
			<cf_SlatwallActionCaller action="admin:setting.listaddresszones" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cfif Not rc.addressZone.isNew()>
				<cf_SlatwallActionCaller action="admin:setting.deleteaddresszone" querystring="addressZoneID=#rc.addressZone.getAddressZoneID()#" class="button" type="link" disabled="#rc.addressZone.isNotDeletable()#" disabledText="#rc.$.Slatwall.rbKey('entity.addressZone.delete_validateIsDeletable')#" confirmRequired="true">
			</cfif>
			<cf_SlatwallActionCaller action="admin:setting.saveaddresszone" type="submit" class="button">
			</form>
		</cfif>
	</div>
</cfoutput>