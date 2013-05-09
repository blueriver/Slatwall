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
<cfinclude template="_slatwall-header.cfm" />
<cfoutput>
	<div class="container">
		
		<div class="row">
			<div class="span12">
				<!--- We use the getTitle() method which uses the title template setting to pull in brand name or whatever else you might want in your titles --->
				<h2>#$.slatwall.product().getTitle()#</h2>
			</div>
		</div>
		<div class="row">
			<div class="span4">
				<div class="well">
					<!--- This displays the primary image which is pulled from the default sku --->
					<a href="#$.slatwall.product().getImagePath()#" target="_blank">#$.slatwall.product().getImage(size="m")#</a>
				</div>
			</div>
			<div class="span8">
				<div class="row">
					<div class="span5">
						<!--- START: PRODUCT DETAILS EXAMPLE --->
						<h4>Product Details Example</h4>
						<dl class="dl-horizontal">
							<!--- Product Code --->
							<dt>Product Code</dt>
							<dd>#$.slatwall.product().getProductCode()#</dd>
							
							<!--- Product Type --->
							<dt>Product Type</dt>
							<dd>#$.slatwall.product().getProductType().getProductTypeName()#</dd>
							
							<!--- Brand --->
							<cfif !isNull($.slatwall.product().getBrand())>
								<dt>Product Type</dt>
								<dd>#$.slatwall.product().getBrand().getBrandName()#</dd>
							</cfif>
							
							<!--- List Price | This price is really just a place-holder type of price that can display the MSRP.  It is typically used to show the highest price --->
							<dt>List Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('listPrice')#</dd>
							
							<!--- Current Account Price | This price is used for accounts that have Price Groups associated with their account.  Typically Price Groups are used for Wholesale pricing, or special employee / account pricing --->
							<dt>Current Account Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('currentAccountPrice')#</dd>
							
							<!--- Sale Price | This value will be pulled from any current active promotions that don't require any promotion qualifiers or promotion codes --->
							<dt>Sale Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('salePrice')# </dd>
							
							<!--- Live Price | The live price looks at both the salePrice and currentAccountPrice to figure out which is better and display that.  This is what the customer will see in their cart once the item has been added so it should be used as the primary price to display --->
							<dt>Live Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('livePrice')# </dd>
							
							<!--- Product Description --->
							<dt>Product Description</dt>
							<dd>#$.slatwall.product().getProductDescription()# &nbsp;</dd>
						</dl>
						<!--- END: PRODUCT DETAILS EXAMPLE --->
					</div>
					<div class="span3">
						<!--- Start: PRICE DISPLAY EXAMPLE --->
						<h4>Price Display Example</h4>
						<p><em>This price is dynamic based on Sale / Account pricing</em></p>
						<br />
						<cfif $.slatwall.product('price') gt $.slatwall.product('livePrice')>
							<span style="text-decoration:line-through;color:##cc0000;">#$.slatwall.product().getFormattedValue('price')#</span><br />
							<span style="font-size:24px;color:##333333;">#$.slatwall.product().getFormattedValue('livePrice')#</span>		
						<cfelse>
							<span style="font-size:24px;color:##333333;">#$.slatwall.product().getFormattedValue('livePrice')#</span>
						</cfif>
						<!---[ DEVELOPER NOTES ]														
																										
								When asking for a price from a product, it automatically pulls			
								that price from whichever has been defined as the 'Default Sku'			
								in the admin.  If your skus have different prices, you will either		
								want to update the price based on the sku selected in an addToCart		
								form, or you might want to put the price in the dropdowns themselves.	
								Another option would be to use the type of AddToCart form that lists	
								out all of the skus.													
																										
						--->
						<!--- END: PRICE DISPLAY EXAMPLE --->
					</div>
				</div>
				
				<hr />
				
				<!--- START: ADD TO CART EXAMPLE 1 --->
				<h4>Add To Cart Form Example 1</h4>
				<p><em>This add to cart form is extreamly simple, and will just display a dropdown list of skus to select the one to add.  Note if there is only one sku, no dropdown will be shown but instead a hidden field of skuID will be added</em></p>
				
				<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. ---> 
				<form action="?s=1" method="post">
					<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
					
					<!---[ DEVELOPER NOTES ]																				
																															
						$.slatwall.product().getSkus() returns all of the skus for a product								
					 																										
					 	sorted = true | allows for the list to be sorted based on the optionGroup and option sort order		
						fetchOptions = true | optimizes the query to pull down the option details to be displayed			
																															
					--->
					<cfset local.skus = $.slatwall.product().getSkus(sorted=true, fetchOptions=true) />
						
					<!--- Check to see if there are more than 1 skus, if so then display the options dropdown --->
					<cfif arrayLen(local.skus) gt 1>
						
						<!--- Sku Selector --->
						<select name="skuID" class="required">
							
							<!--- Blank option to force user to select (this is optional) --->	
							<option value="">Select Option</option>
							
							<!--- Loop over the skus to display options --->
							<cfloop array="#local.skus#" index="local.sku">
								<!--- This provides an option for each sku, with the 'displayOptions' method to show the optionGroup / option names --->
								<option value="#local.sku.getSkuID()#">#local.sku.displayOptions()#</option>
							</cfloop>
							
						</select>
						
						<br />
						
					<!--- If there are only 1 skus, then add a hidden field --->
					<cfelse> 
						<input type="hidden" name="skuID" value="#$.slatwall.product().getDefaultSku().getSkuID()#" />
					</cfif>
					
					<!--- Add to Cart Button --->
					<button type="submit">Add To Cart</button>
				</form>
				<!--- END: ADD TO CART EXAMPLE 1 --->
				
				<hr />
					
				<!--- Start: Add To Cart Form Example 2 --->
				<h4>Add To Cart Form Example 2</h4>
				
				<form action="?s=1" method="post">
					<input type="hidden" name="slatAction" value="public:cart.addItem" />
					
					
				</form>
				
				<!--- End: Add To Cart Form Example 2 --->
			</div>
		</div>
		
		<!--- Lower Section --->
		<hr />
		
		<!--- Start: Add Product Review Example --->
		<div class="row">
			<div class="span12">
				<h4>Add Product Review Example</h4>
			</div>
		</div>
		<!--- End: Add Product Review Example --->
			
		<hr />
			
		<!--- Start: Related Products Example --->
		<div class="row">
			<div class="span12">
				<h4>Related Products Example</h4>
			</div>
		</div>
		<!--- End: Related Products Example --->
		
		<hr />
		
		<!--- Start: Image Gallery Example --->
		<div class="row">
			<div class="span12">
				<h4>Image Gallery Example</h4>
				
				<cfset local.galleryDetails = $.slatwall.product().getImageGalleryArray() />
				
				<!---[ DEVELOPER NOTES ]																		
																												
					The primary method that makes images galleries possible is:									
																												
					$.slatwall.getImageGalleryArray( array resizedSizes )										
																												
					This is a very unique method to give you all the data you need to create an image gallery	
					with whatever sizes.  The ImageGalleryArray will take whatever sizes you pass in, and pass	
					back the details and resized image paths for all of the skus default images as well as any	
					alternative images that were assigned to the product.										
																												
					For example, if you wanted to get 2 sizes back 100x100 and 500x500 so that you could		
					display thumbnails ect.  You would just do:													
																												
					$.slatwall.getImageGalleryArray( [ {width=100, height=100}, {width=500, height=500} ] )		
																												
																												
					By default if you don't pass in your own resizing array, it will just ask for the 3 sizes	
					of Small, Medium, and Large which will get the actually sizes from the product settings.	
					The logic it runs by default is the same as if you did this:								
																												
					$.slatwall.getImageGalleryArray( [ {size='small'},{size='medium'},{size='large'} ] )		
																												
																												
					Basically every structure in the array, will just call the getResizedImagePath() method		
					so you can pass in whatever resizing and cropping arguments you like based on the specs		
					that you read more about here:																
																												
					http://docs.getslatwall.com/reference/product-images-and-cropping/							
																												
				--->
				<cfloop array="#local.galleryDetails#" index="local.image">
					
					<!---[ DEVELOPER NOTES ]																		
																													
						Now that we are inside of the loop of images being returned, you have access to the			
						following detials insilde of the local.image struct that came back in the array				
																													
					--->
				</cfloop>
				
			</div>
		</div>
		<!--- End: Image Gallery Example --->
	</div>
