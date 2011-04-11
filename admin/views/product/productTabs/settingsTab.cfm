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

<!--- set up options for setting select boxes --->
<cfset local.Options = [{id="1",name=rc.$.Slatwall.rbKey('sitemanager.yes')},{id="0",name=rc.$.Slatwall.rbKey('sitemanager.no')}] />
<cfoutput>
	<table class="stripe" id="productTypeSettings">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey('admin.product.productsettings')#</th>
			<th>#rc.$.Slatwall.rbKey('admin.product.productSettingSource')#</th>
			<th></th>
		</tr>
		<!--- First two settings can only be set in the product and can't inherit --->
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.publishedFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.publishedFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("publishedFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="publishedFlag" edit="#rc.edit#" displayType="plain" editType="select" editOptions="#local.Options#" allowNullOption="false"></td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.manufactureDiscontinuedFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.manufactureDiscontinuedFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("manufactureDiscontinuedFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="manufactureDiscontinuedFlag" edit="#rc.edit#" displayType="plain" editType="select" editOptions="#local.Options#" allowNullOption="false"></td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.trackInventoryFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.trackInventoryFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("trackInventoryFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="trackInventoryFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('trackInventoryFlag'))#)" editOptions="#local.Options#"></td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.callToOrderFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.callToOrderFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("callToOrderFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="callToOrderFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('callToOrderFlag'))#)" editOptions="#local.Options#"></td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.allowShippingFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.allowShippingFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("allowShippingFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="allowShippingFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowShippingFlag'))#)" editOptions="#local.Options#"></td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.allowPreorderFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.allowPreorderFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("allowPreorderFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="allowPreorderFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowPreorderFlag'))#)" editOptions="#local.Options#"></td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.allowBackorderFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.allowBackorderFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("allowBackorderFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="allowBackorderFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowBackOrderFlag'))#)" editOptions="#local.Options#"></td>
		</tr>
		<tr>
			<td class="property varWidth">
				<a href="##" class="tooltip">
					#rc.$.Slatwall.rbKey("entity.product.allowDropShipFlag")#
					<span>#rc.$.Slatwall.rbKey("entity.Product.allowDropshipFlag_hint")#</span>
				</a>
			</td>
			<td>#rc.Product.getSettingSource("allowDropShipFlag")#</td>
			<td><cf_PropertyDisplay object="#rc.Product#" property="allowDropShipFlag" edit="#rc.edit#" displayType="plain" editType="select" nullValue="#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('allowDropshipFlag'))#)" editOptions="#local.Options#"></td>
		</tr>	
	</table>
</cfoutput>