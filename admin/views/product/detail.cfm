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
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.product" type="any" />

<!---
<cfif rc.edit>
	<cfset getAssetWire().includeAsset("js/admin-product.edit.js") />
	<cfset getAssetWire().includeAsset("css/admin-product.edit.css") />
</cfif>
--->

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:product.list" type="list">
	<cfif !rc.edit>
	<cf_SlatwallActionCaller action="admin:product.edit" queryString="productID=#rc.product.getProductID()#" type="list">
	</cfif>
</ul>

<cfoutput>
<div class="svoadminproductdetail">
	#rc.product.getImage(width="100", height="100")#
	
	<cfif rc.edit>
	<form name="ProductEdit" enctype="multipart/form-data" method="post">
		<input type="hidden" name="slatAction" value="admin:product.save" />
		<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
	</cfif>
	<dl class="twoColumn">
		<cf_SlatwallPropertyDisplay object="#rc.Product#" property="publishedFlag" edit="#rc.edit#">
		<cf_SlatwallPropertyDisplay object="#rc.Product#" property="productName" edit="#rc.edit#">
		<cf_SlatwallPropertyDisplay object="#rc.Product#" property="productCode" edit="#rc.edit#">
		<cfif rc.edit>
			<cf_SlatwallPropertyDisplay object="#rc.Product#" property="brand" edit="true">
		<cfelse>
			<cf_SlatwallPropertyDisplay object="#rc.Product#" property="brand" edit="false" valueLink="#buildURL(action='admin:brand.detail', queryString='brandID=#rc.product.getBrand().getBrandID()#')#">
		</cfif>
		<cfif rc.edit>
			<cf_SlatwallPropertyDisplay object="#rc.Product#" property="productType" edit="true">
		<cfelse>
			<cf_SlatwallPropertyDisplay object="#rc.Product#" property="productType" edit="false" valueLink="#buildURL(action='admin:product.detailProductType', queryString='productTypeID=#rc.product.getProductType().getProductTypeID()#')#">
		</cfif>
		<cf_SlatwallPropertyDisplay object="#rc.Product#" property="urlTitle" edit="#rc.edit#">
		<cfif $.slatwall.setting('advanced_showRemoteIDFields')>
			<cf_SlatwallPropertyDisplay object="#rc.Product#" property="remoteID" edit="#rc.edit#">	
		</cfif>
	</dl>

<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all clear">
	<ul>
		<li><a href="##tabSkus" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.skus")#</span></a></li>	
		<li><a href="##tabDescription" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.webdescription")#</span></a></li>
		<li><a href="##tabProductSettings" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.productsettings")#</span></a></li>
		<li><a href="##tabProductPages" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.productpages")#</span></a></li>
		<li><a href="##tabProductCategories" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.productCategoryAssignment")#</span></a></li>
		<li><a href="##tabAlternateImages" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.alternateimages")#</span></a></li>
		<li><a href="##tabProductReviews" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.productreviews")#</span></a></li>
		<cfloop array="#rc.attributeSets#" index="local.attributeSet">
			<li><a href="##tabCustomAttributes_#local.attributeSet.getAttributeSetID()#" onclick="return false;"><span>#local.attributeSet.getAttributeSetName()#</span></a></li>
		</cfloop>
	</ul>

	<div id="tabSkus">
		#view("product/producttabs/skus")#
	</div>
	<div id="tabDescription">
		<cf_SlatwallPropertyDisplay object="#rc.Product#" property="productDescription" edit="#rc.edit#" fieldType="wysiwyg">
	</div>
	<div id="tabProductSettings">
		#view("product/producttabs/settings")#
	</div>
	<div id="tabProductPages">
		#view("product/producttabs/productpages")#
	</div>
	<div id="tabProductCategories">
		#view("product/producttabs/productcategories")#
	</div>
	<div id="tabAlternateImages">
		#view("product/producttabs/alternateimages")#
	</div>
	<div id="tabProductReviews">
		#view("product/producttabs/productreviews")#
	</div>
	#view("product/producttabs/customattributes")#
</div>
<cfif rc.edit>
	<div id="actionButtons" class="clearfix">
		<cf_SlatwallActionCaller action="admin:product.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
		<cf_SlatwallActionCaller action="admin:product.delete" querystring="productID=#rc.product.getproductID()#" disabled="#rc.product.isNotDeletable()#" type="link" class="button" confirmrequired="true">
		<cf_SlatwallActionCaller action="admin:product.save" type="submit" class="button">
	</div>
	</form>
	
	<cfinclude template="dialogs/pricegrouprateskuupdate.cfm">
	<cfinclude template="dialogs/priceautofill.cfm">
	<cfinclude template="dialogs/weightautofill.cfm">
</cfif>
</div>

</cfoutput>
