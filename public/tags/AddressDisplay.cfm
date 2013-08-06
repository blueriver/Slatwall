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
<cfparam name="attributes.domType" type="string" default="p" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<#attributes.domType# class="sw-address-display">
			<cfif !isNull(attributes.address.getName()) and len(attributes.address.getName())>
				#attributes.address.getName()#<br />
			</cfif>
			<cfif !isNull(attributes.address.getCompany()) and len(attributes.address.getCompany())>
				#attributes.address.getCompany()#<br />
			</cfif>
			<cfif !isNull(attributes.address.getStreetAddress()) and len(attributes.address.getStreetAddress())>
				#attributes.address.getStreetAddress()#<br />
			</cfif>
			<cfif !isNull(attributes.address.getStreet2Address()) and len(attributes.address.getStreet2Address())>
				#attributes.address.getStreet2Address()#<br />
			</cfif>
			<cfif !isNull(attributes.address.getCity()) and len(attributes.address.getCity())>
				#attributes.address.getCity()#,
			</cfif>
			<cfif !isNull(attributes.address.getStateCode()) and len(attributes.address.getStateCode())>
				#attributes.address.getStateCode()# 
			</cfif>
			<cfif !isNull(attributes.address.getPostalCode()) and len(attributes.address.getPostalCode())>
				#attributes.address.getPostalCode()#
			</cfif>
			<br />
			<cfif !isNull(attributes.address.getCountryCode()) and len(attributes.address.getCountryCode())>
				#attributes.address.getCountryCode()#<br />
			</cfif>
		</#attributes.domType#>
	</cfoutput>
</cfif>