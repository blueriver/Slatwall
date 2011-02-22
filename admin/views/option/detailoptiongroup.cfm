<cfparam name="rc.edit" default="false" />
<cfparam name="rc.optiongroup" type="any" />
 
<cfoutput>
<ul id="navTask">
	<cf_ActionCaller action="admin:option.create" querystring="optiongroupid=#rc.optiongroup.getoptiongroupid()#" type="list">
    <cfif !rc.edit><cf_ActionCaller action="admin:option.editoptiongroup" querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#" type="list"></cfif>
	<cf_ActionCaller action="admin:option.list" type="list">
</ul>
<cfif rc.edit>
<form name="OptionGroupForm" id="OptionGroupForm" enctype="multipart/form-data" action="#buildURL(action='admin:option.saveoptiongroup')#" method="post">
<input type="hidden" id="optionGroupID" name="optionGroupID" value="#rc.optionGroup.getOptionGroupID()#" />
</cfif>
    <dl class="oneColumn optionDetail">
    	<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupName" edit="#rc.edit#" title="#rc.$.Slatwall.rbKey('entity.optiongroup.optiongroupname')#" />
		<cfif rc.edit>
		<!--- if editing, display field for image uploading --->
		<dt>
			<a href="##" class="tooltip"><label for="optionGroupImageFile">#rc.$.Slatwall.rbKey("admin.option.selectoptiongroupimage")#</label><span>#rc.$.Slatwall.rbKey("admin.option.optiongroupimagehint")#</span></a>	
		</dt>
		<dd id="editImage">
			<input type="file" id="optionGroupImageFile" name="optionGroupImageFile" class="text">
		</dd>
		</cfif>
		<cfif len(rc.OptionGroup.getOptionGroupImage())>
		<!--- if editing, and optiongroup has an image, display it  --->
		<dt>
			#rc.$.Slatwall.rbKey("entity.optiongroup.optiongroupimage")#
		</dt>
		<dd>
			<img src="#rc.$.siteConfig('assetPath')#/images/Slatwall/#rc.OptionGroup.getImagePath()#" alt="#rc.OptionGroup.getOptionGroupName()#" />
		<cfif rc.edit>
			<input type="checkbox" name="removeImage" value="1" id="chkRemoveImage"> <label for="chkRemoveImage">#rc.$.Slatwall.rbKey("admin.option.removeimage")#</label>
		</cfif>
		</dd>
		</cfif>
		<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupDescription" edit="#rc.edit#" toggle="show" toggletext="#rc.$.Slatwall.rbKey('sitemanager.content.fields.expand')#,#rc.$.Slatwall.rbKey('sitemanager.content.fields.close')#" editType="wysiwyg" />
	</dl>
<cfif rc.edit>
<cf_actionCaller action="admin:option.list" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
<cf_ActionCaller action="admin:option.saveoptiongroup" type="submit">
</form>
<cfelse>
<h4>#rc.$.Slatwall.rbKey('entity.optiongroup.options')#</h4>
<ul id="optionList">
<cfloop array="#rc.optionGroup.getOptions()#" index="local.thisOption">
	<li>#local.thisOption.getOptionName()#</li>
</cfloop>
</ul>
</cfif>
</cfoutput>