<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="/Slatwall/public/tags" />

<!---[DEVELOPER NOTES]															
																				
	If you would like to customize any of the public tags used by this			
	template, the recommended method is to uncomment the below import,			
	copy the tag you'd like to customize into the directory defined by			
	this import, and then reference with swc:tagname instead of sw:tagname.		
	Technically you can define the prefix as whatever you would like and use	
	whatever directory you would like but we recommend using this for			
	the sake of convention.														
																				
	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />				
																				
--->

<cfparam name="attributes.address" type="any" />
<cfparam name="attributes.ID" type="string" default="#createUUID()#" />
<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
<cfparam name="attributes.fieldList" type="string" default="countryCode,name,company,streetAddress,street2Address,locality,city,stateCode,postalCode" />
<cfparam name="attributes.fieldClass" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<!--- We place all of thse values into a 'sw-address' div so that the jQuery below updates the address fields based on --->
		<div id="#attributes.ID#" class="sw-address">
			
			<!--- We need to add a hidden address field so that the data can be populated, or updated --->
			<input type="hidden" name="#attributes.fieldNamePrefix#addressID" value="#attributes.address.getAddressID()#" />
			
			<cfloop list="#attributes.fieldList#" index="thisField">
				<!--- Country (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "countryCode">
					<div class="control-group" data-sw-address="countryCode">
						<label class="control-label" for="rating">#request.slatwallScope.rbKey('entity.address.countryCode')#</label>
						<div class="controls">
							
							<sw:formField type="select" name="#attributes.fieldNamePrefix#countryCode" valueObject="#attributes.address#" valueObjectProperty="countryCode" valueOptions="#attributes.address.getCountryCodeOptions()#" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="countryCode" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Name (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "name">
					<div class="control-group" data-sw-property="name">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.name')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:formField type="text" name="#attributes.fieldNamePrefix#name" valueObject="#attributes.address#" valueObjectProperty="name" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="name" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Company (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif thisField eq "company">
					<div class="control-group" data-sw-property="company">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.company')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:formField type="text" name="#attributes.fieldNamePrefix#company" valueObject="#attributes.address#" valueObjectProperty="company" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="company" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Street Address (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif attributes.address.getCountry().getStreetAddressShowFlag() and thisField eq "streetAddress">
					<div class="control-group" data-sw-property="streetAddress">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.streetAddress')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:formField type="text" name="#attributes.fieldNamePrefix#streetAddress" valueObject="#attributes.address#" valueObjectProperty="streetAddress" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="streetAddress" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Street 2 Address (important the data-sw-address allows for this to be modified by jQuery below)--->
				<cfif attributes.address.getCountry().getStreet2AddressShowFlag() and thisField eq "street2Address">
					<div class="control-group" data-sw-property="street2Address">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.street2Address')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:formField type="text" name="#attributes.fieldNamePrefix#street2Address" valueObject="#attributes.address#" valueObjectProperty="street2Address" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="street2Address" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Locality --->
				<cfif attributes.address.getCountry().getLocalityShowFlag() and thisField eq "locality">
					<div class="control-group" data-sw-property="postalCode">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.locality')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:formField type="text" name="#attributes.fieldNamePrefix#locality" valueObject="#attributes.address#" valueObjectProperty="locality" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="locality" />
							
						</div>
					</div>
				</cfif>
				
				<!--- City --->
				<cfif attributes.address.getCountry().getCityShowFlag() and thisField eq "city">
					<div class="control-group" data-sw-property="city">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.city')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:formField type="text" name="#attributes.fieldNamePrefix#city" valueObject="#attributes.address#" valueObjectProperty="city" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="city" />
							
						</div>
					</div>
				</cfif>
				
				<!--- State Code --->
				<cfif attributes.address.getCountry().getStateCodeShowFlag() and thisField eq "stateCode">
					<div class="control-group" data-sw-property="stateCode">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.stateCode')#</label>
						<div class="controls" data-sw-field="true">
							
							<cfif arrayLen(attributes.address.getStateCodeOptions()) gt 1>
								<sw:formField type="select" name="#attributes.fieldNamePrefix#stateCode" valueObject="#attributes.address#" valueObjectProperty="stateCode" valueOptions="#attributes.address.getStateCodeOptions()#" class="#attributes.fieldClass#" />
							<cfelse>
								<sw:formField type="text" name="#attributes.fieldNamePrefix#stateCode" valueObject="#attributes.address#" valueObjectProperty="stateCode" class="#attributes.fieldClass#" />
							</cfif>
							<sw:errorDisplay object="#attributes.address#" errorName="stateCode" />
							
						</div>
					</div>
				</cfif>
				
				<!--- Postal Code --->
				<cfif attributes.address.getCountry().getPostalCodeShowFlag() and thisField eq "postalCode">
					<div class="control-group" data-sw-property="postalCode">
						<label class="control-label" for="rating" data-sw-label="true">#request.slatwallScope.rbKey('entity.address.postalCode')#</label>
						<div class="controls" data-sw-field="true">
							
							<sw:formField type="text" name="#attributes.fieldNamePrefix#postalCode" valueObject="#attributes.address#" valueObjectProperty="postalCode" class="#attributes.fieldClass#" />
							<sw:errorDisplay object="#attributes.address#" errorName="postalCode" />
							
						</div>
					</div>
				</cfif>
			</cfloop>
			<script type="text/javascript">
				
				(function($){
					
					$(document).ready(function(e){
						
						$('body').on('change', 'select[name="#attributes.fieldNamePrefix#countryCode"]', function(){
							
							var fieldList = '#attributes.fieldList#';
							
							var data = {
								'slatAction': 'public:ajax.country',
								'countryCode': $(this).val()
							};
							
							jQuery.ajax({
								type: 'get',
								url: '#request.slatwallScope.getApplicationValue("baseURL")#/',
								data: data,
								dataType: "json",
								context: document.body,
								beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
								error: function( err ) {
									alert('There was an error processing request: ' + err);
								},
								success: function(r) {
									console.log(r);
								}
							});
							
						});
							
					});
					
				})( jQuery );
				
			</script>
		</div>
	</cfoutput>
</cfif>