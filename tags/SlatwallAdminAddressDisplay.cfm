<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfparam name="attributes.showCountry" type="boolean" default="true" />
<cfparam name="attributes.showName" type="boolean" default="true" />
<cfparam name="attributes.showCompany" type="boolean" default="true" />
<cfparam name="attributes.showStreetAddress" type="boolean" default="true" />
<cfparam name="attributes.showStreet2Address" type="boolean" default="true" />
<cfparam name="attributes.showLocality" type="boolean" default="true" />
<cfparam name="attributes.showCity" type="boolean" default="true" />
<cfparam name="attributes.showState" type="boolean" default="true" />
<cfparam name="attributes.showPostalCode" type="boolean" default="true" />


<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="slatwall-address-container">
			<input type="hidden" name="#attributes.fieldNamePrefix#addressID" value="#attributes.address.getAddressID()#" />
			<cfif attributes.showCountry>
				<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#countryCode" property="countryCode" fieldType="select" edit="#attributes.edit#" fieldClass="slatwall-address-countryCode" />
			</cfif>
			<cfif attributes.showName>
				<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#name" property="name" edit="#attributes.edit#" fieldClass="slatwall-address-name" />
			</cfif>
			<cfif attributes.showCompany>
				<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#company" property="company" edit="#attributes.edit#" fieldClass="slatwall-address-company"  />
			</cfif>
			<cfif attributes.address.getCountry().getStreetAddressShowFlag() and attributes.showStreetAddress>
				<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#streetAddress" property="streetAddress" edit="#attributes.edit#" fieldClass="slatwall-address-streetAddress" />	
			</cfif>
			<cfif attributes.address.getCountry().getStreet2AddressShowFlag() and attributes.showStreet2Address>
				<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#street2Address" property="street2Address" edit="#attributes.edit#" fieldClass="slatwall-address-street2Address" />	
			</cfif>
			<cfif attributes.address.getCountry().getCityShowFlag() and attributes.showCity>
				<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#city" property="city" edit="#attributes.edit#" fieldClass="slatwall-address-city" />	
			</cfif>
			<cfif attributes.address.getCountry().getStateCodeShowFlag() and attributes.showState>
				<cfif arrayLen(attributes.address.getStateCodeOptions()) gt 1>
					<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="select" edit="#attributes.edit#" fieldClass="slatwall-address-stateCode" />
				<cfelse>
					<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="text" edit="#attributes.edit#" fieldClass="slatwall-address-stateCode" />
				</cfif>
			</cfif>
			<cfif attributes.address.getCountry().getPostalCodeShowFlag() and attributes.showPostalCode>
				<cf_HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#postalCode" property="postalCode" edit="#attributes.edit#" fieldClass="slatwall-address-postalCode" />	
			</cfif>
		</div>
	</cfoutput>
</cfif>