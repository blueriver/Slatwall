<cfset local.Brand = application.slat.brandManager.read(BrandID=rc.BrandID) />
<cfoutput>
	<div class="ItemDetailMain">
		<dl>
			<dt>Brand Name</dt>
			<dd>#local.Brand.getBrandName()#</dd>
		</dl>
	</div>
	
	<div class="TCLeftTThird">
		<cfset local.args = structNew() />
		<cfset local.args.Brand = local.Brand />
		<cfset local.args.HiddenColumns = "BrandName" />
		#view('product/list', local.args)#
	</div>
	<div class="TCRightThird">
		<cfset local.args = structNew() />
		<cfset local.args.Brand = local.Brand />
		#view('vendor/list', local.args)#
	</div>
</cfoutput>