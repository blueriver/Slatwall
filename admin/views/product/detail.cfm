<cfparam name="rc.edit" type="boolean" default="false" />
<cfparam name="rc.product" type="any" />

<cfoutput>
<cfif rc.edit>
<cfset local.productTypes = rc.product.getProductTypeTree() />
<form name="ProductEdit" action="?action=admin:product.save" method="post">
	<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
<cfelse>
	<a href="#buildURL(action='product.edit',queryString='productID=#rc.Product.getProductID()#')#">Edit Product</a>
</cfif>

	<!--- <div class="ItemDetailImage"><img src="http://www.nytro.com/prodimages/#rc.Product.getDefaultImageID()#-DEFAULT-s.jpg"></div> --->
	<div class="ItemDetailMain">
		<cf_PropertyDisplay object="#rc.Product#" property="active" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productName" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productCode" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productYear" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="brand" edit="#rc.edit#">
		<!---<cf_PropertyDisplay object="#rc.Product#" property="productType" edit="#rc.edit#">--->
        <dl>
            <dt>
                <cfif rc.edit>
                <label for="productType_productTypeID">Product Type:</label></dt>
				<cfelse>
				    Product Type:
				</cfif>
            <dd>
                <cfif rc.edit and structKeyExists(rc,"productTypes")>
		            <select name="productType_productTypeID" id="productType_productTypeID">
		                <option value="">None</option>
		            <cfloop query="local.productTypes">
		                <cfset ThisDepth = local.productTypes.TreeDepth />
		                <cfif ThisDepth><cfset bullet="-"><cfelse><cfset bullet=""></cfif>
		                <option value="#local.productTypes.productTypeID#"<cfif !isNull(rc.product.getProductType()) AND rc.product.getProductType().getProductTypeID() EQ local.productTypes.productTypeID> selected="selected"</cfif>>
		                    #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##bullet##local.productTypes.productType#
		                </option>
		            </cfloop>
		            </select>
				<cfelse>
				    <cfif isNull(rc.Product.getProductType())>
					None
					<cfelse>
					  #rc.Product.getProductType().getProductType()#
					 </cfif>
				</cfif>
            </dd>
        </dl>
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
		<cfset local.skus = rc.Product.getSkus() />
		<cfif rc.edit>
			<input type="button" class="button" id="addSKU" value="Add SKU" />
		</cfif>
<!---		<cfif arrayLen(local.skus)>--->
			<table id="skuTable">
				<thead>
				<tr>
					<th>Company SKU</th>
					<th>Original Price</th>
					<th>List Price</th>
					<th>QOH</th>
					<th>QOO</th>
					<th>QC</th>
					<th>QIA</th>
					<th>QEA</th>
					<th>Image Path</th>
					<th>Admin</th>
				</tr>
				</thead>
				<tbody>
			<cfset local.arrayIndex = 1 />
			<cfif not rc.edit>	
				<cfloop array="#local.skus#" index="local.thisItem">
				<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>			
					<td>#local.thisItem.getSkuID#</td>
					<td>#local.thisItem.getOriginalPrice()#</td>
					<td>#local.thisItem.getListPrice()#</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<cfset local.arrayIndex++ />
				</cfloop>
			<cfelse>
				<cfloop array="#local.skus#" index="local.thisItem">
				<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>			
					<td><input type="text" name="SKU#local.arrayIndex#_SKUID" id="SKU#local.arrayIndex#_SKUID" value="#local.thisItem.getSkuID()#" /></td>
					<td><input type="text" name="SKU#local.arrayIndex#_originalPrice" id="SKU#local.arrayIndex#_originalPrice" value="#local.thisItem.getOriginalPrice()#" /></td>
					<td><input type="text" name="SKU#local.arrayIndex#_listPrice" id="SKU#local.arrayIndex#_listPrice" value="#local.thisItem.getListPrice()#" /></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<cfset local.arrayIndex++ />
				</cfloop>
			</cfif>
			</tbody>
			</table>
<!---		<cfelse>
			<p>There are no SKU's for this product.</p>
		</cfif>--->
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
<cfif rc.edit>
<button type="submit">Save</button>
</form>
</cfif>
</cfoutput>
<table id="tableTemplate" class="hideElement">
<tbody>
<tr>
	<td><input type="text" name="" id="" value="" /></td>
	<td><input type="text" name="" id="" value="" /></td>
	<td><input type="text" name="" id="" value="" /></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
</tr>
</tbody>
</table>