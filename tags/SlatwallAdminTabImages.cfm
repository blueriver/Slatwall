<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	
	<cfset attributes.tabid = "images" />
	<cfset attributes.text = attributes.hibachiScope.rbKey("entity.image_plural") />
	<cfset attributes.view = "" />
	<cfset attributes.property = "" />
	<cfset attributes.count = arrayLen(attributes.object.getImages()) />
	
	<cfsavecontent variable="attributes.tabcontent" >
		<div class="tab-pane" id="tabImages">
			<cf_SlatwallAdminImagesDisplay object="#attributes.object#" />
		</div>
	</cfsavecontent>
	
	<cfassociate basetag="cf_HibachiTabGroup" datacollection="tabs">
</cfif>