<cfset date = #createodbcdatetime(now())#>
<cfset publicationID = "6">
<cfset rootpath = "../">
<cfset siteID = 50><!---For PBT--->
<cfparam name = "page_title" default = "Paint and Coatings Industry News : ">
<cfparam name = "meta_tags" default = "paint news, coatings news, coating industry news, paint industry news, Paint BidTracker">
<cfparam name = "meta_description" default = "The latest industry news on painting and coating projects, as covered by Paint BidTracker">
<cfif not isdefined("fuseaction") or fuseaction is "search" or fuseaction is "searchresults">
	<cfquery name="pull_news" datasource="#application.dataSource#" maxrows="25">
		select news_articles_new.ID, news_articles_new.display_title,news_articles_new.abstract,news_articles_new.publish_date,news_articles_new.article,<!---news_category.category,--->news_articles_new.thumbnail,news_articles_new.thumbnail_nl,news_articles_new.lock_comments
		from news_articles_new
		<!---left outer join news_category on news_category.newscatid = news_articles_new.newscatid--->
		where news_articles_new.ID in (select contentid from tags_log where content_typeid = 39 and tagid = <cfqueryparam value="#siteID#" cfsqltype="cf_sql_integer">)
		and news_articles_new.publish_date < <cfqueryparam value= "#date#" cfsqltype = "cf_sql_timestamp">
		and news_articles_new.active = 1
		order by news_articles_new.publish_date desc
	</cfquery>
	<!---cfquery name="evnt" datasource="#application.dataSource#" maxrows="25">
		select shorttitle as eventname,eventdate as calendardate,location,eventid,author as contact,enddate
		from ps_db_events
		where eventID in (select contentid from tags_log where content_typeid = 44 and tagid = 53)
		and (eventdate > <cfqueryparam value="#date-1#" cfsqltype="cf_sql_timestamp"> <!---and enddate < <cfqueryparam value="#date+1#" cfsqltype="cf_sql_timestamp">--->)
		order by eventDate asc,enddate asc,shorttitle
	</cfquery--->
	<cfquery name="pull_tags_all" datasource="#application.dataSource#">
		select distinct tags_log.tagid,tag,tag_typeid
		from tags_log
		inner join tags on tags.tagid = tags_log.tagid and content_typeid in (39,44)
		where (contentid in (<cfif pull_news.recordcount gt 0>#valuelist(pull_news.id)#<cfelse>0</cfif>)<!--- or contentid in (<cfif evnt.recordcount gt 0>#valuelist(evnt.eventid)#<cfelse>0</cfif>)--->) and tag_typeid in (1,4,10,14)
		and active = 1
	</cfquery>
	<cfset content_types = "39">
</cfif>

<cfif isdefined("fuseaction") and (fuseaction is "view" or fuseaction is "forward" or fuseaction is "comment" or fuseaction is "commentpost")>
	<cfset content_types = 39>
	<!---If no article ID is found, redirect to main news landing page--->
	<cfif not isdefined("id") or id is ""><cflocation url="#request.rootpath#dmz/?action=news"></cfif>
	
	<cfquery name="pull_news" datasource="#application.dataSource#">
		select news_articles_new.ID, news_articles_new.display_title,news_articles_new.abstract,news_articles_new.publish_date,news_articles_new.article,<!---news_category.category,--->news_articles_new.meta_keywords,news_articles_new.lock_comments,news_articles_new.thumbnail
		from news_articles_new
		<!---left outer join news_category on news_category.newscatid = news_articles_new.newscatid--->
		where news_articles_new.id = <cfqueryPARAM value = "#ID#" CFSQLType = "CF_SQL_INTEGER"> 
		order by news_articles_new.id desc
	</cfquery>
	<cfquery name="pull_tags_rel_site" datasource="#application.dataSource#">
		select tag,tagID
		from tags
		where tag_typeID = 6 and tagID in (select tagID from tags_log where contentID =  <cfqueryPARAM value = "#ID#" CFSQLType = "CF_SQL_INTEGER">  and content_typeID = #content_types#)
		and active = 1
	</cfquery>
	<cfquery name="pull_tags_all" datasource="#application.dataSource#">
		select distinct tags_log.tagid,tag,tag_typeid
		from tags_log
		inner join tags on tags.tagid = tags_log.tagid and content_typeid =39
		where contentid = <cfqueryPARAM value = "#ID#" CFSQLType = "CF_SQL_INTEGER">  and tag_typeid in (1,4,10,14)
		and active = 1
	</cfquery>
	<cfquery name="pull_tags_main_topic" datasource="#application.dataSource#">
		select distinct tags_log.tagid,tag,tag_typeid
		from tags_log
		inner join tags on tags.tagid = tags_log.tagid and content_typeid =39
		where contentid = <cfqueryPARAM value = "#ID#" CFSQLType = "CF_SQL_INTEGER">  and tag_typeid in (14)
		and active = 1
		order by tag
	</cfquery>
	<cfquery name="pull_tags_link_list" datasource="#application.dataSource#">
		select distinct tags_log.tagid,tag,tag_typeid
		from tags_log
		inner join tags on tags.tagid = tags_log.tagid and content_typeid =39
		where contentid = <cfqueryPARAM value = "#ID#" CFSQLType = "CF_SQL_INTEGER">  and tag_typeid in (1,4,10)
		and active = 1
		order by tag
	</cfquery>
	<cfset page_title = "#pull_news.display_title# : Paint BidTracker News">
	<cfset meta_description = "#pull_news.abstract#">
	<cfset meta_tags = "#pull_news.meta_keywords#">
</cfif>

<!---Pull relevant tags for list--->
	<!---Set the master tag query--->
	<!---Initialize--->
	<cfset all_rel_tags = QueryNew("tagid, total, featured, tag, rownumber", "integer, integer, integer, varchar, integer")>
	<cfset counter=0>
	<!---Get the article tags--->
	<cfquery name="pull_news_tags" datasource="#application.dataSource#">
		select distinct tags_log.tagid, count(tags_log.tagid) as total, tags.tag, tags_log.featured
		from tags_log
		inner join tags on tags.tagid = tags_log.tagid
		where contentid in (<cfif isdefined("pull_news") and pull_news.recordcount gt 0><cfqueryparam value="#valuelist(pull_news.id)#" cfsqltype="cf_sql_integer" list="true"><cfelse>0</cfif>)
		and tag_typeid in (1,4,10,14) and content_typeid = 39
		group by tags_log.tagid, tags.tag, tags_log.featured
		order by total desc, tags.tag
	</cfquery>
	<!---Add the news tags to the master--->
	<cfloop query="pull_news_tags">
		<cfif listfind(#valuelist(all_rel_tags.tagid)#, #tagid#) eq 0>
			<cfset newRow = QueryAddRow(all_rel_tags, 1)>
			<cfset counter=counter+1>
			<cfset temp = QuerySetCell(all_rel_tags, "tagid", #tagid#, #counter#)>
			<cfset temp = QuerySetCell(all_rel_tags, "total", #total#, #counter#)>
			<cfset temp = QuerySetCell(all_rel_tags, "tag", "#tag#", #counter#)>
			<cfset temp = QuerySetCell(all_rel_tags, "rownumber", "#counter#", #counter#)>
			<cfif featured is 1><cfset temp = QuerySetCell(all_rel_tags, "featured", 1, #counter#)></cfif>
		<cfelse>
			<!---Add to the count of the existing row--->
			<cfquery name="find_row" dbtype="query">
				select rownumber from all_rel_tags where tagid = <cfqueryparam value="#tagid#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset temp = QuerySetCell(all_rel_tags, "total", #all_rel_tags.total#+#total#, #find_row.rownumber#)>
		</cfif>
	</cfloop>
	
	<div class="row">
		<div class="col-sm-12 page-header">
			<h3>Paint and Coatings Industry News</h3>
		</div>   	
		<!---div class="col-sm-2 text-right">
			<a href="#request.rootpath#dmz/?fuseaction=search">Search News</a> 
		</div--->
	</div>	

	<cfset short_max = 10>
	<cfif short_max gt pull_news.recordcount>
		<cfset short_max = pull_news.recordcount>
	</cfif>
	<cfset full_start = short_max + 1>
	<cfoutput>
		<CFLOOP QUERY="PULL_NEWS" startrow="1" endrow="#short_max#">
			<div class="container newsrow">
				<div class="row">
					<div class="col-md-4 col-sm-4 col-xs-12">
						<cfif thumbnail is not "">
						<a href="#request.rootpath#dmz/?action=newsview&fuseaction=view&id=#id#">
							<img src="#thumbnail#" align="left" alt="#display_title#" title="#display_title#" class="img-responsive">
						</a>
						</cfif>
					</div>	
					<div class="col-md-8 col-sm-8 col-xs-12">
						<h2><a href="#request.rootpath#dmz/?action=newsview&fuseaction=view&id=#id#"><b>#display_title#</b></a></h2>
						<p>#dateformat(pull_news.publish_date,"dddd mmmm d, yyyy")#</p>
						<p>#abstract#</p>
					</div>	
				</div>
			</div>	
		</cfloop>
	</cfoutput>
<!---End relevant tags pull--->
<!---
<cfoutput>
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
                          <tr>
                            <td align="right">
                            	
							</td>
                     	  </tr>
                     	  <tr>
                       		<td width="100%">
                          	  <div align="center">
                          	    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    ---Set max rows for short, default list---
										<cfset short_max = 10>
										<cfif short_max gt pull_news.recordcount>
										<cfset short_max = pull_news.recordcount>
										</cfif>
										<cfset full_start = short_max + 1>
								  
								  <CFLOOP QUERY="PULL_NEWS" startrow="1" endrow="#short_max#">
								  <tr>
                                      <td width="100%">
									  <cfif currentrow lte #short_max#>
                                        <div align="left">
                                          <table border="0" cellpadding="0" cellspacing="0" width="190">
                                            <tr>
                                              <td width="166">
                                                <cfif thumbnail is not ""><img src="#thumbnail#" align="left" alt="#display_title#">
												</cfif></td>
                                            </tr>
                                          </table>
                                        </div>
										</cfif>
                                        <h1 class="headlines" style="margin-bottom: 0;"><a href="#request.rootpath#dmz/?action=newsview&fuseaction=view&id=#id#"><b>#display_title#</b></a></h1>
                                        <p class="smaller" style="margin-top: 0; margin-bottom: 0">
                                    #dateformat(pull_news.publish_date,"dddd mmmm d, yyyy")#</p>
                                        <p style="margin-top: 0;">#abstract#</p></td>
                                    </tr>
                                    <tr>
                                      <td width="100%">
                                        <hr size="1" color="C0C0C0" noshade>
                                      </td>
                                    </tr>
                                    </CFLOOP>
									
									
									
                                 
                                    <tr>
                                      <td width="100%">
                                      
                                      </td>
                                    </tr>
                          		</table>
                          	  </div>                              </td>
                     	  </tr>
                          <tr>
                             <td width="100%" align="right">
                             <cfif pull_news.recordcount gt #short_max#>
                             ---Call to script---
				<script language="javascript">toggle(getObject('newsadd'), 'news_link');</script>
										
				---Add rest of list to short list, initially hidden---
				<div id="newsadd" style="display:none" align="left">
					<cfloop startrow="#full_start#" endrow="#pull_news.recordCount#" query="pull_news">  
						<h1 class="headlines" style="margin-bottom: 0;">
						<a href="#request.rootpath#dmz/?action=newsview&fuseaction=view&id=#id#"><b>#display_title#</b></a></h1>
						<p class="smaller" style="margin-top: 0; margin-bottom: 0">
						#dateformat(pull_news.publish_date,"dddd mmmm d, yyyy")#</p>
						---p style="margin-top: 0;">#abstract#</p---
						<hr size="1" color="C0C0C0" noshade> 
					</cfloop>
				</div>
				---Toggle link if short list maxes out and more results to display---
				<p align="right"><a title="expand/collapse" id="news_link" href="javascript: void(0);" 
				onclick="toggle(this, 'newsadd');"  style="text-decoration: none; color: ##000000; ">See more</a>
				&nbsp;<img src="#rootpath#images/yellowtriangle.jpg" border="0"></p>
			   </cfif>
                             </td>
                          </tr>
                          <tr>
                          	<td>
                            &nbsp;<br>
                            &nbsp;
                            </td>
                          </tr>
                   	    </table>
		</td>
	</tr>
</table>
</cfoutput>--->