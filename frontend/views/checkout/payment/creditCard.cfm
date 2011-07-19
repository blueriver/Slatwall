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
<cfparam name="params.edit" type="boolean" default="true" />
<cfparam name="params.orderPayment" type="any" />
<cfparam name="params.orderPaymentIndex" type="string" />

<cfset local.sameAsShipping = false>

<cfif !isNull(params.orderPayment.getBillingAddress())>
	<cfset local.address = params.orderPayment.getBillingAddress() />
<cfelseif arrayLen($.slatwall.cart().getOrderFulfillments()) eq 1 and not isNull($.slatwall.cart().getOrderFulfillments()[1].getShippingAddress())>
	<cfset local.sameAsShipping = true />
	<cfset local.address = $.slatwall.cart().getOrderFulfillments()[1].getShippingAddress() />
<cfelse>
	<cfset local.address = getBeanFactory().getBean("addressService").newAddress() />
</cfif>

<cfoutput>
	<div class="svocheckoutpaymentcreditcard">
		<div class="paymentAddress">
			<h4>Billing Address</h4>
			<cfif local.sameAsShipping>
				<dl>
					<dt>Same As Shipping</dt>
					<dd><input type="hidden" name="orderPayments[#params.orderPaymentIndex#].billingAddress.sameAsShipping" value="" /><input type="checkbox" name="orderPayments[#params.orderPaymentIndex#].billingAddress.sameAsShipping" value="1" checked="checked" /></dd>
				</dl>
				<cf_SlatwallAddressDisplay address="#local.address#" fieldNamePrefix="orderPayments[#params.orderPaymentIndex#].billingAddress." edit="#params.edit#">
			<cfelse>
				<cf_SlatwallAddressDisplay address="#local.address#" fieldNamePrefix="orderPayments[#params.orderPaymentIndex#].billingAddress." edit="#params.edit#">
			</cfif>
		</div>
		<div class="paymentMethod">
			<h4>Credit Card Details</h4>
			<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].paymentMethodID" value="creditCard" />
			<input type="hidden" name="orderPayments[#params.orderPaymentIndex#].orderPaymentID" value="#params.orderPayment.getOrderPaymentID()#" />
			<cfif params.orderPayment.getErrorBean().hasError('processing')>
				<div class="error">#params.orderPayment.getErrorBean().getError('processing')#</div>
			</cfif> 
			<dl>
				<cf_SlatwallPropertyDisplay object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].nameOnCreditCard" property="nameOnCreditCard" edit="#params.edit#" /> 
				<cf_SlatwallPropertyDisplay object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].creditCardNumber" property="creditCardNumber" noValue="true" edit="#params.edit#" />
				<cf_SlatwallPropertyDisplay object="#params.orderPayment#" fieldName="orderPayments[#params.orderPaymentIndex#].securityCode" property="securityCode" noValue="true" edit="#params.edit#" />
				<dt class="spdcreditcardexperationdate">
					<label for="experationMonth">Expires</label>
				</dt>
				<dd id="spdcreditcardexpirationdate">
					<select name="orderPayments[#params.orderPaymentIndex#].expirationMonth">
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
					</select> / 
					<select name="orderPayments[#params.orderPaymentIndex#].expirationYear">
						<option value="11">2011</option>
						<option value="12">2012</option>
						<option value="13">2013</option>
						<option value="14">2014</option>
						<option value="15">2015</option>
						<option value="16">2016</option>
						<option value="17">2017</option>
						<option value="18">2018</option>
						<option value="19">2019</option>
						<option value="20">2020</option>
						<option value="21">2021</option>
						<option value="22">2022</option>
					</select>
				</dd>
			</dl>
		</div>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				
				jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.sameAsShipping"]').click(function(){
					var shippingAddress = {
						name : '#local.address.getName()#',
						company : '#local.address.getCompany()#',
						streetAddress :  '#local.address.getStreetAddress()#',
						street2Address : '#local.address.getStreet2Address()#',
						city : '#local.address.getCity()#',
						stateCode : '#local.address.getStateCode()#',
						postalCode : '#local.address.getPostalCode()#',
						countryCode : '#local.address.getCountryCode()#',
					};
					if(jQuery(this).is(':checked')){
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.name"]').val(shippingAddress['name']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.company"]').val(shippingAddress['company']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.streetAddress"]').val(shippingAddress['streetAddress']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.street2Address"]').val(shippingAddress['street2Address']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.city"]').val(shippingAddress['city']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.postalCode"]').val(shippingAddress['postalCode']);
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val(shippingAddress['stateCode']);
						jQuery('select[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val(shippingAddress['stateCode']);
						jQuery('select[name="orderPayments[#params.orderPaymentIndex#].billingAddress.countryCode"]').val(shippingAddress['countryCode']);
					} else {
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.name"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.company"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.streetAddress"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.street2Address"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.city"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.postalCode"]').val('');
						jQuery('input[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val('');
						jQuery('select[name="orderPayments[#params.orderPaymentIndex#].billingAddress.stateCode"]').val('');
					};
				});
			});
		</script>
	</div>
</cfoutput>