<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.object" type="any" default="" />
	<cfparam name="attributes.pageTitle" type="string" default="#request.context.pageTitle#" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	<cfparam name="attributes.createModal" type="boolean" default="false" />
	<cfparam name="attributes.createAction" type="string" default="#request.context.crudActionDetails.createAction#" />
	<cfparam name="attributes.createQueryString" type="string" default="" />
	
	<cfparam name="attributes.backAction" type="string" default="#request.context.crudActionDetails.listAction#" />
	<cfparam name="attributes.backQueryString" type="string" default="" />
	
	<cfparam name="attributes.cancelAction" type="string" default="#request.context.crudActionDetails.cancelAction#" />
	<cfparam name="attributes.cancelQueryString" type="string" default="" />
	
	<cfparam name="attributes.showcreate" type="boolean" default="true" />
	<cfparam name="attributes.showedit" type="boolean" default="true" />
	<cfparam name="attributes.showdelete" type="boolean" default="true" />
<cfelse>
	<cfif not structKeyExists(request.context, "modal") or not request.context.modal>
		<cfoutput>
			<div class="actionnav well well-small">
				<div class="row-fluid">
					<div class="span4">
						<h1>#attributes.pageTitle#</h1>
					</div>
					<div class="span8">
						<div class="btn-toolbar">
							<!--- Listing --->
							<cfif attributes.type eq "listing" >
								<cfparam name="request.context.keywords" default="" />
								
								<form name="search" class="action-bar-search btn-group" action="/plugins/Slatwall/" method="get">
									<input type="hidden" name="slatAction" value="#request.context.crudActionDetails.thisAction#" />
									<input type="text" name="keywords" value="#request.context.keywords#" placeholder="#request.slatwallScope.rbKey('define.search')# #attributes.pageTitle#" data-tableid="LD#replace(attributes.object.getSavedStateID(),'-','','all')#">
								</form>
								
								<div class="btn-group">
									<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #request.slatwallScope.rbKey('define.actions')# <span class="caret"></span></button>
									<ul class="dropdown-menu">
										<cf_HibachiActionCaller action="#request.context.crudActionDetails.exportAction#" text="#request.slatwallScope.rbKey('define.exportlist')#" type="list">
										<!---#thistag.generatedcontent#--->
									</ul>
								</div>

								<cfif len(attributes.createAction) or len(thistag.generatedcontent)>
									<div class="btn-group">
										<cfif listLen(attributes.createAction) eq 1>
											<cfif attributes.createModal>
												<cf_HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white" modal="true">
											<cfelse>
												<cf_HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white">
											</cfif>
										<cfelse>
											<cf_HibachiActionCallerDropdown title="#request.slatwallScope.rbKey('define.add')#" icon="plus" dropdownClass="pull-right">
												<cfloop list="#attributes.createAction#" index="action">
													<cf_HibachiActionCaller action="#action#" type="list" queryString="#attributes.createQueryString#" modal="#attributes.createModal#" /> 
												</cfloop>
												#thistag.generatedcontent#
											</cf_HibachiActionCallerDropdown>
										</cfif>
									</div>
								</cfif>
							<!--- Detail --->
							<cfelseif attributes.type eq "detail">
								<!--- set default value for cancel action querystring --->
								<cfset attributes.cancelQueryString = (len(trim(attributes.cancelQueryString)) gt 0) ? attributes.cancelQueryString : "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" />
								<div class="btn-group">
									<cf_HibachiActionCaller action="#attributes.backAction#" queryString="#attributes.backQueryString#" class="btn" icon="arrow-left">
								</div>
								<cfif !attributes.object.isNew() && len(thistag.generatedcontent)>
									<div class="btn-group">
										<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #request.slatwallScope.rbKey('define.actions')# <span class="caret"></span></button>
										<ul class="dropdown-menu pull-right">
											#thistag.generatedcontent#
										</ul>
									</div>
								</cfif>
								<div class="btn-group">
									<cfif attributes.edit>
										<cfif not attributes.object.isNew() and attributes.showdelete>
											<cf_HibachiActionCaller action="#request.context.crudActionDetails.deleteAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.slatwallScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#attributes.object.isNotDeletable()#">
										</cfif>
										<cf_HibachiActionCaller action="#attributes.cancelAction#" querystring="#attributes.cancelQueryString#" text="#request.slatwallScope.rbKey('define.cancel')#" class="btn btn-inverse" icon="remove icon-white">
										<cf_HibachiActionCaller action="#request.context.crudActionDetails.saveAction#" text="#request.slatwallScope.rbKey('define.save')#" class="btn btn-success" type="button" submit="true" icon="ok icon-white">
									<cfelse>
										<cfif attributes.showdelete>
											<cf_HibachiActionCaller action="#request.context.crudActionDetails.deleteAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.slatwallScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#attributes.object.isNotDeletable()#">
										</cfif>
										<cfif attributes.showedit>
											<cf_HibachiActionCaller action="#request.context.crudActionDetails.editAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#request.slatwallScope.rbKey('define.edit')#" class="btn btn-primary" icon="pencil icon-white" submit="true" disabled="#attributes.object.isNotEditable()#">
										</cfif>
									</cfif>
								</div>
							<!--- Process --->
							<cfelseif attributes.type eq "process">
								<div class="btn-group">
									<button type="submit" class="btn btn-primary"><i class="icon-cog icon-white"></i> #request.slatwallScope.rbKey('define.process')#</button>
								</div>
							</cfif>
							<cfset thistag.generatedcontent = "" />
						</div>
					</div>
				</div>
			</div>
		</cfoutput>
		<cf_HibachiMessageDisplay />
	<cfelse>
		<cfset thistag.generatedcontent = "" />
	</cfif>
	
</cfif>