<cfscript>
	
// Required Values
variables.assetConfig.baseAssetPath = "/plugins/Slatwall/assets/";

// Optional Dependencies
variables.assetDependencies["js/global.js"] = [
	"/admin/js/jquery/jquery.js"
	];
	
variables.assetDependencies["js/admin.js"] = [
	"/admin/js/jquery/jquery-ui.js",
	"/admin/js/jquery/jquery-ui-i18n.js",
	"/admin/js/admin.js",
	"/tasks/widgets/ckeditor/ckeditor.js",
	"/tasks/widgets/ckeditor/adapters/jquery.js",
	"/tasks/widgets/ckfinder/ckfinder.js"
	];
	
variables.assetDependencies["js/admin-product.detail.js"] =	[
	"js/tools/jquery.colorbox-min.js",
	"css/tools/colorbox/colorbox.css",
	"js/tools/imgPreview-min.js"
	];
</cfscript>