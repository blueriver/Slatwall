<cfscript>
	
// Required Values
variables.assetConfig.baseAssetPath = "/plugins/Slatwall/assets/";

// Optional Dependencies
variables.assetDependencies["js/global.js"] = 				["/admin/js/jquery/jquery.js","/admin/js/jquery/jquery-ui.js","/admin/js/jquery/jquery-ui-i18n.js","/admin/js/admin.js"];
variables.assetDependencies["js/admin-product.edit.js"] = 	["js/tools/jquery.colorbox-min.js", "css/tools/colorbox/colorbox.css"];
variables.assetDependencies["js/admin-product.detail.js"] =	["js/tools/imgPreview-min.js"];
</cfscript>