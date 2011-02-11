<cfoutput>
	<div class="svoadminsettingdetail">
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>
				<li><a href="##tabProduct" onclick="return false;"><span>Product</span></a></li>	
				<li><a href="##tabOrder" onclick="return false;"><span>Order</span></a></li>
				<li><a href="##tabAccount" onclick="return false;"><span>Account</span></a></li>
			</ul>
			<div id="tabProduct">
				<cf_PropertyDisplay object="#rc.settingService.getBySettingName('product.trackInventory')#" title="Track Inventory" property="settingValue" fieldName="product.trackInventory" edit="#rc.edit#" editType="checkbox">
			</div>
			<div id="tabOrder">
				
			</div>
			<div id="tabAccount">
				
			</div>
		</div>
	</div>
</cfoutput>