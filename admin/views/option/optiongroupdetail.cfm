<cfparam name="rc.edit" default="false" />

<cfoutput>
<ul id="navTask">
    <cfif !rc.edit><cf_ActionLink action="admin:option.editoptiongroup" querystring="optiongroupid=#rc.optionGroup.getOptionGroupID()#" listitem="true"></cfif>
	<cf_ActionLink action="admin:option.list" listitem="true">
</ul>
<cfif rc.edit>
<form name="OptionGroupForm" id="OptionGroupForm" enctype="multipart/form-data" action="?action=admin:option.processOptionGroupForm" method="post">
<input type="hidden" id="optionGroupID" name="optionGroupID" value="#rc.optionGroup.getOptionGroupID()#" />
</cfif>
    <dl class="oneColumn">
    	<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupName" edit="#rc.edit#" title="#rc.$w.rbKey('entity.optiongroup.optiongroupname')#" />
		<cfif rc.edit>
		<dt>
			<a href="##" class="tooltip"><label for="optionGroupImageFile">#rc.$w.rbKey("admin.option.selectoptiongroupimage")#</label><span>#rc.$w.rbKey("option.formimagehint")#</span></a>	
		</dt>
		<dd id="editImage">
			<input type="file" id="optionGroupImageFile" name="optionGroupImageFile" class="text">
		</dd>
		</cfif>
		<cfif len(rc.OptionGroup.getOptionGroupImage())>
		<dt>
			#rc.$w.rbKey("option.optiongroupimage")#
		</dt>
		<dd>
			<img src="#rc.$.siteConfig('assetPath')#/images/Slatwall/#rc.OptionGroup.getImagePath()#" alt="#rc.OptionGroup.getOptionGroupName()#" />
		<cfif rc.edit>
			<input type="checkbox" name="removeImage" value="1" id="chkRemoveImage"> <label for="chkRemoveImage">#rc.$w.rbKey("option.removeimage")#</label>
		</cfif>
		</dd>
		</cfif>
		<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupDescription" edit="#rc.edit#" title="#rc.$w.rbKey('entity.optiongroup.optiongroupdescription')#" toggle="show" toggletext="#rc.$w.rbKey('sitemanager.content.fields.expand')#,#rc.$w.rbKey('sitemanager.content.fields.close')#" editType="wysiwyg" />
	</dl>
	#view("option/optionlist")#
<cfif rc.edit>
<fieldset id="buttons">
<p><input type="button" class="button" id="addOption" value="#rc.$w.rbKey('option.addoption')#" />
<input type="button" class="button" id="remOption" value="#rc.$w.rbKey('option.removeoption')#" disabled="true" /></p>
<p><input type="submit" value="#rc.$w.rbKey('option.save')#" /></p>
</fieldset>
</form>
#view("option/inc/optionformtemplate")#
</cfif>
</cfoutput>