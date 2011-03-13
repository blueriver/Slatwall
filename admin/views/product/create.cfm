<cfparam name="rc.product" type="any" />
<cfparam name="rc.productTypes" type="any" default="#rc.Product.getProductTypeTree()#" />
<cfparam name="rc.optionGroups" type="any" />

<cfoutput>
<div id="createProductForm">
	<form name="CreateProduct" method="post">
		<dl class="oneColumn">
		    <cf_PropertyDisplay object="#rc.Product#" first="true" property="productName" edit="true">
		    <cf_PropertyDisplay object="#rc.Product#" property="productCode" edit="true">
		    <cf_PropertyDisplay object="#rc.Product#" property="brand" edit="true">
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
		</dl>
		<br />
		<dl class="twoColumn productPrice">
			<cf_PropertyDisplay object="#rc.Product#" property="productYear" edit="true">
			<cf_PropertyDisplay object="#rc.Product#" property="shippingWeight" edit="true">
			<dt><label for="price">Base #rc.$.Slatwall.rbKey('entity.sku.price')#</label></dt>
			<dd><input type="text" name="price" /></dd>
			<dt><label for="listPrice">Base #rc.$.Slatwall.rbKey('entity.sku.listprice')#</label></dt>
			<dd><input type="text" name="listPrice" /></dd>
		</dl>
		<br />
		<br />
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
				<cf_ActionCaller action="admin:option.createoptiongroup" type="link">
			<cfelse>
				 <!--- no options defined --->
				<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsdefined")#</em></p>
			</cfif>
			<input type="hidden" name="contentID" value="" /> 
		<div id="actionButtons" class="clearfix">
			<cf_actionCaller action="admin:product.list" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_ActionCaller action="admin:product.save" type="submit" />
		</div>
	</form>
</div>
</cfoutput>