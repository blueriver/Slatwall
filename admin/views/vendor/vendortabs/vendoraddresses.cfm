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
	<table id="AddressList" class="listing-grid stripe">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.address.streetAddress")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.address.street2Address")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.address.city")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.address.stateCode")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.address.postalCode")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.address.countryCode")#</th>
			<th>&nbsp</th>
		</tr>
		<cfloop array="#rc.vendor.getVendorAddresses()#" index="local.vendorAddress">	
			<tr>
				<td class="varWidth">#Local.vendorAddress.getAddress().getStreetAddress()#</td>
				<td>#Local.vendorAddress.getAddress().getStreet2Address()#</td>
				<td>#Local.vendorAddress.getAddress().getCity()#</td>
				<td>#Local.vendorAddress.getAddress().getStateCode()#</td>
				<td>#Local.vendorAddress.getAddress().getPostalCode()#</td>
				<td>#Local.vendorAddress.getAddress().getCountryCode()#</td>
				<td class="administration">
					<ul class="three">
						<cf_SlatwallActionCaller action="admin:vendor.editvendoraddress" querystring="vendorAddressID=#local.vendorAddress.getVendorAddressID()#" class="edit" type="list">
						<cf_SlatwallActionCaller action="admin:vendor.detailvendoraddress" querystring="vendorAddressID=#local.vendorAddress.getVendorAddressID()#" class="detail" type="list">
						<cf_SlatwallActionCaller action="admin:vendor.deletevendoraddress" querystring="vendorAddressID=#local.vendorAddress.getVendorAddressID()#" class="delete" type="list" disabled="#NOT local.vendorAddress.isDeletable()#" confirmrequired="true">
					</ul>     						
				</td>
			</tr>
		</cfloop>
	</table>
	
	<!--- We are in Add or Edit mode (not view) --->
	<cfif rc.edit>
		<!--- If the VendorAddress is new, then that means that we are just editing the PriceGroup --->
		<cfif rc.vendorAddress.isNew()>
			<button type="button" id="addVendorAddressButton" value="true">#rc.$.Slatwall.rbKey("admin.vendoraddress.edit.addVendorAddress")#</button>
		</cfif>
		
		<div id="vendorAddressInputs" <cfif rc.vendorAddress.isNew() AND !rc.vendorAddress.hasErrors()>class="ui-helper-hidden"</cfif> >
			<strong>#rc.$.Slatwall.rbKey("admin.vendoraddress.edit.addVendorAddress")#</strong>
			<cfinclude template="vendoraddressdisplay.cfm">
			<input type="hidden" name="vendorAddresses[1].vendorAddressId" value="#rc.vendorAddress.getVendorAddressId()#"/>
			
			<!--- The populateSubProperties is read by the implicit save() handler to determine if it should process the saveVendorAddress() method. --->
			<cfif rc.vendorAddress.isNew() && not rc.vendorAddress.hasErrors()>
				<input type="hidden" name="populateSubProperties" id="populateSubProperties" value="false"/>
			<cfelse>
				<input type="hidden" name="populateSubProperties" value="true"/>
			</cfif>
		</div>

		<br /><br />
	</cfif>
	
	
</cfoutput>