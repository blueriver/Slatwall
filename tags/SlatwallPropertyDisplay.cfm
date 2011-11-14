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

<!--- These are required Attributes --->
<cfparam name="attributes.object" type="any" />										<!--- hint: This is a required attribute that defines the object that contains the property to display --->
<cfparam name="attributes.property" type="string" /> 								<!--- hint: This is a required attribute as the property that you want to display" --->

<!--- These are optional Attributes --->
<cfparam name="attributes.edit" type="boolean" default="false" />					<!--- hint: When in edit mode this will create a Form Field, otherwise it will just display the value" --->

<cfparam name="attributes.title" type="string" default="" />						<!--- hint: This can be used to override the displayName of a property" --->

<cfparam name="attributes.value" type="string" default="" />						<!--- hint: This can be used to override the value of a property --->
<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />		<!--- hint: This can be used to set a default value for the property IF it hasn't been defined  NOTE: right now this only works for select boxes--->
<cfparam name="attributes.valueDefault" type="string" default="" />					<!--- hint: This can be used to set a default value for the property IF it hasn't been defined  NOTE: right now this only works for select boxes--->
<cfparam name="attributes.valueLink" type="string" default="" />					<!--- hint: if specified, will wrap property value with an achor tag using the attribute as the href value --->
<cfparam name="attributes.valueDisplayFormat" type="string" default="" />			<!--- hint: This can be used to defined the format of this property wehn it is displayed --->

<cfparam name="attributes.fieldName" type="string" default="" />					<!--- hint: This can be used to override the default field name" --->
<cfparam name="attributes.fieldType" type="string" default="" />					<!--- hint: When in edit mode you can override the default type of form object to use" --->

<cfparam name="attributes.titleClass" default="" />									<!--- hint: Adds class to whatever markup wraps the title element --->
<cfparam name="attributes.valueClass" default="" />									<!--- hint: Adds class to whatever markup wraps the value element --->
<cfparam name="attributes.fieldClass" default="" />									<!--- hint: Adds class to the actual field element --->
<cfparam name="attributes.valueLinkClass" default="" />								<!--- hint: Adds class to whatever markup wraps the value link element --->

<cfparam name="attributes.toggle" type="string" default="no" />						<!--- hint: This attribute indicates whether the field can be toggled to show/hide the value. Possible values are "no" (no toggling), "Show" (shows field by default but can be toggled), or "Hide" (hide field by default but can be toggled) --->
<cfparam name="attributes.displayType" default="dl" />								<!--- hint: This attribute is used to specify if the information comes back as a definition list (dl) item or table row (table) or with no formatting or label (plain) --->

<!--- Add Custom class --->
<!--- Removed for more specific class definitions <cfparam name="attributes.class" default="" /> --->

<!--- id for styling link, if specified --->
<!--- Removed for more specific id definitions <cfparam name="attributes.linkID" default="" /> --->

<!--- overwrite the generated id for the property element (dd or td) --->
<!--- Removed for more specific id definitions <cfparam name="attributes.id" default="" /> --->

<!--- if this is a dl displaytype this attribute can be used to designate if this is the first property to be displayed for proper <dt> styling --->
<!--- Removed to use the the titleClass and valueClass <cfparam name="attributes.first" default="false" /> --->

<!--- hint: This can be used to override the default data type" --->
<!--- Removed in favor of specifying as object meta data <cfparam name="attributes.dataType" default="" /> --->

<!--- hint: text that is displayed when the property value is null --->
<!--- Removing In Favor of using rbKey convention <cfparam name="attributes.nullLabel" type="string" default="" /> --->

<!--- hint: Allows you to set what gets displayed when there is no value --->
<!--- Removing In Favor of using rbKey convention  <cfparam name="attributes.noValue" type="boolean" default="false" /> --->

<!--- hint: This is used in case a sub object property has a different name than the property --->
<!--- Removing In Favor of adding method to base object for this  <cfparam name="attributes.propertyObject" type="string" default="" /> --->

<!--- hint: This attribute indicates that the property will have a tooltip mouseover message --->
<!--- Removing In Favor of using rbKey convention <cfparam name="attributes.tooltip" default="false" type="boolean" /> --->

<!--- hint: This attribute contains the content of a mouseover tooltip message to override the value in the rB (entity.entityname.propertyname_hint) --->
<!--- Removing In Favor of using rbKey convention <cfparam name="attributes.tooltipmessage" default="" type="string" /> --->

