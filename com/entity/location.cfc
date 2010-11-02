<cfcomponent displayname="Location" table="slatlocation" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="LocationID" fieldtype="id" generator="guid" />
	<cfproperty name="LocationName" />
	
</cfcomponent>