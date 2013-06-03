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