<cfoutput>
	<div class="span10">
		#body#
	</div>
	<div class="span2">
		<ul class="nav nav-list">
			<li class="nav-header">Orders</li>
			<cf_SlatwallActionCaller action="admin:order.listorder" type="list">
		</ul>
	</div>
</cfoutput>