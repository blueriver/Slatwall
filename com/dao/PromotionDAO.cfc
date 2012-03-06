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
		
		<cfset var allDiscounts = "" />
		<cfset var skuPrice = "" />
		<cfset var skuResults = "" />
		<cfset var timeNow = now() />
		
		<cfquery name="allDiscounts">
			SELECT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'sku' as 'discountLevel',
				CASE
					WHEN prSku.percentageOff IS NULL AND prSku.amountOff IS NULL THEN 'amount'
					WHEN prSku.percentageOff IS NULL AND prSku.amount IS NULL THEN 'amountOff'
					WHEN prSku.amountOff IS NULL AND prSku.amount IS NULL THEN 'percentageOff'
				END as 'salePriceDiscountType',
				CASE
					WHEN prSku.percentageOff IS NULL AND prSku.amountOff IS NULL THEN prSku.amount
					WHEN prSku.percentageOff IS NULL AND prSku.amount IS NULL THEN SlatwallSku.price - prSku.amountOff
					WHEN prSku.amountOff IS NULL AND prSku.amount IS NULL THEN SlatwallSku.price - (SlatwallSku.price * (prSku.percentageOff / 100))
				END as 'salePrice',
				prSku.percentageOff as 'percentageOff',
				prSku.amountOff as 'amountOff',
				prSku.amount as 'amount',
				prSku.roundingRuleID as 'roundingRuleID',
				pSku.endDateTime as 'salePriceExpirationDateTime',
				pSku.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallPromotionRewardProductSku on SlatwallPromotionRewardProductSku.skuID = SlatwallSku.skuID
			  INNER JOIN
			  	SlatwallPromotionReward prSku on prSku.promotionRewardID = SlatwallPromotionRewardProductSku.promotionRewardID
			  INNER JOIN
			  	SlatwallPromotion pSku on pSku.promotionID = prSku.promotionID
			WHERE
				pSku.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pSku.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pSku.activeFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  AND
			  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pSku.promotionID)
			<cfif structKeyExists(arguments, "skuID")>
			  AND
				SlatwallSku.skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
			<cfelseif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
			SELECT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'product' as 'discountLevel',
				CASE
					WHEN prProduct.percentageOff IS NULL AND prProduct.amountOff IS NULL THEN 'amount'
					WHEN prProduct.percentageOff IS NULL AND prProduct.amount IS NULL THEN 'amountOff'
					WHEN prProduct.amountOff IS NULL AND prProduct.amount IS NULL THEN 'percentageOff'
				END as 'salePriceDiscountType',
				CASE
					WHEN prProduct.percentageOff IS NULL AND prProduct.amountOff IS NULL THEN prProduct.amount
					WHEN prProduct.percentageOff IS NULL AND prProduct.amount IS NULL THEN SlatwallSku.price - prProduct.amountOff
					WHEN prProduct.amountOff IS NULL AND prProduct.amount IS NULL THEN SlatwallSku.price - (SlatwallSku.price * (prProduct.percentageOff / 100))
				END as 'salePrice',
				prProduct.percentageOff as 'percentageOff',
				prProduct.amountOff as 'amountOff',
				prProduct.amount as 'amount',
				prProduct.roundingRuleID as 'roundingRuleID',
				pProduct.endDateTime as 'salePriceExpirationDateTime',
				pProduct.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallPromotionRewardProductProduct on SlatwallPromotionRewardProductProduct.productID = SlatwallSku.productID
			  INNER JOIN
			  	SlatwallPromotionReward prProduct on prProduct.promotionRewardID = SlatwallPromotionRewardProductProduct.promotionRewardID
			  INNER JOIN
			  	SlatwallPromotion pProduct on pProduct.promotionID = prProduct.promotionID
			WHERE
				pProduct.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pProduct.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pProduct.activeFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  AND
			  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pProduct.promotionID)
			<cfif structKeyExists(arguments, "skuID")>
			  AND
				SlatwallSku.skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
			<cfelseif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
			SELECT
				SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'brand' as 'discountLevel',
				CASE
					WHEN prBrand.percentageOff IS NULL AND prBrand.amountOff IS NULL THEN 'amount'
					WHEN prBrand.percentageOff IS NULL AND prBrand.amount IS NULL THEN 'amountOff'
					WHEN prBrand.amountOff IS NULL AND prBrand.amount IS NULL THEN 'percentageOff'
				END as 'salePriceDiscountType',
				CASE
					WHEN prBrand.percentageOff IS NULL AND prBrand.amountOff IS NULL THEN prBrand.amount
					WHEN prBrand.percentageOff IS NULL AND prBrand.amount IS NULL THEN SlatwallSku.price - prBrand.amountOff
					WHEN prBrand.amountOff IS NULL AND prBrand.amount IS NULL THEN SlatwallSku.price - (SlatwallSku.price * (prBrand.percentageOff / 100))
				END as 'salePrice',
				prBrand.percentageOff as 'percentageOff',
				prBrand.amountOff as 'amountOff',
				prBrand.amount as 'amount',
				prBrand.roundingRuleID as 'roundingRuleID',
				pBrand.endDateTime as 'salePriceExpirationDateTime',
				pBrand.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallProduct on SlatwallProduct.productID = SlatwallSku.productID
			  INNER JOIN
			  	SlatwallPromotionRewardProductBrand on SlatwallPromotionRewardProductBrand.brandID = SlatwallProduct.brandID
			  INNER JOIN
			  	SlatwallPromotionReward prBrand on prBrand.promotionRewardID = SlatwallPromotionRewardProductBrand.promotionRewardID
			  INNER JOIN
			  	SlatwallPromotion pBrand on pBrand.promotionID = prBrand.promotionID
			WHERE
				pBrand.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pBrand.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pBrand.activeFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  AND
			  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pBrand.promotionID)
			<cfif structKeyExists(arguments, "skuID")>
			  AND
				SlatwallSku.skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
			<cfelseif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
		  	SELECT
		  		SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'option' as 'discountLevel',
				CASE
					WHEN prOption.percentageOff IS NULL AND prOption.amountOff IS NULL THEN 'amount'
					WHEN prOption.percentageOff IS NULL AND prOption.amount IS NULL THEN 'amountOff'
					WHEN prOption.amountOff IS NULL AND prOption.amount IS NULL THEN 'percentageOff'
				END as 'salePriceDiscountType',
				CASE
					WHEN prOption.percentageOff IS NULL AND prOption.amountOff IS NULL THEN prOption.amount
					WHEN prOption.percentageOff IS NULL AND prOption.amount IS NULL THEN SlatwallSku.price - prOption.amountOff
					WHEN prOption.amountOff IS NULL AND prOption.amount IS NULL THEN SlatwallSku.price - (SlatwallSku.price * (prOption.percentageOff / 100))
				END as 'salePrice',
				prOption.percentageOff as 'percentageOff',
				prOption.amountOff as 'amountOff',
				prOption.amount as 'amount',
				prOption.roundingRuleID as 'roundingRuleID',
				pOption.endDateTime as 'salePriceExpirationDateTime',
				pOption.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallSkuOption on SlatwallSkuOption.skuID = SlatwallSku.skuID
			  INNER JOIN
			  	SlatwallPromotionRewardProductOption on SlatwallPromotionRewardProductOption.optionID = SlatwallSkuOption.optionID
			  INNER JOIN
			  	SlatwallPromotionReward prOption on prOption.promotionRewardID = SlatwallPromotionRewardProductOption.promotionRewardID
			  INNER JOIN
			  	SlatwallPromotion pOption on pOption.promotionID = prOption.promotionID
			WHERE
				pOption.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pOption.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pOption.activeFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  AND
			  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pOption.promotionID)
			<cfif structKeyExists(arguments, "skuID")>
			  AND
				SlatwallSku.skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
			<cfelseif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		  UNION
		  	SELECT
		  		SlatwallSku.skuID as 'skuID',
				SlatwallSku.price as 'originalPrice',
				'productType' as 'discountLevel',
				CASE
					WHEN prProductType.percentageOff IS NULL AND prProductType.amountOff IS NULL THEN 'amount'
					WHEN prProductType.percentageOff IS NULL AND prProductType.amount IS NULL THEN 'amountOff'
					WHEN prProductType.amountOff IS NULL AND prProductType.amount IS NULL THEN 'percentageOff'
				END as 'salePriceDiscountType',
				CASE
					WHEN prProductType.percentageOff IS NULL AND prProductType.amountOff IS NULL THEN prProductType.amount
					WHEN prProductType.percentageOff IS NULL AND prProductType.amount IS NULL THEN SlatwallSku.price - prProductType.amountOff
					WHEN prProductType.amountOff IS NULL AND prProductType.amount IS NULL THEN SlatwallSku.price - (SlatwallSku.price * (prProductType.percentageOff / 100))
				END as 'salePrice',
				prProductType.percentageOff as 'percentageOff',
				prProductType.amountOff as 'amountOff',
				prProductType.amount as 'amount',
				prProductType.roundingRuleID as 'roundingRuleID',
				pProductType.endDateTime as 'salePriceExpirationDateTime',
				pProductType.promotionID as 'promotionID'
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallProduct on SlatwallProduct.productID = SlatwallSku.productID
			  INNER JOIN
			  	SlatwallProductType on SlatwallProduct.productTypeID = SlatwallProductType.productTypeID
			  INNER JOIN
			  <cfif getDBType() eq "MySQL">
			  	SlatwallPromotionRewardProductProductType on SlatwallProductType.productTypeIDPath LIKE concat('%', SlatwallPromotionRewardProductProductType.productTypeID, '%')
			  <cfelse>
			  	SlatwallPromotionRewardProductProductType on SlatwallProductType.productTypeIDPath LIKE ('%' + SlatwallPromotionRewardProductProductType.productTypeID + '%')
			  </cfif>
			  INNER JOIN
			  	SlatwallPromotionReward prProductType on prProductType.promotionRewardID = SlatwallPromotionRewardProductProductType.promotionRewardID
			  INNER JOIN
			  	SlatwallPromotion pProductType on pProductType.promotionID = prProductType.promotionID
			WHERE
				pProductType.startDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pProductType.endDateTime >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#timeNow#">
			  AND
				pProductType.activeFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			  AND
			  	NOT EXISTS(SELECT promotionID FROM SlatwallPromotionCode WHERE promotionID = pProductType.promotionID)
			<cfif structKeyExists(arguments, "skuID")>
			  AND
				SlatwallSku.skuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skuID#">
			<cfelseif structKeyExists(arguments, "productID")>
			  AND
				SlatwallSku.productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">	
			</cfif>
		</cfquery>
		
		<cfquery name="skuPrice" dbtype="query">
			SELECT
				skuID,
				MIN(salePrice) as salePrice
			FROM
				allDiscounts
			GROUP BY
				skuID
		</cfquery>
		
		<cfquery name="skuResults" dbtype="query">
			SELECT
				AllDiscounts.skuID,
				AllDiscounts.originalPrice,
				AllDiscounts.discountLevel,
				AllDiscounts.salePriceDiscountType,
				AllDiscounts.salePrice,
				AllDiscounts.percentageOff,
				AllDiscounts.amountOff,
				AllDiscounts.amount,
				AllDiscounts.roundingRuleID,
				AllDiscounts.salePriceExpirationDateTime,
				AllDiscounts.promotionID
			FROM
				allDiscounts,
				skuPrice
			WHERE
				allDiscounts.skuID = skuPrice.skuID
			  and
			    allDiscounts.salePrice = skuPrice.salePrice
		</cfquery>
		
		<cfreturn skuResults /> 
	</cffunction>
		
</cfcomponent>