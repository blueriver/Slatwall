<cfset request.layout = false />
<cfdump var="#rc.optionsArray.options#" />
<cfoutput>
ArrayLen = #arrayLen(rc.optionsArray.options)#
</cfoutput>
<!---<cfset opts = rc.optionsStruct.options />

<cfscript>
	for( i in opts) {
		writeOutput(opts[i].label & "<br>");
	}
</cfscript>--->