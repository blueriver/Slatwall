<cfscript>
	
// Required Values
variables.assetConfig.baseAssetPath = "#application.configBean.getContext()#/plugins/Slatwall/assets/";

// Optional Dependencies
variables.assetDependencies["js/admin.js"] = [
	"#application.configBean.getContext()#/admin/js/jquery/jquery.js",
	"#application.configBean.getContext()#/admin/js/jquery/jquery-ui.js",
	"#application.configBean.getContext()#/admin/js/jquery/jquery-ui-i18n.js",
	"#application.configBean.getContext()#/admin/js/admin.js",
	"#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js",
	"#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js",
	"#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js",
	"#application.configBean.getContext()#/admin/css/admin.css",
	"#application.configBean.getContext()#/admin/css/jquery/default/jquery.ui.all.css"
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