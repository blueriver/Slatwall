<cfscript>
	
// Required Values
variables.assetConfig.baseAssetPath = "/plugins/Slatwall/assets/";

// Optional Dependencies
variables.assetDependencies["js/admin.js"] = [
	"/admin/js/jquery/jquery.js",
	"/admin/js/jquery/jquery-ui.js",
	"/admin/js/jquery/jquery-ui-i18n.js",
	"/admin/js/admin.js",
	"/tasks/widgets/ckeditor/ckeditor.js",
	"/tasks/widgets/ckeditor/adapters/jquery.js",
	"/tasks/widgets/ckfinder/ckfinder.js",
	"/admin/css/admin.css",
	"/admin/css/jquery/default/jquery.ui.all.css"
	];
	
variables.assetDependencies["js/admin-product.detail.js"] =	[
	"js/tools/jquery.colorbox-min.js",
	"css/tools/colorbox/colorbox.css",
	"js/tools/imgPreview-min.js"
	];
	
/*
variables.assetDependencies["js/common-toolbar.menu.js"] =	[
	"js/tools/jquery.hotkeys-0.7.9.min.js"
	];
*/
</cfscript>