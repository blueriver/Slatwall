<cfcomponent displayname="Account" table="slataccount" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="AccountID" fieldtype="id" generator="guid" />
	<cfproperty name="MuraUserID" />
	<cfproperty name="FirstName" />
	<cfproperty name="LastName" />
	
</cfcomponent>
