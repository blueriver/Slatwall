<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	<cfparam name="attributes.adminComments" type="boolean" default="true" /> 
	
	<cfif attributes.edit>
		<cfset attributes.redirectAction = "admin:entity.edit#attributes.object.getClassName()#" />
	<cfelse>
		<cfset attributes.redirectAction = "admin:entity.detail#attributes.object.getClassName()#" />
	</cfif>
	
	<div class="tab-pane" id="tabComments">
		<cfoutput>
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<th class="primary">#attributes.hibachiScope.rbKey("entity.comment.comment")#</th>
					<th>#attributes.hibachiScope.rbKey("entity.comment.publicFlag")#</th>
					<th>#attributes.hibachiScope.rbKey("entity.define.createdByAccount")#</th>
					<th>#attributes.hibachiScope.rbKey("entity.define.createdDateTime")#</th>
					<cfif attributes.adminComments><th class="admin1">&nbsp;</th></cfif>
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
									<cfif attributes.adminComments><td class="admin1 highlight-ltblue">&nbsp;</td></cfif>
								</cfcase>
								<cfdefaultcase>
									<td class="primary" colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
								</cfdefaultcase>
							</cfswitch>
						<cfelse>
							<td class="primary" style="white-space:normal;">#commentRelationship['comment'].getCommentWithLinks()#</td>
							<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getPublicFlag(), "yesno")#</td>
							<td><cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif></td>
							<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
							<cfif attributes.adminComments><td class="admin1"><cf_HibachiActionCaller action="admin:entity.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&sRenderItem=detail#attributes.object.getClassName()#&fRenderItem=detail#attributes.object.getClassName()#" modal="true" class="btn btn-mini" icon="pencil" iconOnly="true" /></td></cfif>
						</cfif>
					</tr>
				</cfloop>
				<cfif arrayLen(attributes.object.getComments()) eq 0>
					<tr><td colspan="<cfif attributes.adminComments>5<cfelse>4</cfif>" style="text-align:center;"><em>#attributes.hibachiScope.rbKey("entity.comment.norecords", {entityNamePlural=attributes.hibachiScope.rbKey('entity.comment_plural')})#</em></td></tr>
				</cfif>
			</table>
			<cfif attributes.adminComments>
				<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.slatAction#" modal="true" class="btn" icon="plus" />
			</cfif>
		</cfoutput>
	</div>
</cfif>