<cfparam name="rc.product" type="any" />
<cfparam name="rc.productTypes" default="#rc.Product.getProductTypeTree()#" />
<cfparam name="rc.optionGroups" type="any" />
<cfparam name="rc.productPages" type="any" />

<cfoutput>
<div id="createProductForm">
 <div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
	<ul>
    <li><a href="##tabBasicProductInfo" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.basicinfo")#</span></a></li>
	<li><a href="##tabOptions" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.productoptions")#</span></a></li>
	<li><a href="##tabProductDetails" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.productdetails")#</span></a></li>
	<li><a href="##tabProductSettings" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.productsettings")#</span></a></li>
	<li><a href="##tabProductPages" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.productpages")#</span></a></li>
	<li><a href="##tabExtendedAttributes" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.attributes")#</span></a></li>
	<li><a href="##tabAltImages" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.altimages")#</span></a></li>
	</ul>
	
<form name="CreateProduct" method="post">	
<div id="tabBasicProductInfo">
 <dl class="oneColumn">
    <cf_PropertyDisplay object="#rc.Product#" first="true" property="productName" edit="true">
    <cf_PropertyDisplay object="#rc.Product#" property="brand" edit="true">
    <cf_PropertyDisplay object="#rc.Product#" property="productCode" edit="true">
    <dt>
        <label for="productType_productTypeID">Product Type</label>
    </dt>
    <dd>
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
    </dd>
	<dl class="twoColumn productPrice">
		<dt><label for="price">Base #rc.$.Slatwall.rbKey('entity.sku.price')#</label></dt>
		<dd><input type="text" name="price" /></dd>
		<dt><label for="listPrice">Base #rc.$.Slatwall.rbKey('entity.sku.listprice')#</label></dt>
		<dd><input type="text" name="listPrice" /></dd>
	</dl>
    <cf_PropertyDisplay object="#rc.Product#" property="ProductDescription" first="true" edit="true" editType="wysiwyg">

</dl>
</div>

	<div id="tabOptions">
		<h4>#rc.$.Slatwall.rbKey("admin.product.selectoptions")#</h4>
		<!---<input type="hidden" name="options" value="" />--->
		<cfif arrayLen(rc.optionGroups) gt 0>
			<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
			<cfset local.options = local.thisOptionGroup.getOptions(sortby="sortOrder") />
			<p><a href="javascript:;" onclick="jQuery('##selectOptions#local.thisOptionGroup.getOptionGroupID()#').slideDown();">#rc.$.Slatwall.rbKey("entity.option.optionGroup")#: #local.thisOptionGroup.getOptionGroupName()#</a></p>
			<div class="optionsSelector" id="selectOptions#local.thisOptionGroup.getOptionGroupID()#" style="display:none;">
				<a href="javascript:;" onclick="jQuery('##selectOptions#local.thisOptionGroup.getOptionGroupID()#').slideUp();">[#rc.$.Slatwall.rbKey("sitemanager.content.fields.close")#]</a>
			<cfif arrayLen(local.options)>
				<cfset local.optionIndex = 1 />	
				<ul>
				<cfloop array="#local.options#" index="local.thisOption">
					<li><input type="checkbox" name="options.#local.thisOptionGroup.getOptionGroupName()#" id="option#local.thisOption.getOptionID()#" value="#local.thisOption.getOptionID()#" /> <label for="option#local.thisOption.getOptionID()#">#local.thisOption.getOptionName()#</label></li>
	            <cfset local.optionIndex++ />
				</cfloop>
				</ul>
			<cfelse>
				<!--- no options in this optiongroup defined --->
				<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsingroup")#</em></p>
				<cf_ActionCaller action="admin:option.create" queryString="optionGroupID=#local.thisOptionGroup.getOptionGroupID()#">
			</cfif>
			</div>
			</cfloop>
		<cfelse>
			 <!--- no options defined --->
			<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsdefined")#</em></p>
			<cf_ActionCaller action="admin:option.createoptiongroup" type="link">
		</cfif>
	</div>
	
	<div id="tabProductDetails">
	<dl class="twoColumn">
		<cf_PropertyDisplay object="#rc.Product#" property="productYear" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="shippingWeight" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="publishedWeight" tooltip="true" edit="true">
	</dl>
	</div>

	<div id="tabProductSettings">
	<dl class="twoColumn">
		<cf_PropertyDisplay object="#rc.Product#" property="active" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="nonInventory" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="showonWeb" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="showonWebWholesale" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="manufactureDiscontinued" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="allowPreorder" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="allowBackorder" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="allowShipping" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="allowDropship" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="nonInventoryItem" tooltip="true" edit="true">
		<cf_PropertyDisplay object="#rc.Product#" property="callToOrder" tooltip="true" edit="true">
	</dl>
	</div>

	<div id="tabProductPages">
	<h4>#rc.$.Slatwall.rbKey("admin.product.selectproductpages")#</h4>
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
	<div id="tabExtendedAttributes">
	
	</div>
	<div id="tabAltImages">
	
	</div>

</div>

<div id="actionButtons" class="clearfix">
<cf_actionCaller action="admin:product.list" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
<cf_ActionCaller action="admin:product.save" type="submit" />
</div>

</form>

</div>
</cfoutput>