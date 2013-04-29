component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="task";

	// Data Properties
	property name="updateOrderFlag" hb_formFieldType="yesno" hb_formatType="yesno" sw_taskConfig="true";
	property name="updateStockSkuProductFlag" hb_formFieldType="yesno" hb_formatType="yesno" sw_taskConfig="true";
	
}