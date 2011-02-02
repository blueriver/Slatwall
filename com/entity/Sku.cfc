component displayname="Sku" entityname="SlatwallSku" table="SlatwallSku" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="skuID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="listPrice" ormtype="float";
	property name="price" ormtype="float";
	
	// Related Object Properties
	property name="product" fieldtype="many-to-one" fkcolumn="ProductID" cfc="product";
	property name="stocks" singularname="stock" fieldtype="one-to-many" fkcolumn="SkuID" cfc="stock" inverse="true" cascade="all";
	
	// Non-Persistant Properties
	property name="livePrice" persistent="false";
	property name="qoh" persistent="false" type="numeric";
	property name="qc" persistent="false" type="numeric";
	property name="qexp" persistent="false" type="numeric";
	property name="webQOH" persistent="false" type="numeric";
	property name="webQC" persistent="false" type="numeric";
	property name="webQEXP" persistent="false" type="numeric";
	property name="webWholesaleQOH" persistent="false" type="numeric";
	property name="webWholesaleQC" persistent="false" type="numeric";
	property name="webWholesaleQEXP" persistent="false" type="numeric";
	
}