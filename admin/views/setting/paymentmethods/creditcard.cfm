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
<cfparam name="rc.allSettings" type="struct" />

<cfsilent>
	<cfset local.yesNoValueOptions = [{name=$.slatwall.rbKey('define.yes'), value=1},{name=$.slatwall.rbKey('define.no'), value=0}] />
</cfsilent>
<cfoutput>
<dl>
	<dt class="spdcreditcardactiononcheckout">
		#$.slatwall.rbKey("admin.setting.paymentMethod.creditcardActionOnCheckout")#:
	</dt>
	<dd id="spdcreditcardactiononcheckout">
		<cfif rc.edit>
			<cfloop list="none,authorize,authorizeAndCharge" index="local.thisActionOption" >
				<input type="radio" name="paymentmethod_creditCard_checkoutTransactionType" value="#local.thisActionOption#" id="#local.thisActionOption#"<cfif $.Slatwall.setting("paymentMethod_creditCard_checkoutTransactionType") eq local.thisActionOption> checked="checked"</cfif>> <label for="#local.thisActionOption#">#$.slatwall.rbKey("admin.setting.paymentMethod.creditCard.checkoutTransactionType." & local.thisActionOption)#</label> <br>
			</cfloop>
		<cfelse>
			#$.slatwall.rbKey("admin.setting.paymentMethod.creditCard.checkoutTransactionType." & $.Slatwall.setting("paymentMethod_creditCard_checkoutTransactionType"))#
		</cfif>
	</dd>
	<cf_SlatwallPropertyDisplay object="#rc.allSettings.paymentMethod_creditCard_storeCreditCardWithOrderPayment#" title="#rc.$.Slatwall.rbKey('setting.paymentMethod.creditCard.storeCreditCardWithOrderPayment')#" property="settingValue" fieldName="paymentMethod_creditCard_storeCreditCardWithOrderPayment" edit="#rc.edit#" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
	<cf_SlatwallPropertyDisplay object="#rc.allSettings.paymentMethod_creditCard_storeCreditCardWithAccount#" title="#rc.$.Slatwall.rbKey('setting.paymentMethod.creditCard.storeCreditCardWithAccount')#" property="settingValue" fieldName="paymentMethod_creditCard_storeCreditCardWithAccount" edit="#rc.edit#" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
	<dt class="spdcreditcardtypes">#$.Slatwall.rbKey("admin.setting.paymentMethod.creditCardsAccepted")#</dt>
	<dd id="spdcreditcardsaccepted">
	<cfif rc.edit>
		<cfloop list="Mastercard,Visa,Amex,Discover,Diners Club,JCB,EnRoute,CarteBlanche" index="local.thisTypeOption" >
			<input type="checkbox" name="paymentmethod_creditCard_creditCardTypes" value="#local.thisTypeOption#" id="#local.thisTypeOption#"<cfif listFind($.Slatwall.setting("paymentmethod_creditCard_creditCardTypes"),local.thisTypeOption)> checked="checked"</cfif>> <label for="#local.thisTypeOption#">#local.thisTypeOption#</label> <br>
		</cfloop>
	<cfelse>
		#$.Slatwall.setting("paymentmethod_creditCard_creditCardTypes")#
	</cfif>
	</dd>	
</dl>
</cfoutput>