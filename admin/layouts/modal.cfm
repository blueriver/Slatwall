<cfoutput>
	<div class="modal-header">
		<cfset pageTitle = request.context.$.slatwall.rbKey(replace(request.context.slatAction,':','.','all')) />
		<cfif right(pageTitle, 8) eq "_missing">
			<cfif left(listLast(request.context.slatAction, "."), 4) eq "list">
				<cfset pageTitle = replace(request.context.$.slatwall.rbKey('admin.define.list'), "${itemEntityName}", request.context.$.slatwall.rbKey('entity.#request.context.itemEntityName#')) />
			<cfelseif left(listLast(request.context.slatAction, "."), 4) eq "edit">
				<cfset pageTitle = replace(request.context.$.slatwall.rbKey('admin.define.edit'), "${itemEntityName}", request.context.$.slatwall.rbKey('entity.#request.context.itemEntityName#')) />
			<cfelseif left(listLast(request.context.slatAction, "."), 6) eq "create">
				<cfset pageTitle = replace(request.context.$.slatwall.rbKey('admin.define.create'), "${itemEntityName}", request.context.$.slatwall.rbKey('entity.#request.context.itemEntityName#')) />
			<cfelseif left(listLast(request.context.slatAction, "."), 6) eq "detail">
				<cfset pageTitle = replace(request.context.$.slatwall.rbKey('admin.define.detail'), "${itemEntityName}", request.context.$.slatwall.rbKey('entity.#request.context.itemEntityName#')) />
			</cfif>
		</cfif>
		<a class="close" data-dismiss="modal">x</a>
		<h3>#pageTitle#</h3>
	</div>
	<div class="modal-body">
		#body#
	</div>
	<div class="modal-footer">
		<a href="##" class="btn close" data-dismiss="modal">Close</a>
	</div>
</cfoutput>