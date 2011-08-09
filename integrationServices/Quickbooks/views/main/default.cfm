<cfoutput>
	<form name="fileUpload" method="post" action="?slatAction=quickbooks:main.productImport" enctype="multipart/form-data">
		<input type="file" name="inventoryImport" />
		<button type="submit">Upload</button>
	</form>
</cfoutput>