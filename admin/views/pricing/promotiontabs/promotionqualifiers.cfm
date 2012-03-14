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
	<cfif arrayLen(rc.promotion.getPromotionQualifiers()) GT 0>
		<table class="listing-grid stripe">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.promotionQualifier.qualifierType")#</th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.promotion.promotionQualifier.item")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.promotionQualifier.minimumQuantity")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.promotionQualifier.minimumPrice")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.promotionQualifier.maximumPrice")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.promotionQualifierFulfillment.maximumFulfillmentWeight")#</th>
					<th class="administration">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.promotion.getPromotionQualifiers()#" index="local.thisPromotionQualifier">
					<cfif not local.thisPromotionQualifier.hasErrors()>
						<tr>
							<td>#$.Slatwall.rbKey('entity.promotionQualifier.qualifierType.' & local.thisPromotionQualifier.getQualifierType())#</td>
							<td class="varWidth">
								<cfset local.itemName = "" />
								<cfif local.thisPromotionQualifier.getQualifierType() eq "product">
									<cfif arrayLen(local.thisPromotionQualifier.getSkus())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierProduct.skus') & ": " />
										<cfset local.itemName &= local.thisPromotionQualifier.displaySkuCodes() />
										<cfset local.itemName &= "</p>" />
									</cfif>	
									<cfif arrayLen(local.thisPromotionQualifier.getProducts())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierProduct.products') & ": " />
										<cfset local.itemName &= local.thisPromotionQualifier.displayProductNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionQualifier.getProductTypes())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierProduct.productTypes') & ": " />
										<cfset local.itemName &= local.thisPromotionQualifier.displayProductTypeNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionQualifier.getBrands())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierProduct.brands') & ": " />
										<cfset local.itemName &= local.thisPromotionQualifier.displayBrandNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionQualifier.getOptions())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierProduct.options') & ": " />
										<cfset local.itemName &= local.thisPromotionQualifier.displayOptionNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionQualifier.getProductContent())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierProduct.productContent') & ": " />
										<cfset local.itemName &= local.thisPromotionQualifier.displayProductPageNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(local.thisPromotionQualifier.getProductCategories())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierProduct.productCategories') & ": " />
										<cfset local.itemName &= local.thisPromotionQualifier.displayProductCategoryNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif not len(local.itemName)>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey("define.all") />
										<cfset local.itemName &= "</p>" />
									</cfif>
								<cfelseif local.thisPromotionQualifier.getQualifierType() eq "fulfillment">
									<cfif arrayLen(thisPromotionQualifier.getFulfillmentMethods())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierFulfillment.fulfillmentMethods') & ": " />
										<cfset local.itemName &= thisPromotionQualifier.displayFulfillmentMethodNames() />
										<cfset local.itemName &= "</p>" />
 									</cfif>
									<cfif arrayLen(thisPromotionQualifier.getShippingMethods())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierFulfillment.shippingMethods') & ": " />
										<cfset local.itemName &= thisPromotionQualifier.displayShippingMethodNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif arrayLen(thisPromotionQualifier.getAddressZones())>
										<cfset local.itemName &= "<p>" />
										<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierFulfillment.addressZones') & ": " />
										<cfset local.itemName &= thisPromotionQualifier.displayAddressZoneNames() />
										<cfset local.itemName &= "</p>" />
									</cfif>
									<cfif not len(local.itemName)>
										<cfset local.itemName = $.Slatwall.rbKey("define.all") />
									</cfif>
								<cfelseif local.thisPromotionQualifier.getQualifierType() eq "order">
									<cfset local.itemName = $.Slatwall.rbKey("define.na") />
								</cfif>
								#local.itemName#
							</td>
							<td>
								#local.thisPromotionQualifier.getMinimumQuantity()#
							</td>
							<td>
								#local.thisPromotionQualifier.getMinimumPrice()#
							</td>
							<td>
								#local.thisPromotionQualifier.getMaximumPrice()#
							</td>
							<td>
								#local.thisPromotionQualifier.getQualifierType() eq "fulfillment" ? local.thisPromotionQualifier.getMaximumFulfillmentWeight() : $.Slatwall.rbKey("define.na")#
							</td>
							<td class="administration">
								<ul class="two">
									<cf_SlatwallActionCaller action="admin:promotion.edit" querystring="promotionQualifierID=#local.thisPromotionQualifier.getPromotionQualifierID()#&promotionID=#rc.promotion.getPromotionID()###tabPromotionQualifiers" class="edit" type="list">
									<cf_SlatwallActionCaller action="admin:promotion.deletePromotionQualifier" querystring="promotionQualifierID=#local.thisPromotionQualifier.getPromotionQualifierID()#&promotionID=#rc.promotion.getPromotionID()#" class="delete" type="list" disabled="#local.thisPromotionQualifier.isNotDeletable()#" confirmrequired="true">
								</ul>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p><em>#rc.$.Slatwall.rbKey("admin.promotion.nopromotionqualifiersdefined")#</em></p>
		<br /><br />
	</cfif>
	<cfif rc.edit>
		<!--- If the Option is new, then that means that we are just editing the Option --->
		<cfif rc.promotionQualifierProduct.isNew() && !rc.promotionQualifierProduct.hasErrors() && rc.promotionQualifierFulfillment.isNew() && !rc.promotionQualifierFulfillment.hasErrors() && rc.promotionQualifierOrder.isNew() && !rc.promotionQualifierOrder.hasErrors()>
			<button type="button" id="addPromotionQualifierButton" value="true">#rc.$.Slatwall.rbKey("admin.promotion.detail.addPromotionQualifier")#</button>
			<!---<button type="button" id="addPromotionQualifierFulfillmentButton" value="true">#rc.$.Slatwall.rbKey("admin.promotion.detail.addPromotionQualifierFulfillment")#</button>--->
			<input type="hidden" name="savePromotionQualifierProduct" id="savePromotionQualifierProductHidden" value="false"/>
			<input type="hidden" name="savePromotionQualifierFulfillment" id="savePromotionQualifierFulfillmentHidden" value="false"/>
			<input type="hidden" name="savePromotionQualifierOrder" id="savePromotionQualifierOrderHidden" value="false"/>
		<cfelse>
			<cfif !rc.promotionQualifierProduct.isNew() || rc.promotionQualifierProduct.hasErrors()>
				<input type="hidden" name="savePromotionQualifierProduct" id="savePromotionQualifierProductHidden" value="true"/>
				<input type="hidden" name="savePromotionQualifierFulfillment" id="savePromotionQualifierFulfillmentHidden" value="false"/>
				<input type="hidden" name="savePromotionQualifierOrder" id="savePromotionQualifierOrderHidden" value="false"/>
			</cfif>
			<cfif !rc.promotionQualifierFulfillment.isNew() || rc.promotionQualifierFulfillment.hasErrors()>
				<input type="hidden" name="savePromotionQualifierProduct" id="savePromotionQualifierProductHidden" value="false"/>
				<input type="hidden" name="savePromotionQualifierFulfillment" id="savePromotionQualifierFulfillmentHidden" value="true"/>
				<input type="hidden" name="savePromotionQualifierOrder" id="savePromotionQualifierOrderHidden" value="false"/>
			</cfif>
			<cfif !rc.promotionQualifierOrder.isNew() || rc.promotionQualifierOrder.hasErrors()>
				<input type="hidden" name="savePromotionQualifierProduct" id="savePromotionQualifierProductHidden" value="false"/>
				<input type="hidden" name="savePromotionQualifierFulfillment" id="savePromotionQualifierFulfillmentHidden" value="false"/>
				<input type="hidden" name="savePromotionQualifierOrder" id="savePromotionQualifierOrderHidden" value="true"/>
			</cfif>
		</cfif>
		
		<input type="hidden" name="populateSubProperties" value="false"/>
		<dl id="qualifierTypeSelector" class="twoColumn hideElement">				
			<dt><label for="qualifierType">#rc.$.Slatwall.rbKey("entity.promotionQualifier.qualifierType")#</label></dt>
			<dd>
				<select name="qualifierType" id="promotionQualifierType">
					<option value="">#rc.$.Slatwall.rbKey("define.select")#</option>
					<option value="product">#rc.$.Slatwall.rbKey("entity.promotionQualifier.qualifierType.product")#</option>
					<option value="fulfillment">#rc.$.Slatwall.rbKey("entity.promotionQualifier.qualifierType.fulfillment")#</option>
					<option value="order">#rc.$.Slatwall.rbKey("entity.promotionQualifier.qualifierType.order")#</option>
				</select>
			</dd>
		</dl>		
		<div id="promotionQualifierProductInputs" <cfif rc.promotionQualifierProduct.isNew() and not rc.promotionQualifierProduct.hasErrors()>class="ui-helper-hidden"</cfif> >
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="minimumQuantity" fieldName="promotionQualifiers[1].minimumQuantity" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="minimumPrice" fieldName="promotionQualifiers[1].minimumPrice" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="maximumPrice" fieldName="promotionQualifiers[1].maximumPrice" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="brands" fieldName="promotionQualifiers[1].brands" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="productTypes" fieldName="promotionQualifiers[1].productTypes" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="products" fieldName="promotionQualifiers[1].products" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="productContent" value="#rc.promotionQualifierProduct.getContentPaths()#"  fieldType="multiSelect" fieldName="promotionQualifiers[1].productContent" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierProduct#" property="productCategories" value="#rc.promotionQualifierProduct.getCategoryPaths()#"  fieldType="multiSelect" fieldName="promotionQualifiers[1].productCategories" edit="true" />
			</dl>
			<input type="hidden" name="promotionQualifiers[1].promotionQualifierID" value="#rc.promotionQualifierProduct.getPromotionQualifierID()#"/>
		</div>
		
		<div id="promotionQualifierFulfillmentInputs" <cfif rc.promotionQualifierFulfillment.isNew() and not rc.promotionQualifierFulfillment.hasErrors()>class="ui-helper-hidden"</cfif> >
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierFulfillment#" property="minimumQuantity" fieldName="promotionQualifiers[1].minimumQuantity" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierFulfillment#" property="maximumFulfillmentWeight" fieldName="promotionQualifiers[1].maximumFulfillmentWeight" edit="true" />				
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierFulfillment#" property="fulfillmentMethods" fieldName="promotionQualifiers[1].fulfillmentMethods" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierFulfillment#" property="shippingMethods" fieldName="promotionQualifiers[1].shippingMethods" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierFulfillment#" property="addressZones" fieldName="promotionQualifiers[1].addressZones" edit="true" />
			</dl>
			<input type="hidden" name="promotionQualifiers[1].promotionQualifierID" value="#rc.promotionQualifierFulfillment.getPromotionQualifierID()#"/>
		</div>
		
		<div id="promotionQualifierOrderInputs" <cfif rc.promotionQualifierOrder.isNew() and not rc.promotionQualifierOrder.hasErrors()>class="ui-helper-hidden"</cfif> >
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierOrder#" property="minimumQuantity" fieldName="promotionQualifiers[1].minimumQuantity" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierOrder#" property="minimumPrice" fieldName="promotionQualifiers[1].minimumPrice" edit="true" />
			</dl>
			<input type="hidden" name="promotionQualifiers[1].promotionQualifierID" value="#rc.promotionQualifierOrder.getPromotionQualifierID()#"/>
		</div>
		
		<br /><br />
	</cfif>
</cfoutput>