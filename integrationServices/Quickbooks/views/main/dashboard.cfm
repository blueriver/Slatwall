<cfdump var="#request.context.$.siteConfig('assetPath')#" />
<cfabort />

<cfif structKeyExists(form, "processInventoryImport")>
	<cfset newFilename = createUUID() & ".txt" />
	<cffile action="upload" filefield="inventoryImport" destination="C:\TempTestFiles" nameConflict="overwrite"  result="uploadedFile">
	<cffile action="rename" destination="C:\TempTestFiles\#newFilename#" source="C:\TempTestFiles\#uploadedFile.serverFile#" > 
	<cfhttp method="get" url="file:///c:/TempTestFiles/#newFilename#" delimiter="#chr(9)#" result="importQuery">
	<cfdump var="#importQuery#" />
</cfif>

<cfoutput>
	<form name="fileUpload" method="post" enctype="multipart/form-data">
		<input type="hidden" name="processInventoryImport" value="1" />
		<input type="file" name="inventoryImport" />
		<button type="submit">Upload</button>
	</form>
</cfoutput>