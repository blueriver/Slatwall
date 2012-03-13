<cfoutput>
	<div class="span10">
		#body#
	</div>
	<div class="span2">
		<ul class="nav nav-list">
			<li class="nav-header">#rc.$.slatwall.rbKey('admin:account')#</li>
			<cf_SlatwallActionCaller action="admin:account.listaccount" type="list">
			<cf_SlatwallActionCaller action="admin:account.createaccount" type="list">
		</ul>
	</div>
</cfoutput>