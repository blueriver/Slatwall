<cfoutput>
	<div class="svoutilitytoolbar">
		#view('admin:utility/toolbarsearch')#
		#view('admin:utility/campaignlink', args)#
		<ul class="MainMenu">
			<li class="MenuTop"></li>
			<cfif secureDisplay("admin:main")>
				<cf_ActionCaller action="admin:main" type="list">
				<li>
					<cf_ActionCaller action="admin:product">
					<div class="MenuSubOne">
						<ul>
							<cf_ActionCaller action="admin:product" type="list">
							<cf_ActionCaller action="admin:product.listproducttypes" type="list">
							<cf_ActionCaller action="admin:option" type="list">
							<cf_ActionCaller action="admin:brand" type="list">
						</ul>
					</div>
				</li>
			</cfif>
			<cfif secureDisplay("admin:account")>
				<li>
					<cf_ActionCaller action="admin:account">
					<div class="MenuSubOne">
						<ul>
							<cf_ActionCaller action="admin:account.list" type="list">
						</ul>
					</div>
				</li>
			</cfif>
			<cfif secureDisplay("admin:setting")>
				<li>
					<cf_ActionCaller action="admin:setting">
					<div class="MenuSubOne">
						<ul>
							<cf_ActionCaller action="admin:setting.detail" type="list">
							<cf_ActionCaller action="admin:setting.editpermissions" type="list">
						</ul>
					</div>
				</li>
			</cfif>
			<cfif secureDisplay("admin:help")>
				<li>
					<cf_ActionCaller action="admin:help">
					<div class="MenuSubOne">
						<ul>
							<cf_ActionCaller action="admin:help.about" type="list">
						</ul>
					</div>
				</li>
			</cfif>
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
			<cfset local.currentProductID = rc.$.Slatwall.getCurrentProduct().getProductID() />
			<cfif len(local.currentProductID)>
				<li><a href="#buildURL(action='admin:product.detail', querystring='ProductID=#local.currentProductID#')#">Product Detail</a></li>
			</cfif>
		</ul>
	</div>
</cfoutput>