<cfoutput>
	<div class="span10">
		<cfinclude template="inc/sectionheader.cfm" />
		#body#
	</div>
	<div class="span2" style="padding-top:55px;">
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
		</ul>
	</div>
</cfoutput>