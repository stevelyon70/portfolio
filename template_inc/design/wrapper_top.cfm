<!DOCTYPE html>
<html lang="en" class="no-js">
	<head>
		<title>PBT360: Market Analytics and Business Intelligence for the Coatings Industry</title>
		<meta charset="utf-8" />
		<meta name="referrer" content="origin">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta content="" name="description" />
		<meta content="" name="author" />
		<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
		<link rel="icon" href="/favicon.ico" type="image/x-icon">
		<cfinclude template="../style_inc.cfm">
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>		
		<!--[if gte IE 9]><!-->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
		<!--<![endif]-->
	</head>
	<body class="header-default">
		<cftry>
			<cfinclude template="../header_inc.cfm">
		<cfcatch><cfdump var="#cfcatch#" /></cfcatch></cftry>
		<div class="main-container">
			<cftry>
			<cfparam name="url.dashboardx" default="" />
			<cfinclude template="../side_nav_inc.cfm">
			<cfcatch><cfdump var="#cfcatch#" /></cfcatch></cftry>
			<div class="main-content">
				
				<div class="container">
				<!-- breadcrumb -->
					<cfinclude template="../breadcrumb.cfm" />