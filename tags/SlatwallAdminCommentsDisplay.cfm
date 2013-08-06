<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

	Notes:
	
--->
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