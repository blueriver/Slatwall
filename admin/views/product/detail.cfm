<cfparam name="rc.edit" default="false" />
<cfparam name="rc.product" type="any" />
<cfparam name="rc.productTypes" default="#rc.Product.getProductTypeTree()#" />
<cfparam name="rc.productPages" type="any" />

<cfoutput>
<cfif rc.edit>
<form name="ProductEdit" action="#buildURL(action='admin:product.save')#" method="post">
	<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
<cfelse>
	<a href="#buildURL(action='product.edit',queryString='productID=#rc.Product.getProductID()#')#">Edit Product</a>
</cfif>
	<dl class="twoColumn">
		<cf_PropertyDisplay object="#rc.Product#" property="active" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productName" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productCode" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="brand" edit="#rc.edit#">
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
	            <cfloop query="rc.productTypes">
	                <cfset ThisDepth = rc.productTypes.TreeDepth />
	                <cfif ThisDepth><cfset bullet="-"><cfelse><cfset bullet=""></cfif>
	                <option value="#rc.productTypes.productTypeID#"<cfif !isNull(rc.product.getProductType()) AND rc.product.getProductType().getProductTypeID() EQ rc.productTypes.productTypeID> selected="selected"</cfif>>
	                    #RepeatString("&nbsp;&nbsp;&nbsp;",ThisDepth)##bullet##rc.productTypes.productType#
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
		<cf_PropertyDisplay object="#rc.Product#" property="filename" edit="#rc.edit#">
	</dl>
	
<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
	<ul>
		<li><a href="##tabSkus" onclick="return false;"><span>SKUs</span></a></li>	
		<li><a href="##tabDescription" onclick="return false;"><span>Web Description</span></a></li>
		<li><a href="##tabProductDetails" onclick="return false;"><span>Product Details</span></a></li>
		<li><a href="##tabProductSettings" onclick="return false;"><span>Product Settings</span></a></li>
		<li><a href="##tabProductPages" onclick="return false;"><span>Product Pages</span></a></li>
		<li><a href="##tabCustomAttributes" onclick="return false;"><span>Custom Attributes</span></a></li>
		<li><a href="##tabAlternateImages" onclick="return false;"><span>Alternate Images</span></a></li>
	</ul>

	<div id="tabSkus">
		<cfset local.skus = rc.Product.getSkus() />
		<cfif rc.edit>
			<input type="button" class="button" id="addSKU" value="Add SKU" />
		</cfif>
			<table id="skuTable" class="stripe">
				<thead>
				<tr>
					<th>Company SKU</th>
					<th>Options</th>
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
				<tr>			
					<td>#local.thisItem.getSkuID()#</td>
					<td>#local.thisItem.displayOptions()#</td>
					<td>#local.thisItem.getPrice()#</td>
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
				<tr>			
					<td><input type="text" name="SKU#local.arrayIndex#_SKUID" id="SKU#local.arrayIndex#_SKUID" value="#local.thisItem.getSkuID()#" /></td>
					<td><input type="text" name="SKU#local.arrayIndex#_originalPrice" id="SKU#local.arrayIndex#_Price" value="#local.thisItem.getPrice()#" /></td>
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
	</div>
	
	<div id="tabDescription">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductDescription" edit="#rc.edit#" editType="wysiwyg">
	</div>
	<div id="tabProductDetails">
		<dl class="twoColumn">
			<cf_PropertyDisplay object="#rc.Product#" property="productYear" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="shippingWeight" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="publishedWeight" edit="#rc.edit#">
		</dl>
	</div>
	<div id="tabProductSettings">
		<dl class="twoColumn">
			<cf_PropertyDisplay object="#rc.Product#" property="showonWebRetail" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="showonWebWholesale" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="manufactureDiscontinued" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="allowPreorder" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="allowBackorder" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="allowDropship" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="nonInventoryItem" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="callToOrder" edit="#rc.edit#">
			<cf_PropertyDisplay object="#rc.Product#" property="allowShipping" edit="#rc.edit#">
		</dl>
	</div>
	<div id="tabProductPages">
		<cfif rc.productPages.getRecordCount() gt 0>
			<input type="hidden" name="categoryID" value="" />
			<ul>
				<cfloop condition="rc.productPages.hasNext()">
					<li>
						<cfset local.thisProductPage = rc.productPages.next() />
						<input type="checkbox" id="productPage#local.thisProductPage.getContentID()#" name="contentID" value="#local.thisProductPage.getContentID()#" /> 
						<label for="productPage#local.thisProductPage.getContentID()#">#local.thisProductPage.getTitle()#</label>
					</li>	
				</cfloop>
			</ul>
		<cfelse>
			<p><em>#rc.$.Slatwall.rbKey("admin.product.noproductpagesdefined")#</em></p>
		</cfif>
	</div>
	<div id="tabCustomAttributes">
	
	</div>
	<div id="tabAlternateImages">
	
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