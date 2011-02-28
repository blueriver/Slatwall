<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:product.create" type="list">
</ul>

<div class="svoadminproductlist">
	<form method="post">
		<input name="Keyword" value="#rc.Keyword#" /> <button type="submit">Search</button>
	</form>

	<table id="ProductList" class="listtable">
		<tr>
			<!---<th>Search Score</th>--->
			<th>#rc.$.Slatwall.rbKey("entity.brand.brandName_title")#</th>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.product.productName")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.productYear_title")#</th>
			<!---<th>Product Code</th>--->
			<th>#rc.$.Slatwall.rbKey("entity.product.qoh")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qoo")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qc")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qia")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qea")#</th>
			<th>&nbsp</th>
		</tr>
	<!--- since we are looping through an array, not a recordset, I'll use a counter do the alternate row table formatting --->
	<cfset local.rowcounter = 1 />			
		<cfloop array="#rc.ProductSmartList.getPageRecords()#" index="Local.Product">
			<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
				<!---<td>#Local.Product.getSearchScore()#</td>--->
				<td>#Local.Product.getBrand().getBrandName()#</td>
				<td class="varWidth">#Local.Product.getProductName()#</td>
				<td>#Local.Product.getProductYear()#</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td class="administration">
					<cfset local.productID = Local.Product.getProductID() />
		          <ul class="three">
                      <cf_ActionCaller action="admin:product.edit" querystring="productID=#local.productID#" class="edit" type="list">            
					  <cf_ActionCaller action="admin:product.detail" querystring="productID=#local.productID#" class="viewDetails" type="list">
					  <cf_ActionCaller action="admin:product.delete" querystring="productID=#local.productID#" class="delete" type="list" disabled="false" confirmrequired="true">
		          </ul>     						
				</td>
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
