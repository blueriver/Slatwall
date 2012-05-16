<cfoutput>
	<link rel="stylesheet" href="#request.slatwallScope.getSlatwallRootURL()#/assets/fetools/fetools.css" type="text/css" media="all" />
	<script src="#request.slatwallScope.getSlatwallRootURL()#/assets/fetools/fetools.js" type="text/javascript" language="Javascript"></script>
	<div id="sw-fetools">
		<div class="sw-handle">
			<a href="##" class="sw-logo"></a>	
		</div>
		<ul class="sw-menu">
			<li>
				<a href="##" class="sw-submenu-toggle"><i class="icon icon-tags"></i> #request.slatwallScope.rbKey('admin.product_nav')#</a>
				<ul>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listproduct">#request.slatwallScope.rbKey('entity.product_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listproducttype">#request.slatwallScope.rbKey('entity.producttype_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listoptiongroup">#request.slatwallScope.rbKey('entity.optiongroup_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listbrand">#request.slatwallScope.rbKey('entity.brand_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listsubscriptionterm">#request.slatwallScope.rbKey('entity.subscriptionterm_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listsubscriptionbenefit">#request.slatwallScope.rbKey('entity.subscriptionbenefit_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listproductreview">#request.slatwallScope.rbKey('entity.productreview_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:pricing.listpromotion">#request.slatwallScope.rbKey('entity.promotion_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:pricing.listpricegroup">#request.slatwallScope.rbKey('entity.pricegroup_plural')#</a></li>
				</ul>
			</li>
			<li class="divider"></li>
			<li>
				<a href="##" class="sw-submenu-toggle"><i class="icon icon-inbox"></i> #request.slatwallScope.rbKey('admin.order_nav')#</a>
				<ul>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:order.listorder">#request.slatwallScope.rbKey('entity.order_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:order.listorderfulfillment">#request.slatwallScope.rbKey('entity.orderfulfillment_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:vendor.listvendororder">#request.slatwallScope.rbKey('entity.vendororder_plural')#</a></li>
				</ul>
			</li>
			<li class="divider"></li>
			<li>
				<a href="##" class="sw-submenu-toggle"><i class="icon icon-user"></i> #request.slatwallScope.rbKey('admin.account_nav')#</a>
				<ul>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:account.listaccountv">#request.slatwallScope.rbKey('entity.account_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:vendor.listvendor">#request.slatwallScope.rbKey('entity.vendor_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:account.listsubscriptionusage">#request.slatwallScope.rbKey('entity.subscriptionusage_plural')#</a></li>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:account.listpermissiongroup">#request.slatwallScope.rbKey('entity.permissiongroup_plural')#</a></li>
				</ul>
			</li>
			<li class="divider"></li>
			<li>
				<a href="##" class="sw-submenu-toggle"><i class="icon icon-random"></i> #request.slatwallScope.rbKey('admin.integration_nav')#</a>
				<ul>
					<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:warehouse.listintegration">#request.slatwallScope.rbKey('entity.stockreceiver_plural')#</a></li>
					<cfset local.integrationSubsystems = request.slatwallScope.getService('integrationService').getActiveFW1Subsystems() />
					<cfloop array="#local.integrationSubsystems#" index="local.intsys">
						<li>
							<a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=#local.intsys.subsystem#:main.default">#local.intsys.name#</a>
						</li>
					</cfloop>
				</ul>
			</li>
			<li class="divider"></li>
			<li>
				<a href="##" class="sw-submenu-toggle active"><i class="icon icon-file"></i> Page Tools</a>
				<ul class="open">
					<li><a href="">View Product Settings</a></li>
					<li><a href="">View Product Inventory</a></li>
					<li><a href="">Product Admin</a></li>
					<li><a href="">Product Type Admin</a></li>
					<li><a href="">Brand Admin</a></li>
				</ul>
			</li>
			
		</ul>	
	</div>
</cfoutput>