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
<cfparam name="attributes.returnURL" type="string" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="comments">
			<div class="commentList">
				<cfif arrayLen(attributes.entity.getComments()) gt 0>
					<table class="listing-grid stripe">
						<tr>
							<th>#request.muraScope.slatwall.rbKey("define.createdDateTime")#</th>
							<th>#request.muraScope.slatwall.rbKey("define.createdByAccount")#</th>
							<th class="varWidth">#request.muraScope.Slatwall.rbKey("entity.comment.comment")#</th>
						</tr>
						<cfloop array="#attributes.entity.getComments()#" index="commentRelationship">
							<tr>
								<cfif commentRelationship['referencedRelationshipFlag']>
									<cfset originalEntity = commentRelationship['comment'].getPrimaryRelationship().getRelationshipEntity() />
									<cfswitch expression="#originalEntity.getClassName()#">
										<cfcase value="Order">
											<td class="highlighted">#request.muraScope.slatwall.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
											<td class="highlighted">#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
											<td class="varWidth highlighted" colspan="3">This #attributes.entity.getClassName()# was referenced in a comment on <a href="?slatAction=order.detail&orderID=#originalEntity.getOrderID()#">Order Number #originalEntity.getOrderNumber()#</a>.
										</cfcase>
										<cfdefaultcase>
											<td class="varWidth" colspan="3">??? Programming Issue for #originalEntity.getClassName()# entity comments</td>
										</cfdefaultcase>
									</cfswitch>
								<cfelse>
									<td>#request.muraScope.slatwall.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</td>
									<td>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</td>
									<td class="varWidth">#commentRelationship['comment'].getCommentWithLinks()#</td>
								</cfif>
							</tr>
						</cfloop>
					</table>
				</cfif>
			</div>
			<div class="newComment">
				<form name="addComment" method="post" action="?slatAction=admin:comment.createComment" />
					<input type="hidden" name="commentRelationships[1].commentRelationshipID" value="" />
					<input type="hidden" name="commentRelationships[1].#attributes.entity.getClassName()#.#attributes.entity.getPrimaryIDPropertyName()#" value="#attributes.entity.getPrimaryIDValue()#" />
					<input type="hidden" name="returnURL" value="#attributes.returnURL#" />
					<dl class="oneColumn">
						<dt>New Comment</dt>
						<dd><cf_SlatwallFormField fieldType="textarea" fieldName="comment"> </dd>
					</dl>
					<button type="submit">Add Comment</button>
				</form>
			</div>
		</div>
	</cfoutput>
</cfif>