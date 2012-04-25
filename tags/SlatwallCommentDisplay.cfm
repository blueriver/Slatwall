<!---

    Slatwall - An e-commerce plugin for Mura CMS
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

<!--- These are required Attributes --->
<cfparam name="attributes.entity" type="any" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<cfif arrayLen(attributes.entity.getComments()) gt 0>
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<th class="primary">#request.slatwallScope.rbKey("entity.comment.comment")#</th>
					<th>#request.slatwallScope.rbKey("entity.comment.publicFlag")#</th>
					<th>#request.slatwallScope.rbKey("entity.define.createdByAccount")#</th>
					<th>#request.slatwallScope.rbKey("entity.define.createdDateTime")#</th>
					<th class="admin1">&nbsp;</th>
				</tr>
				<cfloop array="#attributes.entity.getComments()#" index="commentRelationship">
					<tr>
						<cfif commentRelationship['referencedRelationshipFlag']>
							<cfset originalEntity = commentRelationship['comment'].getPrimaryRelationship().getRelationshipEntity() />
							<cfswitch expression="#originalEntity.getClassName()#">
								<cfcase value="Order">
									<td class="primary highlight-ltblue" colspan="2">This #attributes.entity.getClassName()# was referenced in a comment on <a href="?slatAction=order.detailorder&orderID=#originalEntity.getOrderID()###tabComments">Order Number #originalEntity.getOrderNumber()#</a></td>
									<td class="highlight-ltblue">#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
									<td class="highlight-ltblue">#request.slatwallScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
									<td class="admin1 highlight-ltblue">&nbsp;</td>
								</cfcase>
								<cfdefaultcase>
									<td class="primary" colspan="5">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
								</cfdefaultcase>
							</cfswitch>
						<cfelse>
							<td class="primary" style="white-space:normal;">#commentRelationship['comment'].getCommentWithLinks()#</td>
							<td>#request.slatwallScope.formatValue(commentRelationship['comment'].getPublicFlag(), "yesno")#</td>
							<td>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
							<td>#request.slatwallScope.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
							<td class="admin1"><cf_SlatwallActionCaller action="admin:comment.editcomment" queryString="commentID=#commentRelationship['comment'].getCommentID()#&#attributes.entity.getPrimaryIDPropertyName()#=#attributes.entity.getPrimaryIDValue()#&returnAction=#request.context.detailAction#" modal="true" class="btn btn-mini" icon="pencil" iconOnly="true" /></td>
						</cfif>
					</tr>
				</cfloop>
			</table>
		</cfif>
		<cf_SlatwallActionCaller action="admin:comment.createcomment" querystring="#attributes.entity.getPrimaryIDPropertyName()#=#attributes.entity.getPrimaryIDValue()#&returnAction=#request.context.detailAction#" modal="true" class="btn btn-primary" />
	</cfoutput>
</cfif>