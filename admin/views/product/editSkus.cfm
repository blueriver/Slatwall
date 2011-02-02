<cfoutput>
<table>
	<tr>
		<th>Company SKU</th>
		<th>Original Price</th>
		<th>List Price</th>
		<th>QOH</th>
		<th>QOO</th>
		<th>QC</th>
		<th>QIA</th>
		<th>QEA</th>
		<th>Image Path</th>
		<th></th>
	</tr>
	<cfset local.arrayIndex = 1 />
	<cfloop array="#local.skus#" index="local.thisItem">
	<tr>			
		<td><input type="text" name="SKU#local.arrayIndex#_SKUID" id="SKU#local.arrayIndex#_SKUID" value="#local.thisItem.getSkuID()#" /></td>
		<td><input type="text" name="SKU#local.arrayIndex#_originalPrice" id="SKU#local.arrayIndex#_originalPrice" value="#local.thisItem.getOriginalPrice()#" /></td>
		<td><input type="text" name="SKU#local.arrayIndex#_listPrice" id="SKU#local.arrayIndex#_listPrice" value="#local.thisItem.getListPrice()#" /></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	<cfset local.arrayIndex++ />
	</cfloop>
</table>
</cfoutput>