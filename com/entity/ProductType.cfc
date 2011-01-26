component displayname="Product Type" entityname="SlatwallProductType" table="SlatwallProductType" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="productTypeID" type="string" fieldtype="id" generator="guid";
	property name="productType" type="string";
	
	// Related Object Properties
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID";
	
}