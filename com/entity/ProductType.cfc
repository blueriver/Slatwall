component displayname="Product Type" entityname="SlatwallProductType" table="SlatwallProductType" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="productTypeID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="productType" ormtype="string";
	
	// Related Object Properties
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID";
	
}