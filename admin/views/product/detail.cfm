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

<cfif rc.edit>
	<cfhtmlhead text='<link media="screen" rel="stylesheet" href="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/css/colorbox.css"/>' />
	<cfhtmlhead text='<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/jquery.colorbox-min.js"></script>' />
	<cfhtmlhead text='<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/skuForm.js"></script>' />
</cfif>

<cfhtmlhead text='<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/imgpreview.min.js"></script>' />
<cfhtmlhead text='<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/imgHover.js"></script>' />

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
		<cf_PropertyDisplay object="#rc.Product#" property="brand" edit="#rc.edit#" nullValue="#rc.$.Slatwall.rbKey('admin.none')#">
		<cf_PropertyDisplay object="#rc.Product#" property="productType" edit="#rc.edit#">
		<cf_PropertyDisplay object="#rc.Product#" property="filename" edit="#rc.edit#">
	</dl>
	
<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
	<ul>
		<li><a href="##tabSkus" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.skus")#</span></a></li>	
		<li><a href="##tabDescription" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.webdescription")#</span></a></li>
		<li><a href="##tabProductDetails" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.productdetails")#</span></a></li>
		<li><a href="##tabProductSettings" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.productsettings")#</span></a></li>
		<li><a href="##tabProductPages" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.productpages")#</span></a></li>
		<li><a href="##tabCustomAttributes" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.customattributes")#</span></a></li>
		<li><a href="##tabAlternateImages" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.product.detail.tab.alternateimages")#</span></a></li>
	</ul>

	<div id="tabSkus">
		#view("product/productTabs/skuTab")#
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
		#view("product/productTabs/settingsTab")#
	</div>
	<div id="tabProductPages">
		#view("product/productTabs/productPagesTab")#
	</div>
	<div id="tabCustomAttributes">
	
	</div>
	<div id="tabAlternateImages">
	
	</div>
</div>
<cfif rc.edit>
<div id="actionButtons" class="clearfix">
	<cf_ActionCaller action="admin:product.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
	<cf_ActionCaller action="admin:product.delete" querystring="productID=#rc.product.getproductID()#" type="link" class="button" confirmrequired="true">
	<cf_ActionCaller action="admin:product.save" type="submit">
</div>
</form>
</cfif>
</div>

</cfoutput>