component displayname="Sku Option" entityname="SlatwallSkuOption" table="SlatwallSkuOption" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="skuOptionID" type="string" fieldtype="id" generator="guid";
	
	// Related Object Properties
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="option" cfc="Option" fieldtype="many-to-one" fkcolumn="optionID";

}