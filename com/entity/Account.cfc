<cfcomponent displayname="Account" entityname="slataccount" table="slataccount" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="AccountID" 				type="string" fieldtype="id" generator="guid" />
	<cfproperty name="MuraUserID"				type="string" default="" hint="This is the mura user id that ties an account to a login" />
	<cfproperty name="FirstName"				type="string" default="" hint="This Value is only Set if a MuraID does not exist" />
	<cfproperty name="LastName" 				type="string" default="" hint="This Value is only Set if a MuraID does not exist" />
	<cfproperty name="Company" 					type="string" default="" hint="This Value is only Set if a MuraID does not exist" />
	<cfproperty name="RemoteEmployeeID"			type="string" default="" hint="Only used when integrated with a remote system" />
	<cfproperty name="RemoteCustomerID"			type="string" default="" hint="Only used when integrated with a remote system" />
	<cfproperty name="RemoteContactID"			type="string" default="" hint="Only used when integrated with a remote system" />
	
	<cfproperty name="MuraUser"					type="any" persistent="false" />
	
	<!--- Start: Override if MuraUserID exists --->
	<cffunction name="getMuraUser">
		<cfif not isDefined('variables.MuraUser')>
			<cfif isDefined('variables.MuraUserID') and variables.MuraUserID neq ''>
				<cfset variables.MuraUser = application.userManager.getByID(variables.MuraUserID) />
			</cfif>
		</cfif>
		
		<cfreturn variables.MuraUser />
	</cffunction>
	
	<cffunction name="getFirstName">
		<cfif not isDefined('variables.FirstName') or variables.FirstName eq ''>
			<cfset variables.FirstName = getMuraUser().getFirstName() />
		</cfif>
		
		<cfreturn variables.FirstName />
	</cffunction>
	
	<cffunction name="getLastName">
		<cfif not isDefined('variables.LastName') or variables.LastName eq ''>
			<cfset variables.LastName = getMuraUser().getLastName() />
		</cfif>
		
		<cfreturn variables.LastName />
	</cffunction>
	
	<cffunction name="getCompany">
		<cfif not isDefined('variables.Company') or variables.Company eq ''>
			<cfset variables.Company = getMuraUser().getCompany() />
		</cfif>
		
		<cfreturn variables.Company />
	</cffunction>
	<!--- End: Override if MuraUserID exists --->
	
</cfcomponent>
