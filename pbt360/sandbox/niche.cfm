<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>

 <cfquery name="w2" datasource="#application.dataSource#">
 	 SELECT [tagID]
	 FROM [paintsquare].[dbo].[pbt_tags]
	 where tag_parentID <> 0 and tag_typeID =9 and active = 1
	 order by pbt_tags.tag
 </cfquery> 
 <cfquery name="users" datasource="#application.dataSource#">
 	 SELECT userid
	 FROM [paintsquare].[dbo].[bid_subscription_log]
	 where active = 1 and packageid = 16
	 	and effective_date <= '2018-03-08'
	 	and expiration_date >= '2018-03-08'
	 order by userid
 </cfquery> 
<cfset usrs = valuelist(users.userid)>




		
	<cfoutput query="w2">
		<cfloop list="#usrs#" index="_x">
			<!---cfquery name="w1" datasource="#application.dataSource#" timeout="300"--->
			 
						 
				 insert into pbt_user_tags	 (userID, tagID, active) values (#_x#,#tagid#,1);</br>
			 			 <!---/cfquery--->  
		</cfloop> 
	</cfoutput>





</body>
</html>