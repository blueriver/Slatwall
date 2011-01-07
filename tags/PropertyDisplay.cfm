<!--- hint: This is a required attribute that defines the object that contains the property to display --->
<cfparam name="attributes.object" type="any" />

<!--- hint: This is a required attribute as the property that you want to display" --->
<cfparam name="attributes.property" type="string" />

<!--- hint: This can be used to override the displayName of a property" --->
<cfparam name="attributes.title" default="" />

<!--- hint: This can be used to override the default value of a property" --->
<cfparam name="attributes.value" default="" />

<!--- hint: When in edit mode this will create a Form Field, otherwise it will just display the value" --->
<cfparam name="attributes.edit" default=false type="boolean" />

<!--- hint: When in edit mode you can override the default type of form object to use" --->
<cfparam name="attributes.editType" default="" type="string"  />

<!--- hint: This should be an array of structs that contain two paramaters: ID & Name" --->
<cfparam name="attributes.editOptions" default="#arrayNew(1)#" type="array" />

<!---
	attributes.editType have the following options:
	text
	textarea
	checkbox
	select
	radiogroup
	wysiwyg
--->

<cfif thisTag.executionMode is "start">

	<cfset local = structNew() />
	<cfset local.metadata = getMetadata(attributes.object) />
	<cfset local.propertyMetadata = structNew() />
	
	<!--- Loop over properties in object and find metadata for this property --->
	<cfloop array="#local.metadata.properties#" index="i">
		<cfif UCASE(i.name) eq UCASE(attributes.property)>
			<cfset local.propertyMetadata = i />
		</cfif>
	</cfloop>
	
	<cfif structCount(local.propertyMetadata)>
		
		<!--- If the title attribute was not set, then set it as the the properties displayName ---> 
		<cfif attributes.title eq "">
			<cfif structKeyExists(local.propertyMetadata, "displayName")>
				<cfset attributes.title = local.propertyMetadata.displayName />
			<cfelse>
				<cfset attributes.title = local.propertyMetadata.name />
			</cfif>
		</cfif>
		
		<!--- If the value attribute was not set, then try to determine the value from the object, and if that isn't set, then use the objects default. --->
		<cfif attributes.Value eq "">
			<cfset attributes.value = evaluate('attributes.object.get#Local.PropertyMetadata.Name#()') />
			
			<cfif isObject(attributes.value)>
				<cfset local.subEntityMetadata = getMetadata(attributes.value) />
				<cfset attributes.value = "">
				<cfloop array="#local.subEntityMetadata.properties#" index="i">
					<cfif structKeyExists(i, "fieldtype") and i.fieldtype eq "id">
						<cfset attributes.value = evaluate("attributes.object.get#Local.PropertyMetadata.Name#().get#i.name#()") />
					</cfif>
				</cfloop>
			<cfelse>
				<cfif attributes.value eq "" and structKeyExists(local.propertyMetadata, "default")>
					<cfset attributes.value = local.propertyMetadata.default />
				</cfif>
			</cfif>
		</cfif>
		
		<cfif not structKeyExists(attributes, "value") or not isDefined("attributes.value")>
			<cfset attributes.value = "">
		</cfif>
		
		<!--- In in edit mode, and that editType attribute is not set then figure out what to use --->
		<cfif attributes.edit>
			<cfif attributes.editType eq "">
				<!--- Check to see if this is a many-to-one type property.  Otherwise check the propertyMetadata.type for the most suitible form type, if nothing is set then use the default of text --->
				<cfif structKeyExists(local.propertyMetadata, "fieldtype") and local.propertyMetadata.fieldtype eq "many-to-one">
					<cfset attributes.editType = "select" />
				<cfelseif structKeyExists(local.propertyMetadata, "type") and local.propertyMetadata.type eq "string">
					<cfset attributes.editType = "text" />
				<cfelseif structKeyExists(local.propertyMetadata, "type") and local.propertyMetadata.type eq "numeric">
					<cfset attributes.editType = "text" />
				<cfelseif structKeyExists(local.propertyMetadata, "type") and local.propertyMetadata.type eq "boolean">
					<cfset attributes.editType = "checkbox" />
				<cfelse>
					<cfset attributes.editType = "text" />
				</cfif>
			</cfif>
		</cfif>
		
		<cfif attributes.editType eq "select" or attributes.editType eq "radiogroup">
		
			<!--- Use the "getPropertyOptions" function to populate the attributes.editOptions if none are set --->
			<cfif arrayLen(attributes.editOptions) eq 0>
				<cftry>
					<cfset attributes.editOptions = evaluate("attributes.object.get#local.propertyMetadata.name#Options()") />
					<cfcatch>
						<cfset attributes.editOptions = arrayNew(1) />
					</cfcatch>
				</cftry>
			</cfif>
			
			<!--- If none are still set, then change the editType to none, otherwise verify that there is an ID & Name for each option --->
			<cfif arrayLen(attributes.editOptions) eq 0>
				<cfset attributes.editType = "none" />
			<cfelse>
				<cfloop array="#attributes.editOptions#" index="i">
					<cfif not isDefined("i.id") or not isDefined("i.name")>
						<cfset attributes.editType = "none" />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>

		<cfoutput>
	 		<dt class="spd#LCASE(local.propertyMetadata.name)#">
	 			
	 			<!--- If in edit mode, then wrap title in a label tag --->
	 			<cfif attributes.edit>
					<label for="#local.propertyMetadata.name#">
						#attributes.title#
						<!--- If this is a required field the add an asterisk --->
						<cfif structKeyExists(local.propertyMetadata, "validateRequired")>
							*
						</cfif>
					</label>
				<cfelse>
					#attributes.title#
				</cfif>
				
				<!--- If the object has an error Bean, check for errors on this property --->
				<cftry>
					<cfif Len(attributes.object.getErrorBean().getError(local.propertyMetadata.name))>
						<span class="error">#attributes.Object.getErrorBean().getError(PropertyMD.name)#</span>
					</cfif>
					<cfcatch><!-- Object Contains No Error Bean --></cfcatch>
				</cftry>
			</dt>
	 		<dd class="spd#LCASE(local.propertyMetadata.name)#">
				
				<!--- If in edit mode, then generate necessary form field --->
				<cfif attributes.edit eq true and attributes.editType neq "none">
					<cfif attributes.editType eq "text">
						<input type="text" name="#local.propertyMetadata.name#" value="#attributes.value#" />
					<cfelseif attributes.editType eq "textarea">
						<textarea name="#local.propertyMetadata.name#">#attributes.Value#</textarea>
					<cfelseif attributes.editType eq "checkbox">
						<input type="checkbox" name="#local.propertyMetadata.Name#" value="1" <cfif attributes.value>checked="checked"</cfif> />
					<cfelseif attributes.editType eq "select">
						<select name="#local.propertyMetadata.name#_#local.propertyMetadata.name#ID">
							<cfloop array="#attributes.editOptions#" index="i" >
								<option value="#i.id#" <cfif attributes.value eq i.id>selected="selected"</cfif>>#i.name#</option>	
							</cfloop>
						</select>
					<cfelseif attributes.editType eq "radiogroup">
						<!--- TODO: Add radio group display --->
					<cfelseif attributes.editType eq "wysiwyg">
						<!--- TODO: Add wysiwyg display --->
					</cfif>
				<cfelseif attributes.edit eq true and attributes.editType eq "none">
					<!-- A Default Edit Type Could not be created -->
				<cfelse>
					<cfif structKeyExists(local.propertyMetadata, "type") and local.propertyMetadata.type eq "boolean" and attributes.value eq true>
						YES
					<cfelseif structKeyExists(local.propertyMetadata, "type") and local.propertyMetadata.type eq "boolean" and attributes.value eq false>
						NO
					<cfelse>
						#attributes.Value#
					</cfif>
				</cfif>
			</dd>
	 	</cfoutput>
	<cfelse>
		<cfoutput>
			<!-- The Property #attributes.property# Does not exist in object -->
		</cfoutput> 	
 	</cfif>
</cfif>