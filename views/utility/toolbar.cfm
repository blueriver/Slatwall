<cfoutput>
	<div class="svoutilitytoolbar">
		#view('utility/toolbarsearch', args)#
		#view('utility/campaignlink', args)#
		<ul class="MainMenu">
			<li class="MenuTop"></li>
			<li><a href="#buildURL(action='main.default')#">Dashboard</a></li>
			<cfif SecureDisplay('product')>
				<li>
					<a href="#buildSecureURL(action='product.list')#">Products</a>
					<div class="MenuSubOne">
						<ul>
							<li><a href="#buildSecureURL(action='product.edit')#">Create New Product</a></li>
							<li><a href="#buildSecureURL(action='product.list')#">Product Listing</a></li>
							<li><a href="#buildSecureURL(action='brand.edit')#">Create New Brand</a></li>
							<li><a href="#buildSecureURL(action='brand.list')#">Brand Listing</a></li>
						</ul>
					</div>
				</li>
			</cfif>
			<!---
			<cfif SecureDisplay('order')>
				<li>
					<a href="#buildSecureURL(action='order.list', queryString='F_IsOpen=1')#">Orders</a>
					<div class="MenuSubOne">
						<ul>
							<li><a href="#buildSecureURL(action='order.list', queryString='F_IsOpen=1')#">Open Orders</a></li>
							<li><a href="#buildSecureURL(action='order.list')#">All Orders</a></li>
							<li><a href="#buildSecureURL(action='order.create')#">Create New Order</a></li>
						</ul>
					</div>
				</li>
			</cfif>
			
			<cfif SecureDisplay('customer')>
				<li>
					<a href="#buildSecureURL(action='customer.list')#">Customers</a>
					<div class="MenuSubOne">
						<ul>
							<li><a href="#buildSecureURL(action='customer.list')#">Customer Finder</a></li>
							<li><a href="#buildSecureURL(action='customer.create')#">Create New Customer</a></li>
						</ul>
					</div>
				</li>
			</cfif>
			
			<cfif SecureDisplay('po')>
				<li><a href="#buildSecureURL(action='po.list')#">Purchase Orders</a></li>
			</cfif>
			<cfif SecureDisplay('vendor')>
				<li><a href="#buildSecureURL(action='vendor.list', queryString='O_Company=A')#">Vendors</a></li>
			</cfif>
			<li><a href="#buildSecureURL(action='directory.list')#">Company Directory</a></li>
			<cfif SecureDisplay('settings')>
				<li>
					<a href="##">Settings</a>
					<div class="MenuSubOne">
						<ul>
							<li><a href="#buildSecureURL(action='setting.detail')#">Slatwall Settings</a></li>
							<li><a href="#buildSecureURL(action='setting.dbupdate')#">DB Update Utility</a></li>
							<li><a href="#buildSecureURL(action='setting.permissions')#">Group Permissions</a></li>
							<li><a href="#buildSecureURL(action='setting.tasks')#">Task Scheduler</a></li>
						</ul>
					</div>
				</li>
			</cfif>
			--->
			<cfif SecureDisplay('help')>
				<li>
					<a href="##">Help</a>
					<div class="MenuSubOne">
						<ul>
							<li><a href="#buildSecureURL(action='help.about')#">About</a></li>
						</ul>
					</div>
				</li>
			</cfif>
			<li class="MenuBottom"></li>
		</ul>
		<ul class="MainToolbar">
			<li class="LogoSearch">
				<img src="/plugins/#getPluginConfig().getDirectory()#/images/toolbar/toolbar_logo.png" />
				<input type="text" name="AdminSearch" class="AdminSearch" />
			</li>
			<li><a href="http://#cgi.http_host#/">Website</a></li>
			<li><a href="##">Company E-Mail</a></li>
			<cfif isDefined('request.contentBean') and SecureDisplay('utility.campaignlink')>
				<li><a href="javascript:;" onClick="doSlatAction('utility.campaignlink',{'Show': 1, 'LandingPageContentID': '#request.contentBean.getContentID()#', 'QueryString': '#cgi.query_string#'})">Campaign Link</a></li>
			</cfif>
			<cfif isDefined('url.ProductID')>
				<li><a href="#buildURL(action='product.detail', querystring='ProductID=#url.ProductID#')#">Product Detail</a></li>
			</cfif>
			<li><a href="?reload=true">Reload</a></li>
		</ul>
	</div>
	
</cfoutput>