<!--- hint: This should be an array of structs that contain two paramaters: ID & Name" --->
<!--- Removing In Favor of using new SlatwallFormTag <cfparam name="attributes.editOptions" default="#arrayNew(1)#" type="array" /> --->

<!--- hint: whether to allow null (empty string) option in select box control --->
<!--- Removed because a null value should just be added to the getXXXOptions() method in the entity <cfparam name="attributes.allowNullOption" default="true" type="boolean" /> --->

<!--- hint: This attribute is the text of the link used for toggling. Two comma delimited words defaulting to "Show,Hide" --->
<!--- Removing In Favor of using rbKey convention <cfparam name="attributes.toggletext" default="Show,Hide" /> --->

<!---
	attributes.fieldType have the following options:
	
	checkbox
	file
	password
	radiogroup
	select
	text
	textarea
	wysiwyg
	
--->

<!---
	attributes.displayType have the following options:
	dl
	table
	plain
--->

<cfif thisTag.executionMode is "start">
	
	<cfif attributes.value eq "">
		<cfset attributes.value = attributes.object.getValueByPropertyIdentifier( attributes.property ) />
		<cfif isNull(attributes.value) || attributes.value eq "">
			<cfset attributes.value = attributes.valueDefault />
		</cfif>
	</cfif>
	<cfif attributes.title eq "">
		<cfset attributes.title = attributes.object.getPropertyTitle( attributes.property ) />
	</cfif>
	<cfif attributes.fieldName eq "">
		<cfset attributes.fieldName = attributes.object.getPropertyFieldName( attributes.property ) />
	</cfif>
	<cfif attributes.fieldType eq "">
		<cfset attributes.fieldType = attributes.object.getPropertyFieldType( attributes.property ) />
	</cfif>
	<cfif listFindNoCase("checkbox,radiogroup,select", attributes.fieldType)>
		<cfset attributes.valueOptions = attributes.object.invokeMethod( "get#attributes.property#Options" ) />
	</cfif>
	<cfif attributes.valueDisplayFormat eq "">
		<cfset attributes.valueDisplayFormat = attributes.object.getPropertyValueDisplayFormat( attributes.property ) />
	</cfif>
	
	<cfset attributes.titleClass = trim("title #lcase(attributes.propertyName)#title #attributes.titleClass#") />
	<cfset attributes.valueClass = trim("value #lcase(attributes.propertyName)#value #attributes.valueClass#") />
	<cfset attributes.valueLinkClass = trim("valuelink #lcase(attributes.propertyName)#valuelink #attributes.valueLinkClass#") />
	<cfset attributes.fieldClass = trim("field #lcase(attributes.propertyName)#field #attributes.fieldClass#") />
		
	<cfset local = structNew() />
	<cfset local.fw = caller.this />
	
	<cfswitch expression="#attributes.displaytype#">
		<cfcase value="dl">
			<dt class="#attributes.titleClass#">#attributes.title#</dt>
			<dd class="#attributes.valueClass#">
				<cfif rc.edit>
					<cf_SlatwallFormField fieldType="#attributes.fieldType#" fieldName="#attributes.fieldName#" fieldClass="#attributes.fieldClass#" value="#attributes.value#" valueOptions="#attributes.valueOptions#" />
				</cfif>
			</dd>
		</cfcase>
		<cfcase value="table">
			<tr>
				<td class="#attributes.titleClass#">#attributes.title#</td>
				<td class="#attributes.valueClass#">#attributes#</td>
			</tr>
			
		</cfcase>
		<cfcase value="plain">
			
			
		</cfcase>
	</cfswitch>	
</cfif>


