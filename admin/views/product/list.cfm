<cfoutput>
	<div class="svoadminproductlist">
		<form method="post">
			<input name="Keyword" value="#rc.Keyword#" /><button type="submit">Search</button>
		</form>
		<div style="float:right;"><a href="#buildURL(action='admin:product.edit')#">Create Product</a></div>
		<table class="listtable">
			<tr>
				<!---<th>Search Score</th>--->
				<th>Brand</th>
				<th>Product Name</th>
				<th>Year</th>
				<!---<th>Product Code</th>--->
				<th>QOH</th>
				<th>QOO</th>
				<th>QC</th>
				<th>QIA</th>
				<th>QEA</th>
				<th>Administration</th>
			</tr>
		<!--- since we are looping through an array, not a recordset, I'll use a counter do the alternate row table formatting --->
		<cfset local.rowcounter = 1 />			
			<cfloop array="#rc.ProductSmartList.getPageRecords()#" index="Local.Product">
				<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
					<!---<td>#Local.Product.getSearchScore()#</td>--->
					<td>
						<a href="#buildURL(action='admin:brand.detail', queryString='brandID=#Local.Product.getBrand().getBrandID()#')#">
						#Local.Product.getBrand().getBrandName()#
						</a>
					</td>
					<td><a href="#buildURL(action='admin:product.detail', queryString='productID=#Local.Product.getProductID()#')#">#Local.Product.getProductName()#</a></td>
					<td>#Local.Product.getProductYear()#</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<!---<td><a href="#buildURL(action='admin:product.detail', queryString='productID=#Local.Product.getProductID()#')#">#Local.Product.getProductCode()#</a></td>--->
					<td><a href="#buildURL(action='admin:product.edit', queryString='productID=#Local.Product.getProductID()#')#">Edit</a></td>
				</tr>
				<cfset local.rowcounter++ />
			</cfloop>
		</table>
		
		Entity name: #rc.ProductSmartList.getEntityName()#<br>
		
		<strong>Entitie Start:</strong> #rc.ProductSmartList.getEntityStart()#<br />
		<strong>Entitie End:</strong> #rc.ProductSmartList.getEntityEnd()#<br />
		<strong>Entities Per Page:</strong> #rc.ProductSmartList.getEntityShow()#<br />
		<strong>Total Entities:</strong> #rc.ProductSmartList.getTotalEntities()#<br />
		<strong>Current Page:</strong> #rc.ProductSmartList.getCurrentPage()#<br />
		<strong>Total Pages:</strong> #rc.ProductSmartList.getTotalPages()#<br />
		<strong>List Fill Time:</strong> #rc.ProductSmartList.getFillTime()# ms <br />
		<cfif arrayLen(rc.ProductSmartList.getKeywords())>
			<strong>List Search Time:</strong> #rc.ProductSmartList.getSearchTime()# ms<br />
		</cfif>
	</div>
</cfoutput>
