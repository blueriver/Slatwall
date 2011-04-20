<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<!--- hint: This is a required attribute that defines the object that contains the property to display --->
<cfparam name="attributes.object" type="any" />

<!--- hint: This is a required attribute as the property that you want to display" --->
<cfparam name="attributes.property" type="string" />

<!--- hint: This is used in case a sub object property has a different name than the property --->
<cfparam name="attributes.propertyObject" type="string" default="" />

<!--- hint: Value that is displayed when the property value is null --->
<cfparam name="attributes.nullValue" type="string" default="" />

<!--- hint: This can be used to override the displayName of a property" --->
<cfparam name="attributes.title" default="" />

<!--- hint: This can be used to override the default value of a property" --->
<cfparam name="attributes.value" default="" />

<!--- hint: This can be used to override the default field name" --->
<cfparam name="attributes.fieldName" default="" />

<!--- hint: This can be used to override the default data type" --->
<cfparam name="attributes.dataType" default="" />

<!--- hint: When in edit mode this will create a Form Field, otherwise it will just display the value" --->
<cfparam name="attributes.edit" default=false type="boolean" />

<!--- hint: When in edit mode you can override the default type of form object to use" --->
<cfparam name="attributes.editType" default="" type="string"  />

<!--- hint: This should be an array of structs that contain two paramaters: ID & Name" --->
<cfparam name="attributes.editOptions" default="#arrayNew(1)#" type="array" />

<!--- hint: whether to allow null (empty string) option in select box control --->
<cfparam name="attributes.allowNullOption" default="true" type="boolean" />

<!--- hint: This attribute indicates that the property will have a tooltip mouseover message --->
<cfparam name="attributes.tooltip" default="false" type="boolean" />

<!--- hint: This attribute contains the content of a mouseover tooltip message to override the value in the rB (entity.entityname.propertyname_hint) --->
<cfparam name="attributes.tooltipmessage" default="" type="string" />

<!--- hint: This attribute indicates whether the field can be toggled to show/hide the value. Possible values are "no" (no toggling), "Show" (shows field by default but can be toggled), or "Hide" (hide field by default but can be toggled) --->
<cfparam name="attributes.toggle" default="no" type="string" />

<!--- hint: This attribute is the text of the link used for toggling. Two comma delimited words defaulting to "Show,Hide" --->
<cfparam name="attributes.toggletext" default="Show,Hide" />

<!--- hint: This attribute is used to specify if the information comes back as a definition list (dl) item or table row (table) or with no formatting or label (plain) --->
<cfparam name="attributes.displaytype" default="dl" />

<!--- Add Custom class --->
<cfparam name="attributes.class" default="" />

<!--- if specified, will wrap property value with an achor tag using the attribute as the href value --->
<cfparam name="attributes.link" default="" />

<!--- class for styling link, if specified --->
<cfparam name="attributes.linkClass" default="" />

<!--- id for styling link, if specified --->
<cfparam name="attributes.linkID" default="" />

<!--- overwrite the generated id for the property element (dd or td) --->
<cfparam name="attributes.id" default="" />

<!--- if this is a dl displaytype this attribute can be used to designate if this is the first property to be displayed for proper <dt> styling --->
<cfparam name="attributes.first" default="false" />

<!---
	attributes.editType have the following options:
	text
	textarea
	checkbox
	select
	radiogroup
	wysiwyg
	file
--->

<!---
	attributes.displaytype have the following options:
	dl
	table
	plain
--->

