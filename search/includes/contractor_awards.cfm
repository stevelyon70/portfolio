
<cfparam name="startRow" default="1">
<cfparam name="endRow" default="20">
<cfparam name="variable.user_tags" default="-1"/>
<cfparam name="paction" default="#action#">

<cfinclude template="user_trash.cfm">
<cfquery name="getcustomerstates" datasource="#application.datasource#">
select b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (5,6,7,12) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=91&userid=#session.auth.userid#"></cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">

<!---check to see if user is auth. to receive paint bids, if not send them back--->
<cfquery name="checkuser" datasource="#application.datasource#">
select bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards 
from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #session.auth.userid#
</cfquery>                                                  


<cfif checkuser.awards is not 1> 
<cflocation url="?action=91" addtoken="No">
</cfif>

			<!---check user tags if they have a niche tags package only--->
				<cfif listcontains(session.packages, 16)>
				<cfquery name="get_approved_tags" datasource="#application.datasource#">
					select tagID
					from pbt_user_tags
					where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and tagID in (#session.user_tags#)
					and active = 1
				</cfquery>
				<cfset selected_user_tags = valuelist(get_approved_tags.tagID)>
				</cfif>


<CFSET basedate = #CREATEODBCDATE(NOW())#>
<cfset last_yeardate = #DateAdd ("d", -365, basedate)#>

<cftransaction action="begin">

<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
<cfset vdate = dateadd("d",-365,todaydate)>

 <!---run the stored procedure to pull the industrial bids--->
<cfstoredproc procedure="award_paint_new_v4" datasource="#application.datasource#" >
<cfprocparam type="in" dbvarname="@subdate" cfsqltype="CF_SQL_TIMESTAMP" value="#CREATEODBCDATETIME(NOW())#">
<cfprocparam type="in" dbvarname="@categoryid" cfsqltype="CF_SQL_INTEGER" value="1">
<cfprocparam type="in" dbvarname="@vdate" cfsqltype="CF_SQL_TIMESTAMP" value="#last_yeardate#">
<cfprocparam type="in" dbvarname="@supplierid" cfsqltype="CF_SQL_INTEGER" value="#supplierid#">
</cfstoredproc>
<!---
<cfquery name="total_results" datasource="#application.datasource#"><!---pull results from storedproc--->
select count(distinct bidID) as total_returned
from bidtemporary_contractor_v4 where stateid in (#states#) 
</cfquery>
<!---if show all then set the param for endrow to all records--->
<cfif isdefined("showall") and showall EQ "yes">
	<cfset endrow = total_results.total_returned>
</cfif>--->
<!---include file to set sort values
<cfinclude template="sort_params.cfm">--->
<cfset sortvalue = "CASE WHEN submittaldate IS NULL  THEN 1 ELSE 0 END,submittaldate">
<cfquery name="search_results" datasource="#application.datasource#"><!---pull results from storedproc--->
select *
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( ORDER BY #sortvalue# ) AS RowNum
			FROM    (
select distinct a.bidID,a.projectname,a.owner,a.ownerID,a.scopelist as tags,a.submittaldate,a.city,
	 a.state,a.stateID,a.projectsize,a.minimumvalue as minimumvalue,a.maximumvalue as maximumvalue,a.bid as stage,a.stageID,a.postdate as paintpublishdate,a.zipcode,a.valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid, gtwy.supplierID, promas.projectnum,g.PhoneNumber
from bidtemporary_contractor_v4 a

LEFT OUTER JOIN pbt_project_master promas on promas.bidid = a.bidid
LEFT OUTER JOIN pbt_project_master_gateway gtwy on gtwy.bidID = a.bidid
   left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1

INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
	
where a.stateid in (#states#) 
<!---TAGS filter--->
		<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
		and ppmc.tagID in (#selected_user_tags#)
		</cfif>
		<!---USER TRASH --->
		<cfif user_trash.recordcount GT 0>
		and a.bidID not in (#valuelist(user_trash.bidID)#)
		</cfif>
		<!---filter based on zipcodes--->
		<cfif isdefined("ziplist") and ziplist is not "">
		and ((a.zipcode in (#ziplist#) or a.owner_zipcode in (#ziplist#))  or ((a.owner_zipcode is null and a.zipcode is null) ))
		</cfif>
 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #startRow#
    		AND RowNum <= #endRow#
</cfquery>	

</cftransaction>

<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#application.datasource#">
	select bidID 
	from bid_user_project_bids
	where userID = #session.auth.userid# and active = 1
</cfquery>
	
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="insert_usage" datasource="#application.datasource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#session.auth.userid#,'#cfid#',#date#,90,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>
<cfquery name="insertcfid" datasource="#application.datasource#">
INSERT INTO CLOG (cfid,cftoken,visitdate,siteid,remoteip,remotehost,localaddress,path)
VALUES('#cfid#','#cftoken#',#date#,'34','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#','#CGI.CF_Template_Path#')
</cfquery>

 

<cfif not isdefined("search_results")>
<cfquery name="static" datasource="#application.datasource#">
select * from bid_award where bidid = 1
</cfquery>
</cfif>

<cfif not isdefined("tempHRef")>
	<cfset tempHRef = "">
</cfif>

<cfif isdefined("url.supplierid") and isdefined("tempHRef")>
	<cfset tempHRef = tempHRef & "&supplierid=#supplierid#">
</cfif>

<cfset tempHRef = tempHRef & "&action=90">		
					<cfquery name="getname" datasource="#application.datasource#">
					select companyname from supplier_master where supplierid = #supplierid#
					</cfquery>
					
					
		
<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="100%" align="left" valign="top" colspan="3">
                        <div align="left">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <h1><span style="font-size:16px">Contractor History</span></h1>
                              </td>
                              <td width="200" valign="top" align="right">
								<p align="right">
									  <!-- AddThis Button BEGIN -->
								<div class="addthis_toolbox addthis_default_style"><a class="addthis_button_email"></a>  <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
								<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
								<!-- AddThis Button END -->
                              </p>
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
	<td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
               	<td width="100%">
                  	<div align="center">
                	<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
                        	<td height="10"></td>
                  		</tr>			
						<tr>
							<td width="88%" valign="top">
							<strong>Contractor Bidding History for <cfoutput><a href="#request.rootpath#contractor/?contractor&supplierID=#url.supplierID#"><strong>#getname.companyname#</strong></a></cfoutput></strong>
							</td>
							</tr>
							<tr>
                        	<td height="10"></td>
                  		</tr>
						
		<cfif isdefined("static")>
			<cfset mymaxrows="1">
		</cfif>
			<cfif isdefined("search_results") and search_results.recordcount is 0>
				<cfset mymaxrows="1">
			<cfelse>
			</cfif>
<tr>
<td>
Below is a full listing of projects where has <cfoutput><strong>#getname.companyname#</strong></cfoutput>
been an awardee and/or low bidder.
</td>
</tr>
		
		<cfinclude template="search_results_grid_inc.cfm">
		

	<cfif isdefined("search_results") and search_results.recordcount is 0>
		<table><tr><td><b><span class="tex">There are no additional projects to report at this time.</span></b></td></tr></table>
	</cfif>	
	<cfif isdefined("static") and not isdefined("search_results")>
		<table><tr><td><b><span class="tex">There are no additional projects to report at this time.</span></b></td></tr></table>
	</cfif>    
				   
                	</table>
            	</div>
           		</td>
            </tr>
            
   	      </table>
