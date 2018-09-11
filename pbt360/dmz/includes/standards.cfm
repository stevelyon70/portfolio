<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<cfquery name = "getupdates" datasource="#application.dataSource#" maxrows="3">
Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
standardcat.category
from standards
left outer join standardcat on standardcat.catid = standards.catid
where standards.active = 'y'
order by standards.updatedon desc
</cfquery>

<cfquery name="pull_cat" datasource="#application.dataSource#">
select distinct a.catid,a.category
from standardcat a
inner join standards b on b.catid = a.catid
where b.active = 'y' <cfif isdefined('url.catid')> and a.catid = #url.catid#</cfif>
order by a.catid
</cfquery>

<!---cfset barcolor1 = "762776">
<cfset barcolor2 = "db8355"--->
<div class="row">
	<div class="col-sm-12 page-header">
		<h3>Paint and Coatings Industry Standards</h3>
	</div>   	
	<!---div class="col-sm-2 text-right">
		<a href="#request.rootpath#news/?fuseaction=search">Search News</a> 
	</div--->
</div>	
<div class="row">
	<div class="col-sm-12">
	<p>This directory of standards, recommended practices, and test methods from coatings-relevant 
					  organizations and associations gives you quick and convenient direction to find the information that you need.
					  <br><br>In cases where there is a purchase price for the standard, you will be provided a link to the organization's site; 
					  Paint BidTracker does not serve as an agent for direct sales and downloads of standards.
					  <br><br><a class="bold" href="#request.rootpath#standards/?fuseaction=search">Search for Paint and Coatings Industry Standards</a></p>
	</div>
</div>
<cfoutput>
<div class="row">
	<ul>
		<li>3 Most Recently Updated Standards</li>
		<cfloop query="getupdates">
		<li>#category# - <a href="#request.rootpath#standards/?fuseaction=view&id=#standardid#">#standard_title# </a> (#dateformat(updatedon, "m/d/yyyy")#)
		</li>                         
		</cfloop>
	</ul>	
</div>
<cfloop query="pull_cat">
<cfquery name = "get_stnd" datasource="#application.dataSource#">
	Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
	standardcat.category
	from standards
	left outer join standardcat on standardcat.catid = standards.catid
	where  standards.active = 'y' and standards.catid = <cfqueryPARAM value = "#catID#" CFSQLType = "CF_SQL_INTEGER"> 
	order by standards.updatedon desc
