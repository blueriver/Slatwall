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
<cfparam name="rc.promotionQualifier" type="any">
<cfparam name="rc.promotionPeriod" type="any" default="#rc.promotionQualifier.getPromotionPeriod()#" />
<cfparam name="rc.edit" type="boolean">

<cfset local.qualifierType = rc.promotionQualifier.getQualifierType() />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.promotionQualifier#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.promotionQualifier#" edit="#rc.edit#" 
							  cancelAction="admin:pricing.detailpromotionperiod"
							  cancelQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()#&selectedtab=promotionqualifiers" 
							  backAction="admin:pricing.detailpromotionperiod" 
							  backQueryString="promotionperiodID=#rc.promotionperiod.getpromotionperiodID()#&selectedtab=promotionqualifiers" />
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
				<input type="hidden" name="returnAction" value="admin:pricing.detailpromotionperiod&promotionperiodID=#rc.promotionperiod.getpromotionperiodID()#&selectedtab=promotionqualifiers" />
					<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="minimumQuantity" edit="#rc.edit#" />
					<cfif listFindNoCase("product,order",local.qualifierType)>
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="minimumPrice" edit="#rc.edit#" />
					</cfif>
					<cfif local.qualifiertype eq "product">
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="maximumPrice" edit="#rc.edit#" />
					</cfif>
					<cfif local.qualifiertype eq "fulfillment">
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="maximumFulfillmentWeight" edit="#rc.edit#" />
					</cfif>
					<cfif local.qualifierType eq "product">
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="brands" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="productTypes" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="products" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="excludedProductTypes" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="excludedProducts" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="excludedSkus" edit="#rc.edit#" />
					<cfelseif local.qualifierType eq "fulfillment">
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="fulfillmentMethods" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="shippingMethods" edit="#rc.edit#" />
						<cf_SlatwallPropertyDisplay object="#rc.promotionQualifier#" property="addressZones" edit="#rc.edit#" />						
					</cfif>
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
		
	</cf_SlatwallDetailForm>
</cfoutput>