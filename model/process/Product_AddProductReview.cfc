component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="product";

	// Data Properties
	property name="newProductReview" cfc="ProductReview" fieldType="many-to-one" persistent="false" fkcolumn="productReviewID";
	
	public any function getNewProductReveiw() {
		if(!structKeyExists(variables, "newProductReview")) {
			variables.newProductReview = getService("productService").newProductReview();
		}
		return variables.newProductReview;
	}
	
}