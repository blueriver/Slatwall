<cfoutput>
	<cfset currentpricecode="L">
	<cfquery name="customers"  datasource="#application.slatsettings.getSetting('IntegrationDSN')#" username="#application.slatsettings.getSetting('IntegrationDBUsername')#" password="#application.slatsettings.getSetting('IntegrationDBPassword')#">
		select
			price_code,
			first_name,
			last_name
		from
			tb_customers 
		where price_code <> ''
		order by price_code,first_name
	</cfquery>
	<table cellspacing="0" cellpadding="0" class="listtable">
		<tr>
			<th>First Name</th>
			<th>Last Name</th>
			<th>Product Discount</th>
			<th>Service Discount</th>
		</tr>
		<cfloop query="customers">
			<cfif #currentpricecode# neq #customers.price_code#>
				<cfset currentpricecode = #customers.price_code#>
				<tr class="redbg">
					<td colspan="4" style="font-weight:bold;font-size:14px;color:##FFFFFF;">Price Code: #customers.price_code#</td>
				</td>
			</cfif>
			<tr>
				<td>#customers.first_name#</td>
				<td>#customers.last_name#</td>
				<td>
					<cfif #customers.price_code# eq "A">
						Cost + 10%
					<cfelseif #customers.price_code# eq "B">
						20% Off
					<cfelseif #customers.price_code# eq "C">
						20% Off
					<cfelseif #customers.price_code# eq "D">
						10% Off
					<cfelseif #customers.price_code# eq "E">
						15% Off
					<cfelseif #customers.price_code# eq "F">
						10% Off
					<cfelseif #customers.price_code# eq "G">
						Cost + 20%
					<cfelseif #customers.price_code# eq "H">
						Cost + 20%
					<cfelse>
						No Discount
					</cfif>
				</td>
				<td>
					<cfif #customers.price_code# eq "A">
						FREE
					<cfelseif #customers.price_code# eq "B">
						FREE
					<cfelseif #customers.price_code# eq "C">
						20% Off
					<cfelseif #customers.price_code# eq "D">
						20% Off
					<cfelseif #customers.price_code# eq "E">
						20% Off
					<cfelseif #customers.price_code# eq "F">
						10% Off
					<cfelseif #customers.price_code# eq "G">
						FREE
					<cfelseif #customers.price_code# eq "H">
						No Discount
					<cfelse>
						No Discount
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>