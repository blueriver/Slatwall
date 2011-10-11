<cfoutput>
	<ul id="navTask"></ul>
	<p><strong>IMPORTANT NOTE:</strong> The quickbooks integration is currently under major development and not intended to be used in a production capacity.  If you are not an active developer working on this integration we recommend not using any of these features.</p>
	<h2>Upload Inventory</h2>
	<form name="fileUpload" method="post" action="?slatAction=quickbooks:main.productImport" enctype="multipart/form-data">
		<input type="file" name="inventoryImport" />
		<button type="submit">Upload</button>
	</form>
	<hr />
	<h2>Export Orders IIF</h2>
	<form name="exportOrders" method="post" action="?slatAction=quickbooks:main.orderExport">
		<button type="submit">Export</button>
	</form>
</cfoutput>