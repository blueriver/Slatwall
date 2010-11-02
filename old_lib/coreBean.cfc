<cfcomponent output="false" name="coreBean" hint="">

	<cfset variables.instance = structnew() />
	<cfset variables.instance.Attributes = arraynew(1) />
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAttributes" returntype="array" access="public" output="false" hint="">
    	<cfreturn variables.instance.Attributes />
    </cffunction>
    <cffunction name="setAttributes" access="private" output="false" hint="">
    	<cfargument name="Attributes" type="array" required="true" />
    	<cfset variables.instance.Attributes = arguments.Attributes />
    </cffunction>
	
	<cffunction name="getAttributeValueByID" returntype="any" access="public" output="false" hint="">
    	<cfargument name="AttributeID" reqired="true" type="numeric"  />
    	<cfreturn variables.instance.Attributes[arguments.AttributeID].Value />
    </cffunction>
	
	<cffunction name="getAttributeNameByID" returntype="any" access="public" output="false" hint="">
    	<cfargument name="AttributeID" reqired="true" type="numeric" />
    	<cfreturn variables.instance.Attributes[arguments.AttributeID].Name />
    </cffunction>
    
	<cffunction name="getAttributeValueByName" returntype="any" access="public" output="false" hint="">
    	<cfargument name="Name" reqired="true" type="string" />
		
		<cfset var ReturnID = 0 />
		<cfset var I = 0 />
		
		<cfloop from="1" to="#ArrayLen(arguments.instance.Attributes)#" step="1" index="I">
			<cfif arguments.instance.Attributes[I].Name eq arguments.Name>
				<cfset ReturnID = I />
			</cfif>
		</cfloop>
		<cfif ReturnID>
			<cfreturn "" />
		<cfelse>
			<cfreturn variables.instance.Attributes[arguments.AttributeID].Value />	
		</cfif>
    </cffunction>
    
	<cffunction name="set" access="public" returntype="any" output="false">
		<cfargument name="record" type="any" required="true">
		
		<cfset var columnexists=1 />
		<cfset var currentcolumn=1 />
		<cfset var AttributeName="" />
		<cfset var AttributeValue="" />
		<cfset var RecordAttributes=arrayNew(1) />
		
		<cfif isquery(arguments.record)>
		
			<!--- Turn Attribute Columns Into Array --->
			<cfloop condition="columnexists eq 1">
				<cfif ListFindNoCase(record.ColumnList, "Attr#currentcolumn#Name")>
					<cfset AttributePair = structnew() />
					<cfset AttributePair.Name = evaluate("arguments.record.Attr#currentcolumn#Name") />
					<cfset AttributePair.Value = evaluate("arguments.record.Attr#currentcolumn#Value") />
					<cfset RecordAttributes[#currentcolumn#] = #AttributePair# />
					<cfset currentcolumn = currentcolumn + 1>
				<cfelse>
					<cfset columnexists = 0>
				</cfif>
			</cfloop>
			
			<cfset setAttributes(RecordAttributes) />
			
			<cfloop list="#arguments.record.ColumnList#" index="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate('set#prop#(arguments.record.#prop#)') />
				</cfif>
			</cfloop>
		<cfelseif isStruct(arguments.record)>
			<cfloop collection="#arguments.record#" item="prop">

				<!--- Turn Attribute Columns Into Array --->
				<cfloop condition="columnexists eq 1">
					<cfif StructKeyExists(arguments.record,"Attr#currentcolumn#Name")>
						<cfset AttributePair = structnew() />
						<cfset AttributePair.Name = evaluate("arguments.record.Attr#currentcolumn#Name") />
						<cfset AttributePair.Value = evaluate("arguments.record.Attr#currentcolumn#Value") />
						<cfset RecordAttributes[#currentcolumn#] = #AttributePair# />
						<cfset currentcolumn = currentcolumn + 1>
					<cfelse>
						<cfset columnexists = 0>
					</cfif>
				</cfloop>
				
				<cfset setAttributes(RecordAttributes) />
				
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.record[prop])") />
				</cfif>
				
			</cfloop>
		</cfif>
	</cffunction>
	
</cfcomponent>