</cfoutput>
<cfinclude template="_slatwall-footer.cfm" />
<!---
<div class="svoproductdetail">
	<div class="image">
		
	</div>
	<dl>
		<cf_SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="productCode">
		<cf_SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="livePrice">
		<cf_SlatwallPropertyDisplay object="#$.slatwall.Product()#" property="productDescription">
	</dl>
	<form action="#$.createHREF(filename=$.slatwall.setting('globalPageShoppingCart'),queryString='nocache=1')#" method="post">
		<input type="hidden" name="productID" value="#$.slatwall.Product().getProductID()#" />
		<input type="hidden" name="slatAction" value="frontend:cart.addItem" />
		<cfset local.fulfillmentMethodSkus = {} />
		<!--- Product Options --->
		<cfif arrayLen($.slatwall.product().getSkus(true)) eq 1>
			<input type="hidden" name="skuID" value="#$.slatwall.Product().getSkus()[1].getSkuID()#" />
		<cfelse>
			<dl>
				<dt>Select Option</dt>
				<dd>
					<select name="skuID">
						<cfset local.skus = $.slatwall.product().getSkus(sorted=true, fetchOptions=true) />
						<cfloop array="#local.skus#" index="local.sku">
							<option value="#local.sku.getSkuID()#">#local.sku.displayOptions()#</option>
							<cfloop list="#local.sku.setting('skuEligibleFulfillmentMethods')#" index="local.fulfillmentMethodID">
								<cfif structKeyExists(fulfillmentMethodSkus,local.fulfillmentMethodID)>
									<cfset fulfillmentMethodSkus[local.fulfillmentMethodID] = listAppend(fulfillmentMethodSkus[local.fulfillmentMethodID],local.sku.getSkuID()) />
								<cfelse>
									<cfset fulfillmentMethodSkus[local.fulfillmentMethodID] = local.sku.getSkuID() />
								</cfif>
							</cfloop>
						</cfloop>
					</select>
				</dd>
			</dl>
		</cfif>
		<!--- END: Product Options --->
		
		<!--- START: Sku Price --->
		<cfif !isNull($.slatwall.product('defaultSku').getUserDefinedPriceFlag()) AND $.slatwall.product('defaultSku').getUserDefinedPriceFlag()>
			<input type="text" name="price" value="" />
		</cfif>
		
		<!--- Fulfillment Options --->
		<cfif listLen(structKeyList(local.fulfillmentMethodSkus)) GT 1>
			<cfset local.fulfillmentMethodSmartList = $.slatwall.getService("fulfillmentService").getFulfillmentMethodSmartList() />
			<cfset local.fulfillmentMethodSmartList.addInFilter('fulfillmentMethodID', structKeyList(local.fulfillmentMethodSkus)) />
			<cfset local.fulfillmentMethodSmartList.addOrder('sortOrder|ASC') />
			<cfset local.fulfillmentMethods = local.fulfillmentMethodSmartList.getRecords() />
			<dl>
				<dt>Select Fulfillment Option</dt>
				<dd>
					<select name="fulfillmentMethodID">
						<cfloop array="#local.fulfillmentMethods#" index="local.fulfillmentMethod">
							<option value="#local.fulfillmentMethod.getFulfillmentMethodID()#" skuIDs="#local.fulfillmentMethodSkus[local.fulfillmentMethod.getFulfillmentMethodID()]#">#local.fulfillmentMethod.getFulfillmentMethodName()#</option>
						</cfloop>
					</select>
				</dd>
			</dl>
		</cfif>	
		
		<!--- END: Fulfillment Options --->
		
		<!--- Product Customizations --->
		<cfset customAttributeSetTypeArray = ['astProductCustomization','astOrderItem'] />
		<cfloop array="#$.slatwall.product().getAttributeSets(customAttributeSetTypeArray)#" index="local.customizationAttributeSet">
			<div class="productCustomizationSet #lcase(replace(local.customizationAttributeSet.getAttributeSetName(), ' ', '', 'all'))#">
				<h4>#local.customizationAttributeSet.getAttributeSetName()#</h4>
				<dl>
					<cf_SlatwallAttributeSetDisplay attributeSet="#local.customizationAttributeSet#" entity="#$.slatwall.product()#" edit="true" />
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
				<dt class="title">#review.getReviewTitle()#</dt>
				<dt class="name">#review.getReviewerName()#</dt>
				<dd class="rating">#review.getRating()#</dd>
				<dd class="review">#review.getReview()#</dd>
			</dl>
		</cfloop>
		<form action="?nocache=1" method="post">
			<input type="hidden" name="slatAction" value="frontend:product.addReview" />
			<input type="hidden" name="product.productID" value="#$.slatwall.product('productID')#" />
			<dl>
				<dt>Name</dt>
				<dd><input type="text" name="reviewerName" value="#$.slatwall.account('fullname')#" /></dd>
				<dt>Rating</dt>
				<dd>
					<select name="rating">
						<option value="5" selected="selected">5</option>
						<option value="4">4</option>
						<option value="3">3</option>
						<option value="2">2</option>
						<option value="1">1</option>
					</select>
				</dd>
				<dt>Title</dt>
				<dd><input type="text" name="reviewTitle" value="" /></dd>
				<dt>Review</dt>
				<dd><textarea name="review"></textarea></dd>
			</dl>
			<button type="submit">Add Review</button>
		</form>
	</div>
</div>
--->