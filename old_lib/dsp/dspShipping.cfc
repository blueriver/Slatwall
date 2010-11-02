<cfcomponent output="false" name="dspShipping" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getShippingOptions" access="remote" returntype="string" output="false">
		<cfargument name="CartShippingAddressID" default="1" />
		<cfargument name="FirstName" default="" />
		<cfargument name="LastName" default="" />
		<cfargument name="Email" default="" />
		<cfargument name="PhoneNumber" default="" />
		<cfargument name="Country" default="" />
		<cfargument name="Locality" default="" />
		<cfargument name="State" default="" />
		<cfargument name="City" default="" />
		<cfargument name="PostalCode" default="" />
		<cfargument name="StreetAddress" default="" />
		
			<cfset var ShippingRates = structNew() />
			<cfset var returnHTML = "">
			<cfset var counter=0 />
			<cfset var CurrentOrderTotal = 0 />
			<cfset var CurrentShippingWeightTotal = 0 />
			<cfset var I = 0 />
			
			<cfset application.Slat.cartManager.updateCartShippingAddress(
				CartShippingAddressID = arguments.CartShippingAddressID,
				FirstName = arguments.FirstName,
				LastName = arguments.LastName,
				EMail = arguments.EMail,
				PhoneNumber = arguments.PhoneNumber,
				Country = arguments.Country,
				StreetAddress = arguments.StreetAddress,
				City = arguments.City,
				State = arguments.State,
				Locality = arguments.Locality,
				PostalCode = arguments.PostalCode
			) />
			
			<cfset ShippingRates = application.Slat.shippingManager.getShippingRates(arguments.CartShippingAddressID) />
			
			<cfsavecontent variable="ReturnHTML">
				<cfoutput>
					<div class="sdoShippingOptions">
						<h3 class="title">Shipping Methods</h3>
						<cfif arrayLen(#ShippingRates.FedEx#) gt 0>
							<input type="hidden" name="ShippingCarrier" value="FedEx" />
							
							<cfset CurrentOrderTotal = application.slat.cartManager.getCartItemsTotal() />
							<cfset CurrentShippingWeightTotal = application.slat.cartManager.getCartTotalShipmentWeight() />
							<cfloop array="#ShippingRates.FedEx#" index="I">
								
								<!--- Temporary Fix For Free Shipping, Should Be Removed Later --->
								<cfif CurrentOrderTotal gt 100 and I.Type eq "FEDEX_GROUND" and Session.slat.cart.ShippingAddresses[1].country eq "US" and CurrentShippingWeightTotal lt 20>
									<cfset I.Cost = 0>
								<cfelse>
									<cfset I.Cost = I.Cost * 1.10>
								</cfif>
								<!--- Temporary Fix For Free Shipping, Should Be Removed Later --->
								
								<cfset counter=counter+1 />
								<dl>
								<cfif I.Type eq Session.Slat.Cart.ShippingMethods[1].Method or (Session.Slat.Cart.ShippingMethods[1].Method eq "" and counter eq arraylen(#ShippingRates.FedEx#))>
									<cfset counter=0 />
									<dt>
										<input type="hidden" name="ShippingCost" value="#I.Cost#" />
										<input type="radio" name="ShippingMethod" value="#I.Type#" checked="checked" onClick="changeShippingMethod({'slatProcess':'UpdateCartShippingMethod','ShippingAddressID':'1','ShippingCarrier':'FedEx','ShippingMethod':'#I.Type#','ShippingCost':'#I.Cost#'})">
									</dt>
								<cfelse>
									<dt>
										<input type="radio" name="ShippingMethod" value="#I.Type#" onClick="changeShippingMethod({'slatProcess':'UpdateCartShippingMethod','ShippingAddressID':'1','ShippingCarrier':'FedEx','ShippingMethod':'#I.Type#','ShippingCost':'#I.Cost#'})">
									</dt>
								</cfif>
									<dd><span class="cost">#DollarFormat(I.Cost)#</span> - #application.Slat.shippingManager.getFriendlyShipMethodName(I.Type)#</dd>
								</dl>
							</cfloop>
						<cfelse>
							<div class="NoShippingRate">
								The Shipping Address you provided was not vaild.  Please verify all of the values, and click the button below.<br />
								<button class="slatButton btnGetShippingRates" onClick="updateShippingMethods();">Continue - Get Rates</button>
							</div>
						</cfif>
						<cfif arrayLen(#ShippingRates.FedEx#) gt 0>
							<button class="slatButton btnContinue" type="submit">Continue</button>
						</cfif>
						<script type="text/javascript">
							<cfif arrayLen(#ShippingRates.FedEx#) gt 0>
								$('form[name=ShippingDetails]').attr('onSubmit', 'return PowerValidate(this);');
							<cfelse>
								$('form[name=ShippingDetails]').attr('onSubmit', 'updateShippingMethods(); return false;');
							</cfif>
							function changeShippingMethod(FormValuesJSON){
								$('input[name=ShippingCost]').val(FormValuesJSON.ShippingCost);
								var sah = 'sdoCartOrderSummary';
								var Display = 'CartOrderSummary';
								runSlatProcess(FormValuesJSON, sah, Display);
							}
						</script>
					</div>
				</cfoutput>
			</cfsavecontent>
			
		<cfreturn #ReturnHTML# />
	</cffunction>
	
	<cffunction name="getShippingAddressForm" access="package" returntype="string" output="false">
		<cfargument name="CartShippingAddressID" default="1" />
		<cfargument name="FirstName" default="" />
		<cfargument name="LastName" default="" />
		<cfargument name="Email" default="" />
		<cfargument name="PhoneNumber" default="" />
		<cfargument name="Country" default="US" />
		<cfargument name="Locality" default="" />
		<cfargument name="State" default="" />
		<cfargument name="City" default="" />
		<cfargument name="PostalCode" default="" />
		<cfargument name="StreetAddress" default="" />
		<cfargument name="Street2Address" default="" />
		
		<cfset var ShippingCountriesQuery = querynew('empty') />
		<cfset var ThisCountry = querynew('empty') />
		<cfset var StatesQuery = querynew('empty') />
		<cfset var ShippingLocalityLabel = "" />
		<cfset var ShippingStateLabel = "" />
		<cfset var ShippingCityLabel = "" />
		<cfset var ShippingPostalCodeLabel = "" />
		<cfset var ShippingStreetAddressLabel = "" />
		<cfset var AjaxHook = "" />
		<cfset var returnHTML = "">
		
		<cfset ShippingCountriesQuery = application.slatSettings.getAllCountriesQuery() />
		<cfset ThisCountry = application.slatSettings.getCountryQuery(CountryCode=arguments.Country) />
		<cfset AjaxHook = application.slat.ajaxManager.getNewAjaxHook() />
		
		<cfif ThisCountry.DisplayTranslated eq 0>
			<cfset ShippingLocalityLabel = ThisCountry.LocalityDisplayName />
			<cfset ShippingStateLabel = ThisCountry.StateDisplayName />
			<cfset ShippingCityLabel = ThisCountry.CityDisplayName />
			<cfset ShippingPostalCodeLabel = ThisCountry.PostalCodeDisplayName />
			<cfset ShippingStreetAddressLabel = ThisCountry.StreetDisplayName />
			<cfset ShippingStreet2AddressLabel = ThisCountry.Street2DisplayName />
		<cfelseif ThisCountry.DisplayTranslated eq 1>
			<cfset ShippingLocalityLabel = ThisCountry.LocalityDisplayNameTranslated />
			<cfset ShippingStateLabel = ThisCountry.StateDisplayNameTranslated />
			<cfset ShippingCityLabel = ThisCountry.CityDisplayNameTranslated />
			<cfset ShippingPostalCodeLabel = ThisCountry.PostalCodeDisplayNameTranslated />
			<cfset ShippingStreetAddressLabel = ThisCountry.StreetDisplayNameTranslated />
			<cfset ShippingStreet2AddressLabel = ThisCountry.Street2DisplayNameTranslated />
		<cfelseif ThisCountry.DisplayTranslated eq 2>
			<cfif ThisCountry.LocalityDisplayName neq ThisCountry.LocalityDisplayNameTranslated>
				<cfset ShippingLocalityLabel = "#ThisCountry.LocalityDisplayName# <span class='translation'>(#ThisCountry.LocalityDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset ShippingLocalityLabel = ThisCountry.LocalityDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.StateDisplayName neq ThisCountry.StateDisplayNameTranslated>
				<cfset ShippingStateLabel = "#ThisCountry.StateDisplayName# <span class='translation'>(#ThisCountry.StateDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset ShippingStateLabel = ThisCountry.StateDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.CityDisplayName neq ThisCountry.CityDisplayNameTranslated>
				<cfset ShippingCityLabel = "#ThisCountry.CityDisplayName# <span class='translation'>(#ThisCountry.CityDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset ShippingCityLabel = ThisCountry.CityDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.PostalCodeDisplayName neq ThisCountry.PostalCodeDisplayNameTranslated>
				<cfset ShippingPostalCodeLabel = "#ThisCountry.PostalCodeDisplayName# <span class='translation'>(#ThisCountry.PostalCodeDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset ShippingPostalCodeLabel = ThisCountry.PostalCodeDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.StreetDisplayName neq ThisCountry.StreetDisplayNameTranslated>
				<cfset ShippingStreetAddressLabel = "#ThisCountry.StreetDisplayName# <span class='translation'>(#ThisCountry.StreetDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset ShippingStreetAddressLabel = ThisCountry.StreetDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.Street2DisplayName neq ThisCountry.Street2DisplayNameTranslated>
				<cfset ShippingStreet2AddressLabel = "#ThisCountry.Street2DisplayName# <span class='translation'>(#ThisCountry.Street2DisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset ShippingStreet2AddressLabel = ThisCountry.Street2DisplayNameTranslated />
			</cfif>
		</cfif>

		<cfsavecontent variable="ReturnHTML">
			<cfoutput>
				<div class="sdoShippingAddress #AjaxHook#">
					<h3 class="title">Shipping Address</h3>
					<dl class="ShippingFirstName">
						<dt>First Name</dt>
						<dd><input type="text" name="ShippingFirstName" value="#arguments.FirstName#" required="true" message="Please Enter a Shipping Contact First Name" maxlength="20" /></dd>
					</dl>
					<dl class="ShippingLastName">
						<dt>Last Name</dt>
						<dd><input type="text" name="ShippingLastName" value="#arguments.LastName#" required="true" message="Please Enter a Shipping Contact Last Name" maxlength="20" /></dd>
					</dl>
					<dl class="ShippingEmail">
						<dt>Email Address <span class="example">(john@hotmail.com)</span></dt>
						<dd><input type="text" name="ShippingEmail" value="#arguments.Email#" required="email" message="Please Enter a Valid Shipping Contact Email Address" maxlength="60" /></dd>
					</dl>
					<dl class="ShippingPhoneNumber">
						<dt>Phone Number <span class="example">(555-555-1234)</span></dt>
						<dd><input type="text" name="ShippingPhoneNumber" value="#arguments.PhoneNumber#" required="phone" message="Please Enter a Valid Shipping Contact Phone Number" maxlength="20" /></dd>
					</dl>
					<dl class="ShippingCountry">
						<dt><label for="Shipping Country">Country</label></dt>
						<dd>
							<select name="ShippingCountry" onChange="ShippingCountryChange();">
								<cfloop query="ShippingCountriesQuery">
									<option value="#ShippingCountriesQuery.CountryCode#"<cfif arguments.Country eq ShippingCountriesQuery.CountryCode> selected="selected"</cfif>>#ShippingCountriesQuery.CountryDisplayName#</option> 
								</cfloop>
							</select>
						</dd>
					</dl>
					<dl class="ShippingStreetAddress">
						<dt><label for="ShippingStreetAddress">#ShippingStreetAddressLabel#</label></dt>
						<dd>
							<cfif ThisCountry.StreetDisplayType eq 1>
								<input type="text" name="ShippingStreetAddress" value="#arguments.StreetAddress#" maxlength="50" required="yes" message="Please Enter A Valid Shipping #ShippingStreetAddressLabel#" />
							<cfelse>
								<input type="text" name="ShippingStreetAddress" value="#arguments.StreetAddress#" maxlength="50" />
							</cfif>
						</dd>
					</dl>
					<cfif ThisCountry.Street2DisplayType gt 0>
						<dl class="ShippingStreetTwoAddress">
							<dt><label for="ShippingStreet2Address">#ShippingStreet2AddressLabel#</label></dt>
							<dd><input type="text" name="ShippingStreet2Address" value="#arguments.Street2Address#" maxlength="50" <cfif ThisCountry.Street2DisplayType eq 1>required="true" message="Please Enter A Valid Shipping #ShippingStreet2AddressLabel#"</cfif> /></dd>
						</dl>
					</cfif>
					<cfif ThisCountry.LocalityDisplayType gt 0>
						<dl class="ShippingLocality">
							<dt><label for="ShippingLocality">#ShippingLocalityLabel#</label></dt>
							<dd><input type="text" name="ShippingLocality" value="#arguments.Locality#" maxlength="20" onChange="updateShippingMethods();" <cfif ThisCountry.LocalityDisplayType eq 1>required="true" message="Please Enter A Valid Shipping #ShippingLocalityLabel#"</cfif> /></dd>
						</dl>
					</cfif>
					<cfif ThisCountry.CityDisplayType gt 0>
						<dl class="ShippingCity">
							<dt><label for="ShippingCity">#ShippingCityLabel#</label></dt>
							<dd>
								<cfif ThisCountry.CityDisplayType eq 2>
									<cfset CitiesQuery = application.slatsettings.getCitiesByCountryCodeQuery(ThisCountry.CountryCode) />
									<select name="ShippingCity" onChange="updateShippingMethods();" required="true" message="Please Enter A Valid Shipping #ShippingCityLabel#">
										<option value=""<cfif arguments.City eq ""> selected="selected"</cfif>>Select #ShippingCityLabel#</option>
										<cfloop query="CitiesQuery">
											<option value="#CitiesQuery.CityCode#"<cfif arguments.City eq CitiesQuery.CityCode> selected="selected"</cfif>>#CitiesQuery.CityDisplayName#</option> 
										</cfloop>
									</select>
								<cfelse>
									<input type="text" name="ShippingCity" onChange="updateShippingMethods();" value="#arguments.City#" maxlength="20" <cfif ThisCountry.CityDisplayType eq 1>required="true" message="Please Enter A Valid Shipping #ShippingCityLabel#"</cfif> />
								</cfif>
							</dd>
						</dl>
					</cfif>
					<cfif ThisCountry.StateDisplayType gt 0>
						<dl class="ShippingState">
							<dt><label for="ShippingState">#ShippingStateLabel#</label></dt>
							<dd>
								<cfif ThisCountry.StateDisplayType eq 2>
									<cfset StatesQuery = application.slatsettings.getStatesByCountryCodeQuery(ThisCountry.CountryCode) />
									<select name="ShippingState" onChange="updateShippingMethods();" required="true" message="Please Enter A Valid Shipping #ShippingStateLabel#">
										<option value=""<cfif arguments.State eq ""> selected="selected"</cfif>>Select #ShippingStateLabel#</option>
										<cfloop query="StatesQuery">
											<option value="#StatesQuery.StateCode#"<cfif arguments.State eq StatesQuery.StateCode> selected="selected"</cfif>>#StatesQuery.StateDisplayName#</option> 
										</cfloop>
									</select>
								<cfelse>
									<input type="text" name="ShippingState" onChange="updateShippingMethods();" value="#arguments.State#" maxlength="5">
								</cfif>
							</dd>
						</dl>
					</cfif>
					<cfif ThisCountry.PostalCodeDisplayType gt 0>
						<dl class="ShippingPostalCode">
							<dt><label for="ShippingPostalCode">#ShippingPostalCodeLabel#</label></dt>
							<dd><input type="text" name="ShippingPostalCode" value="#arguments.PostalCode#" onChange="updateShippingMethods();" required="true" message="Please Enter A Valid #ShippingPostalCodeLabel#" /></dd>
						</dl>
					</cfif>
						<script type="text/javascript">
						function ShippingCountryChange(){
							var Display = "ShippingAddressForm";
							var DisplaySettingsJSON = {
								"CartShippingAddressID": "#arguments.CartShippingAddressID#",
								"FirstName": $('input[name=ShippingFirstName]').val(),
								"LastName": $('input[name=ShippingLastName]').val(),
								"Email": $('input[name=ShippingEmail]').val(),
								"PhoneNumber": $('input[name=ShippingPhoneNumber]').val(),
								"Country": $('select[name=ShippingCountry] :selected').val(),
								"Locality": $('input[name=ShippingLocality]').val(),
								"State": <cfif ThisCountry.StateDisplayType eq 1>$('input[name=ShippingState]').val()<cfelse>$('select[name=ShippingState] :selected').val()</cfif>,
								"City": $('input[name=ShippingCity]').val(),
								"State": $('input[name=ShippingState]').val(),
								"PostalCode": $('input[name=ShippingPostalCode]').val(),
								"StreetAddress": $('input[name=ShippingStreetAddress]').val(),
								"Street2Address": $('input[name=ShippingStreet2Address]').val()
							};
							var sah = "#AjaxHook#";
							getSlatDisplay(sah, Display, DisplaySettingsJSON);
							updateShippingMethods();
						}
						 
						function updateShippingMethods(){
							$('button.btnContinue').css('display','none');
							$('form[name=ShippingDetails]').attr('onSubmit', 'return false;');
							var DisplaySettingsJSON = {
								"CartShippingAddressID": "#arguments.CartShippingAddressID#",
								"FirstName": $('input[name=ShippingFirstName]').val(),
								"LastName": $('input[name=ShippingLastName]').val(),
								"Email": $('input[name=ShippingEmail]').val(),
								"PhoneNumber": $('input[name=ShippingPhoneNumber]').val(),
								"Country": $('select[name=ShippingCountry] :selected').val(),
								"Locality": $('input[name=ShippingLocality]').val(),
								"State": <cfif ThisCountry.StateDisplayType eq 1>$('input[name=ShippingState]').val()<cfelse>$('select[name=ShippingState] :selected').val()</cfif>,
								"City": $('input[name=ShippingCity]').val(),
								"PostalCode": $('input[name=ShippingPostalCode]').val(),
								"StreetAddress": $('input[name=ShippingStreetAddress]').val(),
								"Street2Address": $('input[name=ShippingStreet2Address]').val()
							};
							displaySlatPreloader('sdoShippingOptions', 'Loading Rates', '<h3 class="title">Shipping Methods</h3>');
							getSlatDisplay('sdoShippingOptions', 'ShippingOptions', DisplaySettingsJSON);
						}
					</script>
				</div>
			</cfoutput>
		</cfsavecontent>
			
		<cfreturn returnHTML>
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>