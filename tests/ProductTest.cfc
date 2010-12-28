component extends="mxunit.framework.TestCase" output="false" {
	public void function SetUp() {
		variables.productEntity = new Slatwall.com.entity.Product();
		// Setup Code Here
	}
	
	public void function testEntityMethodGetQIA() {
		variables.productEntity.setQOH(6);
		variables.productEntity.setQC(2);
		variables.productEntity.setQOO(8);
		assertEquals(4, variables.productEntity.getQIA());
	}
}
