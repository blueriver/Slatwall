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
<cfparam name="attributes.address" type="any" />
<cfparam name="attributes.edit" type="boolean" default="true" />
<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
<cfparam name="attributes.showName" type="boolean" default="true" />
<cfparam name="attributes.showCompany" type="boolean" default="true" />
<cfparam name="attributes.showStreetAddress" type="boolean" default="true" />
<cfparam name="attributes.showStreet2Address" type="boolean" default="true" />
<cfparam name="attributes.showLocality" type="boolean" default="true" />
<cfparam name="attributes.showCity" type="boolean" default="true" />
<cfparam name="attributes.showState" type="boolean" default="true" />
<cfparam name="attributes.showPostalCode" type="boolean" default="true" />
<cfparam name="attributes.showCountry" type="boolean" default="true" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="addressDisplay">
			<cfif attributes.edit>
				<dl>
					<cfif attributes.showCountry>
						<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#countryCode" property="countryCode" editType="select" edit="true" />
					</cfif>
					<cfif attributes.showName>
						<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#name" property="name" edit="true" />
					</cfif>
					<cfif attributes.showCompany>
						<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#company" property="company" edit="true" />
					</cfif>
					<cfif attributes.address.getCountry().getStreetAddressShowFlag() and attributes.showStreetAddress>
						<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#streetAddress" property="streetAddress" edit="true" />
					</cfif>
					<cfif attributes.address.getCountry().getStreet2AddressShowFlag() and attributes.showStreet2Address>
						<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#street2Address" property="street2Address" edit="true" />
					</cfif>
					<cfif attributes.address.getCountry().getCityShowFlag() and attributes.showCity>
						<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#city" property="city" edit="true" />
					</cfif>
					<cfif attributes.address.getCountry().getStateCodeShowFlag() and attributes.showState>
						<cfif arrayLen(attributes.address.getStateCodeOptions()) gt 1>
							<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" editType="select" edit="true" />
						<cfelse>
							<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" editType="text" edit="true" />
						</cfif>
					</cfif>
					<cfif attributes.address.getCountry().getPostalCodeShowFlag() and attributes.showPostalCode>
						<cf_SlatwallPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#postalCode" property="postalCode" edit="#attributes.edit#" />
					</cfif>
					<input type="hidden" name="#attributes.fieldNamePrefix#addressID" value="#attributes.address.getAddressID()#" />
				</dl>
				
				<script type="text/javascript">
					jQuery(document).ready(function(){
						jQuery('select[name="#attributes.fieldNamePrefix#countryCode"]').change(function() {
							
							var addressData = {
								apiKey: '#request.context.$.slatwall.getAPIKey("DisplayAddressDisplay", "get")#',
								addressID : jQuery('input[name="addressID"]').val(),
								fieldNamePrefix : '#attributes.fieldNamePrefix#',
								showName : '#attributes.showName#',
								showCompany : '#attributes.showCompany#',
								showStreetAddress : '#attributes.showStreetAddress#',
								showStreet2Address : '#attributes.showStreet2Address#',
								showLocality : '#attributes.showLocality#',
								showCity : '#attributes.showCity#',
								showState : '#attributes.showState#',
								showPostalCode : '#attributes.showPostalCode#',
								showCountry : '#attributes.showCountry#',
								countryCode : jQuery('select[name="#attributes.fieldNamePrefix#countryCode"]').val(),
								name : jQuery('input[name="#attributes.fieldNamePrefix#name"]').val(),
								company : jQuery('input[name="#attributes.fieldNamePrefix#company"]').val(),
								streetAddress : jQuery('input[name="#attributes.fieldNamePrefix#streetAddress"]').val(),
								street2Address : jQuery('input[name="#attributes.fieldNamePrefix#street2Address"]').val(),
								city : jQuery('input[name="#attributes.fieldNamePrefix#city"]').val(),
								postalCode : jQuery('input[name="#attributes.fieldNamePrefix#postalCode"]').val()
							};
							
							if( jQuery('input[name="#attributes.fieldNamePrefix#stateCode"]').val() != undefined ) {
								addressData["stateCode"] = jQuery('input[name="#attributes.fieldNamePrefix#stateCode"]').val();
							}
							
							console.log(addressData);
							
							jQuery.ajax({
								type: 'get',
								url: '/plugins/Slatwall/api/index.cfm/display/addressDisplay/',
								data: addressData,
								dataType: "json",
								context: document.body,
								success: function(r) {
									jQuery('div.addressDisplay').replaceWith(r);
								}
							});
							
						});
					});
				</script>
			<cfelse>
				<cfif len(attributes.address.getName())><strong>#attributes.address.getName()#</strong><br /></cfif>
				<cfif len(attributes.address.getCompany())>#attributes.address.getCompany()#<br /></cfif>
				<cfif len(attributes.address.getStreetAddress())>#attributes.address.getStreetAddress()#<br /></cfif>
				<cfif len(attributes.address.getStreet2Address())>#attributes.address.getStreet2Address()#<br /></cfif>
				<cfif len(attributes.address.getCity())>#attributes.address.getCity()#, </cfif>
				<cfif len(attributes.address.getStateCode())>#attributes.address.getStateCode()# </cfif>
				<cfif len(attributes.address.getPostalCode())>#attributes.address.getPostalCode()#</cfif><br />
				<cfif len(attributes.address.getCountryCode())>#attributes.address.getCountryCode()#</cfif>
			</cfif>
		</div>
	</cfoutput>
</cfif>