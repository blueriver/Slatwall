<cfset local.Product = rc.Product />

<cfoutput>
	<!--- <div class="ItemDetailImage"><img src="http://www.nytro.com/prodimages/#local.Product.getDefaultImageID()#-DEFAULT-s.jpg"></div> --->
	<div class="ItemDetailMain">
		<dl>
			<dt>Product Name</dt>
			<dd>#local.Product.getProductName()#</dd>
		</dl>
		<dl>
			<dt>Product Code</dt>
			<dd>#local.Product.getProductCode()#</dd>
		</dl>
		<dl>
			<dt>Brand</dt>
			<dd>#local.Product.getBrand().getBrandName()#</dd>
		</dl>
		<dl>
			<dt>Product Year</dt>
			<dd>#local.Product.getProductYear()#</dd>
		</dl>
		<dl>
			<dt>Gender</dt>
			<dd>#local.Product.getGenderType().getType()#</dd>
		</dl>
	</div>
	
	<div class="ItemDetailBar">
		<dl>
			<dt>On Web</dt>
			<dd>
				<cfif local.Product.getShowOnWebRetail() eq 1>
					<a href="#local.Product.getWebRetailLink()#">YES</a>
				<cfelse>
					NO
				</cfif>
			</dd>
		</dl>
		<dl>
			<dt>Total QOH</dt>
			<dd>#local.Product.getQOH()#</dd>
		</dl>
		<dl>
			<dt>Total QOO</dt>
			<dd>#local.Product.getQOO()#</dd>
		</dl>
		<dl>
			<dt>Total QC</dt>
			<dd>#local.Product.getQC()#</dd>
		</dl>
		<!---
		<dl class="wide">
			<dt>Original Price</dt>
			<dd>#local.Product.getOriginalPrice()#</dd>
		</dl>
		<dl class="wide">
			<dt>List Price</dt>
			<dd>#local.Product.getListPrice()#</dd>
		</dl>
		<dl class="wide">
			<dt>Price</dt>
			<dd class="green">#local.Product.getLivePrice()#</dd>
		</dl>
		--->
	</div>
	<!---
	<div>
		<cfset args = structNew() />
		<cfset args.Product = local.Product />
		#viewSecure('sku/list', args)#
		<cfset args = structNew() />
		<cfset args.ProductID = local.Product.getProductID() />
		#viewSecure('product/contentassignment', args)#
		
		<cfif SecureDisplay('product.contentassignment')>
			<hr />
			<cfinclude template="#application.slatsettings.getSetting('PluginPath')#/view_old/Products/Specifications.cfm" />
			<hr />
			<cfinclude template="#application.slatsettings.getSetting('PluginPath')#/view_old/Products/Misc.cfm" />
		</cfif>
		
	</div>
	--->
</cfoutput>