<!---
	
	This template was built based on the specifications found here:
	http://support.google.com/merchants/bin/answer.py?hl=en&answer=188494&topic=2473824&ctx=topic#US
	
--->

<cfparam name="rc.skuSmartList" type="any" />

<cfoutput>
<?xml version="1.0"?>
<rss version="2.0" xmlns:g="http://base.google.com/ns/1.0">
	<channel>
		<title>Slatwall Product Feed</title>
		<link>http://#CGI.HTTP_HOST#</link>
		<description>Google Product Feed for http://#CGI.HTTP_HOST#</description>
		<cfloop array="#rc.skuSmartList.getRecords()#" index="local.sku">
		<item>
			<g:id>#local.sku.getSkuCode()#</g:id>
			<title>#local.sku.getProduct().getCalculatedTitle()# - #local.sku.displayOptions()#</title>
			<description>#local.sku.getProduct().getDescription()#</description>
			<g:google_product_category></g:google_product_category>
			<g:product_type>#local.sku.getProduct().getProductType().getSimpleRepresentation()#</g:product_type>
			<link>http://#CGI.HTTP_HOST##local.sku.getProduct().getProductURL()#</link>
			<g:image_link>http://#CGI.HTTP_HOST##local.sku.getResizedImagePath()#</g:image_link>
			<cfloop array="#local.sku.getProduct().getProductImages()#" index="local.image">
				<g:additional_image_link>http://#CGI.HTTP_HOST##local.image.getResizedImagePath()#</g:additional_image_link>
			</cfloop>
			<g:condition>new</g:condition>
			<g:price>#local.sku.getPrice()#</g:price>
			
			<!---
			<g:availability></g:availability>
			<g:sale_price></g:sale_price>
			<g:sale_price_effective_date></g:sale_price_effective_date>
			<g:brand></g:brand>
			<g:gtin></g:gtin>
			<g:mpn></g:mpn>
			<g:gender></g:gender>
			<g:age_group></g:age_group>
			--->
			<g:item_group_id>#local.sku.getProduct().getProductCode()#</g:item_group_id>
			<!---
			<g:color></g:color>
			<g:size></g:size>
			<g:material></g:material>
			<g:pattern></g:pattern>
			<g:tax>
			   <g:country></g:country>
			   <g:region></g:region>
			   <g:rate></g:rate>
			   <g:tax_ship></g:tax_ship>
			</g:tax>
			<g:shipping>
			   <g:country></g:country>
			   <g:region></g:region>
			   <g:service></g:service>
			   <g:price></g:price>
			</g:shipping>
			<g:shipping_weight></g:shipping_weight>
			<g:online_only></g:online_only>
			--->
		</item>
		</cfloop>
	</channel>
</rss>
</cfoutput>