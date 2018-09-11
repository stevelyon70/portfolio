<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>
<cfparam default="#dateformat(now(), 'yyyy-mm-dd')#" name="url.runDate" />
<cfquery datasource="paintsquare" name="q1" result="r1">
	select count(*) as cnt
	from pbt_docs
	where CAST(DATE_RECEIVED as DATE) = '#url.runDate#'
</cfquery>
<!-- get log file -->
<cffile action="READ" file="C:\ColdFusion11\pbt_cms\logs\pbt_s3_docs.log" variable="f1" result="r1" />
<body>
<div>
	<img src="http://www.paintbidtracker.com/images/PBT_Logo_WebHeader_Home_DoubleSize.png" width="50%" />
</div>
<form action="" method="get" >
	<div>Select Date : <input type="date" name="runDate" value="<cfoutput>#url.runDate#</cfoutput>"  /> <input type="submit" /></div>
</form>

<div>
	<h2><cfoutput>#q1.cnt# Docs upload for #url.runDate#</cfoutput></h2>
</div>
<cfset request.totRecs = listlen(f1, chr(13)) />
<cfset request.startDisplay = request.totRecs - 10 />
<cfset request.startDisplay = max(request.startDisplay, 0) />
<cfset request.y= 1>

<cfloop list="#f1#" delimiters="#chr(13)#" index="_x">
<div>
	<cfif _x contains 'PBT_CMS'>
		<cfset thisRecord = listtoarray(_x) />
		<cftry>
		<cfif request.y gte request.startDisplay>
		<cfoutput>#thisRecord[1]# : #thisRecord[3]# : #thisRecord[4]# : #thisRecord[6]#</cfoutput>	
		</cfif>
		<cfcatch></cfcatch></cftry>
		<cfset request.y = request.y+1>
	</cfif>
</div>
<!---cfif y gte 10><cfbreak /></cfif---->
</cfloop>






<!--- Set the Time that is the lower bound of the window --->
<cfset SystemTime = TimeFormat(CreateTime(7, 00, 00))> 

<!--- Set the Time that is the upper bound of the window --->
<cfset SystemTime2 = TimeFormat(CreateTime(13, 00, 00))> 

<!--- Set the current Time --->
<cfset CurrentTime = TimeFormat(CreateTime(Hour(Now()), Minute(Now()), Second(Now())))>



<!--- Test to see if the respondent is here too early --->
<cfif CurrentTime LT SystemTime>
<div ><a href="s3_doc_uploader.cfm" target="_blank">Run the Doc Upload</a></div>
<cfelse>

<!--- Test to see if the respondent is here too late --->
<cfif CurrentTime GT SystemTime2>
<div ><a href="s3_doc_uploader.cfm" target="_blank">Run the Doc Upload</a></div>
<cfelse>

</cfif>

</cfif>

</body>
</html>