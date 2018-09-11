<cfoutput>		
	<cfset tempHRef = "">
	
<!---new variables for search--->
<cfif isdefined("project_stage")><cfset tempHRef = tempHRef & "&project_stage=#project_stage#"></cfif>	
<cfif isdefined("amount")><cfset tempHRef = tempHRef & "&amount=#amount#"></cfif>	
<cfif isdefined("postfrom")><cfset tempHRef = tempHRef & "&postfrom=#postfrom#"></cfif>	
<cfif isdefined("postto")><cfset tempHRef = tempHRef & "&postto=#postto#"></cfif>
<cfif isdefined("subfrom")><cfset tempHRef = tempHRef & "&subfrom=#subfrom#"></cfif>	
<cfif isdefined("subto")><cfset tempHRef = tempHRef & "&subto=#subto#"></cfif>		
<cfif isdefined("allprojects")><cfset tempHRef = tempHRef & "&allprojects=#allprojects#"></cfif>	
<cfif isdefined("all_scopes")><cfset tempHRef = tempHRef & "&all_scopes=#all_scopes#"></cfif>	
<cfif isdefined("industrial")><cfset tempHRef = tempHRef & "&industrial=#industrial#"></cfif>
<cfif isdefined("commercial")><cfset tempHRef = tempHRef & "&commercial=#commercial#"></cfif>		
<cfif isdefined("paintingprojects")><cfset tempHRef = tempHRef & "&paintingprojects=#paintingprojects#"></cfif>	
<cfif isdefined("qualifications")><cfset tempHRef = tempHRef & "&qualifications=#qualifications#"></cfif>		
<cfif isdefined("scopes")><cfset tempHRef = tempHRef & "&scopes=#scopes#"></cfif>
<cfif isdefined("structures")><cfset tempHRef = tempHRef & "&structures=#structures#"></cfif>
<cfif isdefined("supply")><cfset tempHRef = tempHRef & "&supply=#supply#"></cfif>
<cfif isdefined("sorting")><cfset tempHRef = tempHRef & "&sorting=#sorting#"></cfif>
<cfif isdefined("ownerID")><cfset tempHRef = tempHRef & "&ownerID=#ownerID#"></cfif>
<cfif isdefined("bidstatus")><cfset tempHRef = tempHRef & "&bidstatus=#bidstatus#"></cfif>
<cfif isdefined("state")><cfset tempHRef = tempHRef & "&state=#state#"></cfif>
<cfif isdefined("generalcontracts")><cfset tempHRef = tempHRef & "&generalcontracts=#generalcontracts#"></cfif>	
<cfif isdefined("packageID")><cfset tempHRef = tempHRef & "&packageID=#packageID#"></cfif>	
<cfif isdefined("verifiedprojects")><cfset tempHRef = tempHRef & "&verifiedprojects=#verifiedprojects#"></cfif>	
<cfif isdefined("contractorname")><cfset tempHRef = tempHRef & "&contractorname=#contractorname#"></cfif>
<cfif isdefined("supplierID")><cfset tempHRef = tempHRef & "&supplierID=#supplierID#"></cfif>	
<cfif isdefined("all_services")><cfset tempHRef = tempHRef & "&all_services=#all_services#"></cfif>
<cfif isdefined("services")><cfset tempHRef = tempHRef & "&services=#services#"></cfif>		
<!---view agency page sorting--->
<cfif isdefined("bidfrom")><cfset tempHRef = tempHRef & "&bidfrom=#bidfrom#"></cfif>
<cfif isdefined("bidto")><cfset tempHRef = tempHRef & "&bidto=#bidto#"></cfif>
<cfif isdefined("awardfrom")><cfset tempHRef = tempHRef & "&awardfrom=#awardfrom#"></cfif>
<cfif isdefined("awardto")><cfset tempHRef = tempHRef & "&awardto=#awardto#"></cfif>
<cfif isdefined("bid")><cfset tempHRef = tempHRef & "&bid=#bid#"></cfif>
<cfif isdefined("awd")><cfset tempHRef = tempHRef & "&awd=#awd#"></cfif>
<!---end--->
<cfif isdefined("appear")><cfset tempHRef = tempHRef & "&appear=#appear#"></cfif>
<cfif isdefined("editornotes") and editornotes is not ""><cfset tempHRef = tempHRef & "&editornotes=#editornotes#"></cfif>
<cfif isdefined("bidscope")><cfset tempHRef = tempHRef & "&bidscope=#bidscope#"> </cfif>
<cfif isdefined("structure")><cfset tempHRef = tempHRef & "&structure=#structure#"> </cfif>
<cfif isdefined("structureid")><cfset tempHRef = tempHRef & "&structureid=#structureid#"> </cfif>
<cfif isdefined("bidtype")><cfset tempHRef = tempHRef & "&bidtype=#bidtype#"> </cfif>
<cfif isdefined("bidsubcategory")><cfset tempHRef = tempHRef & "&bidsubcategory=#bidsubcategory#"> </cfif>
<cfif isdefined("bidcategory")><cfset tempHRef = tempHRef & "&bidcategory=#bidcategory#">  </cfif>
<cfif isdefined("qt")><cfset tempHRef = tempHRef & "&qt=#urlencodedformat(qt)#"></cfif>
<cfif isdefined("col")><cfset tempHRef = tempHRef & "&col=#col#"></cfif>
<cfif isdefined("nh")><cfset tempHRef = tempHRef & "&nh=#nh#"></cfif>
<cfif isdefined("closedaterange")><cfset tempHRef = tempHRef & "&closedaterange=#closedaterange#"></cfif>
<cfif isdefined("postdaterange")><cfset tempHRef = tempHRef & "&postdaterange=#postdaterange#"></cfif>
<cfif isdefined("projectdaterange")><cfset tempHRef = tempHRef & "&projectdaterange=#projectdaterange#"></cfif>
<cfif isdefined("bidsubcategory2")><cfset tempHRef = tempHRef & "&bidsubcategory2=#bidsubcategory2#"></cfif>
<cfif isdefined("month4")><cfset tempHRef = tempHRef & "&month4=#month4#"></cfif>
<cfif isdefined("day4")><cfset tempHRef = tempHRef & "&day4=#day4#"></cfif>
<cfif isdefined("year4")><cfset tempHRef = tempHRef & "&year4=#year4#"></cfif>
<cfif isdefined("month3")><cfset tempHRef = tempHRef & "&month3=#month3#"></cfif>
<cfif isdefined("day3")><cfset tempHRef = tempHRef & "&day3=#day3#"></cfif>
<cfif isdefined("year3")><cfset tempHRef = tempHRef & "&year3=#year3#"></cfif>
<cfif isdefined("month1")><cfset tempHRef = tempHRef & "&month1=#month1#"></cfif>
<cfif isdefined("day1")><cfset tempHRef = tempHRef & "&day1=#day1#"></cfif>
<cfif isdefined("year1")><cfset tempHRef = tempHRef & "&year1=#year1#"></cfif>
<cfif isdefined("month2")><cfset tempHRef = tempHRef & "&month2=#month2#"></cfif>
<cfif isdefined("day2")><cfset tempHRef = tempHRef & "&day2=#day2#"></cfif>
<cfif isdefined("year2")><cfset tempHRef = tempHRef & "&year2=#year2#"></cfif>
<cfif isdefined("saved")><cfset tempHRef = tempHRef & "&saved=#saved#"></cfif>
<cfif isdefined("action")><cfset tempHRef = tempHRef & "&action=#action#"></cfif>

