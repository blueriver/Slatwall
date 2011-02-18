<cfparam name="local.options" type="array" default="#[]#" />
<cfparam name="local.optionsCount" default="1" />
<cfhtmlhead text='<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/optionsform.js"></script>' />
<cfoutput>
<h3>#rc.$.Slatwall.rbKey("option.options")#</h3>
<cfif structKeyExists(rc,"optionGroup")>
	<cfset local.options = rc.OptionGroup.getOptions() />
<cfelseif structKeyExists(rc,"options")>
	<cfset local.options = rc.options />
</cfif>
<cfif arrayLen(local.options) and rc.edit>
	<cfloop from="1" to="#arrayLen(local.options)#" index="local.optionsCount">
	<cfset local.thisOption = local.options[local.optionsCount] />
		<fieldset id="Option#local.optionsCount#" class="optionFieldSet">
			<legend>Option #local.optionsCount#</legend>
			<input type="checkbox" name="options[#local.optionsCount#].deleteOption" id="deleteOption#local.optionsCount#" /> <label for="deleteOption#local.optionsCount#">#rc.$.Slatwall.rbKey("option.deleteoption")#</label>
			<dl class="oneColumn">
				<dt class="spdoptionname">
					<label for="optionName#local.optionsCount#">#rc.$.Slatwall.rbKey("option.optionname")#</label>
				</dt>
				<dd id="spdoptionname#local.optionsCount#" class="spdoptionname">
					<input type="text" name="options[#local.optionsCount#].optionName" id="optionName#local.optionsCount#" value="#local.thisOption.getOptionName()#" />
					<input type="hidden" name="options[#local.optionsCount#].optionID" value="#local.thisOption.getOptionID()#" />
				</dd>
				<dt class="spdoptioncode">
					<label for="optionCode#local.optionsCount#">#rc.$.Slatwall.rbKey("option.optioncode")#</label>
				</dt>
				<dd id="spdoptioncode#local.optionsCount#" class="spdoptioncode">
					<input type="text" name="options[#local.optionsCount#].optionCode" id="optionCode#local.optionsCount#" value="#local.thisOption.getOptionCode()#" />
				</dd>
				<dt class="spdptionimage">
					<label for="optionImageFile#local.optionsCount#">#rc.$.Slatwall.rbKey("option.selectoptionimage")#</label>
				</dt>
				<dd id="spdoptionimage#local.optionsCount#" class="spdoptionimage">
					<input type="file" id="optionImageFile#local.optionsCount#" name="options[#local.optionsCount#].optionImageFile" class="text">
				</dd>
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
				</dd>
			</dl>
		</fieldset>
	</cfloop>
<cfelseif !arrayLen(local.options) and rc.edit>
	<fieldset id="Option#local.optionsCount#" class="optionFieldSet">
		<legend>Option #local.optionsCount#</legend>
		<dl class="oneColumn">
			<dt class="spdoptionname">
				<label for="optionName#local.optionsCount#">#rc.$.Slatwall.rbKey("option.optionname")#</label>
			</dt>
			<dd id="spdoptionname#local.optionsCount#" class="spdoptionname">
				<input type="text" name="options[#local.optionsCount#].optionName" id="optionName#local.optionsCount#" value="" />
				<input type="hidden" name="options[#local.optionsCount#].optionID" value="" />
			</dd>
			<dt class="spdoptioncode">
				<label for="optionCode#local.optionsCount#">#rc.$.Slatwall.rbKey("option.optioncode")#</label>
			</dt>
			<dd id="spdoptioncode#local.optionsCount#" class="spdoptioncode">
				<input type="text" name="options[#local.optionsCount#].optionCode" id="optionCode#local.optionsCount#" value="" />
			</dd>
			<dt class="spdptionimage">
				<label for="optionImageFile#local.optionsCount#">#rc.$.Slatwall.rbKey("option.selectoptionimage")#</label>
			</dt>
			<dd id="spdoptionimage#local.optionsCount#" class="spdoptionimage">
				<input type="file" id="optionImageFile#local.optionsCount#" name="options[#local.optionsCount#].optionImageFile" class="text">
			</dd>
			<dt class="spdoptiondescription">
				<label for="optionDescription#local.optionsCount#">#rc.$.Slatwall.rbKey("option.optiondescription")#</label>
			</dt>
			 <dd id="spdoptiondescription#local.optionsCount#" class="spdoptiondescription" style="display:inherit">
				<textarea name="options[#local.optionsCount#].optionDescription" id="optionDescription#local.optionsCount#" class="richtext"></textarea>
			</dd>
		</dl>
	</fieldset>
<cfelseif arrayLen(local.options) and !rc.edit>
<table class="stripe" id="options" width="400">
	<tr>
		<th class="varWidth">#rc.$.Slatwall.rbKey("option.optionname")#</th>
		<th>#rc.$.Slatwall.rbKey("option.optioncode")#</th>
		<th>#rc.$.Slatwall.rbKey("option.optionimage")#</th>
	</tr>
<cfset local.rowCount = 0 />
<cfloop array="#local.options#" index="local.thisOption">
<cfset local.rowCount++ />
	<tr<cfif local.rowCount mod 2 eq 1> class="alt"</cfif>>
		<td class="varWidth">#local.thisOption.getOptionName()#</td>
		<td>#local.thisOption.getOptionCode()#</td>
		<td><cfif local.thisOption.hasImage()><img src="#rc.$.siteConfig('assetPath')#/images/Slatwall/#local.thisOption.getImagePath()#" alt="#local.thisOption.getOptionName()#" height="25"/></cfif></td>
	</tr>
</cfloop>
</table>
<cfelse>
<p>#rc.$.Slatwall.rbKey("option.nooptions")#</p>
</cfif>
</cfoutput>