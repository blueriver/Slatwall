<cfoutput>
<div id="toolBar" style="display: ">
    <ul>
        <li id="adminPlugIns"><a href="/admin/index.cfm?fuseaction=cPlugins.list&siteid=default">Plugins</a></li>

        <li id="adminSiteManager"><a href="/admin/index.cfm?fuseaction=cArch.list&siteid=default&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</a></li>
        <li id="adminDashboard"><a href="/plugins/#getPluginConfig().getDirectory()#/">#application.rbFactory.getKeyValue(session.rb,"layout.dashboard")#</a></li>
        <li id="adminLogOut"><a href="/admin/index.cfm?fuseaction=cLogin.logout">#application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
        <li id="adminWelcome">#application.rbFactory.getKeyValue(session.rb,"layout.welcome")#, #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#.</li>
    </ul>
</div>
</cfoutput>