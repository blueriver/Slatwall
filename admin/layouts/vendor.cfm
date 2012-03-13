<cfoutput>
	<div class="span10">
		#body#
	</div>
	<div class="span2">
		<ul class="nav nav-list">
			<li class="nav-header">#getSection(rc.slatAction)#</li>
			<cf_SlatwallActionCaller action="admin:vendor.listvendors" type="list">
			<cf_SlatwallActionCaller action="admin:vendor.createvendor" type="list">
			<cf_SlatwallActionCaller action="admin:vendor.createvendororder" type="list">
		</ul>
	</div>
</cfoutput>