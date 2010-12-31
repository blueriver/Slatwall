<cfparam name="attributes.Object" />
<cfparam name="attributes.Property" />
<cfparam name="attributes.Edit" default=false type="boolean" />
<cfparam name="attributes.Title" default="" />
<cfparam name="attributes.Value" default="" />

<cfif thisTag.executionMode is "start">
	
	<cfset MetaData = getMetadata( attributes.Object ) />
	<cfset PorpertyMD = StructNew() />
	<cfset PropertyI = StructNew() />
	<cfset PropertyExists = false />
	
	<cfloop array="#MetaData.Properties#" index="PropertyI">
		<cfif UCASE(PropertyI.Name) eq UCASE(attributes.Property)>
			<cfset PropertyExists = true />
			<cfset PropertyMD = PropertyI />
		</cfif>
	</cfloop>
	
	<cfif PropertyExists>
		<cfif attributes.Title eq "">
			<cfif isDefined('PropertyMD.DisplayName')>
				<cfset attributes.Title = PropertyMD.DisplayName />
			<cfelse>
				<cfset attributes.Title = attributes.Property />
			</cfif>
		</cfif>
		
		<cfif attributes.Value eq "">
			<cfset attributes.Value = evaluate('attributes.Object.get#PropertyMD.Name#()') />
			<cfif attributes.Value eq "">	
				<cfset attributes.Value = PropertyMD.Default />
			</cfif>
		</cfif>
	</cfif>

 	<cfoutput>
 		<dt class="spd#LCASE(PropertyMD.Name)#">
 			<cfif attributes.edit>
				<label for="#PropertyMD.Name#">#attributes.Title#</label>
			<cfelse>#attributes.Title#</cfif>
			<cfif Len(attributes.Object.getErrorBean().getError(PropertyMD.name))>
				<span class="error"> #attributes.Object.getErrorBean().getError(PropertyMD.name)#</span>
			</cfif>
		</dt>
		<dd class="spd#LCASE(PropertyMD.Name)#">
			<cfif attributes.edit>
				<cfif PropertyMD.type eq 'boolean'>
					<input type="checkbox" name="#PropertyMD.Name#" value="1" <cfif attributes.Value>checked="checked"</cfif> />
				<cfelseif PropertyMD.type eq 'string' or PropertyMD.type eq 'numeric'>
					<input type="text" name="#PropertyMD.Name#" value="#attributes.Value#" />
				</cfif>
			<cfelse>
				<cfif PropertyMD.type eq 'boolean' and attributes.Value eq true>
					YES
				<cfelseif PropertyMD.type eq 'boolean' and attributes.Value eq false>
					NO
				<cfelse>
					#attributes.Value#
				</cfif>
			</cfif>
		</dd>
 	</cfoutput>
</cfif>