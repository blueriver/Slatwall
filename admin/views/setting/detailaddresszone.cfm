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
<cfparam name="rc.countriesArray" type="array" />
<cfparam name="rc.edit" type="boolean" /> 

<cfoutput>
	<div class="svoadminsettingdetailaddresszone">
		<ul id="navTask">
	    	<cf_SlatwallActionCaller action="admin:setting.listaddresszones" type="list">
		</ul>
		
		<cfif rc.edit>
		<form name="addressZone" action="#buildURL(action='admin:setting.saveaddresszone')#" method="post">
			<input type="hidden" name="addressZoneID" value="#rc.addressZone.getAddressZoneID()#" />
		</cfif>
			<dl class="oneColumn">
				<cf_SlatwallPropertyDisplay object="#rc.addressZone#" property="addressZoneName" edit="#rc.edit#" first="true">
				<dt>#$.slatwall.rbKey('entity.addresszone.addresszonelocations')#</dt>
				<dd>
					<table id="addressZoneLocations" class="stripe">
						<thead>
							<tr>
								<th>#$.slatwall.rbKey('entity.addresszonelocation.country')#</th>
								<th>#$.slatwall.rbKey('entity.addresszonelocation.state')#</th>
								<th>#$.slatwall.rbKey('entity.addresszonelocation.postalcode')#</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#rc.addressZone.getAddressZoneLocations()#" index="local.addressZoneLocation" >
								<tr>
									<!--- <td><cfif rc.edit><cf_CountrySelector countriesArray="#rc.countriesArray#" selectName="addressZoneLocations.new.countryCode" selectedCountryCode="#local.addressZoneLocation.getCountryCode()#"><cfelse>#local.addressZoneLocation.getCountryCode()#</cfif></td> --->
									<td><cfif rc.edit><input name="addressZoneLocations.#local.addressZoneLocation.getAddressZoneLocationID()#.stateCode" value="#local.addressZoneLocation.getStateCode()#"><cfelse>#local.addressZoneLocation.getStateCode()#</cfif></td>
									<td><cfif rc.edit><input name="addressZoneLocations.#local.addressZoneLocation.getAddressZoneLocationID()#.postalCode" value="#local.addressZoneLocation.getPostalCode()#"><cfelse>#local.addressZoneLocation.getPostalCode()#</cfif></td>
								</tr>
							</cfloop>
						</tbody>
					</table>
					<a class="button" id="addLocation">Add Location</a>
				</dd>
			</dl>
		<cfif rc.edit>
			<cf_SlatwallActionCaller action="admin:setting.listaddresszones" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_SlatwallActionCaller action="admin:setting.saveaddresszone" type="submit" class="button">
		</form>
		</cfif>
		
		<table style="display:none;">
			<tbody class="template">
				<tr>
					<td>
						<!---<cf_CountrySelector countriesArray="#rc.countriesArray#" selectName="addressZoneLocations.new.countryCode"> --->
					</td>
					<td><input type="text" name="addressZoneLocations.new.stateCode"></td>
					<td><input type="text" name="addressZoneLocations.new.postalCode"></td>
				</tr>
			</tbody>
		</table>
		
		<script type="text/javascript">
			var currentNewLocation = 1;
			
			$(document).ready(function(){
				$("##addLocation").click(function(){
					var appendContent = $(".template").html();
					appendContent = appendContent.replace(/.new./g, ".new" + currentNewLocation + ".")
					$("##addressZoneLocations > tbody:last").append(appendContent);
					currentNewLocation++;
				});
			});
		</script>
	</div>
</cfoutput>