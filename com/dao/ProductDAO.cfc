component extends="slatwall.com.dao.BaseDAO" {

	public any function getSmartList(required struct rc, required string entityName){
		
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=arguments.entityName, entityPerfix="Slatwall");
		
		smartList.addKeywordProperty(rawProperty="productCode", weight=9);
		smartList.addKeywordProperty(rawProperty="productName", weight=3);
		smartList.addKeywordProperty(rawProperty="productYear", weight=6);
		smartList.addKeywordProperty(rawProperty="productDescription", weight=1);
		smartList.addKeywordProperty(rawProperty="brand_brandName", weight=3);
		
		return smartList;	
	}
	
	public any function getProductContentSmartList(required struct rc, required string entityName, required string contentID) {
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName="SlatwallProductContent", entityPerfix="Slatwall");
		
		smartList.addKeywordProperty(rawProperty="product_productCode", weight=9);
		smartList.addKeywordProperty(rawProperty="product_productName", weight=3);
		smartList.addKeywordProperty(rawProperty="product_productYear", weight=6);
		smartList.addKeywordProperty(rawProperty="product_productDescription", weight=1);
		smartList.addKeywordProperty(rawProperty="product_brand_brandName", weight=3);
		
		var HQL = "Select product from SlatwallProductContent aSlatwallProductContent where aSlatwallProductContent.contentID = :contentID #smartList.getHQLWhereOrder(true)#";
		smartList.addHQLWhereParam("contentID", arguments.contentID);
		smartList.setRecords(ormExecuteQuery(HQL, smartList.getHQLWhereParams(), false, {ignoreCase="true"}));
		
		return smartList;
	}
	
	public any function clearProductContent(required any product) {
		ORMExecuteQuery("Delete from SlatwallProductContent WHERE productID = '#arguments.product.getProductID()#'");
		//arguments.product.setProductContent(arrayNew(1));
	}
}