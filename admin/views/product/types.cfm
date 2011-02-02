<cfparam name="rc.productTypes" default="#ArrayNew(1)#" type="array" />
<cfoutput>
<cfloop array="#rc.productTypes#" index="local.thisType">
#local.thisType.getProductType()#
</cfloop>
</cfoutput>