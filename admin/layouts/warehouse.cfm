<cfoutput>
	<div class="span10">
		#body#
	</div>
	<div class="span2">
		<ul class="nav nav-list">
			<li class="nav-header">Products</li>
			<cf_SlatwallActionCaller action="admin:product.list" type="list">
			<cf_SlatwallActionCaller action="admin:product.create" type="list">
			<li class="nav-header">Products Types</li>
			<cf_SlatwallActionCaller action="admin:product.listproducttypes" type="list">
			<cf_SlatwallActionCaller action="admin:product.createproducttype" type="list">
			<li class="nav-header">Option Groups</li>
			<cf_SlatwallActionCaller action="admin:product.listoptiongroups" type="list">
			<cf_SlatwallActionCaller action="admin:product.createoptiongroup" type="list">
			<li class="nav-header">Settings</li>
		</ul>
	</div>
</cfoutput>