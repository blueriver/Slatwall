<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	
	<cfset attributes.tabid = "comments" />
	<cfset attributes.text = attributes.hibachiScope.rbKey("entity.comment_plural") />
	<cfset attributes.view = "" />
	<cfset attributes.property = "" />
	<cfset attributes.count = arrayLen(attributes.object.getComments()) />
	
	<cfsavecontent variable="attributes.tabcontent" >
		<div class="tab-pane" id="tabComments">
			<cf_SlatwallAdminCommentsDisplay object="#attributes.object#" />
		</div>
	</cfsavecontent>
	
	<cfassociate basetag="cf_HibachiTabGroup" datacollection="tabs">
</cfif>