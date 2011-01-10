<cfset local.Product = rc.Product />

<cfoutput>
	<!--- <div class="ItemDetailImage"><img src="http://www.nytro.com/prodimages/#local.Product.getDefaultImageID()#-DEFAULT-s.jpg"></div> --->
	<div class="ItemDetailMain">
		<cf_PropertyDisplay object="#rc.Product#" property="Active">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductName">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductCode">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductYear">
		<cf_PropertyDisplay object="#rc.Product#" property="ShippingWeight">
		<cf_PropertyDisplay object="#rc.Product#" property="PublishedWeight">
	</div>
	
	<div class="ItemDetailBar">
		<cf_PropertyDisplay object="#rc.Product#" property="AllowPreorder">
		<cf_PropertyDisplay object="#rc.Product#" property="AllowDropship">
		<cf_PropertyDisplay object="#rc.Product#" property="NonInventoryItem">
		<cf_PropertyDisplay object="#rc.Product#" property="CallToOrder">
		<cf_PropertyDisplay object="#rc.Product#" property="AllowShipping">
	</div>
	
<div class="tabs initActiveTab">
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