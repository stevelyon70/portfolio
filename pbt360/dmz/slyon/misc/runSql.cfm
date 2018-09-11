<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>
<cfparam default="" name="form.runSql" />
<body>
	<cfoutput>#session.packages#</cfoutput>
<div>
	<img src="http://www.paintbidtracker.com/images/PBT_Logo_WebHeader_Home_DoubleSize.png" width="50%" />
</div>
<form action="" method="post" >
	<div>SQL : <textarea name="runSql" ><cfoutput>#form.runSql#</cfoutput></textarea> <input type="submit" /></div>
</form>
<cfif len(form.runSql)>
	<cftry>
		<cfquery datasource="paintsquare" name="q1" result="r1">
			select top 50 *
			from pbt_docs
			where CAST(DATE_RECEIVED as DATE) = '2017-07-11' 
		</cfquery>

		<cfdump var="#r1#" />
		<cfdump var="#q1#" />
	<cfcatch><cfdump var="#cfcatch#" /></cfcatch></cftry>
</cfif>
</body>
</html>