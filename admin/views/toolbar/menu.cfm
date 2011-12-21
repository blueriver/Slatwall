<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfset $.slatwall.getCFStatic().includeData({slatwallToolbarSearchKey=$.slatwall.getAPIKey(resource='DisplayToolbarSearchResults', verb='get')}) />

<cfoutput>
	<div class="svoadmintoolbarmenu">
		<ul class="home">
			<li id="mainMenu">
				<a href="#application.configBean.getContext()#/" class="logo">Main Menu</a>
				<ul class="menu">
					<cf_SlatwallActionCaller action="admin:main" type="list">
					<cf_SlatwallActionCaller action="admin:product" type="list">
					<cf_SlatwallActionCaller action="admin:order" type="list">
					<cf_SlatwallActionCaller action="admin:account" type="list">
					<cf_SlatwallActionCaller action="admin:vendor" type="list">
					<cf_SlatwallActionCaller action="admin:promotion" type="list">
					<cf_SlatwallActionCaller action="admin:report" type="list">
					<cf_SlatwallActionCaller action="admin:setting" type="list">
					<cf_SlatwallActionCaller action="admin:help" type="list">
				</ul>
				<div class="subMenuWrapper">
					<div class="subMenu adminmain">
						<h3>#$.slatwall.rbkey('admin.main')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Most Common Tools</li>
								<cf_SlatwallActionCaller action="admin:product.list" type="list">
								<cf_SlatwallActionCaller action="admin:product.listproducttypes" type="list">
								<cf_SlatwallActionCaller action="admin:brand.list" type="list">
								<cf_SlatwallActionCaller action="admin:account.list" type="list">
								<cf_SlatwallActionCaller action="admin:vendor.listvendor" type="list">
								<cf_SlatwallActionCaller action="admin:promotion.list" type="list">
								<cf_SlatwallActionCaller action="admin:setting.detail" type="list">
							</ul>
							<ul>
								<li class="title">External Resources</li>
								<li><a href="http://www.getSlatwall.com/">getSlatwall.com</a></li>
								<li><a href="http://docs.getSlatwall.com/">Documentation</a></li>
								<li><a href="http://groups.google.com/group/slatwallecommerce/">Google Group</a></li>
							</ul>
						</div>
					</div>
					<div class="subMenu adminproduct">
						<h3>#$.slatwall.rbkey('admin.product')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Products</li>
								<cf_SlatwallActionCaller action="admin:product.create" type="list">
								<cf_SlatwallActionCaller action="admin:product.list" type="list">
							</ul>
							<ul>
								<li class="title">Product Types</li>
								<cf_SlatwallActionCaller action="admin:product.createproducttype" type="list">
								<cf_SlatwallActionCaller action="admin:product.listproducttypes" type="list">
							</ul>
							<ul>
								<li class="title">Product Option Groups</li>
								<cf_SlatwallActionCaller action="admin:option.createoptiongroup" type="list">
								<cf_SlatwallActionCaller action="admin:option.listoptiongroups" type="list">
							</ul>
						</div>
						<div class="oneColumn">
							<ul>
								<li class="title">Brands</li>
								<cf_SlatwallActionCaller action="admin:brand.create" type="list">
								<cf_SlatwallActionCaller action="admin:brand.list" type="list">
							</ul>
							<ul>
								<li class="title">Related</li>
								<cf_SlatwallActionCaller action="admin:attribute" type="list">
								<cf_SlatwallActionCaller action="admin:promotion" type="list">
							</ul>
							<ul>
								<li class="title">Price Groups</li>
								<cf_SlatwallActionCaller action="admin:pricegroup.createPriceGroup" type="list">
								<cf_SlatwallActionCaller action="admin:pricegroup.listPriceGroups" type="list">
							</ul>
						</div>
					</div>
					<div class="subMenu adminaccount">
						<h3>#$.slatwall.rbkey('admin.account')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Accounts</li>
								<cf_SlatwallActionCaller action="admin:account.create" type="list">
								<cf_SlatwallActionCaller action="admin:account.list" type="list">
							</ul>
						</div>
					</div>
					<div class="subMenu adminvendor">
						<h3>#$.slatwall.rbkey('admin.vendor')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Vendors</li>
								<cf_SlatwallActionCaller action="admin:vendor.createvendor" type="list">
								<cf_SlatwallActionCaller action="admin:vendor.listvendors" type="list">
							</ul>
							<ul>
								<li class="title">Vendor Orders</li>
								<cf_SlatwallActionCaller action="admin:vendororder.createvendororder" type="list">
								<cf_SlatwallActionCaller action="admin:vendororder.listvendororders" type="list">
							</ul>
						</div>
					</div>
					<div class="subMenu adminorder">
						<h3>#$.slatwall.rbkey('admin.order')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Orders</li>
								<cf_SlatwallActionCaller action="admin:order.list" type="list">
								<cf_SlatwallActionCaller action="admin:order.listorderfulfillments" type="list">
								<cf_SlatwallActionCaller action="admin:order.listcart" type="list">
							</ul>
						</div>
					</div>
					<div class="subMenu adminpromotion">
						<h3>#$.slatwall.rbkey('admin.promotion')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Promotions</li>
								<cf_SlatwallActionCaller action="admin:promotion.create" type="list">
								<cf_SlatwallActionCaller action="admin:promotion.list" type="list">
							</ul>
						</div>
					</div>
					<div class="subMenu adminreport">
						<h3>#$.slatwall.rbkey('admin.report')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">General Reports</li>
								<cf_SlatwallActionCaller action="admin:report.order" type="list">
							</ul>
						</div>
					</div>
					<div class="subMenu adminsetting">
						<h3>#$.slatwall.rbkey('admin.setting')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Settings</li>
								<cf_SlatwallActionCaller action="admin:setting.detail" type="list">
								<cf_SlatwallActionCaller action="admin:setting.detailpermissions" type="list">
							</ul>
							<ul>
								<li class="title">Configuration</li>
								<cf_SlatwallActionCaller action="admin:setting.listtaxcategories" type="list">
								<cf_SlatwallActionCaller action="admin:setting.listaddresszones" type="list">
								<cf_SlatwallActionCaller action="admin:setting.listpaymentmethods" type="list">
								<cf_SlatwallActionCaller action="admin:setting.listfulfillmentmethods" type="list">
							</ul>
							<ul>
								<li class="title">Tools</li>
								<cf_SlatwallActionCaller action="admin:setting.detailviewupdate" type="list">
								<cf_SlatwallActionCaller action="admin:setting.detaildbtools" type="list">
								<cfif $.currentUser().getS2()>
									<li class="last"><a href="#$.slatwall.getSlatwallRootPath()#/api/index.cfm?dashboard">REST API Dashboard</a></li>
									<li class="last"><a href="#$.slatwall.getSlatwallRootPath()#/?reload=true">Reload</a></li>
								</cfif>
							</ul>
						</div>
						<div class="oneColumn">
							<ul>
								<li class="title">Integration</li>
								<cf_SlatwallActionCaller action="admin:integration.list" type="list">
								<cfset local.integrationSubsystems = $.slatwall.getService('integrationService').getActiveFW1Subsystems() />
								<cfloop array="#local.integrationSubsystems#" index="local.intsys">
									<a href="#buildURL(action='#local.intsys.subsystem#:main.default')#">#local.intsys.name#</a>
								</cfloop>
							</ul>
							<ul>
								<li class="title">Rounding Rules</li>
								<cf_SlatwallActionCaller action="admin:roundingrule.create" type="list">
								<cf_SlatwallActionCaller action="admin:roundingrule.list" type="list">
							</ul>
							<ul>
								<li class="title">Locations</li>
								<cf_SlatwallActionCaller action="admin:location.createlocation" type="list">
								<cf_SlatwallActionCaller action="admin:location.listlocations" type="list">
							</ul>
						</div>
					</div>
					<div class="subMenu adminhelp">
						<h3>#$.slatwall.rbkey('admin.help')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Help Topics</li>
								<cf_SlatwallActionCaller action="admin:help.about" type="list">
								<li><a href="http://docs.getSlatwall.com/">Documentation</a></li>
							</ul>
						</div>
					</div>
					<div class="subMenu searchresults">
						<h3>Search Results</h3>
						<cf_SlatwallToolbarSearchResults />
					</div>
				</div>
			</li>
			<li id="search">
				<input type="text" class="search" id="SlatwallToolbarSearch" tabindex="1" />
			</li>
			<li id="pageTools">
				<a href="#application.configBean.getContext()#/" class="website">Website</a>
			</li>
		</ul>
		<ul class="favorites">
			<li id="navDashboard">
				<cf_SlatwallActionCaller action="admin:main" type="link">
			</li>
			<li id="navProducts">
				<ul class="addMenuNav">
					<cf_SlatwallActionCaller action="admin:product.create" type="list">
					<cf_SlatwallActionCaller action="admin:product.list" type="list" class="last">
				</ul>
				<cf_SlatwallActionCaller action="admin:product" type="link">
			</li>
			<li id="navOrders">
				<ul class="addMenuNav">
					<cf_SlatwallActionCaller action="admin:order.list" type="list">
					<cf_SlatwallActionCaller action="admin:order.listorderfulfillments" type="list" class="last">
				</ul>
				<cf_SlatwallActionCaller action="admin:order" type="link">
			</li>
			<li id="navAccounts">
				<ul class="addMenuNav">
					<cf_SlatwallActionCaller action="admin:account.create" type="list">
					<cf_SlatwallActionCaller action="admin:account.list" type="list" class="last">
				</ul>
				<cf_SlatwallActionCaller action="admin:account" type="link">
			</li>
			<li id="navMura">
				<ul class="addMenuNav">
					<li><a href="/admin/index.cfm?fuseaction=cArch.list&amp;siteid=default&amp;moduleid=00000000000000000000000000000000000&amp;topid=00000000000000000000000000000000001">Site Manager</a></li>
					<li><a href="/admin/index.cfm?fuseaction=cPlugins.list&amp;siteid=default">Plugins</a></li>
				</ul>
				<a href="/admin/index.cfm?fuseaction=cDashboard.main&amp;siteid=default&amp;span=1">Mura Dashboard</a>
			</li>
		</ul>
	</div>
</cfoutput>