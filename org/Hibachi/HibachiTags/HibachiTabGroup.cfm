<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.allowComments" type="boolean" default="false">
<cfparam name="attributes.allowCustomAttributes" type="boolean" default="false">

<cfif (not isObject(attributes.object) || not attributes.object.isNew()) and (not structKeyExists(request.context, "modal") or not request.context.modal)>
	<cfif thisTag.executionMode is "end">
		
			<cfparam name="thistag.tabs" default="#arrayNew(1)#" />
			<cfparam name="activeTab" default="tabSystem" />
			
			<cfif arrayLen(thistag.tabs)>
				<cfset activeTab = thistag.tabs[1].tabid />
			</cfif>
			
			<div class="tabbable tabs-left row-fluid">
				<div class="tabsLeft">
					<ul class="nav nav-tabs">
						<cfloop array="#thistag.tabs#" index="tab">
							<cfoutput><li <cfif activeTab eq tab.tabid>class="active"</cfif>><a href="###tab.tabid#" data-toggle="tab">#tab.text#<cfif tab.count> <span class="badge">#tab.count#</span></cfif></a></li></cfoutput>
						</cfloop>
						<cfif isObject(attributes.object) && attributes.allowCustomAttributes>
							<cfloop array="#attributes.object.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
								<cfoutput><li><a href="##tab#lcase(attributeSet.getAttributeSetCode())#" data-toggle="tab">#attributeSet.getAttributeSetName()#</a></li></cfoutput>
							</cfloop>
						</cfif>
						<cfif isObject(attributes.object) && attributes.allowComments>
							<cfoutput><li><a href="##tabComments" data-toggle="tab">#attributes.hibachiScope.rbKey('entity.comment_plural')# <cfif arrayLen(attributes.object.getComments())><span class="badge">#arrayLen(attributes.object.getComments())#</span></cfif></a></li></cfoutput>
						</cfif>
						<cfif isObject(attributes.object)>
							<cfoutput><li><a href="##tabSystem" data-toggle="tab">#attributes.hibachiScope.rbKey('define.system')#</a></li></cfoutput>
						</cfif>
					</ul>
				</div>
				<div class="tabsRight">
					<div class="tab-content">
						<cfloop array="#thistag.tabs#" index="tab">
							<cfoutput>
								<div <cfif activeTab eq tab.tabid>class="tab-pane active"<cfelse>class="tab-pane"</cfif> id="#tab.tabid#">
									<div class="row-fluid">
										#request.context.fw.view(tab.view, {rc=request.context, params=tab.params})#
									</div>
								</div>
							</cfoutput>
						</cfloop>
						<cfif isObject(attributes.object) && attributes.allowCustomAttributes>
							<cfloop array="#attributes.object.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
								<cfoutput>
									<div class="tab-pane" id="tab#lcase(attributeSet.getAttributeSetCode())#">
										<div class="row-fluid">
											<cf_SlatwallAttributeSetDisplay attributeSet="#attributeSet#" entity="#attributes.object#" edit="#request.context.edit#" />
										</div>
									</div>
								</cfoutput>
							</cfloop>
						</cfif>
						<cfif isObject(attributes.object) && attributes.allowComments>
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
														<td>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
														<td>#attributes.hibachiScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
														<td class="admin1"><cf_HibachiActionCaller action="admin:comment.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&returnAction=#request.context.detailAction#" modal="true" class="btn btn-mini" icon="pencil" iconOnly="true" /></td>
													</cfif>
												</tr>
											</cfloop>
										</table>
									</cfif>
									<cf_HibachiActionCaller action="admin:comment.createcomment" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&returnAction=#request.context.detailAction#" modal="true" class="btn btn-inverse" icon="plus icon-white" />
								</cfoutput>
							</div>
						</cfif>
						<cfif isObject(attributes.object)>
							<div <cfif arrayLen(thistag.tabs)>class="tab-pane"<cfelse>class="tab-pane active"</cfif> id="tabSystem">
								<div class="row-fluid">
									<cf_SlatwallPropertyList> 
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="#attributes.object.getPrimaryIDPropertyName()#" />
										<cfif attributes.hibachiScope.setting('globalRemoteIDShowFlag') && attributes.object.hasProperty('remoteID')>
											<cf_SlatwallPropertyDisplay object="#attributes.object#" property="remoteID" edit="#iif(request.context.edit && attributes.hibachiScope.setting('globalRemoteIDEditFlag'), true, false)#" />
										</cfif>
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="createdDateTime" />
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="createdByAccount" />
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="modifiedDateTime" />
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="modifiedByAccount" />
									</cf_SlatwallPropertyList>
								</div>
							</div>
						</cfif>
					</div>
				</div>
			</div>
	</cfif>
</cfif>