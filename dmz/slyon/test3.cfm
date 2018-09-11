<cfset variables.agency_name ="Allegheny County"><!--- County Sanitary Authority--->
<cfsearch name="agency_results1" collection="contrak_agency_search" criteria='"#variables.agency_name#"'>
<cfdump var="#agency_results1#">

<cfset variables.agency_name ="Allegheny County Sanitary"><!--- County Sanitary Authority--->
<cfsearch name="agency_results2" collection="contrak_agency_search" criteria='"#variables.agency_name#"'>
<cfdump var="#agency_results2#">