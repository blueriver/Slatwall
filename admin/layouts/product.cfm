<cfoutput>
	<div class="span10">
		<cfloop array="#rc.messages#" index="local.message">
			<div class="alert alert-#local.message.messageType#">
				<a class="close" data-dismiss="alert">x</a>
				#local.message.message#
			</div>
		</cfloop>
		#body#
	</div>
	<div class="span2">
		<div class="well" style="padding:8px 0;">
			<ul class="nav nav-list">
				<li class="nav-header">#rc.$.slatwall.rbKey('admin.product')#</li>
				<cf_SlatwallActionCaller action="admin:product.listproducts" type="list">
				<cf_SlatwallActionCaller action="admin:product.createproduct" type="list">
				<li class="divider"></li>
				<cf_SlatwallActionCaller action="admin:product.listproducttypes" type="list">
				<cf_SlatwallActionCaller action="admin:product.createproducttype" type="list">
				<li class="divider"></li>
				<cf_SlatwallActionCaller action="admin:product.listoptiongroups" type="list">
				<cf_SlatwallActionCaller action="admin:product.createoptiongroup" type="list">
				<li class="divider"></li>
				<cf_SlatwallActionCaller action="admin:product.createbrand" type="list">
				<cf_SlatwallActionCaller action="admin:product.listbrands" type="list">
				<li class="nav-header">#rc.$.slatwall.rbKey('admin.setting')#</li>
			</ul>
		</div>
	</div>
</cfoutput>