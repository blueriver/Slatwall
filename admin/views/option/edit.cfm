<cfparam name="rc.optionGroup" type="any" />

<cfset local.options = rc.optionGroup.getOptions() />

<ul id="navTask">
    <cf_ActionCaller action="admin:option.list" type="list">
	<cf_ActionCaller action="admin:option.editoptiongroup" querystring="optiongroupID=#rc.optiongroup.getoptiongroupid()#" type="list">
</ul>

<cfoutput>

<a class="button" id="newFrmopen" href="javascript:;" onclick="jQuery('##newFrmcontainer').slideDown();this.style.display='none';jQuery('##newFrmclose').show();return false;">#rc.$.Slatwall.rbKey('admin.option.addoption')#</a>
<a class="button" href="javascript:;" style="display:none;" id="newFrmclose" onclick="jQuery('##newFrmcontainer').slideUp();this.style.display='none';jQuery('##newFrmopen').show();return false;">#rc.$.Slatwall.rbKey('admin.option.closeform')#</a>


<div style="display:none;" id="newFrmcontainer">

<form id="newOptionForm" action="#buildURL('admin:option.save')#" method="post">
    <input type="hidden" name="optionGroupID" value="#rc.optionGroup.getOptionGroupID()#" />
    <dl class="oneColumn">
        <cf_PropertyDisplay object="#rc.newOption#" property="optionname" edit="true">
		<cf_PropertyDisplay object="#rc.newOption#" property="optioncode" edit="true">
        <dt class="spdptionimage">
            <label for="optionImageFile">#rc.$.Slatwall.rbKey("admin.option.selectoptionimage")#</label>
        </dt>
        <dd id="spdoptionimage" class="spdoptionimage">
            <input type="file" id="optionImageFile" name="optionImageFile" class="text">
        </dd>
		<cf_PropertyDisplay object="#rc.newOption#" property="optionDescription" edit="true" editType="wysiwyg" toggle="hide">
<!--- 

        <cfif len(local.thisOption.getOptionImage())>
        <dd>
            <img src="#rc.$.siteConfig('assetPath')#/images/Slatwall/#local.thisOption.getImagePath()#" alt="#local.thisOption.getOptionName()#" />
            <cfif rc.edit><input type="checkbox" name="options[#local.optionsCount#].removeOptionImage" value="1" id="chkRemoveOptionImage#local.optionsCount#" /> <label for="chkRemoveOptionImage#local.optionsCount#">#rc.$.Slatwall.rbKey("option.removeimage")#</label></cfif>
        </dd>
        </cfif>
        <dt class="spdoptiondescription">
            <label for="optionDescription#local.optionsCount#">#rc.$.Slatwall.rbKey("option.optiondescription")#</label>
        </dt>
         <dd id="spdoptiondescription#local.optionsCount#" style="display:inherit">
            <textarea name="options[#local.optionsCount#].optionDescription" id="optionDescription#local.optionsCount#" class="richtext">#local.thisOption.getOptionDescription()#</textarea>
        </dd>--->
    </dl>
</form>  
</div>

<cfif arrayLen(rc.optionGroup.getOptions()) gt 0>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsingroup")#</em></p>
</cfif>

</cfoutput>