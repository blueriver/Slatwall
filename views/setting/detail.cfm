<cfset Local.SettingsQuery = application.slatsettings.getSetting('SettingsQuery') />
<cfoutput>
	<div class="svosettingdetail">
		<form name="SettingsUpdate" method="post" action="index.cfm?action=setting.detail">
			<cfloop query="Local.SettingsQuery">
				<dl>
					<dt>#Local.SettingsQuery.SettingDisplayName#</dt>
					<cfif Local.SettingsQuery.Hint neq ''>
						<dd class="Hint">#Local.SettingsQuery.Hint#</dd>
					</cfif>
					<dd>
						<cfif Local.SettingsQuery.SettingType eq "text">
							<input type="text" value="#Local.SettingsQuery.SettingValue#" name="#Local.SettingsQuery.SettingName#" />
						<cfelseif Local.SettingsQuery.SettingType eq "password">
							<input type="password" value="#Local.SettingsQuery.SettingValue#" name="#Local.SettingsQuery.SettingName#" />
						<cfelseif Local.SettingsQuery.SettingType eq "select">
							<select name="#Local.SettingsQuery.SettingName#">
								<cfloop list="#Local.SettingsQuery.SettingOptions#" delimiters="^" index="Local.I">
									<option value="#Local.I#" <cfif Local.SettingsQuery.SettingValue eq Local.I>selected="selected"</cfif>>#Local.I#</option>
								</cfloop>
							</select>
						<cfelseif Local.SettingsQuery.SettingType eq "textarea">
							<textarea name="#Local.SettingsQuery.SettingName#">#Local.SettingsQuery.SettingValue#</textarea>
						</cfif>
					</dd>
				</dl>
			</cfloop>
			<button type="submit">Submit</button>
		</form>
	</div>
</cfoutput>