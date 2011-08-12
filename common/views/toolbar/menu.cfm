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
<cfset getAssetWire().addJSVariable("slatwallToolbarSearchKey", $.slatwall.getAPIKey(resource='DisplayToolbarSearchResults', verb='get')) />

<cfoutput>
	<div class="svocommontoolbarmenu">
		<ul class="home">
			<li id="mainMenu">
				<a href="/" class="logo">Main Menu</a>
				<ul class="menu">
					<cf_SlatwallActionCaller action="admin:main" type="list">
					<cf_SlatwallActionCaller action="admin:product" type="list">
					<cf_SlatwallActionCaller action="admin:order" type="list">
					<cf_SlatwallActionCaller action="admin:account" type="list">
					<cf_SlatwallActionCaller action="admin:promotion" type="list">
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
								<li class="title">Product Options</li>
								<cf_SlatwallActionCaller action="admin:option.createoptiongroup" type="list">
								<cf_SlatwallActionCaller action="admin:option.list" type="list">
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
					<div class="subMenu adminorder">
						<h3>#$.slatwall.rbkey('admin.order')#</h3>
						<div class="oneColumn">
							<ul>
								<li class="title">Orders</li>
								<cf_SlatwallActionCaller action="admin:order.list" type="list">
								<cf_SlatwallActionCaller action="admin:order.listorderfulfillments" type="list">
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
						</div>
						<div class="oneColumn">
							<ul>
								<li class="title">Tools</li>
								<cf_SlatwallActionCaller action="admin:setting.detailviewupdate" type="list">
								<li class="last"><a href="#$.slatwall.getSlatwallRootPath()#/?reload=true">Reload</a></li>
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
				<a href="/" class="website">Website</a>
			</li>
		</ul>
		<ul class="favorites">
			<li id="navDashboard">
				<cf_SlatwallActionCaller action="admin:main" type="link">
			</li>
			<li id="navProducts">
				<ul class="addMenuNav">
					<cf_SlatwallActionCaller action="admin:product.create" type="list">
					<cf_SlatwallActionCaller action="admin:product.list" type="list">
				</ul>
				<cf_SlatwallActionCaller action="admin:product" type="link">
			</li>
			<li id="navOrders">
				<ul class="addMenuNav">
					<cf_SlatwallActionCaller action="admin:order.list" type="list">
					<cf_SlatwallActionCaller action="admin:order.listorderfulfillments" type="list">
				</ul>
				<cf_SlatwallActionCaller action="admin:order" type="link">
			</li>
			<li id="navAccounts">
				<ul class="addMenuNav">
					<cf_SlatwallActionCaller action="admin:account.create" type="list" class="last">
					<cf_SlatwallActionCaller action="admin:account.list" type="list" class="last">
				</ul>
				<cf_SlatwallActionCaller action="admin:account" type="link">
			</li>
		</ul>
	</div>
</cfoutput>