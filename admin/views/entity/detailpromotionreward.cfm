<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfparam name="rc.promotionReward" type="any">
<cfparam name="rc.promotionPeriod" type="any" default="#rc.promotionReward.getPromotionPeriod()#">
<cfparam name="rc.rewardType" type="string" default="#rc.promotionReward.getRewardType()#">
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion reward if its promotion period has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset rc.$.slatwall.showMessageKey('admin.pricing.promotionperiod.editdisabled_info') />
</cfif>
<cfif rc.edit>
	<cfset rc.promotionReward.setRewardType(rc.rewardType) />
</cfif>

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.promotionreward#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.promotionreward#" edit="#rc.edit#" 
							  cancelAction="admin:entity.detailpromotionreward"
							  cancelQueryString="promotionRewardID=#rc.promotionReward.getPromotionRewardID()#" 
							  backAction="admin:entity.detailpromotionperiod" 
							  backQueryString="promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()###tabPromotionRewards" 
							  deleteQueryString="promotionRewardID=#rc.promotionReward.getPromotionRewardID()#&redirectAction=admin:entity.detailpromotionperiod&promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()###tabPromotionRewards" />
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<input type="hidden" name="rewardType" value="#rc.rewardType#" />
				<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
				<input type="hidden" name="promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
				
				<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="amountType" fieldType="select" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="amount" edit="#rc.edit#" />
				<cf_HibachiDisplayToggle selector="select[name=amountType]" showValues="percentageOff">
					<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="roundingRule" edit="#rc.edit#" />
				</cf_HibachiDisplayToggle>
				<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
					<cfif rc.rewardType eq "subscription">
						<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="applicableTerm" edit="#rc.edit#" />
					</cfif>
					<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerOrder" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerItem" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerQualification" edit="#rc.edit#" />
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.promotionreward#">
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
				<cf_HibachiTab view="admin:entity/promotionrewardtabs/producttypes" />
				<cf_HibachiTab view="admin:entity/promotionrewardtabs/products" />
				<cf_HibachiTab view="admin:entity/promotionrewardtabs/skus" />
				<cf_HibachiTab view="admin:entity/promotionrewardtabs/brands" />
				<cfif rc.rewardType eq "merchandise">
					<cf_HibachiTab view="admin:entity/promotionrewardtabs/options" />
				</cfif>
			<cfelseif rc.rewardType eq "fulfillment">
				<cf_HibachiTab view="admin:entity/promotionrewardtabs/fulfillmentMethods" />
				<cf_HibachiTab view="admin:entity/promotionrewardtabs/shippingMethods" />
				<cf_HibachiTab view="admin:entity/promotionrewardtabs/shippingAddressZones" />
			</cfif>
		</cf_HibachiTabGroup>

	</cf_HibachiEntityDetailForm>
</cfoutput>