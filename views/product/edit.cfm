<cfoutput>
	<div class="svoproductedit">
		<form name="ProductEdit" action="?action=product.save&ProductID=#rc.Product.getProductID()#" method="post">
		<dl>
			<dt>Product Name</dt>
			<dd><input type="text" name="ProductName" value="#rc.Product.getProductName()#" /></dd>
		</dl>
		<dl>
			<dt>Active</dt>
			<dd><input type="checkbox" name="Active" <cfif rc.Product.getActive()>checked="checked"</cfif></dd>
		</dl>
		<dl>
			<dt>Manufacture Discontinued</dt>
			<dd><input type="checkbox" name="ManufactureDiscontinued" <cfif rc.Product.getManufactureDiscontinued()>checked="checked"</cfif></dd>
		</dl>
		<button type="submit">Save</button>
		</form>
	</div>
</cfoutput>