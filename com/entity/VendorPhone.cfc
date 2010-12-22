<cfcomponent persistent="true" table="slatvendorphone" extends="slat.com.entity.baseEntity">
	<cfproperty name="VendorPhoneID" fieldtype="id" generator="increment" />
	<cfproperty name="PhoneNumber" type="string" />
	
	<!--- Related and Nested Objects --->
	<cfproperty name="Vendor" cfc="vendor" fieldtype="many-to-one" fkcolumn="VendorID" />
	<cfproperty name="PhoneType" cfc="type" fieldtype="many-to-one" fkcolumn="TypeID" />
</cfcomponent>
