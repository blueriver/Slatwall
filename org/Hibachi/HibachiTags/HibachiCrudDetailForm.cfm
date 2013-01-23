<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.object" type="any" />
	<cfparam name="attributes.saveAction" type="string" default="#request.context.crudActionDetails.saveaction#" />
	<cfparam name="attributes.saveActionQueryString" type="string" default="" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	<cfparam name="attributes.enctype" type="string" default="application/x-www-form-urlencoded">
	<cfparam name="attributes.sRedirectURL" type="string" default="#request.context.crudActionDetails.sRedirectURL#">
	<cfparam name="attributes.sRedirectAction" type="string" default="#request.context.crudActionDetails.sRedirectAction#">
	<cfparam name="attributes.sRenderCrudAction" type="string" default="#request.context.crudActionDetails.sRenderCrudAction#">
	<cfparam name="attributes.fRedirectURL" type="string" default="#request.context.crudActionDetails.fRedirectURL#">
	<cfparam name="attributes.fRedirectAction" type="string" default="#request.context.crudActionDetails.fRedirectAction#">
	<cfparam name="attributes.fRenderCrudAction" type="string" default="#request.context.crudActionDetails.fRenderCrudAction#">
	
	<cfoutput>
		<cfif attributes.edit>
			<cfif len(attributes.saveActionQueryString)>
				<form method="post" action="?s=1&#attributes.saveActionQueryString#" class="form-horizontal" enctype="#attributes.enctype#">
			<cfelse>
				<form method="post" action="?s=1" class="form-horizontal" enctype="#attributes.enctype#">
			</cfif>
			<input type="hidden" name="slatAction" value="#attributes.saveaction#" />
			<input type="hidden" name="#attributes.object.getPrimaryIDPropertyName()#" value="#attributes.object.getPrimaryIDValue()#" />
			<cfif len(attributes.sRedirectURL)><input type="hidden" name="sRedirectURL" value="#attributes.sRedirectURL#" /></cfif>
			<cfif len(attributes.sRedirectAction)><input type="hidden" name="sRedirectAction" value="#attributes.sRedirectAction#" /></cfif>
			<cfif len(attributes.sRenderCrudAction)><input type="hidden" name="sRenderCrudAction" value="#attributes.sRenderCrudAction#" /></cfif>
			<cfif len(attributes.fRedirectURL)><input type="hidden" name="fRedirectURL" value="#attributes.fRedirectURL#" /></cfif>
			<cfif len(attributes.fRedirectAction)><input type="hidden" name="fRedirectAction" value="#attributes.fRedirectAction#" /></cfif>
			<cfif len(attributes.fRenderCrudAction)><input type="hidden" name="fRenderCrudAction" value="#attributes.fRenderCrudAction#" /></cfif>
		</cfif>
		<cfif structKeyExists(request.context, "modal") and request.context.modal>
			<div class="modal-header">
				<a class="close" data-dismiss="modal">&times;</a>
				<h3>#request.context.pageTitle#</h3>
			</div>
			<div class="modal-body">
		</cfif>
	</cfoutput>
<cfelse>
	<cfoutput>
		<cfif structKeyExists(request.context, "modal") and request.context.modal>
			</div>
			<div class="modal-footer">
				<cfif attributes.edit>
					<div class="btn-group">
						<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-remove icon-white"></i> #request.slatwallScope.rbKey('define.cancel')#</a>
						<button type="submit" class="btn btn-success"><i class="icon-ok icon-white"></i> #request.slatwallScope.rbKey('define.save')#</button>
					</div>
				</cfif>
			</div>
		</cfif>
		<cfif attributes.edit>
			</form>
		</cfif>
	</cfoutput>
</cfif>