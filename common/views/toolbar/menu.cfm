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

<cfoutput>
	<div class="svocommontoolbarmenu">
		<ul class="home">
			<li id="mainMenu">
				<a href="javascript:void;" class="logo">Main Menu</a>
				<ul class="menu hideElement">
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
				</ul>
			</li>
			<li id="search">
				<input type="text" class="search" />
			</li>
			<li id="pageTools">
				<a href="/" class="website">Website</a>
			</li>
		</ul>
		<ul class="favorites">
			<li id="navDashboard">
				<cf_ActionCaller action="admin:main" type="link">
			</li>
			<li id="navProducts">
				<ul class="addMenuNav">
					<cf_ActionCaller action="admin:product.list" type="list">
					<cf_ActionCaller action="admin:product.create" type="list">
					<cf_ActionCaller action="admin:product.listproducttypes" type="list">
					<cf_ActionCaller action="admin:option" type="list">
					<cf_ActionCaller action="admin:brand" type="list" class="last">
				</ul>
				<cf_ActionCaller action="admin:product" type="link">
			</li>
			<li id="navOrders">
				<cf_ActionCaller action="admin:order" type="link">
			</li>
			<li id="navAccounts">
				<ul class="addMenuNav">
					<cf_ActionCaller action="admin:account.list" type="list" class="last">
				</ul>
				<cf_ActionCaller action="admin:account" type="link">
			</li>
			<li id="navSettings">
				<ul class="addMenuNav">
					<cf_ActionCaller action="admin:setting.detail" type="list">
					<cf_ActionCaller action="admin:setting.detailpermissions" type="list">
					<cf_ActionCaller action="admin:setting.listaddresszones" type="list">
					<cf_ActionCaller action="admin:setting.listpaymentmethods" type="list">
					<cf_ActionCaller action="admin:setting.listfulfillmentmethods" type="list">
					<cf_ActionCaller action="admin:setting.listintegrationservices" type="list">
					<cf_ActionCaller action="admin:attribute" type="list">
					<cf_ActionCaller action="admin:setting.detailviewupdate" type="list">
					<li class="last"><a href="#$.Slatwall.root()#/?reload=true">Reload</a></li>
				</ul>
				<cf_ActionCaller action="admin:setting" type="link">
			</li>
		</ul>
	</div>
</cfoutput>

