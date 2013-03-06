<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.object" type="any" default="" />
	<cfparam name="attributes.pageTitle" type="string" default="#request.context.pageTitle#" />
	<cfparam name="attributes.edit" type="boolean" default="#request.context.edit#" />
	
	<!--- Action Callers (top buttons) --->
	<cfparam name="attributes.showcancel" type="boolean" default="true" />
	<cfparam name="attributes.showcreate" type="boolean" default="true" />
	<cfparam name="attributes.showedit" type="boolean" default="true" />
	<cfparam name="attributes.showdelete" type="boolean" default="true" />
	
	<!--- Old Action Callers Methodologies (top buttons) --->
	<cfparam name="attributes.createModal" type="boolean" default="false" />
	<cfparam name="attributes.createAction" type="string" default="#request.context.entityActionDetails.createAction#" />
	<cfparam name="attributes.createQueryString" type="string" default="" />
	
	<cfparam name="attributes.backAction" type="string" default="#request.context.entityActionDetails.listAction#" />
	<cfparam name="attributes.backQueryString" type="string" default="" />
	
	<cfparam name="attributes.cancelAction" type="string" default="#request.context.entityActionDetails.cancelAction#" />
	<cfparam name="attributes.cancelQueryString" type="string" default="" />
	
	<cfparam name="attributes.deleteAction" type="string" default="#request.context.entityActionDetails.deleteAction#" />
	<cfparam name="attributes.deleteQueryString" type="string" default="" />
	
<cfelse>
	<cfif not structKeyExists(request.context, "modal") or not request.context.modal>
		<cfoutput>
			<div class="actionnav well well-small">
				<div class="row-fluid">
					<div class="span4">
						<!--- Page Title --->
						<h1>#attributes.pageTitle#</h1>
					</div>
					<div class="span8">
						<div class="btn-toolbar">
							<!--- Listing --->
							<cfif attributes.type eq "listing" >
								<cfparam name="request.context.keywords" default="" />
								
								<!--- Listing: Search --->
								<form name="search" class="action-bar-search btn-group" action="/" method="get">
									<input type="hidden" name="slatAction" value="#request.context.entityActionDetails.thisAction#" />
									<input type="text" name="keywords" value="#request.context.keywords#" placeholder="#attributes.hibachiScope.rbKey('define.search')# #attributes.pageTitle#" data-tableid="LD#replace(attributes.object.getSavedStateID(),'-','','all')#">
								</form>
								
								<!--- Listing: Actions --->
								<div class="btn-group">
									<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #attributes.hibachiScope.rbKey('define.actions')# <span class="caret"></span></button>
									<ul class="dropdown-menu">
										<cf_HibachiActionCaller action="#request.context.entityActionDetails.exportAction#" text="#attributes.hibachiScope.rbKey('define.exportlist')#" type="list">
									</ul>
								</div>
								
								<!--- Listing: Create --->
								<cfif attributes.showCreate>
									<div class="btn-group">
										<cfif structKeyExists(thistag, "createActions") && arrayLen(thistag.createActions) && structKeyExists(thistag.createActions[1], "generatedContent") && len(thistag.createActions[1].generatedContent)>
											#thistag.createActions[1].generatedContent#
										<cfelse>
											<cfif attributes.createModal>
												<cf_HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white" modal="true">
											<cfelse>
												<cf_HibachiActionCaller action="#attributes.createAction#" queryString="#attributes.createQueryString#" class="btn btn-primary" icon="plus icon-white">
											</cfif>
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
										<button class="btn dropdown-toggle" data-toggle="dropdown"><i class="icon-list-alt"></i> #attributes.hibachiScope.rbKey('define.actions')# <span class="caret"></span></button>
										<ul class="dropdown-menu pull-right">
											#thistag.generatedcontent#
										</ul>
									</div>
								</cfif>
								<div class="btn-group">
									
									<cfset local.deleteErrors = attributes.object.validate(context="delete") />
									<cfset local.deleteDisabled = local.deleteErrors.hasErrors() />
									<cfset local.deleteDisabledText = local.deleteErrors.getAllErrorsHTML() />
									
									<cfif attributes.edit>
										<cfif not attributes.object.isNew() and attributes.showdelete>
											<cfset attributes.deleteQueryString = listAppend(attributes.deleteQueryString, "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#", "&") />
											<cf_HibachiActionCaller action="#attributes.deleteAction#" querystring="#attributes.deleteQueryString#" text="#attributes.hibachiScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#local.deleteDisabled#" disabledText="#local.deleteDisabledText#">
										</cfif>
										<cf_HibachiActionCaller action="#attributes.cancelAction#" querystring="#attributes.cancelQueryString#" text="#attributes.hibachiScope.rbKey('define.cancel')#" class="btn btn-inverse" icon="remove icon-white">
										<cf_HibachiActionCaller action="#request.context.entityActionDetails.saveAction#" text="#attributes.hibachiScope.rbKey('define.save')#" class="btn btn-success" type="button" submit="true" icon="ok icon-white">
									<cfelse>
										<cfif attributes.showdelete>
											<cfset attributes.deleteQueryString = listAppend(attributes.deleteQueryString, "#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#", "&") />
											<cf_HibachiActionCaller action="#attributes.deleteAction#" querystring="#attributes.deleteQueryString#" text="#attributes.hibachiScope.rbKey('define.delete')#" class="btn btn-inverse" icon="trash icon-white" confirm="true" disabled="#local.deleteDisabled#" disabledText="#local.deleteDisabledText#">
										</cfif>
										<cfif attributes.showedit>
											<cf_HibachiActionCaller action="#request.context.entityActionDetails.editAction#" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#" text="#attributes.hibachiScope.rbKey('define.edit')#" class="btn btn-primary" icon="pencil icon-white" submit="true" disabled="#attributes.object.isNotEditable()#">
										</cfif>
									</cfif>
								</div>
							<!--- Process --->
							<cfelseif attributes.type eq "process">
								<div class="btn-group">
									<button type="submit" class="btn btn-primary"><i class="icon-cog icon-white"></i> #attributes.hibachiScope.rbKey('define.process')#</button>
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