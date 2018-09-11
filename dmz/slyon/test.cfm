<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>
<cfparam default="default" name="url.test" />
<body>
	<cfmail to="slyon@technologypub.com" from="test@paintsquare.com" subject="test" type="HTML" >	
		#url.test#
	</cfmail>
</body>
</html>