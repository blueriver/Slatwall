component extends="mxunit.framework.TestCase" output="false" {
	public void function SetUp() {
		variables.productEntity = new Slatwall.com.entity.Product();
	}
	
	public void function getQIA_should_Equal4_when_QOHis6andQCis2() {
    	variables.productEntity.setQOH(6);
		variables.productEntity.setQC(2);
		assertEquals(4, variables.productEntity.getQIA());
    }

}
