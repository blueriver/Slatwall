<cfset variables.framework.applicationKey="Slatwall" />
<cfset variables.framework.action="slatAction" />

<!--- Configure the example public UI --->
<cfset arrayAppend(variables.framework.routes, {"$GET/account/" = "/public:main/account/"}) />
<cfset arrayAppend(variables.framework.routes, {"$GET/brand/:urlTitle" = "/public:main/brand/urlTitle/:urlTitle/"}) />
<cfset arrayAppend(variables.framework.routes, {"$GET/checkout/" = "/public:main/checkout/"}) />
<cfset arrayAppend(variables.framework.routes, {"$GET/product/:urlTitle" = "/public:main/product/urlTitle/:urlTitle/"}) />
<cfset arrayAppend(variables.framework.routes, {"$GET/products/" = "/public:main/default/"}) />
<cfset arrayAppend(variables.framework.routes, {"$GET/producttype/:urlTitle" = "/public:main/producttype/urlTitle/:urlTitle/"}) />
<cfset arrayAppend(variables.framework.routes, {"$GET/shoppingcart/" = "/public:main/shoppingcart/"}) />
