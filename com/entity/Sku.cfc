component displayname="Sku" entityname="SlatwallSku" table="SlatwallSku" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="skuID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="listPrice" ormtype="float";
	property name="price" ormtype="float";
	property name="isDefault" default="false" ormtype="boolean";  
	
	// Related Object Properties
	property name="product" fieldtype="many-to-one" fkcolumn="productID" cfc="product";
	property name="stocks" singularname="stock" fieldtype="one-to-many" fkcolumn="SkuID" cfc="stock" inverse="true" cascade="all";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallSkuOption" fkcolumn="skuID" inversejoincolumn="optionID" cascade="save-update"; 
	
	// Non-Persistant Properties
	property name="livePrice" persistent="false" hint="this property should calculate after term sale";
	property name="qoh" persistent="false" type="numeric";
	property name="qc" persistent="false" type="numeric";
	property name="qexp" persistent="false" type="numeric";
	property name="webQOH" persistent="false" type="numeric";
	property name="webQC" persistent="false" type="numeric";
	property name="webQEXP" persistent="false" type="numeric";
	property name="webWholesaleQOH" persistent="false" type="numeric";
	property name="webWholesaleQC" persistent="false" type="numeric";
	property name="webWholesaleQEXP" persistent="false" type="numeric";
	
    public Sku function init() {
       // set default collections for association management methods
       if(isNull(variables.Options)) {
       	    variables.options=[];
       }
       return Super.init();
    }
    
    public string function displayOptions() {
    	var options = getOptions();
    	var dspOptions = "";
    	for(var i=1;i<=arrayLen(options);i++) {
    		var thisOption = options[i];
    		dspOptions = listAppend(dspOptions,thisOption.getOptionName()," ");
    	}
		return dspOptions;
    }

	/******* Association management methods for bidirectional relationships **************/
	
	// Product (many-to-one)
	
	public void function setProduct(required Product Product) {
	   if(isNew() or !arguments.Product.hasSku(this)) {
	   	   variables.product = arguments.Product;
	       arrayAppend(arguments.Product.getSkus(),this);
	   }
	}
	
	public void function removeProduct(required Product Product) {
       var index = arrayFind(arguments.Product.getSkus(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Product.getSkus(),index);
       }    
       structDelete(variables,"Product");
    }
    
    // Option (many-to-many)
    public void function addOption(required Option Option) {
        if(!hasOption(arguments.option)) {
        	// first add option to this Sku
        	arrayAppend(this.getOptions(),arguments.option);
        	// add this Sku to the option
        	arrayAppend(arguments.Option.getSkus(),this);
        }	
    }
    
    public void function removeOption(required Option Option) {
       // first remove the option from this Sku    
       if(hasOption(arguments.option)) {
	       var index = arrayFind(this.getOptions(),arguments.option);
	       if(index>0) {
	           arrayDeleteAt(this.getOptions(),index);
	       }
	      // then remove this Sku from the Option
	       var index = arrayFind(arguments.Option.getSkus(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.Option.getSkus(),index);
	       }
	   }
    }
    /************   END Association Management Methods   *******************/
    
    public void function setIsDefault(required boolean isDefault) {
		if(arguments.isDefault == true) {
			var skus = getProduct().getSkus();
			for(var i = 1; i <= arrayLen(skus); i++) {
				if(skus[i].getIsDefault() == true) {
					skus[i].setIsDefault(false);
					getService("skuService").save(entity=skus[i]);
				}
			}
		}
		variables.isDefault = arguments.isDefault;
	}
    
    public numeric function getQOH() {
    	if(isNull(variables.qoh)) {
    		variables.qoh = 0;
    		var stocks = getStocks();
    		for(var i = 1; i<= arrayLen(stocks); i++) {
    			variables.qoh += stocks[i].getQOH();
    		}
    	}
    	return variables.qoh;
    }
    
    public numeric function getQC() {
    	if(isNull(variables.qc)) {
    		variables.qc = 0;
    		var stocks = getStocks();
    		for(var i = 1; i<= arrayLen(stocks); i++) {
    			variables.qc += stocks[i].getQC();
    		}
    	}
    	return variables.qc;
    }
    
    public numeric function getQEXP() {
       	if(isNull(variables.qexp)) {
    		variables.qc = 0;
    		var stocks = getStocks();
    		for(var i = 1; i<= arrayLen(stocks); i++) {
    			variables.qexp += stocks[i].getQEXP();
    		}
    	}
    	return variables.qc;
    }
	
	public numeric function getQIA() {
		return getQOH() - getQC();
	}
	
	public numeric function getQEA() {
		return (getQOH() - getQC()) + getQEXP();
	}
	
	public string function getImagePath() {
		if(!structKeyExists(variables, "imagePath") or isNull(variables.imagePath)) {
			var options = getOptions();
			var optionString = "";
			for(var i=1; i<=arrayLen(options); i++){
				if(options[i].getOptionGroup().getIsImageGroup()){
					optionString &= "_#options[i].getOptionCode()#";
				}
			}
			variables.imagePath = "/default/assets/images/Slatwall/#getProduct().getProductCode()##optionString#.jpg";
		}
		return variables.imagePath;
	}
	
	public any function getOptionsByGroupIDStruct() {
		if(!structKeyExists(variables, "OptionsByGroupIDStruct")) {
			variables.OptionsByGroupIDStruct = structNew();
			var options = getOptions();
			for(var i=1; i<=arrayLen(options); i++) {
				if( !structKeyExists(variables.OptionsByGroupIDStruct, options[i].getOptionGroup().getOptionGroupID())){
					variables.OptionsByGroupIDStruct[options[i].getOptionGroup().getOptionGroupID()] = options[i];
				}
			}
		}
		return variables.OptionsByGroupIDStruct;
	}
	
	public any function getOptionByOptionGroupID(required string optionGroupID) {
		var optionsStruct = getOptionsByGroupIDStruct();
		return optionsStruct[arguments.optionGroupID];
	}
}