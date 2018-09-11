
<!---get list of bids not to display based on user trash--->	
	<cfquery name="user_trash" datasource="#application.datasource#">
		select bidID 
		from pbt_user_projects_trash
		where userID = #session.auth.userid# and active = 1
	</cfquery>