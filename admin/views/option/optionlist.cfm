<cfparam name="local.options" type="array" default="#[]#" />
<cfhtmlhead text='<script type="text/javascript" src="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/js/optionsform.js"></script>' />
<cfoutput>
<h3>#rc.$w.rbKey("option.options")#</h3>
<cfif structKeyExists(rc,"optionGroup")>
	<cfset local.options = rc.OptionGroup.getOptions() />
</cfif>
	<fieldset>
		<legend>Option 1</legend>
		<dl class="oneColumn">
			<dt class="spdoptionname">
				<label for="optionName">#rc.$w.rbKey("option.optionname")#</label>
			</dt>
			<dd id="spdoptionname">
				<input type="text" name="options[1].optionName" id="optionName" value="" />
				<input type="hidden" name="options[1].optionID" value="" />
			</dd>
			<dt class="spdoptioncode">
				<label for="optionCode">#rc.$w.rbKey("option.optioncode")#</label>
			</dt>
			<dd class="spdoptioncode">
				<input type="text" name="options[1].optionCode" id="optionCode" value="" />
			</dd>
			<dt class="spdptionimage">
				<label for="optionImageFile">#rc.$w.rbKey("option.selectoptionimage")#</label>
			</dt>
			<dd class="spdoptionimage">
				<input type="file" id="optionImageFile1" name="options[1].optionImageFile" class="text">
			</dd>
			<dt class="spdoptiondescription">
				<label for="optionDescription">#rc.$w.rbKey("option.optiondescription")#</label>
			</dt>
			 <dd id="spdoptiondescription" style="display:inherit">
				<textarea name="options[1].optionDescription" id="optionDescription"></textarea>
			</dd>
		</dl>
	</fieldset>
<cfif arraylen(local.options)>

<cfelse>

</cfif>


<fieldset id="optionTemplate" class="hideElement">
<legend></legend>
	<dl class="oneColumn">
		<dt class="spdoptionname">
			<label for="optionName">#rc.$w.rbKey("option.optionname")#</label>
		</dt>
		<dd id="spdoptionname">
			<input type="text" name="optionName" id="optionName" value="" />
			<input type="hidden" name="optionID" value="" />
		</dd>
		<dt class="spdoptioncode">
			<label for="optionCode">#rc.$w.rbKey("option.optioncode")#</label>
		</dt>
		<dd class="spdoptioncode">
			<input type="text" name="optionCode" id="optionCode" value="" />
		</dd>
		<dt class="spdptionimage">
			<label for="optionImageFile">#rc.$w.rbKey("option.selectoptionimage")#</label>
		</dt>
		<dd class="spdoptionimage">
			<input type="file" id="optionImageFile" name="optionImageFile" class="text">
		</dd>
		<dt class="spdoptiondescription">
			<label for="optionDescription">#rc.$w.rbKey("option.optiondescription")#</label>
		</dt>
		 <dd id="spdoptiondescription" style="display:inherit">
			<textarea name="optionDescription"></textarea>
		</dd>
	</dl>
</fieldset>


</cfoutput>