component extends="BaseController" output="false" {
	
	public void function toolbar(required struct rc) {
		request.generateSES = false;
		request.layout = false;
	}
	
}