<cfparam name="attributes.smartList" type="any" />
<cfparam name="attributes.showValue" default="" />
<cfparam name="attributes.showOptions" default="10,25,50,100,250,1000,ALL" />

<cfset variables.fw = caller.this />

<cfif attributes.showValue eq "">
	<cfif structKeyExists(url, "P:Show")>
		<cfset attributes.showValue = url["P:Show"] />
	<cfelseif structKeyExists(form, "P:Show")>
		<cfset attributes.showValue = form["P:Show"] />
	<cfelse>
		<cfset attributes.showValue = "10" />
	</cfif>
</cfif>

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="smartListPager">
			<cfif attributes.smartList.getTotalPages() gt 1>
				<span class="showing">Showing #attributes.smartList.getPageRecordsStart()#-#attributes.smartList.getPageRecordsEnd()# (of #attributes.smartList.getRecordsCount()#)</span>
				<ul class="pages">
					<cfif attributes.smartList.getCurrentPage() gt 1>
						<li class="prev"><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() - 1#')#">Prev</a></li>
					</cfif>
					<cfloop from="1" to="#attributes.smartList.getTotalPages()#" step="1" index="i">
						<cfset currentPage = attributes.smartList.getCurrentPage() />
						<li class="page#i#<cfif currentPage eq i> current</cfif>">
							<cfif currentPage neq i>
								<a href="#attributes.smartList.buildURL('P:Current=#i#')#">#i#</a>
							<cfelse>
								<span>#i#</span>
							</cfif>
						</li>
					</cfloop>
					<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
						<li class="next"><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() + 1#')#">Next</a></li>
					</cfif>
				</ul>
			</cfif>
			<cfset selectID = createUUID().toString() />
			<span class="show">Show: </span>
			<select id="#selectID#" name="P:Show">
				<cfloop list="#attributes.showOptions#" index="i" >
					<option value="#attributes.smartList.buildURL('P:Show=#i#')#" <cfif attributes.showValue eq i>selected='selected'</cfif>>#i#</option>
				</cfloop>
			</select>
			
			<script type="text/javascript">
				$('###selectID#').change(function() {
					window.location.href = $('###selectID#').val();
				});
			</script>
		</div>
	</cfoutput>
</cfif>