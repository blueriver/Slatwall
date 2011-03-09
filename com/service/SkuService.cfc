component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	/**
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required struct optionsStruct, required price, required listprice) {
		// check to see if any options were selected
		if(len(arguments.optionsStruct.formCollectionsList)) {
			// get how many option groups we're dealing with and their names
			var options = arguments.optionsStruct.options;
			var optionGroupCount = structCount(options);
			var optionGroupList = structKeyList(options);
			
			// first get list of options from first option group
			var comboList = options[listFirst(optionGroupList)];
			
			// pars options struct to build list of possible option combinations
			for( var optionGroup in options ) {
				if(optionGroup != listFirst(optionGroupList)) {
					var tempList = "";
					for(var i=1;i<=listLen(comboList);i++) {
						local.thisCombo = listGetAt(comboList,i);
						local.newCombo = "";
						for(var j=1; j<=listLen(options[optionGroup]);j++) {
							newCombo = listAppend(newCombo,thisCombo & " " & listGetAt(options[optionGroup],j));
						}
						tempList = listAppend(tempList,newCombo);
					}
					comboList = tempList;
				}
			}
			for(  i=1; i<=listLen(comboList);i++ ) {
				//every option combination represents 1 Sku, so we create it
				var thisCombo = listGetAt(comboList,i);
				var thisSku = getNewEntity();
				thisSku.setProduct(arguments.product);
				thisSku.setPrice(arguments.price);
				thisSku.setListPrice(arguments.listprice);
				// loop through optionID's within the option combination and set them into the sku
				for( j=1;j<=listLen(thisCombo," ");j++ ) {
					var thisOptionID = listGetAt(thisCombo,j," ");
					thisSku.addOption(getByID(thisOptionID,"SlatwallOption"));
				}
			}
		} else {  // no options were selected so create a default sku
			var thisSku = getNewEntity();
			thisSku.setProduct(arguments.product);
			thisSku.setPrice(arguments.price);
			thisSku.setListPrice(arguments.listprice);
		}
		getDAO().save(arguments.product);
		return true;
	}
	
	

}