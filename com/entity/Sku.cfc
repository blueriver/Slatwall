component displayname="Sku" entityname="SlatwallSku" table="SlatwallSku" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="skuID" fieldtype="id" generator="guid";
	property name="originalPrice" persistent=true type="numeric";
	property name="listPrice" persistent=true type="numeric";
	
	// Related Object Properties
	property name="product" fieldtype="many-to-one" fkcolumn="ProductID" cfc="product";
	property name="stocks" fieldtype="one-to-many" fkcolumn="SkuID" cfc="stock";
	
	// Non-Persistant Properties
	property name="livePrice" persistent=false;
	property name="QOH" persistent=false type="numeric";
	property name="QC" persistent=false type="numeric";
	property name="QOO" persistent=false type="numeric";
	property name="webRetailQOH" persistent=false type="numeric";
	property name="webRetailQC" persistent=false type="numeric";
	property name="webRetailQOO" persistent=false type="numeric";
	property name="webWholesaleQOH" persistent=false type="numeric";
	property name="webWholesaleQC" persistent=false type="numeric";
	property name="webWholesaleQOO" persistent=false type="numeric";
	
}