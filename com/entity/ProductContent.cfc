component displayname="Product Content" entityname="SlatwallProductContent" table="SlatwallProductContent" persistent=true output=false accessors=true extends="slatwall.com.entity.baseEntity" {
	
	// Persistent Properties
	property name="productContentID" ormtype="string" length="35" fieldtype="id" generator="uuid";
	property name="contentID" ormtype="string" length="35";  
	
	// Related Object Properties
	//property name="content" cfc="Content" fieldtype="many-to-one" hint="Mura Content ID" fkcolumn="contentID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="ProductID";
	
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Product (many-to-one)
	
	public void function setProduct(required Product Product) {
	   variables.product = arguments.Product;
	   if(isNew() or !arguments.Product.hasProductContent(this)) {
	       arrayAppend(arguments.Product.getProductContent(),this);
	   }
	}
	
	public void function removeProduct(required Product Product) {
       var index = arrayFind(arguments.Product.getProductContent(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Product.getProductContent(),index);
       }    
       entityDelete(this);
    }
    
	/************   END Association Management Methods   *******************/
		
}