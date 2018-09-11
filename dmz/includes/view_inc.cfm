
<cfquery name="pull_news" datasource="#application.dataSource#">
		select news_articles_new.ID, news_articles_new.display_title,news_articles_new.abstract,news_articles_new.publish_date,news_articles_new.article,<!---news_category.category,--->news_articles_new.meta_keywords,news_articles_new.lock_comments,news_articles_new.thumbnail
		from news_articles_new
		<!---left outer join news_category on news_category.newscatid = news_articles_new.newscatid--->
		where news_articles_new.id = <cfqueryPARAM value = "#ID#" CFSQLType = "CF_SQL_INTEGER"> 
		order by news_articles_new.id desc
	</cfquery>
<cfoutput>          
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<td width="100%" align="left" valign="top" colspan="3">
			<!---cfinclude template="../../modules/offer_inc.cfm"--->
			<div align="left">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td align="left" valign="bottom">
							<h3>Paint and Coatings Industry News </h3>
						</td>
						<td align="right" valign="bottom">
							<p><a href="?action=news">Main News Page</a> <!--Goes to Search page-->
							</p>
						</td>
					</tr>
					<tr>
						<td width="100%" colspan="2"><hr class="PBT" noshade></td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<h1 class="big"><strong>#pull_news.display_title#</strong></h1>
							<p style="margin-bottom:6; margin-top:0;">
							#dateformat(pull_news.publish_date,"dddd, mmmm d, yyyy")#
							<!---cfinclude template="#request.rootpath#../modules/content_tag_links_main_topic.cfm"--->
							</p>
						</td>
						<td align="right" valign="top" width="38%">
							<!-- AddThis Button BEGIN -->
							<div class="addthis_toolbox addthis_default_style"> <!---<a href="##comments"><img src="../assets/images/Comment.gif" alt="Comment" border="0" align="left"></a>---> <a class="addthis_button_email"></a> <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
							<script type="text/javascript" src="//s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
							<!-- AddThis Button END -->
						</td>
					</tr>
				</table>
			</div>
			<div align="left">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="100%"><hr class="PBT" noshade></td>
					</tr>
				</table>
			</div>                      
		</td>
	</tr>
