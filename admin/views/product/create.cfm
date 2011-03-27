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
<cfparam name="rc.product" type="any" />
<cfparam name="rc.productTypes" type="any" default="#rc.Product.getProductTypeTree()#" />
<cfparam name="rc.optionGroups" type="any" />

<ul id="navTask">
	<cf_ActionCaller action="admin:product.list" type="list">
</ul>

<cfoutput>
<div id="createProductForm">
	<form name="CreateProduct" method="post">
		<dl class="oneColumn">
		    <cf_PropertyDisplay object="#rc.Product#" first="true" property="productName" edit="true">
		    <cf_PropertyDisplay object="#rc.Product#" property="productCode" edit="true">
		    <cf_PropertyDisplay object="#rc.Product#" property="brand" edit="true">
			     <cf_ActionCaller action="admin:brand.create" type="link">
		    <dt>
		        <label for="productType_productTypeID">#rc.$.Slatwall.rbKey("entity.product.producttype")# *</label>
		    </dt>
		    <dd>
		    	<cfif rc.productTypes.recordCount gt 0>
			        <select name="productType" id="productType_productTypeID">
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
				 <!--- no product types defined --->
				<em>#rc.$.Slatwall.rbKey("admin.product.noproducttypesdefined")#</em>
				<input type="hidden" name="productType_productTypeID" value="" />
				</cfif>
				<cfif Len(rc.product.getErrorBean().getError("productType"))>
                    <span class="formError">#rc.product.getErrorBean().getError("productType")#</span>
                </cfif>
		    </dd>
		      <cf_ActionCaller action="admin:product.createproducttype" type="link">
		</dl>
		<br />
		<dl class="twoColumn productPrice">
			<cf_PropertyDisplay object="#rc.Product#" property="productYear" edit="true" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="shippingWeight" edit="true" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="price" edit="true" tooltip="true">
			<cf_PropertyDisplay object="#rc.Product#" property="listPrice" edit="true" tooltip="true">
		</dl>
		<br />
		<br />
	    <h4>#rc.$.Slatwall.rbKey("admin.product.selectoptions")#</h4>
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

