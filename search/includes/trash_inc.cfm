
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<!---cfoutput>Echo: #form.bidID# #form.project_folder#</cfoutput--->
	<cfloop list="#form.trash#" index="i">
		<cfquery name="check_status" datasource="#application.dataSource#">
			select bidID 
			from pbt_user_projects_trash
			where bidID = #i# and userID = #session.auth.userID#
		</cfquery>
		<cfif check_status.recordcount EQ 0>
		<cfquery name="insert_bid" datasource="#application.dataSource#">
		insert into pbt_user_projects_trash
		(bidid,userid,date_entered,active)
		values(#i#,#session.auth.userid#,#date#,1)
		</cfquery>
		</cfif>
	</cfloop>
	
	<!---script>
        //alert("Callback: " + text);
			ColdFusion.Window.hide('trashProject')
			window.location.reload()
		
	</script--->
