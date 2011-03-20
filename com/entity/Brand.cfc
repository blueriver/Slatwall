component displayname="Brand" entityname="SlatwallBrand" table="SlatwallBrand" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="brandID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="brandName" ormtype="string" default="" displayname="Brand Name" validateRequired persistent="true" hint="This is the common name that the brand goes by.";
	property name="brandWebsite" ormtype="string" default="" displayname="Brand Website" validateURL persistent="true" hint="This is the Website of the brand";
	
	// Related Object Properties
	property name="products" singularname="product" cfc="Product" fieldtype="one-to-many" fkcolumn="brandID" lazy="extra" inverse="true" cascade="all";    
	property name="brandVendors" singularname="brandVendor" cfc="VendorBrand" fieldtype="one-to-many" fkcolumn="brandID" lazy="extra" inverse="true" cascade="all";
	
	// Calculated Properties
	property name="isAssigned" type="boolean" formula="SELECT count(sp.productID) from SlatwallProduct sp INNER JOIN SlatwallBrand sb on sp.brandID = sb.brandID where sp.brandID=brandID";
	
	public Brand function init(){
	   // set default collections for association management methods
	   if(isNull(variables.Products))
	       variables.Products = [];
	   return Super.init();
	}
	
	public boolean function hasProducts() {
		if(arrayLen(this.getProducts()) gt 0) {
			return true;
		} else {
			return false;
		}
	} 
 
 
 /******* Association management methods for bidirectional relationships **************/
	
	// Products (one-to-many)
	
	public void function addProduct(required Product Product) {
	   arguments.Product.setBrand(this);
	}
	
	public void function removeProduct(required Product Product) {
	   arguments.Product.removeBrand(this);
	}
	
    /************   END Association Management Methods   *******************/
}