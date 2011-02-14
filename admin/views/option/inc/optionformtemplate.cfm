<cfoutput>
<fieldset id="optionTemplate" class="hideElement">
<legend></legend>
	<dl class="oneColumn">
		<dt class="spdoptionname">
			<label for="optionName">#rc.$w.rbKey("option.optionname")#</label>
		</dt>
		<dd id="spdoptionname" class="spdoptionname">
			<input type="text" name="optionName" id="optionName" value="" />
			<input type="hidden" name="optionID" value="" />
		</dd>
		<dt class="spdoptioncode">
			<label for="optionCode">#rc.$w.rbKey("option.optioncode")#</label>
		</dt>
		<dd id="spdoptioncode" class="spdoptioncode">
			<input type="text" name="optionCode" id="optionCode" value="" />
		</dd>
		<dt class="spdptionimage">
			<label for="optionImageFile">#rc.$w.rbKey("option.selectoptionimage")#</label>
		</dt>
		<dd id="spdoptionimage" class="spdoptionimage">
			<input type="file" id="optionImageFile" name="optionImageFile" class="text">
		</dd>
		<dt class="spdoptiondescription">
			<label for="optionDescription">#rc.$w.rbKey("option.optiondescription")#</label>
		</dt>
		 <dd id="spdoptiondescription" class="spdoptiondescription" style="display:inherit">
			<textarea id="optionDescription" name="optionDescription"></textarea>
		</dd>
	</dl>
</fieldset>
</cfoutput>