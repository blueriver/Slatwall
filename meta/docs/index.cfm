<!--
	TOPICS TO COVER
	
	Bi-Directional Relationships
-->
<!DOCTYPE html>
<html>
<head>
<title>SlatwallDocs</title>
<!-- Bootstrap -->
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet" media="screen">
<link href="css/bootstrap-docs-slatwall.css" rel="stylesheet" media="screen">
<link href="css/prettify.css" rel="stylesheet" media="screen">
<!-- Favicon -->
<link rel="icon" href="img/favicon.png" type="image/png" />
<link rel="shortcut icon" href="img/favicon.png" type="image/png" />
<!-- JS --->
<script src="//code.jquery.com/jquery-latest.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/prettify.js"></script>
<script src="js/bootstrap-docs-slatwall.js"></script>
</head>
<body onload="prettyPrint();" data-spy="scroll" data-target="a">
<div class="navbar navbar-inverse navbar-fixed-top">
<div class="navbar-inner">
<div class="container">
<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
<span class="icon-bar"></span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
</a>
<a class="brand" href="#">SlatwallDocs</a>
<div class="nav-collapse collapse priarynav">
<ul class="nav">
<li class="dropdown">
<a href="javascript:void;" class="dropdown-toggle" data-toggle="dropdown">Developers</a>
<ul class="dropdown-menu ">
<li><a href="#gs">Getting Started</a></li>
<li><a href="#configuration">Configuration</a></li>
<li><a href="#frontend">Frontend Development</a></li>
<li><a href="#integration">Integration</a></li>
<li><a href="#reference">Reference</a></li>
</ul>
</li>
<li class="dropdown">
<a href="javascript:void;" class="dropdown-toggle" data-toggle="dropdown">Users</a>
<ul class="dropdown-menu ">
<li><a href="#admin">Admin Overview</a></li>
<li><a href="#account">Accounts</a></li>
<li><a href="#product">Product Management</a></li>
<li><a href="#pricing">Pricing & Promotions</a></li>
<li><a href="#order">Order Management</a></li>
<li><a href="#warehouse">Warehouse & Inventory</a></li>
</ul>
</li>
<li><a href="http://groups.google.com/group/slatwallecommerce" target="_blank">Google Group</a></li>
<li><a href="http://www.ten24web.com/" target="_blank">Professional Support</a></li>
<li><a href="http://www.getslatwall.com" target="_blank">getSlatwall.com</a></li>
</ul>
</div>
</div>
</div>
</div>

<!--------------------- DEVELOPERS --------------------------->

<!-- ============== GETTING STARTED ================== -->
<cf_docsection sectionID="gs" sectionName="Getting Started" sectionTagline="This section provides basic details about Slatwall & how to get started!" sectionType="developer">
	<cf_docitem itemID="gs-overview" itemName="Overview" />
	<cf_docitem itemID="gs-install" itemName="Download / Install" />
	<cf_docitem itemID="gs-update-2" itemName="Updating From Version 2.x" />
	<cf_docitem itemID="gs-file-structure" itemName="File Structure" />
	<cf_docitem itemID="gs-mura" itemName="Mura Integration Overview" />
</cf_docsection>

<!-- =============== CONFIGURATION =================== -->
<cf_docsection sectionID="configuration" sectionName="Configuration" sectionTagline="There are a lot of buttons to press, and knobs to turn... lets find out what they do." sectionType="developer">
	<cf_docitem itemID="configuration-app-config" itemName="Application Configuration" />
	<cf_docitem itemID="configuration-settings" itemName="Settings" />
	<cf_docitem itemID="configuration-custom-attributes" itemName="Custom Attributes" />
	<cf_docitem itemID="configuration-payment-methods" itemName="Payment Methods" />
	<cf_docitem itemID="configuration-fulfillment-methods" itemName="Fulfillment Methods (shipping)" />
</cf_docsection>

<!-- =============== FRONTENT DEV ==================== -->
<cf_docsection sectionID="frontend" sectionName="Frontend Development" sectionTagline="Time to get your hands dirty and start building your dreams." sectionType="developer">
	<cf_docitem itemID="frontend-overview" itemName="Application Configuration" />
	<cf_docitem itemID="frontend-formatting" itemName="Formatting Values" />
</cf_docsection>

<!-- ================ INTEGRATION ==================== -->
<cf_docsection sectionID="integration" sectionName="Integrations" sectionTagline="No platform can fit every business need out of the box, learn how to extend slatwall to fit your needs." sectionType="developer">
	<cf_docitem itemID="integration-overview" itemName="Overview" />
</cf_docsection>

<!-- ================ REFERENCE ====================== -->
<cf_docsection sectionID="reference" sectionName="Reference" sectionTagline="For when you need to dig a little deeper." sectionType="developer">
	<cf_docitem itemID="reference-smart-list" itemName="Smart List" />
	<cf_docitem itemID="reference-slatwall-scope" itemName="Slatwall Scope" />
	<cf_docitem itemID="reference-events" itemName="Events" />
</cf_docsection>

<!--------------------- USERS --------------------------->
<div id="user"></div>

<!-- ============== ADMIN =================== -->
<cf_docsection sectionID="admin" sectionName="Administrator Overview" sectionTagline="You got your login from IT... Now what do you do?" sectionType="user">
	<cf_docitem itemID="admin-dashboard" itemName="Dashboard" />
</cf_docsection>

<!-- ============== ACCOUNT =================== -->
<cf_docsection sectionID="account" sectionName="Accounts" sectionTagline="This guide will provide the base understanding of how accounts work." sectionType="user">
	<cf_docitem itemID="account-overview" itemName="Overview" />
</cf_docsection>

<!-- ============== PRODUCT =================== -->
<cf_docsection sectionID="product" sectionName="Product Management" sectionTagline="Everything about Products, Product Types, Brands, ect." sectionType="user">
	<cf_docitem itemID="product-overview" itemName="Overview" />
</cf_docsection>

<!-- ============== PRICING =================== -->
<cf_docsection sectionID="pricing" sectionName="Pricing & Promotions" sectionTagline="Lets be honest... It's all about getting paid, so you should get a handle on your pricing!" sectionType="user">
	<cf_docitem itemID="pricing-overview" itemName="Overview" />
</cf_docsection>

<!-- ============== ORDER =================== -->
<cf_docsection sectionID="order" sectionName="Order Management" sectionTagline="Now that we are taking orders, lets make sure it doesn't get out of control." sectionType="user">
	<cf_docitem itemID="order-overview" itemName="Overview" />
</cf_docsection>

<!-- ============== WAREHOUSE =================== -->
<cf_docsection sectionID="warehouse" sectionName="Warehouse & Inventory" sectionTagline="Inventory is always moving, learn how to keep an eye on it" sectionType="user">
	<cf_docitem itemID="warehouse-overview" itemName="Overview" />
</cf_docsection>


<div class="container">
<footer>
<p>&copy; ten24 Web Solutions</p>
</footer>
</div>

</body>
</html>