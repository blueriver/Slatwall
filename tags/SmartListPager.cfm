<cfparam name="attributes.smartList" type="array" />
<cfparam name="attributes.showOptions" default="10,25,50,100,250,1000" />

<cfset variables.fw = caller.this />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="smartListPager">
			<ul class="pages">
				<li class="prev"><a href="">Prev</a></li>
				<cfloop from="1" to="#attributes.smartList.getTotalPages()#" step="1" index="local.i">
					<li class="page#i#"><a href="#attributes.smartList.getPageURL(local.i)#"></a></li>
				</cfloop>
				<li class="next"><a href="">Next</a></li>
			</ul>
			<form name="productsPerPage" method="get">
				<select name="P_Show">
					<cfloop list="attributes.showOptions" index="local.i" >
						<option value="#local.i#">local.i</option>
					</cfloop>
				</select>
			</form>
		</div>
	</cfoutput>
</cfif>