<cfcomponent persistent="true" table="slatvendoraddress" extends="slat.com.entity.baseEntity">
	<cfproperty name="VendorAddressID" fieldtype="id" generator="increment" />
		
	<!--- Related and Nested Objects --->
	<cfproperty name="Vendor" cfc="vendor" fieldtype="many-to-one" fkcolumn="VendorID" />
	<cfproperty name="AddressType" cfc="type" fieldtype="many-to-one" fkcolumn="TypeID" />
	<cfproperty name="Address" cfc="address" fieldtype="many-to-one" fkcolumn="AddressID" />
</cfcomponent>