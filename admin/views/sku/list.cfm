<cfif isDefined('args.Product')>
	<cfset local.SkusIterator = args.Product.getSkusIterator() />
<cfelse>
	<cfset local.SkusIterator = application.slat.skuManger.getSkuIterator(request.slat.queryOrganizer.organizeQuery(application.Slat.skuManager.getAllSkusQuery())) />
</cfif>

<cfoutput>
<div class="svoSkuList">
	<h3 class="tableheader">Skus</h3>
	<table class="listtable">
		<tr>
			<th>Last Rec. Date</th>
			<th>Last QR</th>
			<th>Sku Code</th>
			<th>Attributes</th>
			<th>QOH</th>
			<th>QOO</th>
			<th>QC</th>
			<th>QC</th>
			<th>QIA</th>
			<th>QEA</th>
			<th>Next Arrival</th>
		</tr>
		<cfloop condition="#local.SkusIterator.hasNext()#">
			<cfset local.Sku = SkusIterator.Next() />
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td>#local.Sku.getAttributesString()#</td>
				<td>#local.Sku.getQOH()#</td>
				<td>#local.Sku.getQOO()#</td>
				<td>#local.Sku.getQC()#</td>
				<td>QS</td>
				<td class="bluebg">#local.Sku.getQIA()#</td>
				<td class="yellowbg">#local.Sku.getQEA()#</td>
				<td class="yellowbg">#DateFormat(local.Sku.getNextArrivalDate(),"MM/DD/YYYY")#</td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>