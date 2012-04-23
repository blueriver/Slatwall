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
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.allowComments" type="boolean" default="false"> 

<cfset variables.fw = caller.this />

<cfif (not isObject(attributes.object) || not attributes.object.isNew()) and (not structKeyExists(request.context, "modal") or not request.context.modal)>
	<cfif thisTag.executionMode is "end">
		<cfoutput>
			<cfparam name="thistag.tabs" default="#arrayNew(1)#" />
			<cfparam name="activeTab" default="system" />
			<cfif arrayLen(thistag.tabs)>
				<cfset activeTab = thistag.tabs[1].view />
			</cfif>
			<div class="tabbable tabs-left row-fluid">
				<div class="tabsLeft">
					<ul class="nav nav-tabs">
						<cfloop array="#thistag.tabs#" index="tab">
							<li <cfif activeTab eq tab.view>class="active"</cfif>><a href="##tab#listLast(tab.view, '/')#" data-toggle="tab">#request.slatwallScope.rbKey( replace( replace(tab.view, '/', '.', 'all') ,':','.','all' ) )#</a></li>
						</cfloop>
						<cfif isObject(attributes.object) && attributes.allowComments>
							<li><a href="##tabComments" data-toggle="tab">#request.slatwallScope.rbKey('entity.comment_plural')# <cfif arrayLen(attributes.object.getComments())><span class="badge">#arrayLen(attributes.object.getComments())#</span></cfif></a></li>
						</cfif>
						<cfif isObject(attributes.object)>
							<li><a href="##tabSystem" data-toggle="tab">#request.slatwallScope.rbKey('define.system')#</a></li>
						</cfif>
					</ul>
				</div>
				<div class="tabsRight">
					<div class="tab-content">
						<cfloop array="#thistag.tabs#" index="tab">
							<div <cfif activeTab eq tab.view>class="tab-pane active"<cfelse>class="tab-pane"</cfif> id="tab#listLast(tab.view, '/')#">
								<div class="row-fluid">
									#variables.fw.view(tab.view, {rc=request.context})#
								</div>
							</div>
						</cfloop>
						<cfif isObject(attributes.object) && attributes.allowComments>
							<div class="tab-pane" id="tabComments">
								<cf_SlatwallCommentDisplay entity="#attributes.object#" />
							</div>
						</cfif>
						<cfif isObject(attributes.object)>
							<div <cfif arrayLen(thistag.tabs)>class="tab-pane"<cfelse>class="tab-pane active"</cfif> id="tabSystem">
								<div class="row-fluid">
									<cf_SlatwallPropertyList> 
										<cf_SlatwallPropertyDisplay object="#attributes.object#" property="#attributes.object.getPrimaryIDPropertyName()#" />
										<cfif request.slatwallScope.setting('globalRemoteIDShowFlag') && attributes.object.hasProperty('remoteID')>
											<cf_SlatwallPropertyDisplay object="#attributes.object#" property="remoteID" edit="#iif(request.context.edit && request.slatwallScope.setting('globalRemoteIDEditFlag'), true, false)#" />
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
		</cfoutput>
	</cfif>
</cfif>