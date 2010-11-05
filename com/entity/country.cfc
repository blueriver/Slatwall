<cfcomponent displayname="Country" table="slatcountry" persistent="true" extends="slat.com.entity.baseEntity">
	<cfproperty name="CountryID"		type="int" fieldtype="id" generator="increment" />
	<cfproperty name="CountryName"		type="string" default="" displayname="Country Name" hint="" />
	<cfproperty name="CountryCode"		type="string" default="" displayname="Country Code" hint="" />
</cfcomponent>
