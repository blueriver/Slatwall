<cfoutput>
	<div class="svoproductedit">
		<form name="ProductEdit" action="?action=product.save&ProductID=#rc.Product.getProductID()#" method="post">
		<dl>
			<dt>Product Name</dt>
			<dd><input type="text" name="ProductName" value="rc.Product.getProductName()" /></dd>
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
<!---
	<cfproperty name="ManufactureDiscontinued" type="boolean" hint="This property can determine if a product can still be ordered by a vendor or not" />
	<cfproperty name="ShowOnWebRetail" type="boolean" hint="Should this product be sold on the web retail Site" />
	<cfproperty name="ShowOnWebWholesale" type="boolean" hint="Should this product be sold on the web wholesale Site" />
	<cfproperty name="NonInventoryItem" type="boolean" />
	<cfproperty name="CallToOrder" type="boolean" />
	<cfproperty name="InStoreOnly" type="boolean" />
	<cfproperty name="AllowPreorder" type="boolean" hint="" />
	<cfproperty name="AllowBackorder" type="boolean" />
	<cfproperty name="AllowDropship" type="boolean" />
	<cfproperty name="OnTermSale" type="boolean" />
	<cfproperty name="OnClearanceSale" type="boolean" />
	<cfproperty name="ProductName" type="string" hint="Primary Notation for the Product to be Called By" />
	<cfproperty name="ProductCode" type="string" hint="Product Code, Typically used for Manufacturer Coded" />
	<cfproperty name="ProductDescription" type="string" hint="HTML Formated description of the Product" />
	<cfproperty name="ProductYear" />
	<cfproperty name="MadeInCountryCode" />
	<cfproperty name="ShippingWeight" type="string" hint="This Weight is used to calculate shipping charges, gets overridden by sku Shipping Weight" />
	<cfproperty name="PublishedWeight" type="string" hint="This Weight is used for display purposes on the website, gets overridden by sku Published Weight" />
	<cfproperty name="DateCreated" type="string" />
	<cfproperty name="DateLastUpdated" type="string" />
	<cfproperty name="DateFirstReceived" type="string" />
	<cfproperty name="DateLastReceived" type="string" />
--->