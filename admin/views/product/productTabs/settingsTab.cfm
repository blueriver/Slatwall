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