<cfif thisTag.executionMode is "start">

	<cfset local = structNew() />
	<cfset local.metadata = getMetadata(attributes.object) />
	<cfset local.propertyMetadata = structNew() />
	
	<!--- Loop over properties in object and find metadata for this property --->
	<cfloop array="#local.metadata.properties#" index="i">
		<cfif UCASE(i.name) eq UCASE(attributes.property)>
			<cfset local.propertyMetadata = i />
			<cfbreak />
		</cfif>
	</cfloop>
	
	<cfif structCount(local.propertyMetadata)>
		
		<!--- If the title attribute was not set, then set it as the the value in the resource bundle ---> 
		<cfif attributes.title eq "">
			<!--- remove "Slatwall" prefix from entityname --->
			<cfset local.entityName = replaceNocase(attributes.object.getClassName(),"Slatwall","","one") />
			<cfset attributes.title = request.customMuraScopeKeys.slatwall.rbKey("entity." & local.entityName & "." & attributes.property) />
			<cfif right(attributes.title, 8) eq "_missing" >
				<cfset attributes.title = local.propertyMetadata.name />
			</cfif>
		</cfif>
		
		<!--- Try to determine the datatype of the property, if not passed in --->
		<cfif attributes.dataType eq "">
			<cfif (structKeyExists(local.propertyMetadata, "type") and local.propertyMetadata.type eq "boolean") or (structKeyExists(local.propertyMetadata, "ormtype") and local.propertyMetadata.ormtype eq "boolean")>
				<cfset attributes.dataType = "boolean" />
			<cfelse>
				<cfset attributes.dataType = "string" />
			</cfif>
		</cfif>
		
		<!--- If the value attribute was not set, then try to determine the value from the object, and if that isn't set, then use the objects default. --->
		<cfif attributes.value eq "">
			<cfset attributes.value = evaluate('attributes.object.get#Local.PropertyMetadata.Name#()') />
	
			<cfif structKeyExists(attributes,"value")>
				<cfif isObject(attributes.value)>
					<cfset local.subEntityMetadata = getMetadata(attributes.value) />
					<cfset attributes.value = "">
					<cfloop array="#local.subEntityMetadata.properties#" index="i">
						<cfif i.name EQ attributes.property & 'name' or i.name EQ attributes.propertyObject & 'name'>
							<cfset attributes.value = evaluate("attributes.object.get#Local.PropertyMetadata.Name#().get#i.name#()") />
							<cfbreak />
						</cfif>
					</cfloop>
				<cfelseif attributes.value eq "" and structKeyExists(local.propertyMetadata, "default")>
					<cfset attributes.value = local.propertyMetadata.default />
				<cfelseif attributes.value eq "" and not structKeyExists(local.propertyMetadata,"default")>
					<cfset attributes.value = "" />
				</cfif>
			<cfelseif isNull(attributes.value) and len(attributes.nullValue)>
				<cfset attributes.value = attributes.nullValue />
			<cfelseif isNull(attributes.value) and !len(attributes.nullValue) and attributes.dataType eq "boolean">
				<cfset attributes.value = request.customMuraScopeKeys.slatwall.rbKey("sitemanager.no") />
			<cfelse>
			     <cfset attributes.value = "" />
			</cfif>
		</cfif>
		
		<cfif attributes.fieldName eq "">
			<cfset attributes.fieldName = local.propertyMetadata.name />
		</cfif>
		
		<cfif trim(attributes.id) eq "">
		  <cfset attributes.id = "spd" & LCASE(attributes.fieldName) />
		</cfif>
		
		
		<!--- If in edit mode, and that editType attribute is not set then figure out what to use --->
		<cfif attributes.edit>
			<cfif attributes.editType eq "">
				<!--- Check to see if this is a many-to-one type property.  Otherwise check the propertyMetadata.type for the most suitible form type, if nothing is set then use the default of text --->
				<cfif structKeyExists(local.propertyMetadata, "fieldtype") and local.propertyMetadata.fieldtype eq "many-to-one">
					<cfset attributes.editType = "select" />
				<cfelseif (structKeyExists(local.propertyMetadata, "type") and (local.propertyMetadata.type eq "string" or local.propertyMetadata.type eq "numeric")) or (structKeyExists(local.propertyMetadata, "ormtype") and (local.propertyMetadata.ormtype eq "string" or local.propertyMetadata.ormtype eq "float" or local.propertyMetadata.ormtype eq "integer" or local.propertyMetadata.ormtype eq "int"))>
					<cfset attributes.editType = "text" />
				<cfelseif structKeyExists(local.propertyMetadata, "type") and local.propertyMetadata.type eq "boolean" or (structKeyExists(local.propertyMetadata, "ormtype") and local.propertyMetadata.ormtype eq "boolean")>
					<cfset attributes.editType = "radiogroup" />
				<cfelse>
					<cfset attributes.editType = "text" />
				</cfif>
			</cfif>
		</cfif>
		
		<cfif attributes.editType eq "select">
		
			<!--- Use the "getPropertyOptions" function to populate the attributes.editOptions if none are set --->
			<cfif arrayLen(attributes.editOptions) eq 0>
				<cftry>
					<cfset attributes.editOptions = evaluate("attributes.object.get#local.propertyMetadata.name#Options()") />
					<cfcatch>
						<cfset attributes.editOptions = arrayNew(1) />
					</cfcatch>
				</cftry>
			</cfif>
			
			<!--- If none are still set, then change the editType to none, otherwise verify that there is an ID & Name for each option 
			<cfif arrayLen(attributes.editOptions) eq 0>
				<cfset attributes.editType = "none" />
			<cfelse>
				<cfloop array="#attributes.editOptions#" index="i">
					<cfif not isDefined("i.id") or not isDefined("i.name")>
						<cfset attributes.editType = "none" />
						<cfbreak />
					</cfif>
				</cfloop>
			</cfif>--->
		</cfif>
		
		<cfoutput>
			<cfif attributes.displaytype eq "dl">
				<dt class="spd#LCASE(attributes.fieldName)#<cfif len(trim(attributes.class))> #attributes.class#</cfif><cfif attributes.first> first</cfif>">
			<cfelseif attributes.displaytype eq "table">
				<tr class="spd#LCASE(attributes.fieldName)#<cfif len(trim(attributes.class))> #attributes.class#</cfif>">
				<td class="property varWidth">
			</cfif>
	        
	        <cfif attributes.displaytype neq "plain">
	        	<cfif attributes.tooltip>
	                <a href="##" class="tooltip">
	            </cfif> 			
	 			<!--- If in edit mode, then wrap title in a label tag except if it's a radiogroup, in which case the radio buttons are labeled --->
	 			<cfif attributes.edit and attributes.editType NEQ "radiogroup" and attributes.editType NEQ "file">
					<label for="#attributes.fieldName#">
						#attributes.title#
						<!--- If this is a required field the add an asterisk --->
						<cfif structKeyExists(local.propertyMetadata, "validateRequired")>
							*
						</cfif>
					</label>
	 			<cfelseif attributes.edit and attributes.editType EQ "file">
					<label for="#attributes.fieldName#File">
						#attributes.title#
						<!--- If this is a required field the add an asterisk --->
						<cfif structKeyExists(local.propertyMetadata, "validateRequired")>
							*
						</cfif>
					</label>
				<cfelseif attributes.edit and attributes.editType EQ "radiogroup">
					<div class="#attributes.fieldName#File">
						#attributes.title#
						<!--- If this is a required field the add an asterisk --->
						<cfif structKeyExists(local.propertyMetadata, "validateRequired")>
							*
						</cfif>
					</div>
				<cfelse>
					#attributes.title#
				</cfif>
	            <cfif attributes.tooltip>
					<cfif len(trim(attributes.tooltipmessage))>
	                	<span>#attributes.tooltipmessage#</span></a>
					<cfelse>
						<span>#request.customMuraScopeKeys.slatwall.rbKey("entity.#local.entityName#.#attributes.property#_hint")#</span></a>
					</cfif>
	            </cfif>
	            <cfif listFindNoCase("show,hide",attributes.toggle)>
	                <cfif attributes.toggle EQ "show"><cfset local.initText=2 /><cfelse><cfset local.initText=1 /></cfif>
	                <a  href="##" id="#attributes.id#Link" onclick="javascript: toggleDisplay('#attributes.id#','#listFirst(attributes.toggletext)#','#listGetAt(attributes.toggletext,2)#');return false">[#listGetAt(attributes.toggletext,local.initText)#]</a>
	            </cfif>	
	
				<cfif attributes.displaytype eq "dl">
					</dt>
				<cfelseif attributes.displaytype eq "table">
					</td>
				</cfif>
			</cfif> <!--- end cfif block for displayType neq "plain" (display label) --->
			
			<cfif attributes.displayType eq "dl">
				<dd id="#attributes.id#"<cfif listFindNoCase("show,hide",attributes.toggle)> style="display:#attributes.toggle eq 'hide' ? 'none':'inherit'#"</cfif>>
			<cfelseif attributes.displayType eq "table">
				<td id="#attributes.id#" class="value">
			</cfif>
				<!--- If in edit mode, then generate necessary form field --->
				<cfif attributes.edit eq true and attributes.editType neq "none">
					<cfif attributes.editType eq "text">
						<input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" value="#attributes.value#" />
					<cfelseif attributes.editType eq "textarea">
						<textarea name="#attributes.fieldName#" id="#attributes.fieldName#">#attributes.Value#</textarea>
					<cfelseif attributes.editType eq "checkbox">
						<input type="hidden" name="#attributes.fieldName#" id="#attributes.fieldName#" value="" />
						<input type="checkbox" name="#attributes.fieldName#" id="#attributes.fieldName#" value="1" <cfif attributes.value eq true>checked="checked"</cfif> />
					<cfelseif attributes.editType eq "select">
						<cfif arrayLen(attributes.editOptions) gt 0>
						<select name="#attributes.fieldName#" id="#attributes.fieldName#">
							<cfif attributes.allowNullOption>
								<option value="">#attributes.nullValue eq "" ? request.customMuraScopeKeys.slatwall.rbKey('admin.selectBox.select') : attributes.nullValue#</option>
							</cfif>
							<cfloop array="#attributes.editOptions#" index="i" >
								<cfset label = structKeyExists(i,"label") ? i['label'] : i['name'] />
								<option value="#i['id']#" <cfif attributes.value eq i['name']>selected="selected"</cfif>>#label#</option>	
							</cfloop>
						</select>
<!---						<cfelse>
							<input type="hidden" name="#attributes.fieldName#_#attributes.fieldName#ID" value="" />
							<p><em>#request.customMuraScopeKeys.slatwall.rbKey("admin.#attributes.fieldName#.no#attributes.fieldName#sdefined")#</em></p>--->
						</cfif>
					<cfelseif attributes.editType eq "radiogroup">
						<ul class="radiogroup">
						<cfif attributes.dataType eq "boolean">
							<li><input type="radio" name="#attributes.fieldName#" id="#attributes.fieldName#yes" value="1"<cfif yesnoformat(attributes.value)> checked</cfif>> <label for="#attributes.fieldName#yes">#request.customMuraScopeKeys.slatwall.rbKey("user.yes")#</label></li>
							<li><input type="radio" name="#attributes.fieldName#" id="#attributes.fieldName#no" value="0"<cfif not yesnoformat(attributes.value)> checked</cfif>> <label for="#attributes.fieldName#no">#request.customMuraScopeKeys.slatwall.rbKey("user.no")#</label></li>	
						<cfelse>
							<input type="hidden" name="#attributes.fieldName#_#attributes.fieldName#ID" id="#attributes.fieldName#_#attributes.fieldName#ID" value="" />
							<cfloop array="#attributes.editOptions#" index="i">
								<cfset label = structKeyExists(i,"label") ? i.label : i.name />
								<li><input type="radio" name="#attributes.fieldName#_#attributes.fieldName#ID" id="#i.id#" value="#i.id#"<cfif attributes.value eq i.name> checked="true"</cfif>><label for="#i.id#">#label#</label></li>
							</cfloop>
						</cfif>
						</ul>
					<cfelseif attributes.editType eq "wysiwyg">
						<textarea name="#attributes.fieldName#" id="#attributes.id#txt">#attributes.Value#</textarea>
						<script type="text/javascript" language="Javascript">
							var loadEditorCount = 0;
							jQuery('###attributes.id#txt').ckeditor(
								{ toolbar:'Default',
								height:'150',
								customConfig : 'config.js.cfm' },htmlEditorOnComplete);	 
							</script>
					<cfelseif attributes.editType eq "file">
					<!--- ouptut a file upload field --->
						<input type="file" name="#attributes.fieldName#File" id="#attributes.fieldName#File" class="file">
					</cfif>
				<cfelseif attributes.edit eq true and attributes.editType eq "none">
					<!-- A Default Edit Type Could not be created -->
				<cfelse>
					<cfif attributes.dataType eq "boolean" and attributes.value eq true>
						<cfset propertyValue = request.customMuraScopeKeys.slatwall.rbKey("sitemanager.yes") />
					<cfelseif attributes.dataType eq "boolean" and attributes.value eq false>
						<cfset propertyValue = request.customMuraScopeKeys.slatwall.rbKey("sitemanager.no") />
					<cfelse>
						<cfset propertyValue = attributes.Value />
					</cfif>
					<cfif len(attributes.link) gt 0>
						<a href="#attributes.link#"<cfif len(attributes.linkClass) gt 0> class="#attributes.linkClass#"</cfif><cfif len(attributes.linkID) gt 0> id="#attributes.linkID#"</cfif>>#propertyValue#</a>
					<cfelse>
						#propertyValue#
					</cfif>
				</cfif>
			<!--- If the object has an error Bean, check for errors on this property --->
			<cftry>
				<cfif Len(attributes.object.getErrorBean().getError(attributes.fieldName))>
					<span class="formError">#attributes.Object.getErrorBean().getError(local.propertyMetaData.name)#</span>
				</cfif>
				<cfcatch><!-- Object Contains No Error Bean --></cfcatch>
			</cftry>
			<cfif attributes.displaytype eq "dl">
				</dd>
			<cfelseif attributes.displaytype eq "table">
				</td>
				</tr>
			</cfif>
	 	</cfoutput>
	<cfelse>
		<cfoutput>
			<!-- The Property #attributes.property# Does not exist in object -->
		</cfoutput> 	
 	</cfif>
</cfif>