<!---

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
		<cfif attributes.value eq "" and not attributes.noValue>
			<cfset attributes.value = evaluate('attributes.object.get#Local.PropertyMetadata.Name#()') />
	
			<cfif structKeyExists(attributes,"value")>
				<cfif isObject(attributes.value)>
					<cfset local.subEntityMetadata = getMetadata(attributes.value) />
					<cfset attributes.value = "">
					<cfloop array="#local.subEntityMetadata.properties#" index="i">
						<cfif i.name EQ attributes.property & 'ID' 
							  or i.name EQ attributes.propertyObject & 'ID'
							  or i.name EQ attributes.property
							  or i.name EQ attributes.propertyObject>
							<cfset attributes.value = evaluate("attributes.object.get#Local.PropertyMetadata.Name#().get#i.name#()") />
						<cfelseif i.name EQ attributes.property & 'Name' 
							  or i.name EQ attributes.propertyObject & 'Name'
							  or i.name EQ attributes.property
							  or i.name EQ attributes.propertyObject> 
							<cfset attributes.displayValue = evaluate("attributes.object.get#Local.PropertyMetadata.Name#().get#i.name#()") />
						</cfif>
					</cfloop>
				<cfelseif attributes.value eq "" and structKeyExists(local.propertyMetadata, "default")>
					<cfset attributes.value = local.propertyMetadata.default />
				<cfelseif (attributes.value eq "" and not structKeyExists(local.propertyMetadata,"default")) or isNull(attributes.value)>
					<cfset attributes.value = "" />
				</cfif>
			<cfelseif isNull(attributes.value) and len(attributes.nullLabel)>
				<cfset attributes.value = attributes.nullLabel />
			<cfelseif isNull(attributes.value) and !len(attributes.nullLabel) and attributes.dataType eq "boolean">
				<cfset attributes.value = 0 />
			<cfelse>
			     <cfset attributes.value = "" />
			</cfif>
		</cfif>
		
		<cfif attributes.displayValue eq "">
			<cfset attributes.displayValue = attributes.value />
		</cfif>
		
		<cfif attributes.fieldName eq "">
			<cfset attributes.fieldName = local.propertyMetadata.name />
		</cfif>
		
		<cfif trim(attributes.id) eq "">
			<!--- make id from fieldname (fieldname may have dot or array notation so we'll just take the last part) --->
		  <cfset attributes.id = "spd" & listLast(LCASE(attributes.fieldName),".]") />
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
				<dt class="spd#LCASE(attributes.property)#<cfif len(trim(attributes.class))> #attributes.class#</cfif><cfif attributes.first> first</cfif>">
			<cfelseif attributes.displaytype eq "table">
				<tr class="spd#LCASE(attributes.property)#<cfif len(trim(attributes.class))> #attributes.class#</cfif>">
				<td class="property">
			</cfif>
	        
	        <cfif attributes.displaytype neq "plain">
	        	<cfif attributes.tooltip>
	                <a href="##" class="tooltip">
	            </cfif> 			
	 			<!--- If in edit mode, then wrap title in a label tag except if it's a radiogroup, in which case the radio buttons are labeled --->
	 			<cfif attributes.edit and attributes.editType NEQ "radiogroup" and attributes.editType NEQ "file">
					<label for="#attributes.id#"<cfif structKeyExists(local.propertyMetadata, "validateRequired")> class="required"</cfif>>
						#attributes.title#
					</label>
	 			<cfelseif attributes.edit and attributes.editType EQ "file">
					<label for="#attributes.id#File"<cfif structKeyExists(local.propertyMetadata, "validateRequired")> class="required"</cfif>>
						#attributes.title#
					</label>
				<cfelseif attributes.edit and attributes.editType EQ "radiogroup">
					<div class="#attributes.fieldName#"<cfif structKeyExists(local.propertyMetadata, "validateRequired")> class="required"</cfif>>
						#attributes.title#
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
	                <a  href="##" class="toggleLink" onclick="javascript: toggleDisplay(this,'#listFirst(attributes.toggletext)#','#listGetAt(attributes.toggletext,2)#');return false">[#listGetAt(attributes.toggletext,local.initText)#]</a>
	            </cfif>	
	
				<cfif attributes.displaytype eq "dl">
					</dt>
				<cfelseif attributes.displaytype eq "table">
					</td>
				</cfif>
			</cfif> <!--- end cfif block for displayType neq "plain" (display label) --->
			
			<cfif attributes.displayType eq "dl">
				<dd class="spd#LCASE(attributes.property)#">
			<cfelseif attributes.displayType eq "table">
				<td class="value">
			</cfif>
				<cfif listFindNoCase("show,hide",attributes.toggle)>
					<div style="display:#attributes.toggle eq 'hide' ? 'none':'inherit'#">
				</cfif>
				<!--- If in edit mode, then generate necessary form field --->
				<cfif attributes.edit eq true and attributes.editType neq "none">
					<cfif attributes.editType eq "text" or attributes.editType eq "password">
						<input type="#attributes.editType#" name="#attributes.fieldName#" id="#attributes.id#" value="#attributes.value#" />
					<cfelseif attributes.editType eq "textarea">
						<textarea name="#attributes.fieldName#" id="#attributes.id#">#attributes.Value#</textarea>
					<cfelseif attributes.editType eq "checkbox">
						<input type="hidden" name="#attributes.fieldName#" id="#attributes.id#" value="" />
						<input type="checkbox" name="#attributes.fieldName#" id="#attributes.id#" value="1" <cfif attributes.value eq true>checked="checked"</cfif> />
					<cfelseif attributes.editType eq "select">
						<cfif arrayLen(attributes.editOptions) gt 0>
						<select name="#attributes.fieldName#" <cfif len(attributes.class)> class="#attributes.class#"</cfif>>
							<cfif attributes.allowNullOption>
								<option value="">#attributes.nullLabel eq "" ? request.customMuraScopeKeys.slatwall.rbKey('admin.selectBox.select') : attributes.nullLabel#</option>
							</cfif>
                            <cfset attributes.displayValue = (len(attributes.defaultValue) gt 0 AND attributes.displayValue eq "") ? attributes.defaultValue : attributes.displayValue />
 							<cfloop array="#attributes.editOptions#" index="i">
								<!--- if there is a key named "label" use that as the displayed label for the option, if not, default to the "name" key value --->
								<cfset label = structKeyExists(i,"label") ? i['label'] : i['name'] />
								<option value="#i['id']#" <cfif attributes.value eq i['id'] or attributes.displayValue eq label>selected="selected"</cfif>>#label#</option>	
							</cfloop>
						</select>
<!---						<cfelse>
							<input type="hidden" name="#attributes.fieldName#_#attributes.fieldName#ID" value="" />
							<p><em>#request.customMuraScopeKeys.slatwall.rbKey("admin.#attributes.fieldName#.no#attributes.fieldName#sdefined")#</em></p>--->
						</cfif>
					<cfelseif attributes.editType eq "radiogroup">
						<ul class="radiogroup">
						<cfif attributes.dataType eq "boolean">
							<li><input type="radio" name="#attributes.fieldName#" id="#attributes.id#yes" value="1"<cfif attributes.value> checked</cfif>> <label for="#attributes.id#yes">#request.customMuraScopeKeys.slatwall.rbKey("user.yes")#</label></li>
							<li><input type="radio" name="#attributes.fieldName#" id="#attributes.id#no" value="0"<cfif not attributes.value> checked</cfif>> <label for="#attributes.id#no">#request.customMuraScopeKeys.slatwall.rbKey("user.no")#</label></li>	
						<cfelse>
							<input type="hidden" name="#attributes.fieldName#" value="" />
							<cfloop array="#attributes.editOptions#" index="i">
								<cfset label = structKeyExists(i,"label") ? i.label : i.name />
								<li><input type="radio" name="#attributes.fieldName#" id="#i.id#" value="#i.id#"<cfif attributes.value eq i.name> checked="true"</cfif>><label for="#i.id#">#label#</label></li>
							</cfloop>
						</cfif>
						</ul>
					<cfelseif left(attributes.editType,7) eq "wysiwyg">
						<!--- see if this is a default or basic wysiwig --->
						<cfif right(attributes.editType,5) eq "basic">
							<cfset local.wysiwygType = "Basic">
						<cfelse>
							<cfset local.wysiwygType = "Default">
						</cfif>
						<textarea id="#attributes.id#txt" class="wysiwyg #local.wysiwygType#" name="#attributes.fieldName#">#attributes.Value#</textarea>
					<cfelseif attributes.editType eq "file">
					<!--- ouptut a file upload field --->
						<input type="file" name="#attributes.fieldName#File" class="file">
					</cfif>
				<cfelseif attributes.edit eq true and attributes.editType eq "none">
					<!-- A Default Edit Type Could not be created -->
				<cfelse>
					<cfif attributes.dataType eq "boolean" and attributes.value eq true>
						<cfset propertyValue = request.customMuraScopeKeys.slatwall.rbKey("sitemanager.yes") />
					<cfelseif attributes.dataType eq "boolean" and attributes.value eq false>
						<cfset propertyValue = request.customMuraScopeKeys.slatwall.rbKey("sitemanager.no") />
					<cfelse>
						<cfset propertyValue = attributes.displayValue />
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
				<cfelseif len(attributes.object.getErrorBean().getError(attributes.property))>
					<span class="formError">#attributes.Object.getErrorBean().getError(local.propertyMetaData.name)#</span>
				</cfif>
				<cfcatch><!-- Object Contains No Error Bean --></cfcatch>
			</cftry>
			<cfif listFindNoCase("show,hide",attributes.toggle)>
				</div>
			</cfif>
			<cfif attributes.displaytype eq "dl">
				</dd>
			<cfelseif attributes.displaytype eq "table">
				</td>
				</tr>
			</cfif>
	 	</cfoutput>
--->
