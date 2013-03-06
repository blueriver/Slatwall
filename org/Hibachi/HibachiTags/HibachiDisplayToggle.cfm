<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.selector" type="string" />
	
	<cfparam name="attributes.hideValues" type="string" default="0">
	<cfparam name="attributes.showValues" type="string" default="1">
	
	<cfparam name="attributes.loadVisible" type="boolean" default="false" />
	
	<div class="hibachi-display-toggle">
<cfelse>
	</div>
</cfif>
