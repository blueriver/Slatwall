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
<cfcomponent extends="BaseDAO">
	
	<cffunction name="getAllActivePromotions" returntype="Array" access="public">
		<cfreturn ormExecuteQuery(" from SlatwallPromotion sp where sp.startDateTime < ? and sp.endDateTime > ? and sp.activeFlag = 1", [now(), now()]) />
	</cffunction>
	
	<cffunction name="getSalePricePromotionRewardsQuery">
		<cfargument name="skuID" type="string">
		<cfargument name="productID" type="string">
		
		<cfset var rs="" />
		<cfset var pt="" />
		
		<cfquery name="pt">
			SELECT
				productTypeID
			FROM
				SlatwallProduct
			  INNER JOIN
			  	SlatwallSku on SlatwallProduct.productID = SlatwallSku.productID
			WHERE
				SlatwallSku.skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
		</cfquery>
		
		<cfset var productTypeList = getService('productService').getProductTypeFromTree(productTypeID = pt.productTypeID).idpath />
		<cfset var loopCount = 0 />
		<cfset var currentProductTypeID = "" />
		
		<cfquery name="rs">
			SELECT DISTINCT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				SlatwallSku.price - (SlatwallSku.price * (prSku.itemPercentageOff / 100)) as 'skuPercentageOff',
				SlatwallSku.price - prSku.itemAmountOff as 'skuAmountOff',
				prSku.itemAmount as 'skuAmount',
				prSku.roundingRuleID as 'skuRoundingRule',
				pSku.endDateTime as 'skuEndDateTime',
				SlatwallSku.price - (SlatwallSku.price * (prProduct.itemPercentageOff / 100)) as 'productPercentageOff',
				SlatwallSku.price - prProduct.itemAmountOff as 'productAmountOff',
				prProduct.itemAmount as 'productAmount',
				prProduct.roundingRuleID as 'productRoundingRuleID',
				pProduct.endDateTime as 'productEndDateTime',
				SlatwallSku.price - (SlatwallSku.price * (prBrand.itemPercentageOff / 100)) as 'brandPercentageOff',
				SlatwallSku.price - prBrand.itemAmountOff as 'brandAmountOff',
				prBrand.itemAmount as 'brandAmount',
				prBrand.roundingRuleID as 'brandRoundingRuleID',
				pBrand.endDateTime as 'brandEndDateTime',
				SlatwallSku.price - (SlatwallSku.price * (prOption.itemPercentageOff / 100)) as 'optionPercentageOff',
				SlatwallSku.price - prOption.itemAmountOff as 'optionAmountOff',
				prOption.itemAmount as 'optionAmount',
				prOption.roundingRuleID as 'optionRoundingRuleID',
				pOption.endDateTime as 'optionEndDateTime',
				SlatwallSku.price - (SlatwallSku.price * (prProductType.itemPercentageOff / 100)) as 'productTypePercentageOff',
				SlatwallSku.price - prProductType.itemAmountOff as 'productTypeAmountOff',
				prProductType.itemAmount as 'productTypeAmount',
				prProductType.roundingRuleID as 'productTypeRoundingRuleID',
				pProductType.endDateTime as 'productTypeEndDateTime'
			FROM
				SlatwallSku
			  INNER JOIN
				SlatwallProduct on SlatwallProduct.productID = SlatwallSku.productID
			  LEFT JOIN
				SlatwallSkuOption on SlatwallSkuOption.skuID = SlatwallSku.skuID
			  LEFT JOIN
				SlatwallOption on SlatwallOption.optionID = SlatwallSkuOption.optionID
			  LEFT JOIN
			  	SlatwallPromotionRewardProductSku on SlatwallPromotionRewardProductSku.skuID = SlatwallSku.skuID
			  LEFT JOIN
				SlatwallPromotionRewardProductProduct on SlatwallPromotionRewardProductProduct.productID = SlatwallProduct.productID
			  LEFT JOIN
				SlatwallPromotionRewardProductBrand on SlatwallPromotionRewardProductBrand.brandID = SlatwallProduct.brandID
			  LEFT JOIN
				SlatwallPromotionRewardProductOption on SlatwallPromotionRewardProductOption.optionID = SlatwallOption.optionID
			  LEFT JOIN
				SlatwallPromotionRewardProductProductType on SlatwallPromotionRewardProductProductType.productTypeID IN (
					<cfloop list="#productTypeList#" index="currentProductTypeID">
						<cfset loopCount ++ />
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentProductTypeID#">
						<cfif loopCount lt listLen(productTypeList)>
							,
						</cfif>
					</cfloop>
					)
			  LEFT JOIN
			  	SlatwallPromotionReward prSku on prSku.promotionRewardID = SlatwallPromotionRewardProductSku.promotionRewardID
			  LEFT JOIN
			  	SlatwallPromotionReward prProduct on prProduct.promotionRewardID = SlatwallPromotionRewardProductProduct.promotionRewardID
			  LEFT JOIN
			  	SlatwallPromotionReward prBrand on prBrand.promotionRewardID = SlatwallPromotionRewardProductBrand.promotionRewardID
			  LEFT JOIN
			  	SlatwallPromotionReward prOption on prOption.promotionRewardID = SlatwallPromotionRewardProductOption.promotionRewardID
			  LEFT JOIN
			  	SlatwallPromotionReward prProductType on prProductType.promotionRewardID = SlatwallPromotionRewardProductProductType.promotionRewardID
			  LEFT JOIN
				SlatwallPromotion pSku on prSku.promotionID = pSku.promotionID
				  AND
					(pSku.startDateTime is null or pSku.startDateTime <= GETDATE())
				  AND
					(pSku.endDateTime is null or pSku.endDateTime >= GETDATE())
				  AND
					(pSku.activeFlag is null or pSku.activeFlag = 1)
				  AND
				  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pSku.promotionID)
			  LEFT JOIN
				SlatwallPromotion pProduct on prProduct.promotionID = pProduct.promotionID
				  AND
					(pProduct.startDateTime is null or pProduct.startDateTime <= GETDATE())
				  AND
					(pProduct.endDateTime is null or pProduct.endDateTime >= GETDATE())
				  AND
					(pProduct.activeFlag is null or pProduct.activeFlag = 1)
				  AND
				  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pProduct.promotionID)
			  LEFT JOIN
				SlatwallPromotion pBrand on prBrand.promotionID = pBrand.promotionID
				  AND
					(pBrand.startDateTime is null or pBrand.startDateTime <= GETDATE())
				  AND
					(pBrand.endDateTime is null or pBrand.endDateTime >= GETDATE())
				  AND
					(pBrand.activeFlag is null or pBrand.activeFlag = 1)
				  AND
				  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pBrand.promotionID)
			  LEFT JOIN
				SlatwallPromotion pOption on prOption.promotionID = pOption.promotionID
				  AND
					(pOption.startDateTime is null or pOption.startDateTime <= GETDATE())
				  AND
					(pOption.endDateTime is null or pOption.endDateTime >= GETDATE())
				  AND
					(pOption.activeFlag is null or pOption.activeFlag = 1)
				  AND
				  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pOption.promotionID)
			  LEFT JOIN
				SlatwallPromotion pProductType on prProductType.promotionID = pProductType.promotionID
				  AND
					(pProductType.startDateTime is null or pProductType.startDateTime <= GETDATE())
				  AND
					(pProductType.endDateTime is null or pProductType.endDateTime >= GETDATE())
				  AND
					(pProductType.activeFlag is null or pProductType.activeFlag = 1)
				  AND
				  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pProductType.promotionID)
			<cfif structKeyExists(arguments, "skuID")>
			WHERE
				SlatwallSku.skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
			<cfelseif structKeyExists(arguments, "productID")>
			WHERE
				SlatwallProduct.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
			</cfif>
		</cfquery>
		
		<cfreturn rs /> 
	</cffunction>
		
</cfcomponent>