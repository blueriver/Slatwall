<cfparam name="rc.edit" default="false" />

<cfoutput>
<cfif rc.edit>
<form name="OptionGroupForm" id="OptionGroupForm" enctype="multipart/form-data" action="?action=admin:option.processOptionGroupForm" method="post">
<input type="hidden" id="optionGroupID" name="optionGroupID" value="#rc.optionGroup.getOptionGroupID()#" />
<cfelse>
<ul id="navTask">
    <li><a href="#buildURL(action='admin:option.optionGroupForm',querystring='optionGroupID=#rc.OptionGroup.getOptionGroupID()#')#">#rc.rbFactory.getKey("option.editoptiongroup")#</a></li>
</ul>
 </cfif>
    <dl class="oneColumn">
    	<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupName" edit="#rc.edit#" title="#rc.rbFactory.getKey('option.optiongroupname')#" />
		<dt>
		<cfif rc.edit>
			<a href="##" class="tooltip"><label for="optionGroupImageFile">#rc.rbFactory.getKey("option.selectoptiongroupimage")#</label><span>Associate an image for this option Group. Supported Formats: JPG,PNG.</span></a>	
		<cfelse>
			#rc.rbFactory.getKey("option.optiongroupimage")#
		</cfif>
		</dt>
		<cfif rc.edit>
		<dd id="editImage">
			<input type="file" id="optionGroupImageFile" name="optionGroupImageFile" class="text">
		</dd>
		</cfif>
		<cfif len(rc.OptionGroup.getOptionGroupImage())>
		<dd>
			<img src="#rc.$.siteConfig('assetPath')#/images/Slatwall/#rc.OptionGroup.getImagePath()#" alt="#rc.OptionGroup.getOptionGroupName()#" />
		<cfif rc.edit>
			<input type="checkbox" name="removeImage" value="1" id="chkRemoveImage"> <label for="chkRemoveImage">Remove current image</label>
		</cfif>
		</dd>
		</cfif>
		<cf_PropertyDisplay object="#rc.OptionGroup#" property="OptionGroupDescription" edit="#rc.edit#" title="#rc.rbFactory.getKey('option.optiongroupdescription')#" toggle="show" toggletext="#rc.rbfactory.getKey('sitemanager.content.fields.expand')#,#rc.rbfactory.getKey('sitemanager.content.fields.close')#" editType="wysiwyg" />
	</dl>
<cfif rc.edit>
<input type="submit" value="Save" />
</form>
</cfif>
</cfoutput>