<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.header" type="string" default="" />
	
	<cfoutput>
		<tr>
			<td colspan="2" class="table-section">#attributes.header#</td>
		</tr>
	</cfoutput>
</cfif>
