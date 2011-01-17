<cfset local.Product = rc.Product />
<cfparam name="rc.edit" default="false" />

<cfoutput>
<cfif not rc.edit>
	<a href="#buildURL(action='product.edit',queryString='productID=#rc.Product.getProductID()#')#">Edit Product</a>
</cfif>

	<!--- <div class="ItemDetailImage"><img src="http://www.nytro.com/prodimages/#local.Product.getDefaultImageID()#-DEFAULT-s.jpg"></div> --->
	<div class="ItemDetailMain">
		<cf_PropertyDisplay object="#rc.Product#" property="active" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productName" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productCode" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productYear" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="brand" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="filename" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="shippingWeight" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="publishedWeight" edit="#rc.edit#">
	</div>
	
	<div class="ItemDetailBar">
		<cf_PropertyDisplay object="#rc.Product#" property="showonWebRetail" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="showonWebWholesale" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="manufactureDiscontinued" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="allowPreorder" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="allowBackorder" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="allowDropship" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="nonInventoryItem" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="callToOrder" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="allowShipping" edit="#rc.edit#">
	</div>
	
<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
	<ul>
	<li><a href="##tabSkus" onclick="return false;"><span>SKUs</span></a></li>	
	<li><a href="##tabDescription" onclick="return false;"><span>Web Description</span></a></li>
	<li><a href="##tabCategories" onclick="return false;"><span>Categories</span></a></li>
	<li><a href="##tabDiscounts" onclick="return false;"><span>Discounts</span></a></li>
	<li><a href="##tabReviews" onclick="return false;"><span>Reviews</span></a></li>
	<li><a href="##tabExtendedAttributes" onclick="return false;"><span>Extended Attributes</span></a></li>
	<li><a href="##tabAltImages" onclick="return false;"><span>Alternate Images</span></a></li>
	</ul>

	<div id="tabSkus">
	
	</div>
	
	<div id="tabDescription">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductDescription" edit="#rc.edit#" editType="wysiwyg">
	</div>
	<div id="tabCategories">
	
	</div>
	<div id="tabDiscounts">
	
	</div>
	<div id="tabReviews">
	
	</div>
	<div id="tabExtendedAttributes">
	
	</div>
	<div id="tabAltImages">
	
	</div>

</div>
</cfoutput>