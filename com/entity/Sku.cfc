component displayname="Sku" entityname="SlatwallSku" table="SlatwallSku" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="skuID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="listPrice" type="numeric";
	property name="price" type="numeric";
	
	// Related Object Properties
	property name="product" fieldtype="many-to-one" fkcolumn="ProductID" cfc="product";
	property name="stocks" fieldtype="one-to-many" fkcolumn="SkuID" cfc="stock";
	
	// Non-Persistant Properties
	property name="livePrice" persistent=false;
	property name="qoh" persistent=false type="numeric";
	property name="qc" persistent=false type="numeric";
	property name="qexp" persistent=false type="numeric";
	property name="webQOH" persistent=false type="numeric";
	property name="webQC" persistent=false type="numeric";
	property name="webQEXP" persistent=false type="numeric";
	property name="webWholesaleQOH" persistent=false type="numeric";
	property name="webWholesaleQC" persistent=false type="numeric";
	property name="webWholesaleQEXP" persistent=false type="numeric";
	
}