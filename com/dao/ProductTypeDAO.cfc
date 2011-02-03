component extends="slatwall.com.dao.BaseDAO" accessors="true" {

    property name="ProductTypeTreeSorter" type="any";
	
	public any function init(required any productTypeTreeSorter) {
	   setProductTypeTreeSorter(arguments.productTypeTreeSorter);
       return this;
    }

    public any function getProductTypeTree() {
	   var qs = new query();
	   qs.setSQL("SELECT productTypeID, productType, parentProductTypeID
	               FROM SlatwallProductType
				   ORDER BY productType ASC");
	   // return query sorted Product Type tree 
	   return getProductTypeTreeSorter().sortQuery(qs.execute().getResult());
	}
	
}