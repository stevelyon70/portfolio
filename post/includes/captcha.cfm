<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<cfif not structKeyExists(url, "hash")>
   <cfabort>
</cfif>

<cfset variables.captcha = application.captcha.createCaptchaFromHashReference("stream",url.hash) />
<cfcontent type="image/jpg" variable="#variables.captcha.stream#" reset="false" />


</body>
</html>
