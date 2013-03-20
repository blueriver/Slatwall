<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.selector" type="string" />
	<cfparam name="attributes.showValues" type="string" default="1">
	<cfparam name="attributes.valueAttribute" type="string" default="" />
	
	<cfset id = createUUID() />
	
	<cfoutput><div id="#id#" class="hibachi-display-toggle hide" data-hibachi-selector="#attributes.selector#" data-hibachi-show-values="#attributes.showValues#" data-hibachi-value-attribute="#attributes.valueAttribute#"></cfoutput>
<cfelse>
	</div>
</cfif>
