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
	<cfif arrayLen(rc.promotion.getPromotionQualifierExclusions()) GT 0>
		<table class="listing-grid stripe">
			<thead>
				<tr>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.promotion.promotionQualifierExclusion.item")#</th>
					<th class="administration">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.promotion.getpromotionQualifierExclusions()#" index="local.thisPromotionQualifierExclusion">
					<cfif not local.thisPromotionQualifierExclusion.hasErrors()>
						<tr>
							<td class="varWidth">
								<cfset local.itemName = "" />
								<cfif arrayLen(local.thisPromotionQualifierExclusion.getSkus())>
									<cfset local.itemName &= "<p>" />
									<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierExclusion.skus') & ": " />
									<cfset local.itemName &= local.thisPromotionQualifierExclusion.displaySkuCodes() />
									<cfset local.itemName &= "</p>" />
								</cfif>	
								<cfif arrayLen(local.thisPromotionQualifierExclusion.getProducts())>
									<cfset local.itemName &= "<p>" />
									<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierExclusion.products') & ": " />
									<cfset local.itemName &= local.thisPromotionQualifierExclusion.displayProductNames() />
									<cfset local.itemName &= "</p>" />
								</cfif>
								<cfif arrayLen(local.thisPromotionQualifierExclusion.getProductTypes())>
									<cfset local.itemName &= "<p>" />
									<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierExclusion.productTypes') & ": " />
									<cfset local.itemName &= local.thisPromotionQualifierExclusion.displayProductTypeNames() />
									<cfset local.itemName &= "</p>" />
								</cfif>
								<cfif arrayLen(local.thisPromotionQualifierExclusion.getBrands())>
									<cfset local.itemName &= "<p>" />
									<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierExclusion.brands') & ": " />
									<cfset local.itemName &= local.thisPromotionQualifierExclusion.displayBrandNames() />
									<cfset local.itemName &= "</p>" />
								</cfif>
								<cfif arrayLen(local.thisPromotionQualifierExclusion.getOptions())>
									<cfset local.itemName &= "<p>" />
									<cfset local.itemName &= $.Slatwall.rbKey('entity.promotionQualifierExclusion.options') & ": " />
									<cfset local.itemName &= local.thisPromotionQualifierExclusion.displayOptionNames() />
									<cfset local.itemName &= "</p>" />
								</cfif>
								<cfif not len(local.itemName)>
									<cfset local.itemName &= "<p>" />
									<cfset local.itemName &= $.Slatwall.rbKey("define.all") />
									<cfset local.itemName &= "</p>" />
								</cfif>
								#local.itemName#
							</td>
							<td class="administration">
								<ul class="two">
									<cf_SlatwallActionCaller action="admin:promotion.edit" querystring="promotionQualifierExclusionID=#local.thisPromotionQualifierExclusion.getpromotionQualifierExclusionID()#&promotionID=#rc.promotion.getPromotionID()###tabPromotionQualifierExclusions" class="edit" type="list">
									<cf_SlatwallActionCaller action="admin:promotion.deletepromotionQualifierExclusion" querystring="promotionQualifierExclusionID=#local.thisPromotionQualifierExclusion.getPromotionQualifierExclusionID()#&promotionID=#rc.promotion.getPromotionID()#" class="delete" type="list" disabled="#local.thisPromotionQualifierExclusion.isNotDeletable()#" confirmrequired="true">
								</ul>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p><em>#rc.$.Slatwall.rbKey("admin.promotion.nopromotionqualifierexclusionsdefined")#</em></p>
		<br /><br />
	</cfif>
	<cfif rc.edit>
		<!--- If the exclusion is new, then that means that we are just editing it --->
		<cfif rc.promotionQualifierExclusion.isNew() && !rc.promotionQualifierExclusion.hasErrors()>
			<button type="button" id="addPromotionQualifierExclusionButton" value="true">#rc.$.Slatwall.rbKey("admin.promotion.detail.addPromotionQualifierExclusion")#</button>
			<input type="hidden" name="savePromotionQualifierExclusion" id="savePromotionQualifierExclusionHidden" value="false"/>
		<cfelseif !rc.promotionQualifierExclusion.isNew() || rc.promotionQualifierExclusion.hasErrors()>
			<input type="hidden" name="savepromotionQualifierExclusion" id="savePromotionQualifierExclusionHidden" value="true"/>
		</cfif>
		
		<input type="hidden" name="populateSubProperties" value="false"/>		
		<div id="promotionQualifierExclusionInputs" <cfif rc.promotionQualifierExclusion.isNew() and not rc.promotionQualifierExclusion.hasErrors()>class="ui-helper-hidden"</cfif> >
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierExclusion#" property="brands" fieldName="promotionQualifierExclusions[1].brands" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierExclusion#" property="productTypes" fieldName="promotionQualifierExclusions[1].productTypes" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.promotionQualifierExclusion#" property="products" fieldName="promotionQualifierExclusions[1].products" edit="true" />
				<!--- <cf_SlatwallPropertyDisplay object="#rc.promotionQualifierExclusion#" property="skus" fieldName="promotionQualifierExclusions[1].skus" edit="true" /> --->
				<!--- <cf_SlatwallPropertyDisplay object="#rc.promotionQualifierExclusion#" property="options" fieldName="promotionQualifierExclusions[1].options" edit="true" /> --->
			</dl>
			<input type="hidden" name="promotionQualifierExclusions[1].promotionQualifierExclusionID" value="#rc.promotionQualifierExclusion.getPromotionQualifierExclusionID()#"/>
		</div>
		
		<br /><br />
	</cfif>
</cfoutput>