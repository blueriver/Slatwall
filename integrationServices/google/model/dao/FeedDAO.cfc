<cfcomponent accessors="true" output="false">
	
	
	<cffunction name="getProductFeedQuery" access="public" output="false" returntype="Query">
		<cfset rs = "" />
		
		<cfquery name="rs">
			SELECT
				SwSku.skuCode,
				SwProduct.calculatedTitle,
				
			FROM
				SwSku
			  INNER JOIN
			  	SwProduct
			WHERE
				SwSku.activeFlag = 1
			  AND
			  	SwProduct.activeFlag = 1
			  AND
			  	SwProduct.publishedFlag = 1
			  AND
			  	SwProduct.calculatedQATS > 0
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
</cfcomponent>