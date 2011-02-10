<cfoutput>

<cfif arrayLen(rc.options) GT 0>
There are options.
<cfelse>
<p>#rc.rbFactory.getKey("option.nooptionsdefined")#</p>
<ul id="navTask">
    <li><a href="#buildURL(action='admin:option.optionGroupForm')#">#rc.rbFactory.getKey("option.addoptiongroup")#</a></li>
</ul>
</cfif>

</cfoutput>