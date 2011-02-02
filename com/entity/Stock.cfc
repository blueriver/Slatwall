component displayname="Stock" entityname="SlatwallStock" table="SlatwallStock" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="stockID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="qoh" ormtype="integer" persistent="true" hint="Quantity On Hand, This gets decrimented when an item is Shipped, and incrimented when an item is received or transfered in";
	property name="qc" ormtype="integer" persistent="true" hint="Quantity Committed, This gets incrimented when an order is placed, and decremented when an order ships.  It is used to calculated availability";
	property name="qexp" ormtype="integer" persistent="true" hint="Quantity Expected, This is the quantity expected on either a PO or from an order that is being returned.";
	
	// Related Object Properties
	property name="location" fieldtype="many-to-one" fkcolumn="locationID" cfc="Location";
	property name="sku" fieldtype="many-to-one" fkcolumn="skuID" cfc="Sku";
	
}