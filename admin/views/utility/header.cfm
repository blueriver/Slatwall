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
			<cf_ActionCaller action="admin:setting.editpermissions" type="list" class="last">
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