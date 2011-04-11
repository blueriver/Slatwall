<cfoutput>
	<cfif rc.edit>
		<input type="hidden" name="contentID" value="" />
		<cfif rc.productPages.getRecordCount() gt 0>
			<table id="ProductPagesSelect" class="stripe">
				<tr>
					<th></th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productPages.pageTitle")#</th>
				</tr>
				<cfloop condition="rc.productPages.hasNext()">
					<tr>
						<cfset local.thisProductPage = rc.productPages.next() />
						<td>
							<input type="checkbox" id="productPage#local.thisProductPage.getContentID()#" name="contentID" value="#local.thisProductPage.getContentID()#"<cfif listFind(rc.product.getContentIDs(),local.thisProductPage.getContentID())> checked="checked"</cfif> /> 
						</td>
						<td class="varWidth">
							<label for="productPage#local.thisProductPage.getContentID()#">#local.thisProductPage.getTitle()#</label>
						</td>
					</tr>	
				</cfloop>
			</table>
		<cfelse>
			<p><em>#rc.$.Slatwall.rbKey("admin.product.noproductpagesdefined")#</em></p>
		</cfif>
	<cfelse>
		<cfif arrayLen(rc.product.getProductContent())>
			<table id="ProductPages" class="stripe">
				<tr>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productPages.pageTitle")#</th>
					<th>#rc.$.Slatwall.rbKey("admin.product.productPages.preview")#</th>
				</tr>
				<cfloop array="#rc.product.getProductContent()#" index="local.thisProductContent">
					<cfset local.thisContentBean = rc.$.getBean("content").loadBy(contentID=local.thisProductContent.getContentID()) />
					<tr>
						<td class="varWidth">#local.thisContentBean.getTitle()#</td>
						<td class="administration">
							<ul class="one">
								<li class="preview"><a href="#local.thisContentBean.getURL()#" target="_blank">Preview</a></li>
							</ul>
						</td>
					</tr>
				</cfloop>
			</table>
		<cfelse>
			<em>#rc.$.Slatwall.rbKey("admin.product.productPages.noProductPagesAssigned")#</em>
		</cfif>
	</cfif>	
</cfoutput>