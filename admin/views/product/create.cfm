<cfparam name="rc.product" type="any" />
<cfparam name="rc.productTypes" default="#rc.Product.getProductTypeTree()#" />
<cfparam name="rc.optionGroups" type="any" />

<cfoutput>
<div id="basicProductInfo">
<form name="CreateProduct" method="post">
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
	<cf_PropertyDisplay object="#rc.Product#" property="ProductDescription" first="true" edit="true" editType="wysiwyg">
	<dt>
		<label for="productHasOptions">#rc.$.Slatwall.rbKey("admin.product.selecthasoptions")#</label>
	</dt>
	<dd>
		<select name="productHasOptions" id="productHasOptions">
			<option value="no">#rc.$.Slatwall.rbKey("user.no")#</option>
			<option value="yes">#rc.$.Slatwall.rbKey("user.yes")#</option>
		</select>
	</dd>
</dl>
</div>

<div id="productConfiguration">
<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
	<ul>
	<li><a href="##tabOptions" onclick="return false;"><span>#rc.$.Slatwall.rbKey("entity.product.options")#</span></a></li>
	<li><a href="##tabProductDetails" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.productdetails")#</span></a></li>
	<li><a href="##tabProductSettings" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.productsettings")#</span></a></li>
	<li><a href="##tabCategories" onclick="return false;"><span>Categories</span></a></li>
	<li><a href="##tabExtendedAttributes" onclick="return false;"><span>Extended Attributes</span></a></li>
	<li><a href="##tabAltImages" onclick="return false;"><span>Alternate Images</span></a></li>
	</ul>

	<div id="tabOptions">
		<h4>#rc.$.Slatwall.rbKey("admin.product.selectoptions")#</h4>
		<cf_ActionCaller action="admin:option" type="link">
		<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
		<cfset local.options = thisOptionGroup.getOptions(sortby="optionName") />
		<h5>#rc.$.Slatwall.rbKey("entity.option.optionGroup")#: #local.thisOptionGroup.getOptionGroupName()#</h5>
			<ul>
			<cfloop array="#local.options#" index="local.thisOption">
				<li><input type="checkbox" name="options" id="option#local.thisOption.getOptionID()#" value="#local.thisOption.getOptionID()#" /> <label for="option#local.thisOption.getOptionID()#">#local.thisOption.getOptionName()#</label></li>
			</cfloop>
			</ul>
		</cfloop>
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

	<div id="tabCategories">
	   
	</div>
	<div id="tabExtendedAttributes">
	
	</div>
	<div id="tabAltImages">
	
	</div>

</div>
</div>

<div id="createProductButtons">
<cf_actionCaller action="admin:product.list" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
<cf_ActionCaller action="admin:product.save" type="submit" />
</div>
</form>
</cfoutput>