<cfoutput>
	<div class="svoutilitytoolbar">
		#view('admin:utility/toolbarsearch')#
		#view('admin:utility/campaignlink', args)#
		<ul class="MainMenu">
			<li class="MenuTop"></li>
			<li><a href="#buildURL(action='admin:main.dashboard')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.dashboard")#</a></li>
			<li>
				<a href="#buildURL(action='admin:product.list')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.products")#</a>
				<div class="MenuSubOne">
					<ul>
						<li><a href="#buildURL(action='admin:product.edit')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.products.createnewproduct")#</a></li>
						<li><a href="#buildURL(action='admin:product.types')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.products.producttypes")#</a></li>
						<li><a href="#buildURL(action='admin:product.list')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.products.productlisting")#</a></li>
						<li><a href="#buildURL(action='admin:brand.edit')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.products.createnewbrand")#</a></li>
						<li><a href="#buildURL(action='admin:brand.list')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.products.brandlisting")#</a></li>
					</ul>
				</div>
			</li>
			<li>
				<a href="#buildURL(action='admin:account.list')#">#rc.rbFactory.getKeyValue(session.rb,"toolbar.accounts")#</a>
			</li>
			<li>
				<a href="#buildURL(action='admin:setting.detail')#">#rc.$w.rbKey("toolbar.settings")#</a>
			</li>
			<li>
				<a href="##">Help</a>
				<div class="MenuSubOne">
					<ul>
						<li><a href="#buildURL(action='admin:help.about')#">About</a></li>
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