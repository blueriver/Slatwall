component displayname="Stock" entityname="SlatwallStock" table="SlatwallStock" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="stockID" fieldtype="id" generator="guid";
	property name="QOH" type="numeric" persistent="true";
	property name="QC" type="numeric" persistent="true";
	property name="QOO" type="numeric" persistent="true";
	
	// Related Object Properties
	property name="location" fieldtype="many-to-one" fkcolumn="locationID" cfc="Location";
	property name="sku" fieldtype="many-to-one" fkcolumn="skuID" cfc="Sku";
}