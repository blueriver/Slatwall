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
<cfparam name="rc.promotionreward" type="any">
<cfparam name="rc.promotionperiod" type="any" default="#rc.promotionreward.getPromotionPeriod()#" />
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion reward if its promotion period has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset arrayAppend(rc.messages,{message=rc.$.slatwall.rbKey('admin.pricing.promotionreward.editdisabled'),messageType="info"}) />
</cfif>

<cfset local.rewardType = rc.promotionReward.getRewardType() />

<cfoutput>
	Expired: #rc.promotionreward.getPromotionPeriod().isExpired()#
	<cf_SlatwallDetailForm object="#rc.promotionreward#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.promotionreward#" edit="#rc.edit#" 
							  cancelAction="admin:pricing.detailpromotionperiod"
							  cancelQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards" 
							  backAction="admin:pricing.detailpromotionperiod" 
							  backQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards" />
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
				<input type="hidden" name="returnAction" value="admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID()###tabpromotionrewards" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="discountType" fieldType="select" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="percentageOff" edit="#rc.edit#" displayVisible="discountType:percentageOff">
				<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="amountOff" edit="#rc.edit#" displayVisible="discountType:amountOff" />
				<cfif rewardType neq "order">
					<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="amount" edit="#rc.edit#" displayVisible="discountType:amount"  />
				</cfif>
				<cfswitch expression="#local.rewardType#" >
					<cfcase value="product">
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="rewardCanApplyToQualifierFlag" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="itemRewardQuantity" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="maximumOrderRewardQuantity" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="roundingRule" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="brands" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="productTypes" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="products" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="excludedProductTypes" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="excludedProducts" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="excludedSkus" edit="#rc.edit#" />
					</cfcase>
					<cfcase value="shipping">
						<cf_SlatwallPropertyDisplay object="#rc.promotionreward#" property="shippingMethods" edit="#rc.edit#" />
					</cfcase>
				</cfswitch>
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		
	</cf_SlatwallDetailForm>
</cfoutput>