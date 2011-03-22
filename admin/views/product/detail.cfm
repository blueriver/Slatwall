<cfparam name="rc.edit" default="false" />
<cfparam name="rc.product" type="any" />
<cfparam name="rc.productTypes" default="#rc.Product.getProductTypeTree()#" />

<!--- set up options for setting select boxes --->
<cfset local.Options = [{id="1",name=rc.$.Slatwall.rbKey('sitemanager.yes')},{id="0",name=rc.$.Slatwall.rbKey('sitemanager.no')}] />
<cfset local.defaultOption = {id="",name=rc.$.Slatwall.rbKey('setting.inherit')} />

<ul id="navTask">
	<cf_ActionCaller action="admin:product.list" type="list">
	<cfif !rc.edit>
	<cf_ActionCaller action="admin:product.edit" queryString="productID=#rc.product.getProductID()#" type="list">
	</cfif>
</ul>

<cfoutput>
<div class="svoadminproductdetail">
	#rc.product.getImage("s")#
	<cfif rc.edit>
	<form name="ProductEdit" action="#buildURL(action='admin:product.save')#" method="post">
		<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
	</cfif>
	<dl class="twoColumn">
		<cf_PropertyDisplay object="#rc.Product#" property="active" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productName" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="productCode" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="brand" edit="#rc.edit#">
		<dt>
            <cfif rc.edit>
            <label for="productType_productTypeID">Product Type:</label>
			<cfelse>
			    Product Type:
			</cfif>
		</dt>
        <dd>
            <cfif rc.edit and structKeyExists(rc,"productTypes")>
		        <select name="productType_productTypeID" id="productType_productTypeID">
		            <option value="">#rc.$.Slatwall.rbKey("admin.product.selectproducttype")#</option>
		        <cfloop query="rc.productTypes">
		            <cfif rc.productTypes.childCount eq 0> <!--- only want to show leaf nodes of the product type tree --->
		            <cfset local.label = listChangeDelims(rc.productTypes.path, " &raquo; ") />
		            <option value="#rc.productTypes.productTypeID#"<cfif !isNull(rc.product.getProductType()) AND rc.product.getProductType().getProductTypeID() EQ rc.productTypes.productTypeID> selected="selected"</cfif>>
		                #local.label#
		            </option>
		            </cfif>
		        </cfloop>
		        </select>
			<cfelse>
			    <cfif isNull(rc.Product.getProductType())>
				None
				<cfelse>
				  #rc.Product.getProductType().getProductTypeName()#
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
		<cfif rc.edit>
			<input type="button" class="button" id="addSKU" value="Add SKU" />
			<input type="button" class="button" id="addOption" value="Add Option" />
		</cfif>
			<table id="skuTable" class="stripe">
				<thead>
					<tr>
						<th>Default</th>
						<cfset local.optionGroups = rc.Product.getOptionGroupsStruct() />
						<cfloop collection="#local.optionGroups#" item="local.i">
							<th>#local.optionGroups[local.i].getOptionGroupName()#</th>
						</cfloop>
						<th class="varWidth">Image Path</th>
						<th>Original Price</th>
						<th>List Price</th>
						<th>QOH</th>
						<th>QEXP</th>
						<th>QC</th>
						<th>QIA</th>
						<th>QEA</th>
						<th class="administration">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
				<cfloop array="#rc.Product.getSkus()#" index="local.sku">
					<tr>
						<cfif rc.edit>
							<td><input type="radio" name="defaultSku" value="#local.sku.getSkuID()#"<cfif local.sku.getIsDefault()> checked="checked"</cfif> /></td>
						<cfelse>
							<td><cfif local.sku.getIsDefault()>Yes</cfif></td>
						</cfif>
						<cfloop collection="#local.optionGroups#" item="local.i">
							<td>#local.sku.getOptionByOptionGroupID(local.optionGroups[local.i].getOptionGroupID()).getOptionName()#</td>
						</cfloop>
						<td class="varWidth">#local.sku.getImagePath()#</td>
						<td>#DollarFormat(local.sku.getPrice())#</td>
						<td>#DollarFormat(local.sku.getListPrice())#</td>
						<td>#local.sku.getQOH()#</td>
						<td>#local.sku.getQEXP()#</td>
						<td>#local.sku.getQC()#</td>
						<td>#local.sku.getQIA()#</td>
						<td>#local.sku.getQEA()#</td>
						<td class="administration">
							<ul class="one">
								<li class="edit"><a href="##">Edit</a></li>
							</ul>
						</td>
					</tr>
				</cfloop>
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
		<table class="stripe" id="productTypeSettings">
			<tr>
				<th class="varWidth">#rc.$.Slatwall.rbKey('admin.product.productsettings')#</th>
				<th></th>
			</tr>
			<cf_PropertyDisplay object="#rc.Product#" property="trackInventory" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="showOnWeb" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="showOnWebWholesale" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="callToOrder" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="allowShipping" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="allowPreorder" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="allowBackorder" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="allowDropShip" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="manufactureDiscontinued" edit="#rc.edit#" displayType="table" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')#" editOptions="#local.Options#" defaultOption="#local.defaultOption#" tooltip="true">
		</table>
	</div>
	<div id="tabProductPages">
		<cfif rc.edit>
			<cfif rc.productPages.getRecordCount() gt 0>
				<input type="hidden" name="contentID" value="" />
				<ul>
					<cfloop condition="rc.productPages.hasNext()">
						<li>
							<cfset local.thisProductPage = rc.productPages.next() />
							<input type="checkbox" id="productPage#local.thisProductPage.getContentID()#" name="contentID" value="#local.thisProductPage.getContentID()#"<cfif listFind(rc.product.getContentIDs(),local.thisProductPage.getContentID())> checked="checked"</cfif> /> 
							<label for="productPage#local.thisProductPage.getContentID()#">#local.thisProductPage.getTitle()#</label>
						</li>	
					</cfloop>
				</ul>
			<cfelse>
				<p><em>#rc.$.Slatwall.rbKey("admin.product.noproductpagesdefined")#</em></p>
			</cfif>
		<cfelse>
			<!---#rc.product.getProductContent()[1].getContentID()#--->
		</cfif>
	</div>
	<div id="tabCustomAttributes">
	
	</div>
	<div id="tabAlternateImages">
	
	</div>
</div>
<cfif rc.edit>
<div id="actionButtons" class="clearfix">
	<cf_actionCaller action="admin:product.detail" querystring="productID=#rc.product.getProductID()#" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
	<cf_ActionCaller action="admin:product.delete" querystring="productID=#rc.product.getproductID()#" type="link" class="button" confirmrequired="true">
	<cf_ActionCaller action="admin:product.save" type="submit">
</div>
</form>
</cfif>
</div>

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