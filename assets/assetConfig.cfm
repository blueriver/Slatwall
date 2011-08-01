<cfscript>
	
// Required Values
variables.assetConfig.baseAssetPath = "#application.configBean.getContext()#/plugins/Slatwall/assets/";

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
	"js/tools/imgPreview-min.js",
	"js/tools/jquery.colorbox-min.js",
	"css/tools/colorbox/colorbox.css"
	];

variables.assetDependencies["js/admin-order.detail.js"] =	[
	"js/tools/jquery.colorbox-min.js",
	"css/tools/colorbox/colorbox.css"
	];

variables.assetDependencies["js/admin-promotion.detail.js"] =	[
	"js/tools/timepicker/jquery-ui-timepicker-addon.js",
	"css/tools/timepicker/jquery-ui-timepicker-addon.css"
	];
	
</cfscript>