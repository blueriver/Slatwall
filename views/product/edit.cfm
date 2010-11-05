<cfoutput>
	<div class="svoproductedit">
		<form name="ProductEdit" action="?action=product.save" method="post">
		<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
		<dl>
			<dt>Product Name</dt>
			<dd><input type="text" name="ProductName" value="#rc.Product.getProductName()#" /></dd>
		</dl>
		<dl>
			<dt>Active</dt>
			<dd><input type="checkbox" name="Active" value="1" <cfif rc.Product.getActive()>checked="checked"</cfif></dd>
		</dl>
		<dl>
			<dt>Manufacture Discontinued</dt>
			<dd><input type="checkbox" name="ManufactureDiscontinued" value="1" <cfif rc.Product.getManufactureDiscontinued()>checked="checked"</cfif></dd>
		</dl>
		<button type="submit">Save</button>
		</form>
	</div>
</cfoutput>