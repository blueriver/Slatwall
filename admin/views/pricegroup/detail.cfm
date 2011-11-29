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
<cfparam name="rc.priceGroup" type="any">
<cfparam name="rc.priceGroupRate" type="any">	<!--- This will be empty, and will be used by the "template" --->
<cfparam name="rc.edit" type="boolean">

<cfif rc.edit>
	<!---<cfset getAssetWire().addJSVariable("getProductTypeTreeAPIKey", $.slatwall.getAPIKey('productservice/getproductyypetree','post')) />--->
</cfif>

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:priceGroup.list" type="list">
	<cfif !rc.edit>
	<cf_SlatwallActionCaller action="admin:priceGroup.edit" queryString="priceGroupID=#rc.priceGroup.getPriceGroupID()#" type="list">
	</cfif>
</ul>

<cfoutput>
	<div class="svoadminpriceGroupdetail">
		<cfif rc.edit>
		<form name="PriceGroupEdit" action="#buildURL('admin:priceGroup.save')#" method="post">
			<input type="hidden" name="PriceGroupID" value="#rc.PriceGroup.getPriceGroupID()#" />
		</cfif>
			<dl class="oneColumn">
				<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="activeFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="priceGroupName" edit="#rc.edit#" first="true">
				<cf_SlatwallPropertyDisplay object="#rc.PriceGroup#" property="priceGroupCode" edit="#rc.edit#" >
			</dl>
			<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:priceGroup.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cfif !rc.priceGroup.isNew()>
					<cf_SlatwallActionCaller action="admin:priceGroup.delete" querystring="priceGroupid=#rc.priceGroup.getPriceGroupID()#" class="button" type="link" confirmrequired="true">
				</cfif>
				<cf_SlatwallActionCaller action="admin:priceGroup.save" type="submit" class="button">
			</div>
			</cfif>
		</form>
	</div>
	
	
	
	
	
	
	
	
	
	<cfif arrayLen(rc.priceGroup.getPriceGroupRates()) gt 0>
		
		<!--- Display the table showing any existing PriceGroupRates --->
		<table id="priceGroupRateTable" class="mura-table-grid">
			<thead>
				<tr>
					<th>#rc.$.Slatwall.rbKey("entity.priceGroupRate.priceGroupRateType")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.priceGroupRate.priceGroupRateAmount")#</th>
					<th>#rc.$.Slatwall.rbKey("entity.priceGroupRate.priceGroupRateAppliesTo")#</th>
					<cfif rc.edit>
					  <th class="administration">&nbsp;</th>
					</cfif>
				</tr>
			</thead>
			
			<tbody>
				<!--- Loop over each PriceGroupRate in the PriceGroup --->
				<cfloop from="1" to="#arrayLen(rc.priceGroup.getPriceGroupRates())#" index="local.priceGroupRateCount">
					<cfset local.thisPriceGroupRate = rc.priceGroup.getPriceGroupRates()[local.priceGroupRateCount] />
					<tr id="PriceGroupRate#local.priceGroupRateCount#" class="priceGroupRateRow<cfif local.priceGroupRateCount mod 2 eq 1> alt</cfif>">
						<input type="hidden" name="priceGroupRates[#local.priceGroupRateCount#].priceGroupRateID" value="#local.thisPriceGroupRate.getPriceGroupRateID()#" />
						<td class="alignLeft">
							#$.Slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.' & local.thisPriceGroupRate.getType())#
						</td>
						<td>
							#local.thisPriceGrouRate.getAmountRepresentation()#
						</td>
						<td>
							#local.thisPriceGrouRate.getAppliesToRepresentation()#
						</td>
						<cfif rc.edit>
							<td class="administration">
								<cfif !rc.priceGroup.isNew() && !local.thisPriceGroupRate.isNew()>
									<cfset local.disabledText = "" />
									<ul class="two">
										<li class="adminpricegroupeditPriceGroupRate edit">
											<a href="##" class="editPriceGroupRate" id="edit#local.thisPriceGroupRate.getPriceGroupRateID()#">#$.Slatwall.rbKey('admin.priceGroup.editPriceGroupRate')#</a>
										</li>
										<cf_SlatwallActionCaller action="admin:promotion.deletePriceGroupRate" querystring="priceGroupRateID=#local.thisPriceGroupRate.getPriceGroupRateID()#" class="delete" type="list" confirmrequired="true">
									</ul>
								</cfif>
							</td>
						</cfif>
					</tr>
					<cfif local.thisPriceGroupRate.hasErrors() && local.thisPriceGroupRate.getErrorBean().getError("reward") NEQ "">
						<tr>
							<td colspan="5"><span class="formError">#rc.$.Slatwall.rbKey("admin.priceGroup.edit.validatePriceGroupRate")#</span></td>
						</tr>
					</cfif>
					<cfif rc.edit>
					<!--- Row to edit the current reward --->
						<tr id="priceGroupRateEdit#local.thisPriceGroupRate.getPriceGroupRateID()#" class="alt<cfif !local.thisPriceGroupRate.hasErrors()> hideElement</cfif>">
							<td class="alignLeft" colspan="5">
							<input type="hidden" name="priceGroupRates[#local.priceGroupRateCount#].rewardType" value="#local.thisPriceGroupRate.getType()#" />
							<div class = "priceGroupRateForm">
								<cfif local.thisPriceGroupRate.getType() eq "product">
									<dl class="oneColumn">
										<dt>
											<label for="productTypeID#local.priceGroupRateCount#">#rc.$.Slatwall.rbKey("entity.priceGroupRate.productType")#</label>
										</dt>
										<select name="priceGroupRates[#local.priceGroupRateCount#].productType" id="productTypeID#local.priceGroupRateCount#">
								            <option value="0">#$.Slatwall.rbKey("define.all")#</option>
									        <cfloop query="rc.productTypeTree">
												<cfset local.productTypeIDs = local.thisPriceGroupRate.getProductTypeIDs() />
									            <cfset local.thisDepth = rc.productTypeTree.TreeDepth />
									            <cfif local.thisDepth><cfset local.bullet="-"><cfelse><cfset local.bullet=""></cfif>
									            <option value="#rc.productTypeTree.productTypeID#"<cfif listFindNoCase(local.thisPriceGroupRate.getProductTypeIDs(), rc.productTypeTree.productTypeID)> selected="selected"</cfif>>
									                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##local.bullet##rc.productTypeTree.productTypeName#
									            </option>
									        </cfloop>
								        </select>	
										</dd>
										<dt>
											<label for="productName#local.priceGroupRateCount#">#rc.$.Slatwall.rbKey("entity.priceGroupRate.product")#</label>
										</dt>
										<dd>
											<cfset local.productName = local.thisPriceGroupRate.displayProductNames() />
											<cfset local.productID = local.thisPriceGroupRate.getProductIDs() />
											<input type="text" id="productName#local.priceGroupRateCount#" class="rewardProduct" name="priceGroupRates[#local.priceGroupRateCount#].productName" value="#local.productName#" />
											<input type="hidden" id=product#local.priceGroupRateCount# name="priceGroupRates[#local.priceGroupRateCount#].product" value="#local.productID#" />
										</dd>
										<dt>
											<label for="skuCode#local.priceGroupRateCount#">#rc.$.Slatwall.rbKey("entity.priceGroupRate.sku")#</label>
										</dt>
										<dd>
											<cfset local.skuCode = local.thisPriceGroupRate.displaySkuCodes() />
											<cfset local.skuID = local.thisPriceGroupRate.getSkuIDs() />
											<input type="text" id="skuCode#local.priceGroupRateCount#" class="rewardSku" name="priceGroupRates[#local.priceGroupRateCount#].skuCode" value="#local.skuCode#" />
											<input type="hidden" id=sku#local.priceGroupRateCount# name="priceGroupRates[#local.priceGroupRateCount#].sku" value="#local.skuID#" />
										</dd>
										<dt>
											<label for="itemRewardQuantity#local.priceGroupRateCount#">#rc.$.Slatwall.rbKey("entity.priceGroupRate.itemRewardQuantity")#</label>
										</dt>
										<dd>
											<input type="text" id="itemRewardQuantity#local.priceGroupRateCount#" name="priceGroupRates[#local.priceGroupRateCount#].itemRewardQuantity" value="#local.thisPriceGroupRate.getItemRewardQuantity()#" />
										</dd>
										<dt>
											<label for="discountType#local.priceGroupRateCount#">#rc.$.Slatwall.rbKey("admin.priceGroup.edit.discount")#</label>
										</dt>
										<dd>
											<select name="priceGroupRates[#local.priceGroupRateCount#].productDiscountType" id="discountType#local.priceGroupRateCount#">
												<option value="itemAmountOff"<cfif !isNull(local.thisPriceGroupRate.getitemAmountOff()) and isNumeric(local.thisPriceGroupRate.getItemAmountOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.priceGroup.priceGroupRateType.amountOff")#</option>
												<option value="itemPercentageOff"<cfif !isNull(local.thisPriceGroupRate.getitemPercentageOff()) and isNumeric(local.thisPriceGroupRate.getItemPercentageOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.priceGroup.priceGroupRateType.percentageOff")#</option>
												<option value="itemAmount"<cfif !isNull(local.thisPriceGroupRate.getitemAmount()) and isNumeric(local.thisPriceGroupRate.getItemAmount())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.priceGroup.priceGroupRateType.fixedAmount")#</option>
											</select>
											<cfset local.discountValue = !isNull(local.thisPriceGroupRate.getitemAmountOff()) and isNumeric(local.thisPriceGroupRate.getItemAmountOff()) ? local.thisPriceGroupRate.getItemAmountOff() :
																		 !isNull(local.thisPriceGroupRate.getitemPercentageOff()) and isNumeric(local.thisPriceGroupRate.getItemPercentageOff()) ? local.thisPriceGroupRate.getItemPercentageOff() :
																		 local.thisPriceGroupRate.getItemAmount() />
											<input type="text" id="discountValue#local.priceGroupRateCount#" name="priceGroupRates[#local.priceGroupRateCount#].discountValue" value="#local.discountValue#" />
										</dd>
								    </dl>
								<cfelseif local.thisPriceGroupRate.getType() eq "shipping">
									<dl class="oneColumn">
										<dt>
											<label for="shippingMethod#local.priceGroupRateCount#">#rc.$.Slatwall.rbKey("admin.priceGroup.edit.shippingMethod")#</label>
										</dt>
										<dd>
											<cfset local.shippingMethodIDs = local.thisPriceGroupRate.getShippingMethodIDs() />
											<cfif arrayLen(rc.shippingMethods) gt 0>
											<select name="priceGroupRates[#local.priceGroupRateCount#].shippingMethod" id="shippingMethod#local.priceGroupRateCount#">
												<option value="">#$.Slatwall.rbKey("define.select")#</option>
												<cfloop array="#rc.shippingMethods#" index="local.shippingMethod">
													<option value="#local.shippingMethod.getShippingMethodID()#"<cfif listFindNoCase(local.shippingMethodIDs,local.shippingMethod.getShippingMethodID())> selected="selected"</cfif>>#local.shippingMethod.getShippingMethodName()#</option>
												</cfloop>
											</select>
											<cfelse>
												<strong>#$.Slatwall.rbKey("admin.priceGroup.noShippingMethodsConfigured")#</strong>  <cf_SlatwallActionCaller action="admin:setting.editFulfillmentMethod" querystring="fulfillmentmethodID=shipping" type="link" text="#$.slatwall.rbKey('admin.priceGroup.addShippingMethod')#">
											</cfif>
										</dd>
										<dt>
											<label for="discountType#local.priceGroupRateCount#">#rc.$.Slatwall.rbKey("admin.priceGroup.edit.discount")#</label>
										</dt>
										<dd>
											<select name="priceGroupRates[#local.priceGroupRateCount#].shippingDiscountType" id="discountType#local.priceGroupRateCount#">
												<option value="shippingAmountOff"<cfif !isNull(local.thisPriceGroupRate.getShippingAmountOff()) and isNumeric(local.thisPriceGroupRate.getShippingAmountOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.priceGroup.priceGroupRateType.amountOff")#</option>
												<option value="shippingPercentageOff"<cfif !isNull(local.thisPriceGroupRate.getShippingPercentageOff()) and isNumeric(local.thisPriceGroupRate.getShippingPercentageOff())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.priceGroup.priceGroupRateType.percentageOff")#</option>
												<option value="shippingAmount"<cfif !isNull(local.thisPriceGroupRate.getShippingAmount()) and isNumeric(local.thisPriceGroupRate.getShippingAmount())> selected="selected"</cfif>>#$.Slatwall.rbKey("admin.priceGroup.priceGroupRateType.fixedAmount")#</option>
											</select>
											<cfset local.discountValue = !isNull(local.thisPriceGroupRate.getShippingAmountOff()) and isNumeric(local.thisPriceGroupRate.getShippingAmountOff()) ? local.thisPriceGroupRate.getShippingAmountOff() :
																		 !isNull(local.thisPriceGroupRate.getShippingPercentageOff()) and isNumeric(local.thisPriceGroupRate.getShippingPercentageOff()) ? local.thisPriceGroupRate.getShippingPercentageOff() :
																		 local.thisPriceGroupRate.getShippingAmount() />
											<input type="text" id="discountValue#local.priceGroupRateCount#" name="priceGroupRates[#local.priceGroupRateCount#].discountValue" value="#local.discountValue#" />
										</dd>
								    </dl>
								</cfif>	
							</div>
							</td>				
						</tr>
					<!--- // Row to edit the current reward --->
					</cfif>			
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p><em>#$.Slatwall.rbKey('admin.priceGroup.detail.noPriceGroupRatesDefined')#</em></p>
	</cfif>
	
	
	
	
	
	<!--- If in edit mode display the dynamic PriceGroupRate inputs. --->
	<cfif rc.edit>
		<div class="buttons" id="priceGroupRateButtons">
			<a class="button" id="addPriceGroupRate">#rc.$.Slatwall.rbKey("admin.pricegroup.edit.addPriceGroupRate")#</a>
			<a class="button" id="remPriceGroupRate" style="display:none;">#rc.$.Slatwall.rbKey("admin.pricegroup.edit.removePriceGroupRate")#</a>
		</div>
		
		<!--- Form for new price group rate --->
		<div id="priceGroupRateFormTemplate" class="hideElement">
			
			<cf_SlatwallPropertyDisplay object="#rc.PriceGroupRate#" property="globalFlag" edit="#rc.edit#" fieldType="yesno">
			
			
			
			<!---<dl class="oneColumn" id="productReward">
				<dt>
					<label for="productTypeID">#rc.$.Slatwall.rbKey("entity.priceGroupRate.productType")#</label>
				</dt>
				<dd>
					<select name="productType" id="productTypeID">
			            <option value="0">#$.Slatwall.rbKey("define.all")#</option>
				        <cfloop query="rc.productTypeTree">
				            <cfset local.thisDepth = rc.productTypeTree.TreeDepth />
				            <cfif local.thisDepth><cfset local.bullet="-"><cfelse><cfset local.bullet=""></cfif>
				            <option value="#rc.productTypeTree.productTypeID#">
				                #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##local.bullet##rc.productTypeTree.productTypeName#
				            </option>
				        </cfloop>
			        </select>	
				</dd>
				<dt>
					<label for="productName">#rc.$.Slatwall.rbKey("entity.priceGroupRate.product")#</label>
				</dt>
				<dd>
					<input id="productName" name="productName" class="rewardProduct" />
					<input type="hidden" name="product" value="" id="product" />
				</dd>
				<dt>
					<label for="skuCode">#rc.$.Slatwall.rbKey("entity.priceGroupRate.sku")#</label>
				</dt>
				<dd>
					<input type="text" id="skuCode" class="rewardSku" name="skuCode" value="" />
					<input type="hidden" name="sku" value="" id="sku" />
				</dd>
				<dt>
					<label for="itemRewardQuantity">#rc.$.Slatwall.rbKey("entity.priceGroupRate.itemRewardQuantity")#</label>
				</dt>
				<dd>
					<input type="text" id="itemRewardQuantity" name="itemRewardQuantity" value="" />
				</dd>
				<dt>
					<label for="discountType">#rc.$.Slatwall.rbKey("admin.pricegroup.edit.discount")#</label>
				</dt>
				<dd>
					<select name="productDiscountType" id="discountType">
						<option value="itemAmountOff">#$.Slatwall.rbKey("admin.pricegroup.priceGroupRateType.amountOff")#</option>
						<option value="itemPercentageOff">#$.Slatwall.rbKey("admin.pricegroup.priceGroupRateType.percentageOff")#</option>
						<option value="itemAmount">#$.Slatwall.rbKey("admin.pricegroup.priceGroupRateType.fixedAmount")#</option>
					</select>
					<input type="text" id="discountValue" name="discountValue" value="" />
				</dd>
		    </dl>
			<dl class="oneColumn hideElement" id="shippingReward">
				<dt>
					<label for="shippingMethod">#rc.$.Slatwall.rbKey("admin.pricegroup.edit.shippingMethod")#</label>
				</dt>
				<dd>
					<cfif arrayLen(rc.shippingMethods) gt 0>
					<select name="shippingMethod" id="shippingMethod">
						<option value="">#$.Slatwall.rbKey("define.select")#</option>
						<cfloop array="#rc.shippingMethods#" index="local.shippingMethod">
							<option value="#local.shippingMethod.getShippingMethodID()#">#local.shippingMethod.getShippingMethodName()#</option>
						</cfloop>
					</select>
					<cfelse>
						<strong>#$.Slatwall.rbKey("admin.pricegroup.noShippingMethodsConfigured")#</strong>  <cf_SlatwallActionCaller action="admin:setting.editFulfillmentMethod" querystring="fulfillmentmethodID=shipping" type="link" text="#$.slatwall.rbKey('admin.pricegroup.addShippingMethod')#">
					</cfif>
				</dd>
				<dt>
					<label for="discountType">#rc.$.Slatwall.rbKey("admin.pricegroup.edit.discount")#</label>
				</dt>
				<dd>
					<select name="shippingDiscountType" id="discountType">
						<option value="shippingAmountOff">#$.Slatwall.rbKey("admin.pricegroup.priceGroupRateType.amountOff")#</option>
						<option value="shippingPercentageOff">#$.Slatwall.rbKey("admin.pricegroup.priceGroupRateType.percentageOff")#</option>
						<option value="shippingAmount">#$.Slatwall.rbKey("admin.pricegroup.priceGroupRateType.fixedAmount")#</option>
					</select>
					<input type="text" id="discountValue" name="discountValue" value="" />
				</dd>
		    </dl>
			--->	
		</div>
		<!--- // Form for new reward --->
		
	</cfif>
	
	
	
	
</cfoutput>
