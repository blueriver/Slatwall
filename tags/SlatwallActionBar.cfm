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
<cfif not structKeyExists(request.context, "modal") or not request.context.modal>
	<cfif thisTag.executionMode is "start">
		
		<cfparam name="attributes.type" type="string" />
		<cfparam name="attributes.object" type="any" />
		<cfparam name="attributes.edit" type="boolean" default="false" />
		<cfparam name="attributes.pageTitle" type="string" default="#request.context.pageTitle#" />
		
		<cfsilent>
			<cfif attributes.type eq "detail" and not attributes.object.isNew()>
				<cfset attributes.pageTitle &= " - #attributes.object.getSimpleRepresentation()#" />
			</cfif>
		</cfsilent>
	<cfelse>
		<cfoutput>
			<div class="actionnav well well-small">
				<div class="row-fluid">
					<div class="span6"><h1>#attributes.pageTitle#</h1></div>
					<div class="span6">
						<div class="btn-toolbar">
							<cfif attributes.type eq "listing" >
								<div class="btn-group">
									<button class="btn dropdown-toggle" data-toggle="dropdown">#request.context.$.slatwall.rbKey('define.show')# <span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li><a href="#attributes.object.buildURL('P:Show=10')#">10</a></li>
										<li><a href="#attributes.object.buildURL('P:Show=25')#">25</a></li>
										<li><a href="#attributes.object.buildURL('P:Show=50')#">50</a></li>
										<li><a href="#attributes.object.buildURL('P:Show=100')#">100</a></li>
										<li><a href="#attributes.object.buildURL('P:Show=500')#">500</a></li>
										<li><a href="#attributes.object.buildURL('P:Show=all')#">ALL</a></li>
									</ul>
								</div>
								<div class="btn-group">
									<button class="btn dropdown-toggle" data-toggle="dropdown">#request.context.$.slatwall.rbKey('define.actions')# <span class="caret"></span></button>
									<ul class="dropdown-menu">
										<cf_SlatwallActionCaller action="admin:export.list" queryString="savedStateID=#attributes.object.getSavedStateID()#" text="#request.context.$.slatwall.rbKey('define.exportlist')#" type="list">
										#thistag.generatedcontent#
									</ul>
								</div>
								<div class="btn-group">
									<cf_SlatwallActionCaller action="#request.context.createAction#" class="btn btn-primary">
								</div>
							<cfelseif attributes.type eq "detail">
								<div class="btn-group">
									<cf_SlatwallActionCaller action="#request.context.listAction#" text="#request.context.$.Slatwall.rbKey('define.backtolist')#" class="btn">
								</div>
								<cfif !attributes.object.isNew() && len(thistag.generatedcontent)>
									<div class="btn-group">
										<button class="btn dropdown-toggle" data-toggle="dropdown">#request.context.$.slatwall.rbKey('define.actions')# <span class="caret"></span></button>
										<ul class="dropdown-menu">
											#thistag.generatedcontent#	
										</ul>
									</div>
								</cfif>
								<div class="btn-group">
									<cfif request.context.edit>
										<cf_SlatwallActionCaller action="#request.context.cancelAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.context.$.Slatwall.rbKey('define.cancel')#" class="btn btn-inverse">
										<cf_SlatwallActionCaller action="#request.context.deleteAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.context.$.slatwall.rbKey('define.delete')#" class="btn btn-danger" confirm="true" disabled="#attributes.object.isNotDeletable()#">
										<cf_SlatwallActionCaller action="#request.context.saveAction#" text="#request.context.$.Slatwall.rbKey('define.save')#" class="btn btn-success" type="button" submit="true">
									<cfelse>
										<cf_SlatwallActionCaller action="#request.context.deleteAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.context.$.slatwall.rbKey('define.delete')#" class="btn btn-danger" confirm="true" disabled="#attributes.object.isNotDeletable()#">
										<cf_SlatwallActionCaller action="#request.context.editAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.context.$.Slatwall.rbKey('define.edit')#" class="btn btn-primary" submit="true">
									</cfif>
								</div>
							</cfif>
							<cfset thistag.generatedcontent = "" />
						</div>
					</div>
				</div>
			</div>
		</cfoutput>
		
		<cf_SlatwallMessageDisplay />
	</cfif>
</cfif>
