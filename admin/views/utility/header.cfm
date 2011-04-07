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
<img class="slatwallLogo" src="/plugins/#getPluginConfig().getDirectory()#/images/slatwall_logo.png" height="24" width="150" alt="Slatwall Ecommerce" />

<ul id="navUtility">
	<li id="navDashboard">
		<cf_ActionCaller action="admin:main" type="link">
	</li>
	<li id="navProducts">
		<cf_ActionCaller action="admin:product" type="link">
		<ul class="addMenuNav">
			<cf_ActionCaller action="admin:product.list" type="list">
			<cf_ActionCaller action="admin:product.create" type="list">
			<cf_ActionCaller action="admin:product.listproducttypes" type="list">
			<cf_ActionCaller action="admin:option" type="list">
			<cf_ActionCaller action="admin:brand" type="list" class="last">
		</ul>
	</li>
	<li id="navAccounts">
		<cf_ActionCaller action="admin:account" type="link">
		<ul class="addMenuNav">
			<cf_ActionCaller action="admin:account.list" type="list" class="last">
		</ul>
	</li>
	<li id="navSettings">
		<cf_ActionCaller action="admin:setting" type="link">
		<ul class="addMenuNav">
			<cf_ActionCaller action="admin:setting.detail" type="list">
			<cf_ActionCaller action="admin:setting.detailpermissions" type="list" class="last">
			<cf_ActionCaller action="admin:setting.listaddresszones" type="list" class="last">
			<cf_ActionCaller action="admin:setting.listshippingmethods" type="list" class="last">
			<cf_ActionCaller action="admin:setting.listpaymentmethods" type="list" class="last">
			<cf_ActionCaller action="admin:setting.listintegrationservices" type="list" class="last">
		</ul>
	</li>
	<li id="navHelp">
		<cf_ActionCaller action="admin:help" type="link">
		<ul class="addMenuNav">
			<cf_ActionCaller action="admin:help.about" type="list" class="last">
		</ul>
	</li>
    <li id="navSiteManager">
    	<a href="/admin/index.cfm?fuseaction=cArch.list&siteid=default&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a>
	</li>
    <li id="navLogout">
    	<a href="/admin/index.cfm?fuseaction=cLogin.logout">#application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a>
	</li>
</ul>
<p id="welcome">#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</p>
</cfoutput>
