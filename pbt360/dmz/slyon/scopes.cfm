<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>
	
	<cfset tmpScopes = '8,9,17,20,79,45,67,89,79,34,56'/>        

		
		
		
		
		
<cffunction name="queryScope" returntype="string" output="no">
	<cfargument name="_userPrefs" required="yes"/>	
	<cfargument name="qryDefaults" required="yes"/>	
	
	<cfloop list="#arguments.qryDefaults#" index="_x">
		<cfset itemFound = listfind(arguments._userPrefs,_x)>
		<cfif itemFound>
			<cfset arguments._userPrefs= listDeleteAt(arguments._userPrefs,itemFound)/>
		</cfif>
	</cfloop>
	<cfreturn arguments._userPrefs />
</cffunction>
	<cfset _list = queryScope(tmpScopes,'8,9,17,20,79,16,11,13,19,24,10,23,652,9,12,74,73,14,21,70,18,75,76,77,78')/>
		<cfoutput>#_list# </cfoutput><br />	
	
	<cfoutput>
	<cfif listlen(_list)>
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid<br />	
	</cfloop>
	</cfif>
	
	<br />	<br />	<br />	
	
	<cfif listlen(_list)>
		and (
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(_list,_c)#<br />	
	</cfloop>)
	</cfif>
	</cfoutput>
</body>
</html>