<cfcomponent persistent="true" table="slattype" extends="slat.com.entity.baseEntity">
	<cfproperty name="TypeID" fieldtype="id" generator="guid" />
	<cfproperty name="Type" />
	<cfproperty name="ParentType" cfc="Type" fieldtype="many-to-one" fkcolumn="ParentTypeID" />
	<cfproperty name="ChildType" type="array" cfc="Type" fieldtype="one-to-many" fkcolumn="ParentTypeID" cascade="all" inverse="true" />
	
	<cffunction name="getChildType">
		<cfif not isDefined('variables.ChildType')>
			<cfset variables.ChildType = arrayNew(1) />
		</cfif>
		
		<cfreturn variables.ChildType />
	</cffunction>
</cfcomponent>
