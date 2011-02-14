<cfoutput>
	<div class="svoutilitytoolbar">
		#view('admin:utility/toolbarsearch')#
		#view('admin:utility/campaignlink', args)#
		<ul class="MainMenu">
			<li class="MenuTop"></li>
			<cf_ActionLink action="admin:main" listitem="true">
			<li>
				<cf_ActionLink action="admin:product">
				<div class="MenuSubOne">
					<ul>
						<cf_ActionLink action="admin:product.create" listitem="true">
						<cf_ActionLink action="admin:product.types" listitem="true">
						<cf_ActionLink action="admin:product.list" listitem="true">
						<cf_ActionLink action="admin:option.list" listitem="true">
						<cf_ActionLink action="admin:brand.edit" listitem="true">
						<cf_ActionLink action="admin:brand.list" listitem="true">
					</ul>
				</div>
			</li>
			<cf_ActionLink action="admin:account" listitem="true">
			<cf_ActionLink action="admin:setting" listitem="true">
			<li>
				<cf_ActionLink action="admin:help">
				<div class="MenuSubOne">
					<ul>
						<cf_ActionLink action="admin:help.about" listitem="true">
					</ul>
				</div>
			</li>
			<li class="MenuBottom"></li>
		</ul>
		<ul class="MainToolbar">
			<li class="LogoSearch">
				<img src="/plugins/#getPluginConfig().getDirectory()#/images/toolbar/toolbar_logo.png" />
				<form name="ToolbarSearch" method="post" onKeyup="toolbarSearchKeyup(this);" onSubmit="return slatwallAjaxFormSubmit(this);">
					<input type="hidden" name="action" value="admin:utility.toolbarsearch" />
					<input type="text" name="ToolbarKeyword" class="AdminSearch" />
				</form>
			</li>
			<li><a href="http://#cgi.http_host#/">Website</a></li>
			<cfif isDefined('request.contentBean')>
				<li><a href="javascript:;" onClick="doSlatAction('utility.campaignlink',{'Show': 1, 'LandingPageContentID': '#request.contentBean.getContentID()#', 'QueryString': '#cgi.query_string#'})">Campaign Link</a></li>
			</cfif>
			<cfif isDefined('request.muraScope.slatwall.Product')>
				<li><a href="#buildURL(action='admin:product.detail', querystring='ProductID=#request.muraScope.slatwall.Product.getProductID()#')#">Product Detail</a></li>
			</cfif>
		</ul>
	</div>
</cfoutput>