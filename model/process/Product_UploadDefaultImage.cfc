component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="product";

	// Data Properties
	property name="imageFile";
	property name="uploadFile" hb_formFieldType="file" hb_fileAcceptMIMEType="image/*" hb_fileAcceptExtension=".jpeg,.jpg,.png,.gif";
	
}