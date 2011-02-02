component displayname="Vendor Sku Stock" entityname="SlatwallVendorSkuStock" table="SlatwallVendorSkuStock" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="vendorSkuStockID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="cost" ormtype="float";
	property name="quantity" ormtype="integer";
	property name="availableDateTime" ormtype="date";
	property name="lastUpdatedDateTime" ormtype="date";
	
	// Related Object Properties
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";	
}