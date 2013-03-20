<cfif thisTag.executionMode is "end">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	<cfparam name="attributes.attributeSet" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	<cfset attributes.tabid = "attSet" & attributes.attributeSet.getAttributeSetCode() />
	<cfset attributes.text = attributes.attributeSet.getAttributeSetName() />
	<cfset attributes.view = "" />
	<cfset attributes.property = "" />
	<cfset attributes.count = 0 />
	
	<cfsavecontent variable="attributes.tabcontent">
		<div class="tab-pane" id="attSet#attributes.attributeSet.getAttributeSetCode()#">
			<cf_HibachiPropertyRow>
				<cf_HibachiPropertyList>
					<cf_SlatwallAdminAttributeSetDisplay attributeSet="#attributes.attributeSet#" entity="#attributes.object#" edit="#attributes.edit#" />
				</cf_HibachiPropertyList>
			</cf_HibachiPropertyRow>
		</div>
	</cfsavecontent>
	
	<cfassociate basetag="cf_HibachiTabGroup" datacollection="tabs">
</cfif>