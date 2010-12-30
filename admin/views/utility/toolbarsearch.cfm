<cfoutput>
	<cfif isDefined("rc.toolbarKeyword") and len(rc.toolbarKeyword) gte 2>
		<div class="svoadminutilitytoolbarsearch">
			<ul class="SearchMenu">
				<li class="MenuTop">&nbsp;</li>
				
				<cfif arrayLen(rc.productSmartList.getEntityArray())>
					<li class="SearchHeader top"><a href="#buildURL(action='product.list',querystring='Keyword=#rc.toolbarKeyword#')#">Products (#rc.productSmartList.getTotalEntities()#)</a></li>
					<cfloop array="#rc.productSmartList.getEntityArray()#" index="local.Product">
						<li class="SearchResult"><a href="#buildURL(action='product.detail',querystring='ProductID=#local.Product.getProductID()#')#">#local.Product.getProductName()#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				
				<cfif arrayLen(rc.brandSmartList.getEntityArray())>
					<li class="SearchHeader top"><a href="#buildURL(action='brand.list',querystring='Keyword=#rc.toolbarKeyword#')#">Brands (#rc.brandSmartList.getTotalEntities()#)</a></li>
					<cfloop array="#rc.brandSmartList.getEntityArray()#" index="local.Brand">
						<li class="SearchResult"><a href="#buildURL(action='brand.detail',querystring='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				<cfif not arrayLen(rc.productSmartList.getEntityArray()) and not arrayLen(rc.brandSmartList.getEntityArray())>
					<li class="MenuBottom">Nothing Found Matching Your Search</li>
				<cfelse>
					<li class="MenuBottom">&nbsp;</li>
				</cfif>
			</ul>
		</div>
	<cfelse>
		<div class="svoadminutilitytoolbarsearch" style="display:none;"></div>
	</cfif>
</cfoutput>