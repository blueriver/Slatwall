component extends="Slatwall.com.dao.productDAO" output="false" {
	
	public any function read(required string ID, required string entityName) {
		
		var productQuery = new query();
		var product = EntityNew(arguments.entityName);
		
		productQuery.setDataSource(application.Slatwall.pluginConfig.getSetting("Integration"));
		productQuery.setSQL("
			SELECT
				tb_styles.style_id as											'ProductID',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebRetail',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebWholesale',
				tb_styles.style as 												'ProductCode',
				CASE
					WHEN LEN(tb_styles.web_desc) > 0 THEN tb_styles.web_desc
					ELSE tb_styles.description
				END	 as 														'ProductName',
				tb_styles.web_long_desc as										'ProductDescription',
				CASE tb_styles.non_invt 
					WHEN 'Y' THEN 1
					ELSE 0 
				END as 															'NonInventoryItem',
				CASE tb_styles.of19
					WHEN 'TELEPHONE' THEN 1
					ELSE 0
				END as															'CallToOrder',
				CASE tb_styles.of19
					WHEN 'DROP SHIP' THEN 1
					ELSE 0
				END as															'AllowDropship',
				CASE tb_styles.of19
					WHEN 'SPECIAL ORDER' THEN 1
					ELSE 0
				END as															'AllowBackorder',
				1 as															'AllowPreorder',
				tb_styles.brand as												'Brand_BrandID',
				brandtext.web_text as											'Brand_BrandName'
			FROM
				tb_styles
			  inner join
			  	tb_inet_names brandtext on tb_styles.brand = brandtext.orig_text
			  		and brandtext.field_name = 'BRAND'
			  left join
			  	tb_inet_names gendertext on tb_styles.of1 = gendertext.orig_text
			  		and gendertext.field_name = 'OF1'
			WHERE
				tb_styles.style_id= '#arguments.ID#'
		");
		
		var rs = productQuery.execute().getResult();
		
		if(rs.recordcount) {
			product.set(rs);
		}
		
		return product;
	}
	
	public any function fillSmartList(required any smartList, required any entityName) {
		var fillTimeStart = getTickCount();
		
		var productQuery = new query();
		
		productQuery.setDataSource(application.Slatwall.pluginConfig.getSetting("Integration"));
		productQuery.setSQL("
			SELECT 
				tb_styles.style_id as											'ProductID',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebRetail',
				CASE
					WHEN tb_styles.web_product = 'Y' THEN 1
					ELSE 0
				END as															'ShowOnWebWholesale',
				tb_styles.style as 												'ProductCode',
				CASE
					WHEN LEN(tb_styles.web_desc) > 0 THEN tb_styles.web_desc
					ELSE tb_styles.description
				END	 as 														'ProductName',
				tb_styles.web_long_desc as										'ProductDescription',
				CASE tb_styles.non_invt 
					WHEN 'Y' THEN 1
					ELSE 0 
				END as 															'NonInventoryItem',
				CASE tb_styles.of19
					WHEN 'TELEPHONE' THEN 1
					ELSE 0
				END as															'CallToOrder',
				CASE tb_styles.of19
					WHEN 'DROP SHIP' THEN 1
					ELSE 0
				END as															'AllowDropship',
				CASE tb_styles.of19
					WHEN 'SPECIAL ORDER' THEN 1
					ELSE 0
				END as															'AllowBackorder',
				1 as															'AllowPreorder',
				tb_styles.brand as												'Brand_BrandID',
				brandtext.web_text as											'Brand_BrandName'
			FROM
				tb_styles
			  inner join
			  	tb_inet_names brandtext on tb_styles.brand = brandtext.orig_text
			  		and brandtext.field_name = 'BRAND'
			  left join
			  	tb_inet_names gendertext on tb_styles.of1 = gendertext.orig_text
			  		and gendertext.field_name = 'OF1'
		");
		writeDump(arguments.smartList);
		abort;
		arguments.smartList.setRecords(records=productQuery.execute().getResult());
		
		arguments.smartList.setFillTime(getTickCount()-fillTimeStart);
		return arguments.smartList;
	}
}