</cfquery>
<cfquery name="pull_subs" datasource="#application.dataSource#">
	select distinct <cfif not isdefined('url.catid')>top 3</cfif> a.subcatid,a.category,a.catid
	from standardsubcat a
	where 0=0 <cfif not isdefined('url.catid')>and a.catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER"> 
	and a.subcatid in (select subcatid from standards where catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER"></cfif>  and active = 'y')
	order by a.category
</cfquery>
			<cfset short_max = 3>
			<cfif short_max gt pull_subs.recordcount>
				<cfset short_max = pull_subs.recordcount>
			</cfif>
			<cfset full_start = short_max + 1>
<div class="col-sm-6 pull-left">
<div class="container">
	<div class="row">
		<p class="h3">
			<a class="bold" href="?action=standards&catid=#catid#">#category#</a> (#get_stnd.recordcount#)
		</p>
			
	  <cfloop query="pull_subs">
		<cfquery name="count_stnd" datasource="#application.dataSource#">
			Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
			standardcat.category
			from standards
			left outer join standardcat on standardcat.catid = standards.catid
			where  standards.active = 'y' and subcatid = <cfqueryPARAM value = "#subcatID#" CFSQLType = "CF_SQL_INTEGER">  and standards.catid = #pull_subs.catid#
			order by standards.updatedon desc
		</cfquery>
	  
		<p class="h5"><i class="clip-expand"></i><a href="?action=standards&catid=#pull_subs.catid#&subcatid=#subcatid#">#category#</a> (#count_stnd.recordcount#)</p>       <cfloop query="count_stnd">
			 <p class="h6"><a href="?action=standards&standardid=#standardid#">#standard_title#</a></p>      
		</cfloop>                 
	  </cfloop>
	</div>
</div>
</div>			
</cfloop>

                   
        <!---        
                  <table border="0" cellpadding="5" cellspacing="0" width="100%">
                    <tr>
                    <!--left column-->
                      <td valign="top" width="49%">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
						
						
						<cfloop query="pull_cat">
						<cfquery name = "get_stnd" datasource="#application.dataSource#">
						Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
						standardcat.category
						from standards
						left outer join standardcat on standardcat.catid = standards.catid
						where  standards.active = 'y' and standards.catid = <cfqueryPARAM value = "#catID#" CFSQLType = "CF_SQL_INTEGER"> 
						order by standards.updatedon desc
						</cfquery>
						
                          <tr>
                            <td>
                            	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    				<tr>
                      					<td width="50%" valign="bottom"><p class="header1"> 
                                        <a class="bold" href="#request.rootpath#standards/?fuseaction=org&catid=#catid#">#category#</a> (#get_stnd.recordcount#)</p></td>
                      					<td width="50%" valign="bottom" align="right">                      		                                        
									</td>
                   				  </tr>
                  				</table>
                            
							<hr class="PBTsmall" noshade>
							                            </td>
                     	  </tr>
						  <cfquery name="pull_subs" datasource="#application.dataSource#">
						  select distinct a.subcatid,a.category,a.catid
						  from standardsubcat a
						  where a.catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER"> 
						  and a.subcatid in (select subcatid from standards where catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER">  and active = 'y')
						  order by a.category
						  </cfquery>
						  
                     	  <tr>
                       		<td width="100%">
                          	  <div align="center">
                          	    <table border="0" cellpadding="0" cellspacing="0" width="100%">
								 <!---Set max rows for short, default list--->
										<cfset short_max = 3>
										<cfif short_max gt pull_subs.recordcount>
										<cfset short_max = pull_subs.recordcount>
										</cfif>
										<cfset full_start = short_max + 1>
                                  <cfloop query="pull_subs" startrow="1" endrow="#short_max#">
								  	<cfquery name="count_stnd" datasource="#application.dataSource#">
									Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
									standardcat.category
									from standards
									left outer join standardcat on standardcat.catid = standards.catid
									where  standards.active = 'y' and subcatid = <cfqueryPARAM value = "#subcatID#" CFSQLType = "CF_SQL_INTEGER">  and standards.catid = #pull_subs.catid#
									order by standards.updatedon desc
									</cfquery>
								  <tr>
                                    <td width="100%" colspan="2">
                                    <h1 class="headlines" style="margin-bottom: 0">
                                    <a href="#request.rootpath#standards/?fuseaction=subcat&catid=#pull_subs.catid#&subcatid=#subcatid#">#category#</a> (#count_stnd.recordcount#)</h1>                                    </td>
                                  </tr>
								  </cfloop>
                          		</table>
                          	  </div>                              </td>
                     	  </tr>
                          <tr>
                             <td width="100%" align="left">
                              <cfif pull_subs.recordcount gt #short_max#>
                             <!---Call to script--->
				<script language="javascript">toggle(getObject('pull_subs#currentrow#add'), 'pull_subs#currentrow#_link');</script>
										
				<!---Add rest of list to short list, initially hidden--->
				<div id="pull_subs#currentrow#add" style="display:none">
					<cfloop startrow="#full_start#" endrow="#pull_subs.recordcount#" query="pull_subs"><h1 class="headlines" style="margin-bottom: 0">
					<cfquery name="count_stnd" datasource="#application.dataSource#">
									Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
									standardcat.category
									from standards
									left outer join standardcat on standardcat.catid = standards.catid
									where  standards.active = 'y' and subcatid = <cfqueryPARAM value = "#subcatID#" CFSQLType = "CF_SQL_INTEGER">  and standards.catid = #pull_subs.catid#
									order by standards.updatedon desc
									</cfquery>
                                    <a href="#request.rootpath#standards/?fuseaction=subcat&catid=#pull_subs.catid#&subcatid=#subcatid#">#category#</a> (#count_stnd.recordcount#)</h1>  
									</cfloop>
				</div>
				<!---Toggle link if short list maxes out and more results to display--->
				<p align="right"><a title="expand/collapse" id="pull_subs#currentrow#_link" href="javascript: void(0);" 
				onclick="toggle(this, 'pull_subs#currentrow#add');"  style="text-decoration: none; color: ##000000; ">See more</a>
				&nbsp;<img src="#request.rootpath#images/yellowtriangle.jpg" border="0"></p>
			   </cfif>                           </td>
                          </tr>
                          <tr>
                          	<td>&nbsp;                            </td>
                          </tr>
                             
					</cfloop>
							 
							 
							                       
                  
                          <tr>
                          	<td>&nbsp;                            </td>
                          </tr>
                   	    </table>                  
                  </td>
                  <td width="2%">
                  </td>
                  <td valign="top" width="49%">
                   <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                     	<cfloop query="pull_cat2">
						<cfquery name = "get_stnd2" datasource="#application.dataSource#">
						Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
						standardcat.category
						from standards
						left outer join standardcat on standardcat.catid = standards.catid
						where standards.active = 'y' and standards.catid = <cfqueryPARAM value = "#catID#" CFSQLType = "CF_SQL_INTEGER"> 
						order by standards.updatedon desc
						</cfquery>
					 
					 
					 <tr>
                            <td>
                              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                 <tr>
                                   <td width="50%" valign="bottom"><p class="header1">
                                   <a class="bold" href="#request.rootpath#standards/?fuseaction=org&catid=#catid#">#category#</a> (#get_stnd2.recordcount#)</p></td>
                                   <td width="50%" valign="bottom" align="right">
                                 
                                   		                                      </td>
                                </tr>
                              </table>                          
                          	  <hr class="PBTsmall" noshade>
							                              </td>
                     	  </tr>
						  <cfquery name="pull_subs2" datasource="#application.dataSource#" >
						  select distinct a.subcatid,a.category,a.catid
						  from standardsubcat a
						  where a.catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER"> 
						  and a.subcatid in (select subcatid from standards where catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER">  and active = 'y')
						  order by a.category
						  </cfquery>
						  
                     	  <tr>
                       		<td width="100%">
                          	  <div align="center">
                          	    <table border="0" cellpadding="0" cellspacing="0" width="100%">
								 <!---Set max rows for short, default list--->
										<cfset short_max = 3>
										<cfif short_max gt pull_subs2.recordcount>
										<cfset short_max = pull_subs2.recordcount>
										</cfif>
										<cfset full_start = short_max + 1>
								  <cfloop query="pull_subs2" startrow="1" endrow="#short_max#">
								  	<cfquery name="count_stnd2" datasource="#application.dataSource#">
									Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
									standardcat.category
									from standards
									left outer join standardcat on standardcat.catid = standards.catid
									where standards.active = 'y' and subcatid = <cfqueryPARAM value = "#subcatID#" CFSQLType = "CF_SQL_INTEGER">  and standards.catid = #pull_subs2.catid#
									order by standards.updatedon desc
									</cfquery>
								  <tr>
                                    <td width="100%" colspan="2">
                                    <h1 class="headlines" style="margin-bottom: 0">
                                    <a href="#request.rootpath#standards/?fuseaction=subcat&catid=#pull_subs2.catid#&subcatid=#subcatid#">#category#</a> (#count_stnd2.recordcount#)</h1>                                    </td>
                                  </tr>
								  </cfloop>
                                </table>
                          	  </div>                        	</td>
                     	  </tr>
                          <tr>
                             <td width="100%" align="left">
                             <cfif pull_subs2.recordcount gt #short_max#>
                             <!---Call to script--->
				<script language="javascript">toggle(getObject('pull_subs2#currentrow#add'), 'pull_subs2#currentrow#_link');</script>
										
				<!---Add rest of list to short list, initially hidden--->
				<div id="pull_subs2#currentrow#add" style="display:none">
					<cfloop startrow="#full_start#" endrow="#pull_subs2.recordcount#" query="pull_subs2"><h1 class="headlines" style="margin-bottom: 0">
					<cfquery name="count_stnd2" datasource="#application.dataSource#">
									Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
									standardcat.category
									from standards
									left outer join standardcat on standardcat.catid = standards.catid
									where standards.active = 'y' and subcatid = <cfqueryPARAM value = "#subcatID#" CFSQLType = "CF_SQL_INTEGER">  and standards.catid = #pull_subs2.catid#
									order by standards.updatedon desc
									</cfquery>
                                    <a href="#request.rootpath#standards/?fuseaction=subcat&catid=#pull_subs2.catid#&subcatid=#subcatid#">#category#</a> (#count_stnd2.recordcount#)</h1>  
									</cfloop>
				</div>
				<!---Toggle link if short list maxes out and more results to display--->
				<p align="right"><a title="expand/collapse" id="pull_subs2#currentrow#_link" href="javascript: void(0);" 
				onclick="toggle(this, 'pull_subs2#currentrow#add');"  style="text-decoration: none; color: ##000000; ">See more</a>
				&nbsp;<img src="#request.rootpath#images/yellowtriangle.jpg" border="0"></p>
			   </cfif>                       
                             </td>
                          </tr>
                     	  <tr>
                          	<td>&nbsp;
                            
                            </td>
                          </tr>
						  </cfloop>
                       
                   </table>
                  </td>
                 </tr>
                </table>--->     
	</cfoutput>