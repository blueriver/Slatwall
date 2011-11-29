<cfscript>
	
// Required Values
variables.assetConfig.baseAssetPath = "#application.configBean.getContext()#/plugins/Slatwall/assets/";

// Optional Dependencies
variables.assetDependencies["js/admin.js"] = [
	"#application.configBean.getContext()#/admin/js/jquery/jquery.js",
	"#application.configBean.getContext()#/admin/js/jquery/jquery-ui.js",
	"js/tools/datepicker/datepicker_localization.js",
	"#application.configBean.getContext()#/admin/js/admin.js",
	"#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js",
	"#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js",
	"#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js",
	"#application.configBean.getContext()#/plugins/Slatwall/org/ValidateThis/client/jQuery/JS/jquery.validate.min.js",
	"#application.configBean.getContext()#/plugins/Slatwall/org/ValidateThis/client/jQuery/JS/jquery.field.min.js",
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

variables.assetDependencies["js/admin-pricegroup.detail.js"] =	[

	];

variables.assetDependencies["js/admin-promotion.detail.js"] =	[
	"js/tools/timepicker/jquery-ui-timepicker-addon.js",
	"js/tools/chosen/chosen.jquery.min.js",
	"js/tools/jquery.cookie.js",
	"css/tools/dynatree/skin-vista/ui.dynatree.css",
	"js/tools/dynatree/jquery.dynatree.min.js",
	"css/tools/timepicker/jquery-ui-timepicker-addon.css",
	"css/tools/chosen/chosen.css"
	];
	
variables.assetDependencies["js/admin-report.js"] =	[
	"js/tools/highcharts/highstock.js",
	"js/tools/highcharts/highstock-exporting.js"
	];
	
</cfscript>