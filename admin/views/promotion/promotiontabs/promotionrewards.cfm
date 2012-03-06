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
	<cfif arrayLen(rc.promotion.getPromotionRewards()) GT 0>
		<table class="listing-grid stripe">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.promotionReward.rewardType")#</th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.promotion.promotionReward.item")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.promotionRewardProduct.itemRewardQuantity")#</th>
					<th>#rc.$.Slatwall.rbKey("admin.promotion.edit.discount")#</th>
					<th class="administration">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.promotion.getPromotionRewards()#" index="local.thisPromotionReward">
					<cfif not local.thisPromotionReward.hasErrors()>
						<tr>
							<td>#$.Slatwall.rbKey('entity.promotionReward.promotionRewardType.' & local.thisPromotionReward.getRewardType())#</td>
							<td class="varWidth">
								<cfset local.itemName = "" />
								<cfif local.thisPromotionReward.getRewardType() eq "product">
									<cfif arrayLen(local.thisPromotionReward.getSkus())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionRewardProduct.skus') & ": " />
										<cfset local.itemName &= local.thisPromotionReward.displaySkuCodes() />
										<cfset local.itemName &= "</p>" />
									</cfif>	
									<cfif arrayLen(local.thisPromotionReward.getProducts())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionRewardProduct.products') & ": " />
										<cfset local.itemName &= local.thisPromotionReward.displayProductNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionReward.getProductTypes())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionRewardProduct.productTypes') & ": " />
										<cfset local.itemName &= local.thisPromotionReward.displayProductTypeNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionReward.getBrands())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionRewardProduct.brands') & ": " />
										<cfset local.itemName &= local.thisPromotionReward.displayBrandNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionReward.getOptions())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionRewardProduct.options') & ": " />
										<cfset local.itemName &= local.thisPromotionReward.displayOptionNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif not len(local.itemName)>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName = $.Slatwall.rbKey("define.all") />
										<cfset local.itemName &= "</p>" />
									</cfif>
								<cfelseif local.thisPromotionReward.getRewardType() eq "shipping">
									<cfif arrayLen(thisPromotionReward.getShippingMethods())>
										<cfset local.itemName = thisPromotionReward.displayShippingMethodNames() />
									<cfelse>
										<cfset local.itemName = $.Slatwall.rbKey("define.all") />
									</cfif>
								</cfif>
								#local.itemName#
							</td>
							<td>
								<cfif local.thisPromotionReward.getRewardType() eq "product">
									#local.thisPromotionReward.getItemRewardQuantity()#
								</cfif>
							</td>
							<td>
								<cfif local.thisPromotionReward.getRewardType() eq "product">
									<cfif !isNull(local.thisPromotionReward.getPercentageOff()) && isNumeric(local.thisPromotionReward.getPercentageOff())>
										#local.thisPromotionReward.getPercentageOff()#&##37; #$.Slatwall.rbKey("admin.promotion.discount.off")#
									<cfelseif !isNull(local.thisPromotionReward.getAmountOff()) && isNumeric(local.thisPromotionReward.getAmountOff())>
										#local.thisPromotionReward.getFormattedValue('amountOff', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.off")#
									<cfelseif !isNull(local.thisPromotionReward.getAmount()) && isNumeric(local.thisPromotionReward.getAmount())>
										#local.thisPromotionReward.getFormattedValue('amount', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.price")#
									</cfif>
								<cfelseif local.thisPromotionReward.getRewardType() eq "shipping">
									<cfif !isNull(local.thisPromotionReward.getPercentageOff()) && isNumeric(local.thisPromotionReward.getPercentageOff())>
										#local.thisPromotionReward.getPercentageOff()#&##37; #$.Slatwall.rbKey("admin.promotion.discount.off")#
									<cfelseif !isNull(local.thisPromotionReward.getAmountOff()) && isNumeric(local.thisPromotionReward.getAmountOff())>
										#local.thisPromotionReward.getFormattedValue('amountOff', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.off")#
									<cfelseif !isNull(local.thisPromotionReward.getAmount()) && isNumeric(local.thisPromotionReward.getAmount())>
										#local.thisPromotionReward.getFormattedValue('amount', 'currency')# #$.Slatwall.rbKey("admin.promotion.discount.price")#
									</cfif>
								</cfif>	
							</td>
							<td class="administration">
								<ul class="two">
									<cf_SlatwallActionCaller action="admin:promotion.edit" querystring="promotionRewardID=#local.thisPromotionReward.getPromotionRewardID()#&promotionID=#rc.promotion.getPromotionID()###tabPromotionRewards" class="edit" type="list">
									<cf_SlatwallActionCaller action="admin:promotion.deletePromotionReward" querystring="promotionRewardID=#local.thisPromotionReward.getPromotionRewardID()#&promotionID=#rc.promotion.getPromotionID()#" class="delete" type="list" disabled="#local.thisPromotionReward.isNotDeletable()#" confirmrequired="true">
								</ul>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p><em>#rc.$.Slatwall.rbKey("admin.promotion.nopromotionrewardsdefined")#</em></p>
		<br /><br />
	</cfif>
	<cfif rc.edit>
		<!--- If the Option is new, then that means that we are just editing the Option --->
		<cfif rc.promotionRewardProduct.isNew() && not rc.promotionRewardProduct.hasErrors() && rc.promotionRewardShipping.isNew() && not rc.promotionRewardShipping.hasErrors()>
			<button type="button" id="addPromotionRewardButton" value="true">#rc.$.Slatwall.rbKey("admin.promotion.detail.addPromotionReward")#</button>
			<!---<button type="button" id="addPromotionRewardShippingButton" value="true">#rc.$.Slatwall.rbKey("admin.promotion.detail.addPromotionRewardShipping")#</button>--->
			<input type="hidden" name="savePromotionRewardProduct" id="savePromotionRewardProductHidden" value="false"/>
			<input type="hidden" name="savePromotionRewardShipping" id="savePromotionRewardShippingHidden" value="false"/>
			<input type="hidden" name="savePromotionRewardOrder" id="savePromotionRewardOrderHidden" value="false"/>
		<cfelse>
			<cfif !rc.promotionRewardProduct.isNew() || rc.promotionRewardProduct.hasErrors()>
				<input type="hidden" name="savePromotionRewardProduct" id="savePromotionRewardProductHidden" value="true"/>
				<input type="hidden" name="savePromotionRewardShipping" id="savePromotionRewardShippingHidden" value="false"/>
				<input type="hidden" name="savePromotionRewardOrder" id="savePromotionRewardOrderHidden" value="false"/>
			</cfif>
			<cfif !rc.promotionRewardShipping.isNew() || rc.promotionRewardShipping.hasErrors()>
				<input type="hidden" name="savePromotionRewardProduct" id="savePromotionRewardProductHidden" value="false"/>
				<input type="hidden" name="savePromotionRewardShipping" id="savePromotionRewardShippingHidden" value="true"/>
				<input type="hidden" name="savePromotionRewardOrder" id="savePromotionRewardOrderHidden" value="false"/>
			</cfif>
			<cfif !rc.promotionRewardOrder.isNew() || rc.promotionRewardOrder.hasErrors()>
				<input type="hidden" name="savePromotionRewardProduct" id="savePromotionRewardProductHidden" value="false"/>
				<input type="hidden" name="savePromotionRewardShipping" id="savePromotionRewardShippingHidden" value="false"/>
				<input type="hidden" name="savePromotionRewardOrder" id="savePromotionRewardOrderHidden" value="true"/>
			</cfif>
		</cfif>
		
		<input type="hidden" name="populateSubProperties" value="false"/>
		<dl id="rewardTypeSelector" class="twoColumn hideElement">				
			<dt><label for="rewardType">#rc.$.Slatwall.rbKey("entity.promotionReward.rewardType")#</label></dt>
			<dd>
				<select name="rewardType" id="promotionRewardType">
					<option value="">#rc.$.Slatwall.rbKey("define.select")#</option>
					<option value="product">#rc.$.Slatwall.rbKey("entity.promotionReward.rewardType.Product")#</option>
					<option value="shipping">#rc.$.Slatwall.rbKey("entity.promotionReward.rewardType.Shipping")#</option>
					<option value="order">#rc.$.Slatwall.rbKey("entity.promotionReward.rewardType.Order")#</option>
				</select>
			</dd>
		</dl>		
		<div id="promotionRewardProductInputs" <cfif rc.promotionRewardProduct.isNew() and not rc.promotionRewardProduct.hasErrors()>class="ui-helper-hidden"</cfif> >
			<dl class="twoColumn">
				<!---
				<dt><label for="discountType">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardProduct.discountType")#</label></dt>
				<dd>
					<select name="discountType" id="productDiscountType">
						<option value="percentageOff">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardProduct.discountType.percentageOff")#</option>
						<option value="amountOff">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardProduct.discountType.amountOff")#</option>
						<option value="amount">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardProduct.discountType.amount")#</option>
					</select>
				</dd>
				--->
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="discountType" fieldName="promotionRewards[1].discountType" edit="true" fieldType="select" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="percentageOff" fieldName="promotionRewards[1].percentageOff" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="amountOff" fieldName="promotionRewards[1].amountOff" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="amount" fieldName="promotionRewards[1].amount" edit="true" />
				<cfset roundingRuleOptions = rc.promotionRewardProduct.getRoundingRuleOptions() />
				<cfset roundingRuleOptions[1].name = $.slatwall.rbKey('define.none') /> 
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="roundingRule" fieldName="promotionRewards[1].roundingRule.roundingRuleID" valueOptions="#roundingRuleOptions#" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="brands" fieldName="promotionRewards[1].brands" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="productTypes" fieldName="promotionRewards[1].productTypes" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="products" fieldName="promotionRewards[1].products" edit="true" />
				<!--- <cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="skus" fieldName="promotionRewards[1].skus" edit="true" /> --->
				<!--- <cf_SlatwallPropertyDisplay object="#rc.promotionRewardProduct#" property="options" fieldName="promotionRewards[1].options" edit="true" /> --->
			</dl>
			<input type="hidden" name="promotionRewards[1].promotionRewardID" value="#rc.promotionRewardProduct.getPromotionRewardID()#"/>
		</div>
		
		<div id="promotionRewardShippingInputs" <cfif rc.promotionRewardShipping.isNew() and not rc.promotionRewardShipping.hasErrors()>class="ui-helper-hidden"</cfif> >
			<dl class="twoColumn">
				<!---
				<dt><label for="discountType">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardShipping.discountType")#</label></dt>
				<dd>
					<select name="discountType" id="shippingDiscountType">
						<option value="percentageOff">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardShipping.discountType.percentageOff")#</option>
						<option value="amountOff">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardShipping.discountType.amountOff")#</option>
						<option value="amount">#rc.$.Slatwall.rbKey("admin.promotion.promotionRewardShipping.discountType.amount")#</option>
					</select>
				</dd>
				--->
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardShipping#" property="discountType" fieldName="promotionRewards[1].discountType" edit="true" fieldType="select" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardShipping#" property="percentageOff" fieldName="promotionRewards[1].percentageOff" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardShipping#" property="amountOff" fieldName="promotionRewards[1].amountOff" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardShipping#" property="amount" fieldName="promotionRewards[1].amount" edit="true" />
				
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardShipping#" property="shippingMethods" fieldName="promotionRewards[1].shippingMethods" edit="true" />
			</dl>
			<input type="hidden" name="promotionRewards[1].promotionRewardID" value="#rc.promotionRewardShipping.getPromotionRewardID()#"/>
		</div>
		
		<div id="promotionRewardOrderInputs" <cfif rc.promotionRewardOrder.isNew() and not rc.promotionRewardOrder.hasErrors()>class="ui-helper-hidden"</cfif> >
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardOrder#" property="discountType" fieldName="promotionRewards[1].orderDiscountType" edit="true" fieldType="select" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardOrder#" property="percentageOff" fieldName="promotionRewards[1].percentageOff" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionRewardOrder#" property="amountOff" fieldName="promotionRewards[1].amountOff" edit="true" />
			</dl>
			<input type="hidden" name="promotionRewards[1].promotionRewardID" value="#rc.promotionRewardOrder.getPromotionRewardID()#"/>
		</div>
		
		<br /><br />
	</cfif>
</cfoutput>