</table>
<!--end heading-->
<table border="0" cellpadding="5" cellspacing="0" width="100%">              
	<tr>
		<td width="100%" colspan="2">
			<div align="center">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
					<td valign="top">
						<!---cfif isdefined("nl_versionID")>
						<div style="float:right; width:200px; margin-left: 10px;"><cfinclude template="#request.rootpath##request.rootpath#modules/newsletter_headlines_sidebar.cfm"></div>
						</cfif--->
						<p>#pull_news.article#</p>
					</td>
					</tr>
					<tr>
						<td>
							<cfinclude template="#request.rootpath#../modules/social_plug_detail_page.cfm">
							<cfinclude template="#request.rootpath#../modules/content_tag_links_category.cfm">
							<cfif isdefined("nl_versionID")>
								<div style="margin-top: 10px; margin-bottom: 10px">
								<cfinclude template="#request.rootpath#../modules/newsletter_headlines_horiz_scroll.cfm">
								</div>
							</cfif>
							<hr>                                                
						</td>
					</tr>
					<!---<cfquery name="get_comments" datasource="#application.dataSource#">
						select * from gateway_user_comments
						where active=1 and content_typeID = 39
						and contentID = <cfqueryparam value="#ID#" cfsqltype="cf_sql_integer">
						order by date_posted
					</cfquery>
					<cfloop query="get_comments">
					<tr>
						<td>
							<p><i>Comment from #name#</i>, (#dateformat(date_posted, 'm/d/yyyy')#, #timeformat(date_posted, 'h:mm tt')#)</p>
						</td>
					</tr>
					<tr>
						<td><p>#comment#</p>
						</td>
					</tr>
					<tr>
						<td>
							<hr>                                                            
						</td>
					</tr>
					</cfloop>--->
				</table>
			</div>                        
		</td>
	</tr>
	<!---
	<tr>
			<td width="100%" valign="top">
				<p class="bold">
				<a name="comments"><img src="../assets/images/Comment.gif" alt="Comment" border="0" align="left" style="margin-right:5px;"></a>
				Join the Conversation:
				</p>                                               
			</td>
		</tr>
		<cfif pull_news.lock_comments is 1>
		<tr>
				<td>
					This thread has been locked by the site administrators. Further commenting on this story has been disallowed.
				</td>
			</tr>
		<cfelseif isdefined("reg_userID") and reg_userID is not "">
			<cfquery name="get_name" datasource="#application.dataSource#">
				select firstname, lastname, comment_permission from reg_users 
				where reg_userID=<cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif get_name.comment_permission is 3>---Banned---
				<tr>
					<td>
						You have been banned from posting comments to our site for violations of our <a href="#request.rootpath#info/?fuseaction=comments" target="_blank">comment posting policy</a>.
					</td>
				</tr>
			<cfelseif get_name.comment_permission is 2>---Probation---
			<cfform action="#request.rootpath#news/index.cfm?fuseaction=comment" method="post">
			<tr>
				<td>
					<textarea name="comment_text" cols="65%" rows=""></textarea>
				</td>
			</tr>
			<tr>
				<td>
					<cfinput type="hidden" name="ID" value="#ID#">
					<cfinput type="hidden" name="reg_userID" value="#reg_userID#">
					<cfinput type="hidden" name="user_name" value="#get_name.firstname# #get_name.lastname#">
					<cfinput type="hidden" name="probation" value="1">
					<cfinput type="submit" name="submit" value="Add your comment">
					(Your comment will be displayed as posted by #get_name.firstname# #get_name.lastname# pending a review by our site moderators;
					Paint BidTracker reserves the right to remove or edit comments. Comments not consistent with our <a href="#request.rootpath#info/?fuseaction=comments" target="_blank">comment posting policy</a> will not be approved for public viewing.)
				</td>                                               
			</tr>
			</cfform>
			<cfelse>---Allowed---
			<cfform action="#request.rootpath#news/index.cfm?fuseaction=comment" method="post">
			<tr>
				<td>
					<textarea name="comment_text" cols="65%" rows=""></textarea>
				</td>
			</tr>
			<tr>
				<td>
					<cfinput type="hidden" name="ID" value="#ID#">
					<cfinput type="hidden" name="reg_userID" value="#reg_userID#">
					<cfinput type="hidden" name="user_name" value="#get_name.firstname# #get_name.lastname#">
					<cfinput type="submit" name="submit" value="Add your comment">
					(Your comment will be displayed as posted by #get_name.firstname# #get_name.lastname#;
					Paint BidTracker reserves the right to remove or edit comments. Comments not consistent with our <a href="#request.rootpath#info/?fuseaction=comments" target="_blank">comment posting policy</a> will be removed.)
				</td>                                               
			</tr>
			</cfform>
			</cfif>
		<cfelse>
			<tr>
				<td>
					<a href="#request.rootpath#register/?fuseaction=login&art_newsID=#ID#">Sign in to our community to add your comments.</a>
				</td>
			</tr>
		</cfif>--->
	<tr>
		<td width="100%" colspan="2">
			<p align="center">&nbsp;</p>
		</td>
	</tr>
</table>
</cfoutput>

<!---Record page view after content loads--->
<cfset view_date = createodbcdatetime(now())>
<cfquery name="insert_page_view" datasource="#application.dataSource#">
	insert into gateway_page_view_log
	(gateway_id, pageID, contentID, datestamp, reg_userID, cfid)
	values
	(2, 157, #ID#,
	#view_date#, 
	<cfif isdefined("reg_userID") and reg_userID is not "">#reg_userID#<cfelse>NULL</cfif>,
	<cfif isdefined("cfid") and cfid is not "">#cfid#<cfelse>NULL</cfif>)
</cfquery>