<cfif isdefined("label")><cfset tempHRef = tempHRef & "&label=#urlencodedformat(label)#"></cfif>
<cfif isdefined("pscat")><cfset tempHRef = tempHRef & "&pscat=#pscat#"></cfif>
<cfif isdefined("pscat2")><cfset tempHRef = tempHRef & "&pscat2=#pscat2#"></cfif>
<cfif isdefined("bidid")><cfset tempHRef = tempHRef & "&bidid=#bidid#"></cfif>	
<cfif isdefined("fromdate1") and fromdate1 is not ""><cfset tempHRef = tempHRef & "&fromdate1=#fromdate1#"></cfif>
<cfif isdefined("fromdate2") and fromdate2 is not ""><cfset tempHRef = tempHRef & "&fromdate2=#fromdate2#"></cfif>		
<cfif isdefined("todate1") and todate1 is not ""><cfset tempHRef = tempHRef & "&todate1=#todate1#"></cfif>
<cfif isdefined("todate2") and todate2 is not ""><cfset tempHRef = tempHRef & "&todate2=#todate2#"></cfif>
<cfif isdefined("lst")><cfset tempHRef = tempHRef & "&lst=#lst#"></cfif>
<cfif isdefined("expired")><cfset tempHRef = tempHRef & "&expired=#expired#"></cfif>
<cfif isdefined("saction") ><cfset tempHRef = tempHRef & "&saved=1"></cfif>
<cfif isdefined("ltype") ><cfset tempHRef = tempHRef & "&ltype=#ltype#"></cfif>
<cfif isdefined("filter") ><cfset tempHRef = tempHRef & "&filter=#filter#"></cfif>
<cfif isdefined("planholders")><cfset tempHRef = tempHRef & "&planholders=#planholders#"></cfif>
	</cfoutput>	


<cfoutput>
	
	<cfset nextendrow = endrow + rowsperpage>
	<cfset prevrowstart = startrow - rowsperpage>
	<cfset prevrowend = endrow - rowsperpage>
<cfif StartRowBack GT 0>
<cfif isdefined("sort")><a href="?startrow=#prevrowstart#&endrow=#prevrowend#&sort=#sort#&userid=#userid#&desc=#desc#&tempHRef=#tempHRef#"><cfelse><a href="?startrow=#prevrowstart#&endrow=#prevrowend#&userid=#userid#&tempHRef=#tempHRef#"></cfif>
<img src="#request.rootpath#assets/images/goprev.gif"  alt="back #rowsperpage# records" border="0">
</a>
</cfif>
<cfif startrownext LTE TotalRows>
<cfif isdefined("sort")><a href="?startrow=#startrownext#&endrow=#nextendrow#&sort=#sort#&userid=#userid#&desc=#desc#&tempHRef=#tempHRef#"><cfelse><a href="?startrow=#startrownext#&endrow=#nextendrow#&userid=#userid#&tempHRef=#tempHRef#"></cfif>
<img src="#request.rootpath#assets/images/gonext.gif" alt="next #rowsperpage# records" border="0">
</a></cfif>
</cfoutput>


