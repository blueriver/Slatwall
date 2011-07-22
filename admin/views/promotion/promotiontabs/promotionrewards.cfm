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
<cfif rc.edit>
<div class="buttons">
	<a class="button" id="addPromotionReward">#rc.$.Slatwall.rbKey("admin.promotion.edit.addPromotionReward")#</a>
	<a class="button" id="remPromotionReward" style="display:none;">#rc.$.Slatwall.rbKey("admin.promotion.edit.removePromotionReward")#</a>
</div>

</cfif>
	<table id="promotionRewardTable" class="stripe">
		<thead>
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.promotionReward.product")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.promotionReward.itemRewardQuantity")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.promotionReward.itemPercentageOff")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.promotionReward.itemAmountOff")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.promotionReward.itemAmount")#</th>
				<cfif rc.edit>
				  <th class="administration">&nbsp;</th>
				</cfif>
			</tr>
		</thead>
		<tbody>
		<cfloop from="1" to="#arrayLen(rc.promotion.getPromotionRewards())#" index="local.promotionRewardCount">
			<cfset local.thisPromotionReward = rc.promotion.getPromotionRewards()[local.promotionRewardCount] />
			<cfif local.thisPromotionReward.hasErrors() && local.thisPromotionReward.getErrorBean().getError("reward") NEQ "">
				<tr>
					<td colspan="6"><span class="formError">#rc.$.Slatwall.rbKey("admin.promotion.edit.validatePromotionReward")#</span></td>
				</tr>
			</cfif>
			<tr id="PromotionReward#local.promotionRewardCount#" class="promotionRewardRow">
				<input type="hidden" name="promotionRewards[#local.promotionRewardCount#].promotionRewardID" value="#local.thisPromotionReward.getPromotionRewardID()#" />
				<td class="alignLeft">
					<cfif rc.edit>
						<cfif isNull(local.thisPromotionReward.getProduct())>
							<cfset local.thisProductID = "" />
						<cfelse>
							<cfset local.thisProductID = local.thisPromotionReward.getProduct().getProductID() />
						</cfif>
						<input type="text" size="40" name="promotionRewards[#local.promotionRewardCount#].product" value="#local.thisProductID#" />
						<cfif local.thisPromotionReward.hasErrors()>
							<br><span class="formError">#local.thisPromotionReward.getErrorBean().getError("product")#</span>
						</cfif>
					<cfelse>
						#local.thisPromotionReward.getProduct().getProductCode()#
					</cfif>
				</td>
				<td>
					<cfif rc.edit>
						<input type="text" size="6" name="promotionRewards[#local.promotionRewardCount#].itemRewardQuantity" value="#local.thisPromotionReward.getItemRewardQuantity()#" />
						<cfif local.thisPromotionReward.hasErrors()>
							<br><span class="formError">#local.thisPromotionReward.getErrorBean().getError("itemRewardQuantity")#</span>
						</cfif>
					<cfelse>
						#local.thisPromotionReward.getItemRewardQuantity()#
					</cfif>
				</td>
				<td>
					<cfif rc.edit>
						 <input type="text" size="6" name="promotionRewards[#local.promotionRewardCount#].itemPercentageOff" value="#local.thisPromotionReward.getItemPercentageOff()#" />         
						<cfif local.thisPromotionReward.hasErrors()>
							<br><span class="formError">#local.thisPromotionReward.getErrorBean().getError("itemPercentageOff")#</span>
						</cfif>
					<cfelse>
						#local.thisPromotionReward.getItemPercentageOff()#
					</cfif>
				</td>
				<td>
					<cfif rc.edit>
						 <input type="text" size="6" name="promotionRewards[#local.promotionRewardCount#].itemAmountOff" value="#local.thisPromotionReward.getItemAmountOff()#" />         
						<cfif local.thisPromotionReward.hasErrors()>
							<br><span class="formError">#local.thisPromotionReward.getErrorBean().getError("itemAmountOff")#</span>
						</cfif>
					<cfelse>
						#local.thisPromotionReward.getItemAmountOff()#
					</cfif>
				</td>
				<td>
					<cfif rc.edit>
						 <input type="text" size="6" name="promotionRewards[#local.promotionRewardCount#].itemAmount" value="#local.thisPromotionReward.getItemAmount()#" />         
						<cfif local.thisPromotionReward.hasErrors()>
							<br><span class="formError">#local.thisPromotionReward.getErrorBean().getError("itemAmount")#</span>
						</cfif>
					<cfelse>
						#local.thisPromotionReward.getItemAmount()#
					</cfif>
				</td>
				<cfif rc.edit>
					<td class="administration">
						<cfif !rc.promotion.isNew() && !local.thisPromotionReward.isNew()>
							<cfset local.disabledText = "" />
							<ul class="one">
								<cf_SlatwallActionCaller action="admin:promotion.deletePromotionReward" querystring="promotionRewardID=#local.thisPromotionReward.getPromotionRewardID()#" class="delete" type="list" confirmrequired="true">
							</ul>
						</cfif>
					</td>
				</cfif>
			</tr>
		</cfloop>
	</tbody>
</table>

<cfif rc.edit>
<table id="promotionRewardTableTemplate" class="hideElement">
<tbody>
    <tr id="temp">
        <td class="alignLeft">
            <input type="text" size="40" name="product" value="" />
			<input type="hidden" name="promotionRewardID" value="" />
        </td>
        <td>
            <input type="text" size="6" name="itemRewardQuantity" value="" />
        </td>
        <td>
            <input type="text" size="6" name="itemPercentageOff" value="" />         
        </td>
        <td>
            <input type="text" size="6" name="itemAmountOff" value="" />         
        </td>
        <td>
            <input type="text" size="6" name="itemAmount" value="" />         
        </td>
        <td class="administration">
        </td>
    </tr>
</tbody>
</table>
</cfif>
</cfoutput>