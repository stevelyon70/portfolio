<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<!---<cfoutput>Echo: #form.bidID# #form.project_folder#</cfoutput>--->
<cfif project_folder is not 0 and project_folder is not "new"><!---save to existing folder--->

	<cfloop list="#form.bidID#" index="i">
	<cfquery name="getprojectname" datasource="#application.dataSource#">select projectname from pbt_project_master where bidid = #i#</cfquery>
	<cfquery name="insert_bid" datasource="#application.dataSource#">
	insert into bid_user_project_bids
	(bidid,folderid,userid,date_entered,projectname,active)
	values(#i#,#form.project_folder#,#form.userid#,#date#,'#getprojectname.projectname#',1)
	</cfquery>
	<cfquery name="grablast" datasource="#application.dataSource#">
	   		select max(projectid) as lastprojectid
	   		from bid_user_project_bids
	   		where userid = #form.userid# and bidid = #i# and active = 1
	    	</cfquery>
		<cfset projectid = #grablast.lastprojectid#>	
		</cfloop>
<cfelseif project_folder is "new">
		<cflocation url="?action=106&bidid=#form.bidid#&userid=#form.userid#" addtoken="No">	


</cfif>