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
	<div class="svoproductdetail">
		<div class="image">
			<a href="#$.slatwall.Product().getImagePath()#" target="_blank">#$.slatwall.Product().getImage(size="m")#</a>
		</div>
		<cf_SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="productCode">
		<div class="description">#$.slatwall.Product().getProductDescription()#</div>
		<form action="?nocache=1" method="post">
			<input type="hidden" name="productID" value="#$.slatwall.Product().getProductID()#" />
			<input type="hidden" name="slatAction" value="frontend:cart.addItem" />
			<!--- Product Options --->
			<cfif arrayLen($.slatwall.product().getSkus(true)) eq 1>
				<input type="hidden" name="skuID" value="#$.slatwall.Product().getSkus()[1].getSkuID()#" />
			<cfelse>
				<dl>
					<dt>Select Option</dt>
					<dd>
						<select name="skuID">
							<cfloop array="#$.slatwall.product().getSkus(true)#" index="local.sku">
								<option value="#local.sku.getSkuID()#">#local.sku.displayOptions()#</option>
							</cfloop>
						</select>
					</dd>
				</dl>
			</cfif>
			<!--- END: Product Options --->
				
			<!--- Product Customizations --->
			<cfloop array="#$.slatwall.product().getAttributeSets(['astProductCustomization'])#" index="local.customizationAttributeSet">
				<div class="productCustomizationSet #lcase(replace(local.customizationAttributeSet.getAttributeSetName(), ' ', '', 'all'))#">
					<h4>#local.customizationAttributeSet.getAttributeSetName()#</h4>
					<dl>
					<cfloop array="#local.customizationAttributeSet.getAttributes()#" index="local.attribute">
						<cf_SlatwallAttributeDisplay attribute="#local.attribute#" />
					</cfloop>
					</dl>
				</div>
			</cfloop>
			<!--- END: Product Customizations --->
				
			<label for="productQuantity">Quantity: </label><input type="text" name="quantity" value="1" size="2" id="productQuantity" />
			<button type="submit">Add To Cart</button>
		</form>
		<div class="reviews">
			<cfloop array="#$.slatwall.product().getProductReviews()#" index="review">
				<dl>
					<dt>#review.getReviewerName()#</dt>
					<dd>#review.getReview()#</dd>
				</dl>
			</cfloop>
			<form action="?nocache=1" method="post">
				<input type="hidden" name="slatAction" value="frontend:product.addReview" />
				<input type="hidden" name="productID" value="#$.slatwall.product('productID')#" />
				<dl>
					<dt>Name</dt>
					<dd><input type="text" name="reviewerName" value="#$.slatwall.account('fullname')#" /></dd>
					<dt>Review</dt>
					<dd><textarea name="review"></textarea></dd>
				</dl>
				<button type="submit">Add Review</button>
			</form>
		</div>
	</div>
</cfoutput>
