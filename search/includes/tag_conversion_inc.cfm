<!---include other tags to list--->
				<!---water tanks--->
				<cfif listfind(selected_user_tags,"9")>
					<cfset add_list = "75,76,77,78">
					<cfset selected_user_tags = listappend(selected_user_tags,add_list)>
				</cfif>
				<!---lead--->
				<cfif listfind(selected_user_tags_secondary,"94")>
					<cfset add_list = "96,97,98,99,100">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---abrasives--->
				<cfif listfind(selected_user_tags_secondary,"104")>
					<cfset add_list = "105,106,107,108,109,117">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---asbestos--->
				<cfif listfind(selected_user_tags_secondary,"151")>
					<cfset add_list = "96,97,98,99">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---paintingfinishing--->
				<cfif listfind(selected_user_tags_secondary,"27")>
					<cfset add_list = "82,52,145">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---hand powertool--->
				<cfif listfind(selected_user_tags_secondary,"110")>
					<cfset add_list = "111,112,113,114">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---pressure washing--->
				<cfif listfind(selected_user_tags_secondary,"35")>
					<cfset add_list = "101,102,103">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---abrasives related supplies--->
				<cfif listfind(selected_user_tags_secondary,"42")>
					<cfset add_list = "104,105,106,107,108,109,117">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---painting equipment--->
				<cfif listfind(selected_user_tags_secondary,"88")>
					<cfset add_list = "28,43">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---asbestos testing--->
				<cfif listfind(selected_user_tags_secondary,"63")>
					<cfset add_list = "99">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---coatings app--->
				<cfif listfind(selected_user_tags_secondary,"86")>
					<cfset add_list = "54,90,140,139">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				<!---inspection--->
				<cfif listfind(selected_user_tags_secondary,"53")>
					<cfset add_list = "54,55,140">
					<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,add_list)>
				</cfif>
				