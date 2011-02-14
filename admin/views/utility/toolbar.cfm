<cfoutput>
	<div class="svoutilitytoolbar">
		#view('admin:utility/toolbarsearch')#
		#view('admin:utility/campaignlink', args)#
		<ul class="MainMenu">
			<li class="MenuTop"></li>
			<li><a href="#buildURL(action='admin:main')#">#rc.$w.rbKey("admin:main")#</a></li>
			<li>
				<a href="#buildURL(action='admin:product')#">#rc.$w.rbKey("admin:product")#</a>
				<div class="MenuSubOne">
					<ul>
						<cf_ActionLink action="admin:product.create" listitem="true">
						<li><a href="#buildURL(action='admin:product.create')#">#rc.$w.rbKey("admin:product.create")#</a></li>
						<li><a href="#buildURL(action='admin:product.types')#">#rc.$w.rbKey("admin:product.types")#</a></li>
						<li><a href="#buildURL(action='admin:product.list')#">#rc.$w.rbKey("admin:product.list")#</a></li>
                        <li><a href="#buildURL(action='admin:option.list')#">#rc.$w.rbKey("admin:option.list")#</a></li>
						<li><a href="#buildURL(action='admin:brand.edit')#">#rc.$w.rbKey("admin:brand.edit")#</a></li>
						<li><a href="#buildURL(action='admin:brand.list')#">#rc.$w.rbKey("admin:brand.list")#</a></li>
					</ul>
				</div>
			</li>
			<li>
				<a href="#buildURL(action='admin:account')#">#rc.$w.rbKey("admin:account")#</a>
			</li>
			<li>
				<a href="#buildURL(action='admin:setting')#">#rc.$w.rbKey("admin:setting")#</a>
			</li>
			<li>
				<a href="#buildURL(action='admin:help')#">#rc.$w.rbKey("admin:help")#</a>
				<div class="MenuSubOne">
					<ul>
						<li><a href="#buildURL(action='admin:help.about')#">#rc.$w.rbKey("admin:help.about")#</a></li>
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