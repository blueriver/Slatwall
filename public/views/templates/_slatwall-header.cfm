<!---
	
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.
	
Notes: 
	
--->
<!DOCTYPE html>
<html lang="en">
	<head>
	    <meta charset="utf-8">
	    <title>Slatwall</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<!--- jQuery & Slatwall are the only two Javascript includes required for Slatwall to function properly.  You can either reference the slatwall --->
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
		<script src="#$.slatwall.getBaseURL()#/assets/js/jquery-slatwall.min.js"></script>
		
		<!--- AngularJS is required for some of the ajax type of functions on this page.  You can remove AngularJS but you will need to do you own AJAX using the Slatwall jQuery plugin --->
		<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.3/angular.min.js"></script>
		
		<!--- Bootstrap is just included for demo / example purposes.  Removing it will not stop Slatwall from working --->
		<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
		<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
	</head>
	<body style="margin-top:40px;">
		<div class="container">
			<div class="navbar navbar-inverse navbar-fixed-top">
				<div class="navbar-inner">
					<div class="container">
						<div class="nav-collapse">
							<ul class="nav">
								<li><a href="?slatAction=frontend:page.slatwall-productlisting">Product List</a></li>
								<li><a href="?slatAction=frontend:page.slatwall-account">Account</a></li>
								<li><a href="?slatAction=frontend:page.slatwall-shoppingcart">Shopping Cart</a></li>
								<li><a href="?slatAction=frontend:page.slatwall-checkout">Checkout</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>