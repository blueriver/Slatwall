component output="false" update="true" extends="HibachiService" {
	
	// before{EntityName}Save
	// after{EntityName}Save
	// after{EntityName}SaveSuccess
	// after{EntityName}SaveFailure
	
	// before{EntityName}Delete
	// after{EntityName}Delete
	// after{EntityName}DeleteSuccess
	// after{EntityName}DeleteFailure
	
	// before{EntityName}Process
	// after{EntityName}Process
	// after{EntityName}ProcessSuccess
	// after{EntityName}ProcessFailure
	
	// before{EntityName}Process_{processContext}
	// after{EntityName}Process_{processContext}
	// after{EntityName}Process_{processContext}
	// after{EntityName}Process_{processContext}
	
	public void function announceEvent() {
		
	}
	
	public void function registerEvent( required string eventName, required string componentPath, required string methodName ) {
		
	}
	
	public void function registerEventHandler( required any eventHandler ) {
		
	}
	
	public array function getEventOptions() {
		
	}
}