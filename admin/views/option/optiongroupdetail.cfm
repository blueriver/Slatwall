<cfparam name="rc.edit" default="false" />

<cfoutput>
<ul id="navTask">
    <cfif !rc.edit><cf_ActionCaller action="admin:option.editoptiongroup" querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#" type="list"></cfif>
	<cf_ActionCaller action="admin:option.list" type="list">
</ul>
<cfif rc.edit>
<form name="OptionGroupForm" id="OptionGroupForm" enctype="multipart/form-data" action="?action=admin:option.processOptionGroupForm" method="post">
<input type="hidden" id="optionGroupID" name="optionGroupID" value="#rc.optionGroup.getOptionGroupID()#" />
</cfif>
    <dl class="oneColumn">
    	<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupName" edit="#rc.edit#" title="#rc.$.Slatwall.rbKey('entity.optiongroup.optiongroupname')#" />
		<cfif rc.edit>
		<dt>
			<a href="##" class="tooltip"><label for="optionGroupImageFile">#rc.$.Slatwall.rbKey("admin.option.selectoptiongroupimage")#</label><span>#rc.$.Slatwall.rbKey("option.formimagehint")#</span></a>	
		</dt>
		<dd id="editImage">
			<input type="file" id="optionGroupImageFile" name="optionGroupImageFile" class="text">
		</dd>
		</cfif>
		<cfif len(rc.OptionGroup.getOptionGroupImage())>
		<dt>
			#rc.$.Slatwall.rbKey("option.optiongroupimage")#
		</dt>
		<dd>
			<img src="#rc.$.siteConfig('assetPath')#/images/Slatwall/#rc.OptionGroup.getImagePath()#" alt="#rc.OptionGroup.getOptionGroupName()#" />
		<cfif rc.edit>
			<input type="checkbox" name="removeImage" value="1" id="chkRemoveImage"> <label for="chkRemoveImage">#rc.$.Slatwall.rbKey("option.removeimage")#</label>
		</cfif>
		</dd>
		</cfif>
		<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupDescription" edit="#rc.edit#" title="#rc.$.Slatwall.rbKey('entity.optiongroup.optiongroupdescription')#" toggle="show" toggletext="#rc.$.Slatwall.rbKey('sitemanager.content.fields.expand')#,#rc.$.Slatwall.rbKey('sitemanager.content.fields.close')#" editType="wysiwyg" />
	</dl>
	#view("option/optionlist")#
<cfif rc.edit>
<fieldset id="buttons">
<p><input type="button" class="button" id="addOption" value="#rc.$.Slatwall.rbKey('option.addoption')#" />
<input type="button" class="button" id="remOption" value="#rc.$.Slatwall.rbKey('option.removeoption')#" disabled="true" /></p>
<p><input type="submit" value="#rc.$.Slatwall.rbKey('option.save')#" /></p>
</fieldset>
</form>
#view("option/inc/optionformtemplate")#
</cfif>
</cfoutput>