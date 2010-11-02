<cfcomponent output="false" name="dspBilling" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBillingPaymentForm" access="package" returntype="string" output="false">
		<cfargument name="SplitPayment" default=0 />
		<cfargument name="ActiveTab" default="stidCreditCard" />
		<cfargument name="PaymentType" default="" />
		<cfargument name="PaymentCardNumber" default="" />
		<cfargument name="PaymentSecurityCode" default="" />
		<cfargument name="PaymentExpirationMonth" default="" />
		<cfargument name="PaymentExpirationYear" default="" />
		<cfargument name="PaymentCardHolderName" default="" />
		<cfargument name="PaymentGiftCardNumber" default="" />
		
		<cfset var returnHTML = "">
		<cfset var ThisPaymentMethod = structnew() />
		<cfset var ThisCartPaymentID = 0 />
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoBillingPaymentForm">
					<cfif arrayLen(#session.slat.cart.paymentmethods#) gt 0>
						<div class="sdoBillingPaymentsApplied">
							<h3 class="title">Applied Payments</h3>
							#application.slat.messageManager.dspMessage(FormName="RemovePayment")#
							<cfloop from="1" to="#arrayLen(session.slat.cart.paymentmethods)#" index="ThisCartPaymentID">
								<cfset ThisPaymentMethod = structcopy(session.slat.cart.paymentmethods[ThisCartPaymentID]) />
								<ul class="AppliedPayment">
									<li class="PaymentType">#ThisPaymentMethod.Type#</li>
									<li class="PaymentCardNumber"> #application.slat.utilityManager.getSecureCardNumber(ThisPaymentMethod.CardNumber)#</li>
									<li class="PaymentAmount"> #DollarFormat(ThisPaymentMethod.Amount)# </li>
									<li class="Remove">
										<a href="##" onClick="removeCartPayment('#ThisCartPaymentID#'); displaySlatPreloader('sdoBillingPaymentForm', 'Loading', '<h3 class=title>Add Payment</h3>');">Remove</a>
									</li>
								</ul>
							</cfloop>
						</div>
					</cfif>
					<cfif not application.slat.cartManager.getCartAmountDueTotal() lt .01>
						<h3 class="title">Add Payment</h3>
						<ul class="stNav">
							<li class="stidCreditCard">Credit Card</li>
							<li class="stidGiftCard">Gift Card</li>
						</ul>
						<div class="stTab stidCreditCard">
							#application.slat.messageManager.dspMessage(FormName="AddPaymentMethod")#
							<cfif arguments.SplitPayment>
								<form name="AddPaymentMethod" method="Post" onSubmit="return false; ">
							</cfif>
							<input type="hidden" name="slatProcess" value="AddCartPaymentMethod">
							<dl class="PaymentType">
								<dt><label for="PaymentType">Type of Card</label></dt>
								<dd>
									<input type="radio" name="PaymentType" value="Visa"<cfif arguments.PaymentType eq "Visa" or arguments.PaymentType eq ""> checked="checked"</cfif>>
									<img src="#Application.SlatSettings.getSetting('PluginPath')#/images/paymenticons/Visa.gif" />
									<input type="radio" name="PaymentType" value="Mastercard"<cfif arguments.PaymentType eq "Mastercard"> checked="checked"</cfif>>
									<img src="#Application.SlatSettings.getSetting('PluginPath')#/images/paymenticons/Mastercard.gif" />
									<input type="radio" name="PaymentType" value="AMEX"<cfif arguments.PaymentType eq "AMEX"> checked="checked"</cfif>>
									<img src="#Application.SlatSettings.getSetting('PluginPath')#/images/paymenticons/AMEX.gif" />
									<input type="radio" name="PaymentType" value="Discover"<cfif arguments.PaymentType eq "Discover"> checked="checked"</cfif>>
									<img src="#Application.SlatSettings.getSetting('PluginPath')#/images/paymenticons/Discover.gif" />
								</dd>
							</dl>
							<dl class="PaymentCardNumber">
								<dt><label for="PaymentCardNumber">Credit Card Number</label></dt>
								<dd><input type="text" name="PaymentCardNumber" value="#arguments.PaymentCardNumber#" required="true" message="Please Provide A Valid Credit Card Number" maxlength="20" /></dd>
							</dl>
							<dl class="PaymentSecurityCode">
								<dt><label for="PaymentSecurityCode">CVV Code</label></dt>
								<dd><input type="text" name="PaymentSecurityCode" value="#arguments.PaymentSecurityCode#" required="true" message="Please Provide A Valid 3 or 4 Digit CVV Code" maxlength="4" /></dd>
							</dl>
							<dl class="PaymentExpiration">
								<dt><label for="PaymentExpirationMonth">Exp. Date <span class="example">(MM / YY)</span></label></dt>
								<dd>
									<select name="PaymentExpirationMonth" required="true" message="Please Select Expiration Month">
										<option value=""<cfif arguments.PaymentExpirationMonth eq ""> selected="selected"</cfif>>Exp Month</option>
										<option value="01"<cfif arguments.PaymentExpirationMonth eq "01"> selected="selected"</cfif>>01</option>
										<option value="02"<cfif arguments.PaymentExpirationMonth eq "02"> selected="selected"</cfif>>02</option>
										<option value="03"<cfif arguments.PaymentExpirationMonth eq "03"> selected="selected"</cfif>>03</option>
										<option value="04"<cfif arguments.PaymentExpirationMonth eq "04"> selected="selected"</cfif>>04</option>
										<option value="05"<cfif arguments.PaymentExpirationMonth eq "05"> selected="selected"</cfif>>05</option>
										<option value="06"<cfif arguments.PaymentExpirationMonth eq "06"> selected="selected"</cfif>>06</option>
										<option value="07"<cfif arguments.PaymentExpirationMonth eq "07"> selected="selected"</cfif>>07</option>
										<option value="08"<cfif arguments.PaymentExpirationMonth eq "08"> selected="selected"</cfif>>08</option>
										<option value="09"<cfif arguments.PaymentExpirationMonth eq "09"> selected="selected"</cfif>>09</option>
										<option value="10"<cfif arguments.PaymentExpirationMonth eq "10"> selected="selected"</cfif>>10</option>
										<option value="11"<cfif arguments.PaymentExpirationMonth eq "11"> selected="selected"</cfif>>11</option>
										<option value="12"<cfif arguments.PaymentExpirationMonth eq "12"> selected="selected"</cfif>>12</option>
									</select>
									<select name="PaymentExpirationYear" required="true" message="Please Select Expiration Year">
										<option value=""<cfif arguments.PaymentExpirationYear eq ""> selected="selected"</cfif>>Exp Year</option>
										<option value="2010"<cfif arguments.PaymentExpirationYear eq "2010"> selected="selected"</cfif>>2010</option>
										<option value="2011"<cfif arguments.PaymentExpirationYear eq "2011"> selected="selected"</cfif>>2011</option>
										<option value="2012"<cfif arguments.PaymentExpirationYear eq "2012"> selected="selected"</cfif>>2012</option>
										<option value="2013"<cfif arguments.PaymentExpirationYear eq "2013"> selected="selected"</cfif>>2013</option>
										<option value="2014"<cfif arguments.PaymentExpirationYear eq "2014"> selected="selected"</cfif>>2014</option>
										<option value="2015"<cfif arguments.PaymentExpirationYear eq "2015"> selected="selected"</cfif>>2015</option>
										<option value="2016"<cfif arguments.PaymentExpirationYear eq "2016"> selected="selected"</cfif>>2016</option>
										<option value="2017"<cfif arguments.PaymentExpirationYear eq "2017"> selected="selected"</cfif>>2017</option>
										<option value="2018"<cfif arguments.PaymentExpirationYear eq "2018"> selected="selected"</cfif>>2018</option>
										<option value="2019"<cfif arguments.PaymentExpirationYear eq "2019"> selected="selected"</cfif>>2019</option>
										<option value="2020"<cfif arguments.PaymentExpirationYear eq "2020"> selected="selected"</cfif>>2020</option>
									</select>
								</dd>
							</dl>
							<dl class="PaymentCardHolderName">
								<dt><label for="PaymentCardHolderName">Name On Credit Card</label></dt>
								<dd><input type="text" name="PaymentCardHolderName" value="#arguments.PaymentCardHolderName#" required="true" message="Please Enter The Card Holders Name as it Appears on the Card" /></dd>
							</dl>
							<dl class="PaymentAmount">
								<dt><label for="PaymentAmount">Amount</label></dt>
								<dd>
									<cfif SplitPayment>
										<input type="text" name="PaymentAmount" value="#application.slat.cartManager.getCartAmountDueTotal()#" required="true" message="Please Enter A Valid Payment Amount" /><!--- <a href="javascript:;" onClick="splitCreditCard('0','stidCreditCard')">Cancel---></a>
									<cfelse>
										<input type="hidden" name="PaymentAmount" value="#application.slat.cartManager.getCartAmountDueTotal()#" />#DollarFormat(application.slat.cartManager.getCartAmountDueTotal())#<!---<a href="javascript:;" onClick="splitCreditCard('1','stidCreditCard')">Split Payment---></a>
									</cfif>
								</dd>
							</dl>
							<cfif arguments.SplitPayment>
								<button class="slatButton btnAddCard" onClick="processSlatFormAjax($('form[name=AddPaymentMethod]'),'sdoBillingPaymentForm', 'BillingPaymentForm');">Add Card</button>
							</form>
							</cfif>
						</div>
						
						<div class="stTab stidGiftCard">
							<form name="AddGiftCard" onSubmit="return false;" method="post">
								<cfif arguments.PaymentGiftCardNumber eq "">
									<dl class="PaymentCardNumber">
										<dt><label for="PaymentGiftCardNumber">Gift Card Number</label></dt>
										<dd><input type="text" name="PaymentGiftCardNumber" /></dd>
									</dl>
									<button class="slatButton btnCheckGiftCardValue" onClick="checkGiftCardValue();">Check Value</button>
								<cfelse>
									<cfset BalanceQuery = application.Slat.integrationManager.getGiftCardBalanceQuery(arguments.PaymentGiftCardNumber) />
									<cfset CartAmountDue = application.slat.cartManager.getCartAmountDueTotal() />
									<dl class="PaymentCardNumber">
										<dt>Gift Card Number</dt>
										<dd>#arguments.PaymentGiftCardNumber#</dd>
									</dl>
									<cfif BalanceQuery.recordcount lt 1 or BalanceQuery.CardValue eq 0>
										<dl class="CardValue">
											<dt>Card Value</dt>
											<dd>#DollarFormat(0)#</dd>
										</dl>
										<dl class="PaymentCardNumber">
											<dt><label for="PaymentGiftCardNumber">Try Another Card</label></dt>
											<dd><input type="text" name="PaymentGiftCardNumber" /></dd>
										</dl>
										<button class="slatButton btnCheckGiftCardValue" onClick="checkGiftCardValue();">Check Card Value</button>
									<cfelse>
										<dl class="CardValue">
											<dt>Card Value</dt>
											<dd>#DollarFormat(BalanceQuery.CardValue)#</dd>
										</dl>
										<cfif BalanceQuery.CardValue gt application.slat.cartManager.getCartAmountDueTotal()>
											<cfset BalanceAfterUser = BalanceQuery.CardValue - CartAmountDue />
											<dl class="AmountDue">
												<dt>Amount Due</dt>
												<dd>#DollarFormat(CartAmountDue)#</dd>
											</dl>
											<dl class="Balance">
												<dt>Balance After Use</dt>
												<dd>#DollarFormat(BalanceAfterUser)#</dd>
											</dl>
											<input type="hidden" name="PaymentAmount" value="#CartAmountDue#"  />
										<cfelse>
											<dl class="Balance">
												<dt>Card Balance After Use</dt>
												<dd>#DollarFormat(0)#</dd>
											</dl>
											<dl class="RemainingDue">
												<dt>Remaining Total Due</dt>
												<dd>#DollarFormat(CartAmountDue - BalanceQuery.CardValue)#</dd>
											</dl>
											<input type="hidden" name="PaymentAmount" value="#BalanceQuery.CardValue#"  />
										</cfif>
										
										<input type="hidden" name="PaymentType" value="GiftCard"  />
										<input type="hidden" name="PaymentCardNumber" value="#arguments.PaymentGiftCardNumber#"  />
										<input type="hidden" name="slatProcess" value="AddCartPaymentMethod"  />
										<button class="slatButton btnApplyGiftCard" onClick="applyGiftCard();">Apply Card</button>
										<button class="slatButton btnCancelSmall" onClick="splitCreditCard('0', 'stidGiftCard');">Cancel</button>
									</cfif>
								</cfif>
							</form>	
						</div>
						
					</cfif>
					<cfif not arguments.SplitPayment>
						<input type="hidden" name="onSuccess" value="/index.cfm/checkout/confirm/" />
						<button class="slatButton btnContinue" type="submit" onClick="if(PowerValidate($('form[name=Payment]')) == true){$('form[name=Payment]').submit();};">Continue</button>
					</cfif>
					<script type="text/javascript">
						activateSlatTabs();
						focusSlatTab('#arguments.ActiveTab#');
						
						function splitCreditCard(onoff, activeTab){
							var DisplaySettingsJSON = {
								"SplitPayment": onoff,
								"ActiveTab": activeTab,
								"PaymentType": $('input[name=PaymentType]:radio:checked').val(),
								"PaymentCardNumber": $('input[name=PaymentCardNumber]').val(),
								"PaymentSecurityCode": $('input[name=PaymentSecurityCode]').val(),
								"PaymentExpirationMonth": $('select[name=PaymentExpirationMonth] :selected').val(),
								"PaymentExpirationYear": $('select[name=PaymentExpirationYear] :selected').val(),
								"PaymentCardHolderName": $('input[name=PaymentCardHolderName]').val()
							};
							displaySlatPreloader('sdoBillingPaymentForm', 'Loading', '<h3 class="title">Add Payment</h3>');
							getSlatDisplay('sdoBillingPaymentForm', 'BillingPaymentForm', DisplaySettingsJSON);
						}
						
						function checkGiftCardValue(){
							var DisplaySettingsJSON = {
								"SplitPayment": "0",
								"ActiveTab": "stidGiftCard",
								"PaymentType": $('input[name=PaymentType]:radio:checked').val(),
								"PaymentCardNumber": $('input[name=PaymentCardNumber]').val(),
								"PaymentSecurityCode": $('input[name=PaymentSecurityCode]').val(),
								"PaymentExpirationMonth": $('select[name=PaymentExpirationMonth] :selected').val(),
								"PaymentExpirationYear": $('select[name=PaymentExpirationYear] :selected').val(),
								"PaymentCardHolderName": $('input[name=PaymentCardHolderName]').val(),
								"PaymentGiftCardNumber": $('input[name=PaymentGiftCardNumber]').val()
							};
							displaySlatPreloader('sdoBillingPaymentForm', 'Loading', '<h3 class="title">Add Payment</h3>');
							getSlatDisplay('sdoBillingPaymentForm', 'BillingPaymentForm', DisplaySettingsJSON);
						}
						
						function applyGiftCard(){
							var DisplaySettingsJSON = {
								"SplitPayment": "0",
								"ActiveTab": "stidCreditCard",
								"PaymentType": $('input[name=PaymentType]:radio:checked').val(),
								"PaymentCardNumber": $('input[name=PaymentCardNumber]').val(),
								"PaymentSecurityCode": $('input[name=PaymentSecurityCode]').val(),
								"PaymentExpirationMonth": $('select[name=PaymentExpirationMonth] :selected').val(),
								"PaymentExpirationYear": $('select[name=PaymentExpirationYear] :selected').val(),
								"PaymentCardHolderName": $('input[name=PaymentCardHolderName]').val()
							};
							processSlatFormAjax($('form[name=AddGiftCard]'),'sdoBillingPaymentForm', 'BillingPaymentForm', DisplaySettingsJSON);
						}
					</script>
				</div>
				
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn ReturnHTML />
	</cffunction>
	
	<cffunction name="getBillingAddressForm" access="package" returntype="string" output="false">
		<cfargument name="CartBillingAddressID" default="1" />
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
		
		<cfset var BillingCountriesQuery = querynew('empty') />
		<cfset var ThisCountry = querynew('empty') />
		<cfset var StatesQuery = querynew('empty') />
		<cfset var BillingLocalityLabel = "" />
		<cfset var BillingStateLabel = "" />
		<cfset var BillingCityLabel = "" />
		<cfset var BillingPostalCodeLabel = "" />
		<cfset var BillingStreetAddressLabel = "" />
		<cfset var BillingStreet2AddressLabel = "" />
		
		<cfset var AjaxHook = "" />
		<cfset var returnHTML = "">
		
		<cfset BillingCountriesQuery = application.slatSettings.getAllCountriesQuery() />
		<cfset ThisCountry = application.slatSettings.getCountryQuery(CountryCode=arguments.Country) />
		<cfset AjaxHook = application.slat.ajaxManager.getNewAjaxHook() />
		
		<cfif ThisCountry.DisplayTranslated eq 0>
			<cfset BillingLocalityLabel = ThisCountry.LocalityDisplayName />
			<cfset BillingStateLabel = ThisCountry.StateDisplayName />
			<cfset BillingCityLabel = ThisCountry.CityDisplayName />
			<cfset BillingPostalCodeLabel = ThisCountry.PostalCodeDisplayName />
			<cfset BillingStreetAddressLabel = ThisCountry.StreetDisplayName />
			<cfset BillingStreet2AddressLabel = ThisCountry.Street2DisplayName />
		<cfelseif ThisCountry.DisplayTranslated eq 1>
			<cfset BillingLocalityLabel = ThisCountry.LocalityDisplayNameTranslated />
			<cfset BillingStateLabel = ThisCountry.StateDisplayNameTranslated />
			<cfset BillingCityLabel = ThisCountry.CityDisplayNameTranslated />
			<cfset BillingPostalCodeLabel = ThisCountry.PostalCodeDisplayNameTranslated />
			<cfset BillingStreetAddressLabel = ThisCountry.StreetDisplayNameTranslated />
			<cfset BillingStreet2AddressLabel = ThisCountry.Street2DisplayNameTranslated />
		<cfelseif ThisCountry.DisplayTranslated eq 2>
			<cfif ThisCountry.LocalityDisplayName neq ThisCountry.LocalityDisplayNameTranslated>
				<cfset BillingLocalityLabel = "#ThisCountry.LocalityDisplayName# <span class='translation'>(#ThisCountry.LocalityDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset BillingLocalityLabel = ThisCountry.LocalityDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.StateDisplayName neq ThisCountry.StateDisplayNameTranslated>
				<cfset BillingStateLabel = "#ThisCountry.StateDisplayName# <span class='translation'>(#ThisCountry.StateDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset BillingStateLabel = ThisCountry.StateDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.CityDisplayName neq ThisCountry.CityDisplayNameTranslated>
				<cfset BillingCityLabel = "#ThisCountry.CityDisplayName# <span class='translation'>(#ThisCountry.CityDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset BillingCityLabel = ThisCountry.CityDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.PostalCodeDisplayName neq ThisCountry.PostalCodeDisplayNameTranslated>
				<cfset BillingPostalCodeLabel = "#ThisCountry.PostalCodeDisplayName# <span class='translation'>(#ThisCountry.PostalCodeDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset BillingPostalCodeLabel = ThisCountry.PostalCodeDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.StreetDisplayName neq ThisCountry.StreetDisplayNameTranslated>
				<cfset BillingStreetAddressLabel = "#ThisCountry.StreetDisplayName# <span class='translation'>(#ThisCountry.StreetDisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset BillingStreetAddressLabel = ThisCountry.StreetDisplayNameTranslated />
			</cfif>
			<cfif ThisCountry.Street2DisplayName neq ThisCountry.Street2DisplayNameTranslated>
				<cfset BillingStreet2AddressLabel = "#ThisCountry.Street2DisplayName# <span class='translation'>(#ThisCountry.Street2DisplayNameTranslated#)</span>" />
			<cfelse>
				<cfset BillingStreet2AddressLabel = ThisCountry.Street2DisplayNameTranslated />
			</cfif>
		</cfif>

		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoBillingAddress #AjaxHook#">
					<input type="hidden" name="slatProcess" value="UpdateCartBilling">
					<h3 class="title">Billing Address</h3>
					<dl class="BillingFirstName">
						<dt>First Name</dt>
						<dd><input type="text" name="BillingFirstName" value="#arguments.FirstName#" required="true" message="Please Enter a Billing Contact First Name" maxlength="20" /></dd>
					</dl>
					<dl class="BillingLastName">
						<dt>Last Name</dt>
						<dd><input type="text" name="BillingLastName" value="#arguments.LastName#" required="true" message="Please Enter a Billing Contact Last Name" maxlength="20" /></dd>
					</dl>
					<dl class="BillingEmail">
						<dt>Email Address <span class="example">(john@hotmail.com)</span></dt>
						<dd><input type="text" name="BillingEmail" value="#arguments.Email#" required="email" message="Please Enter a Valid Billing Contact Email Address" maxlength="60" /></dd>
					</dl>
					<dl class="BillingPhoneNumber">
						<dt>Phone Number <span class="example">(555-555-1234)</span></dt>
						<dd><input type="text" name="BillingPhoneNumber" value="#arguments.PhoneNumber#" required="phone" message="Please Enter a Valid Billing Contact Phone Number" maxlength="20" /></dd>
					</dl>
					<dl class="BillingCountry" onChange="BillingCountryChange();">
						<dt><label for="Billing Country">Country</label></dt>
						<dd>
							<select name="BillingCountry">
								<cfloop query="BillingCountriesQuery">
									<option value="#BillingCountriesQuery.CountryCode#"<cfif arguments.Country eq BillingCountriesQuery.CountryCode> selected="selected"</cfif>>#BillingCountriesQuery.CountryDisplayName#</option> 
								</cfloop>
							</select>
						</dd>
					</dl>
					<dl class="BillingStreetAddress">
						<dt><label for="BillingStreetAddress">#BillingStreetAddressLabel#</label></dt>
						<dd><input type="text" name="BillingStreetAddress" value="#arguments.StreetAddress#" maxlength="50" required="true" message="Please Enter A Valid Billing #BillingStreetAddressLabel#" /></dd>
					</dl>
					<cfif ThisCountry.Street2DisplayType gt 0>
						<dl class="BillingStreetTwoAddress">
							<dt><label for="BillingStreet2Address">#BillingStreet2AddressLabel#</label></dt>
							<dd><input type="text" name="BillingStreet2Address" value="#arguments.Street2Address#" maxlength="50" /></dd>
						</dl>
					</cfif>
					<cfif ThisCountry.LocalityDisplayType gt 0>
						<dl class="BillingLocality">
							<dt><label for="BillingLocality">#BillingLocalityLabel#</label></dt>
							<dd><input type="text" name="BillingLocality" value="#arguments.Locality#" maxlength="20" /></dd>
						</dl>
					</cfif>
					
					<cfif ThisCountry.CityDisplayType gt 0>
						<dl class="BillingCity">
							<dt><label for="BillingCity">#BillingCityLabel#</label></dt>
							<dd>
								<cfif ThisCountry.CityDisplayType eq 2>
									<cfset CitiesQuery = application.slatsettings.getCitiesByCountryCodeQuery(ThisCountry.CountryCode) />
									<select name="BillingCity">
										<option value=""<cfif arguments.City eq ""> selected="selected"</cfif>>Select #BillingCityLabel#</option>
										<cfloop query="CitiesQuery">
											<option value="#CitiesQuery.CityCode#"<cfif arguments.City eq CitiesQuery.CityCode> selected="selected"</cfif>>#CitiesQuery.CityDisplayName#</option> 
										</cfloop>
									</select>
								<cfelse>
									<input type="text" name="BillingCity" value="#arguments.City#" maxlength="20" <cfif ThisCountry.CityDisplayType eq 1>required="true" message="Please Enter A Valid Billing #BillingCityLabel#"</cfif> />
								</cfif>
							</dd>
						</dl>
					</cfif>
					<cfif ThisCountry.StateDisplayType gt 0>
						<dl class="BillingState">
							<dt><label for="BillingState">#BillingStateLabel#</label></dt>
							<dd>
								<cfif ThisCountry.StateDisplayType eq 2>
									<cfset StatesQuery = application.slatsettings.getStatesByCountryCodeQuery(ThisCountry.CountryCode) />
									<select name="BillingState">
										<option value=""<cfif arguments.State eq ""> selected="selected"</cfif>>Select #BillingStateLabel#</option>
										<cfloop query="StatesQuery">
											<option value="#StatesQuery.StateCode#"<cfif arguments.State eq StatesQuery.StateCode> selected="selected"</cfif>>#StatesQuery.StateDisplayName#</option> 
										</cfloop>
									</select>
								<cfelseif ThisCountry.StateDisplayType eq 1>
									<input type="text" name="BillingState" value="#arguments.State#" maxlength="5">
								</cfif>
							</dd>
						</dl>
					</cfif>
					<cfif ThisCountry.PostalCodeDisplayType gt 0>
						<dl class="BillingPostalCode">
							<dt><label for="BillingPostalCode">#BillingPostalCodeLabel#</label></dt>
							<dd><input type="text" name="BillingPostalCode" value="#arguments.PostalCode#" required="true" message="Please Enter A Valid #BillingPostalCodeLabel#" maxlength="10" /></dd>
						</dl>
					</cfif>
					<script type="text/javascript">
						function BillingCountryChange(){
							var Display = "BillingAddressForm";
							var DisplaySettingsJSON = {
								"CartBillingAddressID": "#arguments.CartBillingAddressID#",
								"FirstName": $('input[name=BillingFirstName]').val(),
								"LastName": $('input[name=BillingLastName]').val(),
								"Email": $('input[name=BillingEmail]').val(),
								"PhoneNumber": $('input[name=BillingPhoneNumber]').val(),
								"Country": $('select[name=BillingCountry] :selected').val(),
								"Locality": $('input[name=BillingLocality]').val(),
								"State": <cfif ThisCountry.StateDisplayType eq 1>$('input[name=BillingState]').val()<cfelse>$('select[name=BillingState] :selected').val()</cfif>,
								"City": $('input[name=BillingCity]').val(),
								"State": $('input[name=BillingState]').val(),
								"PostalCode": $('input[name=BillingPostalCode]').val(),
								"StreetAddress": $('input[name=BillingStreetAddress]').val(),
								"Street2Address": $('input[name=BillingStreet2Address]').val()
							};
							var sah = "#AjaxHook#";
							getSlatDisplay(sah, Display, DisplaySettingsJSON);
						}
					</script>
				</div>
				
			</cfoutput>
		</cfsavecontent>
			
		<cfreturn ReturnHTML>
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>
