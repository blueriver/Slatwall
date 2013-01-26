<cfdirectory action="list" directory="#expandPath('/Slatwall/model/entity')#" name="entities">

<cfdump var="#entities#" />
<cfloop query="entities">
	<cfif listLast(entities.name, ".") eq "cfc">
		<cfset thisEntity = createObject("component", "Slatwall.model.entity.#listFirst(entities.name, ".")#") />
		<cfdump var="#thisEntity.getThisMetaData()#" abort />
	</cfif>
</cfloop>