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
			<cfoutput>
				<cfif arrayLen(attributes.object.getComments()) gt 0>
					<table class="table table-striped table-bordered table-condensed">
						<tr>
							<th class="primary">#attributes.hibachiScope.rbKey("entity.comment.comment")#</th>
							<th>#attributes.hibachiScope.rbKey("entity.comment.publicFlag")#</th>
							<th>#attributes.hibachiScope.rbKey("entity.define.createdByAccount")#</th>
							<th>#attributes.hibachiScope.rbKey("entity.define.createdDateTime")#</th>
							<th class="admin1">&nbsp;</th>
						</tr>
						<cfloop array="#attributes.object.getComments()#" index="commentRelationship">
							<tr>
								<cfif commentRelationship['referencedRelationshipFlag']>
									<cfset originalEntity = commentRelationship['comment'].getPrimaryRelationship().getRelationshipEntity() />
									<cfswitch expression="#originalEntity.getClassName()#">
										<cfcase value="Order">
											<td class="primary highlight-ltblue" colspan="2">This #attributes.object.getClassName()# was referenced in a comment on <a href="?slatAction=order.detailorder&orderID=#originalEntity.getOrderID()###tabComments">Order Number #originalEntity.getOrderNumber()#</a></td>
											<td class="highlight-ltblue">#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
											<td class="highlight-ltblue">#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
											<td class="admin1 highlight-ltblue">&nbsp;</td>
										</cfcase>
										<cfdefaultcase>
											<td class="primary" colspan="5">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
										</cfdefaultcase>
									</cfswitch>
								<cfelse>
									<td class="primary" style="white-space:normal;">#commentRelationship['comment'].getCommentWithLinks()#</td>
									<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getPublicFlag(), "yesno")#</td>
									<td><cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif></td>
									<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
									<td class="admin1"><cf_HibachiActionCaller action="admin:entity.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&sRenderItem=detail#attributes.object.getClassName()#&fRenderItem=detail#attributes.object.getClassName()#" modal="true" class="btn btn-mini" icon="pencil" iconOnly="true" /></td>
								</cfif>
							</tr>
						</cfloop>
					</table>
				</cfif>
				<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&sRenderItem=detail#attributes.object.getClassName()#&fRenderItem=detail#attributes.object.getClassName()#" modal="true" class="btn btn-inverse" icon="plus icon-white" />
			</cfoutput>
		</div>
	</cfsavecontent>
	
	<cfassociate basetag="cf_HibachiTabGroup" datacollection="tabs">
</cfif>