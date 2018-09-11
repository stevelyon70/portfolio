<cfparam name="startRow" default="1">
<cfparam name="endRow" default="5">

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="getcustomerstates" datasource="#application.datasource#"><!---get the user states--->
select distinct b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (1,2,3,4,5,6,7,8,9,10,12,14) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=91&userid=#session.auth.userid#" addtoken="Yes"></cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">

<!---check to see if user is auth. to receive paint bids, if not send them back--->
<!---cfquery name="checkuser" datasource="#application.datasource#">select bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #session.auth.userid#</cfquery--->                                                  
<cfquery name="checkuser" datasource="#application.datasource#">
select bid_subscription_log.packageid
from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_subscription_log.packageid in (1,2,3,4,5,6,7,8,9,10,12,14)  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
</cfquery> 
 
<cfif checkuser.recordcount is 0 >
<cflocation url="?userid=#session.auth.userid#" addtoken="No">
</cfif>
<cfset zip_packageid = valuelist(checkuser.packageid)>
<cfinclude template="zip_module.cfm">
 <CFSET BASEDATE = #createodbcdate(now())#>
 <cfset last_yeardate = #DateAdd ("d", -365, basedate)#>
<cfset lastsixty = dateadd("d",-60,basedate)>
<!---run tags check--->
	<cfquery name="get_approved_tags" datasource="#application.datasource#">
		select tagID
		from pbt_user_tags
		where userID = #session.auth.userid#
		and active = 1
	</cfquery>
	<cfif get_approved_tags.recordcount GT 0>
		<cfset selected_user_tags = valuelist(get_approved_tags.tagID)>
	</cfif>
	
<!---include file to set sort values--->
<cfinclude template="sort_params.cfm">
<cfquery name="total_results" datasource="#application.datasource#">
SELECT distinct a.bidID,a.stageID
from pbt_project_master_gateway a
INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
left outer join bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid= <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_user_viewed_log.award is null
left outer join pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)	
left outer join pbt_project_contacts k on k.bidID = a.bidID and k.contact_typeID = 3 --eng

where a.stateid in (#states#) and a.bidid <> 1 
and a.supplierID = <cfqueryPARAM value = "#supplierID#" CFSQLType = "CF_SQL_INTEGER">

<!---filter based on zipcodes--->
		<cfif isdefined("ziplist") and ziplist is not "">
		and ((a.zipcode in (#ziplist#) or a.owner_zipcode in (#ziplist#))  or ((a.owner_zipcode is null and a.zipcode is null) ))
		</cfif>
<!---TAGS filter--->
		<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
		and ppmc.tagID in (#selected_user_tags#)
		</cfif>
<!---post date--->
   	<cfif isdefined("bidfrom") and bidfrom NEQ "">
   		and a.paintpublishdate >= '#bidfrom#'
		   <cfif isdefined("bidto") and bidto NEQ ""> 
		   	AND a.paintpublishdate <= '#bidto#'
		   </cfif>
	</cfif>
<!---stage filter set--->
   	<cfif isdefined("bid") and bid NEQ "">
	 	and a.stageID in (1,4,20,21,22,23,24)
	</cfif>
	<cfif isdefined("awd") and awd NEQ "">
	 	and a.stageID in (5,6)
	</cfif>
</cfquery>	
<!---if show all then set the param for endrow to all records--->
<cfif isdefined("showall") and showall EQ "yes">
	<cfset endrow = total_results.recordcount>
</cfif>
<cfquery name="getbids" datasource="#application.datasource#">
select *
	from 
			(
			SELECT  *,ROW_NUMBER() OVER ( ORDER BY #sortvalue# ) AS RowNum
			FROM    (
select distinct a.bidid,a.stageID,a.stage,a.owner,a.projectname,ppe.companyname as architect,a.submittaldate,a.city,a.county,a.state,a.tags,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.valuetypeID as valuetype,a.stateid,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.paintpublishdate,a.ownerid,a.supplierID
from pbt_project_master_gateway a
INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
left outer join bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid= <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_user_viewed_log.award is null
left outer join pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)	
left outer join pbt_project_contacts k on k.bidID = a.bidID and k.contact_typeID = 3 --eng
--left outer join pbt_contact_detail l on l.pbt_contactID = k.pbt_contactID
left outer join pbt_project_engineers ppe on ppe.engineerID = a.engineerID --engineers for project
left outer join state_master ppe2 on ppe2.stateID = ppe.stateID --engineer state
where a.stateid in (#states#) and a.bidid <> 1 
and a.supplierid = <cfqueryPARAM value = "#supplierid#" CFSQLType = "CF_SQL_INTEGER">

<!---filter based on zipcodes--->
		<cfif isdefined("ziplist") and ziplist is not "">
		and ((a.zipcode in (#ziplist#) or a.owner_zipcode in (#ziplist#))  or ((a.owner_zipcode is null and a.zipcode is null) ))
		</cfif>
<!---TAGS filter--->
		<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
		and ppmc.tagID in (#selected_user_tags#)
		</cfif>
<!---post date--->
   	<cfif isdefined("bidfrom") and bidfrom NEQ "">
   		and a.paintpublishdate >= '#bidfrom#'
		   <cfif isdefined("bidto") and bidto NEQ ""> 
		   	AND a.paintpublishdate <= '#bidto#'
		   </cfif>
	</cfif>	
<!---stage filter set--->
   	<cfif isdefined("bid") and bid NEQ "">
	 	and a.stageID in (1,4,20,21,22,23,24)
	</cfif>
	<cfif isdefined("awd") and awd NEQ "">
	 	and a.stageID in (5,6)
	</cfif>
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #startRow#
    		AND RowNum <= #endRow#
</cfquery>	
<cfquery name="getbids_count" dbtype = "query">
	select *
	from total_results
	where stageID in (1,4,20,21,22,23,24)
</cfquery>
<cfquery name="getawards" dbtype = "query">
	select *
	from total_results
	where stageID in (5,6)
</cfquery>

<cfquery name="getowner_contact" datasource="#application.datasource#" maxrows="1">
select distinct supplier_master.companyname,supplier_master.billingaddress,supplier_master.phonenumber,supplier_master.stateid,supplier_master.faxnumber,supplier_master.postalcode,supplier_master.emailaddress,supplier_master.websiteurl,supplier_master.city,state_master.state
from supplier_master
left outer join state_master on state_master.stateid = supplier_master.stateid
where supplier_master.supplierid = <cfqueryPARAM value = "#supplierid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="insert_usage" datasource="#application.datasource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#session.auth.userid#,'#cfid#',#date#,53,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>
<cfquery name="insertcfid" datasource="#application.datasource#">
INSERT INTO CLOG (cfid,cftoken,visitdate,siteid,remoteip,remotehost,localaddress,path)
VALUES('#cfid#','#cftoken#',#date#,'26','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#','#CGI.CF_Template_Path#')
</cfquery>

<CFPARAM NAME="mystartrow" DEFAULT="1" type="numeric">
<cfif not isdefined("realstartrow")>
<CFPARAM NAME="realstartrow" DEFAULT="1" type="numeric">
</cfif>
<!---date picker--->
	<script>
	$(function() {
		var dates = $( "#bidfrom, #bidto" ).datepicker({
			defaultDate: "-1w",
			maxDate: "+0",
			changeMonth: true,
			numberOfMonths: 3,
			/*beforeShowDay: $.datepicker.noWeekends,*/
			onSelect: function( selectedDate ) {
				var option = this.id == "bidfrom" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
	});
	</script>
	<script>
	$(function() {
		var dates = $( "#awardfrom, #awardto" ).datepicker({
			defaultDate: "-1w",
			maxDate: "+0",
			changeMonth: true,
			numberOfMonths: 3,
			/*beforeShowDay: $.datepicker.noWeekends,*/
			onSelect: function( selectedDate ) {
				var option = this.id == "awardfrom" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
	});
	</script>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
    	<td width="100%" align="left" valign="top" colspan="3">
        	<div align="left">
          	<table border="0" cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                	<td align="left" valign="bottom">
                   	<h3>Project Intelligence</h3>
                  	</td>
                 	<!---<td valign="top" width="180">
					<p>
					<!-- AddThis Button BEGIN -->
					<div class="addthis_toolbox addthis_default_style"><a class="addthis_button_email"></a> <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
					<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
					<!-- AddThis Button END -->
               		</p>
					</td>--->
             	</tr>
		<tr>
      			<td width="100%"><hr class="PBT" noshade></td>
    			</tr>
         	</table>
            </div>

		</td>
    </tr>
</table>
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 pull-left">
	<strong>Agency Information for <cfoutput><a href="#request.rootpath#agency/?agency&supplierID=#url.supplierID#">#getowner_contact.companyname#</cfoutput></a></strong>
	<br><br>
 	
	<table border="0" cellspacing="1" cellpadding="3"  bgcolor="black" bordercolor="black" bordercolorlight="black"   bordercolordark="black" width="185" >
		<cfoutput query="getowner_contact"> 
		<cfif emailaddress is not "" or billingaddress is not "" or city is not "" or phonenumber is not "" or faxnumber is not "" or websiteurl is not ""> 

		<tr><td bgcolor="white">
		<span class="tex"><strong>Contact Information</strong></span><br>
		<cfif emailaddress is not "">
		<!---tr bgcolor="white">
		  <td width="109" ---><a href="mailto:#emailaddress#"><span class="tex">Contact This Agency</span></a>
		  <!---td width="109" ></td></td>
		</tr---> <br>
		</cfif>
		<cfif billingaddress is not "">
		  <span class="tex">#billingaddress#</span>
		<br>
		</cfif>
		<cfif city is not "">
		  <span class="tex">#city#,<cfif stateid is not 66> #state#</cfif> <cfif postalcode is not "">#postalcode#</cfif></span>
			<br>
		</cfif>
		<cfif phonenumber is not "">
		<cfset ph = rereplace(phonenumber,"[^0-9]","","all")>
		<cfset length = len("ph")>
		<cfset phon = mid(ph,"1","3")>
		<cfset phon2= mid(ph,"4","3")>
		<cfset phon3=mid(ph,"7","4")>
		<cfset phonenumber2="#phon#-#phon2#-#phon3#">
		 <span class="tex">Phone: #phonenumber2#</span>
		<br>
		</cfif>
		<cfif faxnumber is not "">
		<cfset fx = rereplace(faxnumber,"[^0-9]","","all")>
		<cfset length = len("fx")>
		<cfset fax = mid(fx,"1","3")>
		<cfset fax2= mid(fx,"4","3")>
		<cfset fax3=mid(fx,"7","4")>
		<cfset faxnumber2="#fax#-#fax2#-#fax3#">
		<span class="tex">Fax: #faxnumber2#</span>
		<br>
		</cfif>
		<cfif emailaddress is not "">
		 <span class="tex">#emailaddress#</span>
		<br>
		</cfif>
		<cfif websiteurl is not "">
		<!---tr bgcolor="white"--->
		  <!---td width="218" colspan="2"---><span class="tex">#websiteurl#</span><!---/td--->
		<!---/tr--->
		</cfif>
		</td></tr>
		</cfif>
		</cfoutput>
	</table>
</div>	
<div class="col-xs-6 col-sm-6 col-md-8 col-lg-7 pull-left">	
	<br><br>		
	<cfoutput>
		<div class="col-xs-12 col-sm-12 col-md-6 col-lg-5 pull-left">				
			<cfset tempHRef = "">
			<!---view agency page sorting--->
			<cfif isdefined("bidfrom")><cfset tempHRef = tempHRef & "&bidfrom=#bidfrom#"></cfif>
			<cfif isdefined("bidto")><cfset tempHRef = tempHRef & "&bidto=#bidto#"></cfif>
			<cfif isdefined("awardfrom")><cfset tempHRef = tempHRef & "&awardfrom=#awardfrom#"></cfif>
			<cfif isdefined("awardto")><cfset tempHRef = tempHRef & "&awardto=#awardto#"></cfif>
			<cfif isdefined("bid")><cfset tempHRef = tempHRef & "&bid=#bid#"></cfif>
			<cfif isdefined("awd")><cfset tempHRef = tempHRef & "&awd=#awd#"></cfif>
			<cfif IsDefined("ownerID")><cfset temphref = temphref & "&ownerID=#ownerID#"></cfif>
			<cfif IsDefined("supplierID")><cfset temphref = temphref & "&supplierID=#supplierID#"></cfif>
			<cfif IsDefined("PRS") and prs is 1><cfset temphref = temphref & "&PRS=#PRS#"></cfif>
			<cfif IsDefined("BD")><cfset temphref = temphref & "&BD=#BD#"></cfif>	


			<table border="0" cellpadding="0">
				<tr>
					<td valign="top">
						<span class="tex2">#getbids_count.recordcount# Bid Notices</span><a href="##bid"><u></u></a>
					</td>
				</tr>

				<cfform name="CFForm_1" action="?userid=#session.auth.userid#&supplierID=#supplierID#&bid=1&prs=1&bd=1&action=#action#" method="POST">
					<tr>
						<td valign="top">
							<span class="tex">View All Bid Notices for this Company</span><br>						
							<label for="bidfrom">Posted between</label>
							<input type="text" id="bidfrom" name="bidfrom" class="form-control" size="10"/>
							<label for="bidto">And</label>
							<input type="text" id="bidto" name="bidto" class="form-control"/>
							<input type="submit" name="submit" value="Go" class="btn btn-primary"> 
						</td>
					</tr>
				</cfform>
			</table>
			<br><br>
		</div>

		<div class="col-xs-12 col-sm-12 col-md-6 col-lg-5 pull-left">			
			<cfset tempHRef1 = "">
			<cfif IsDefined("PRS") and prs is 2><cfset temphref1 = temphref1 & "&PRS=#PRS#"></cfif>
			<cfif IsDefined("awd")><cfset temphref1 = temphref1 & "&awd=#awd#"></cfif>
			<cfif IsDefined("ad")><cfset temphref1 = temphref1 & "&ad=#ad#"></cfif>

			<table border="0" cellpadding="0">
				<tr>
					<td valign="top">
						<span class="tex2">#getawards.recordcount# Awards/Results In Last 60 Days</span><a href="##bid"><u></u></a>
					</td>
				</tr>

				<cfform name="CFForm_1" action="?userid=#session.auth.userid#&supplierid=#supplierid#&awd=1&prs=2&ad=1&action=#action#" method="POST">
					<tr>
						<td valign="top">
							<span class="tex">View All Awards/Results Notices for this Company</span><br>														 
							<label for="awardfrom">Posted between </label>
							<input type="text" id="awardfrom" name="awardfrom" class="form-control"/>
							<label for="awardto">And</label>
							<input type="text" id="awardto" name="awardto" class="form-control"/>
							<input type="submit" name="submit" value="Go" class="btn btn-primary">
						</td>
					</tr>
				</cfform>
			</table>
		</div>

	</cfoutput>
</div>
<br><br><br>
<cfif getbids.recordcount is not 0>
	<!---<a name="bid">--->
  		<cfinclude template="agency_bid_include.cfm">
	<!---</a>--->
<cfelse>
  
  	No results for the criteria you selected.
<cfset totalrows = 0>
 </cfif>
  <!---br>
  <cfif getawards.recordcount is not 0>
  	<cfif not isdefined("bd")><a name="awards">
		<cfinclude template="agency_award_include.cfm">
	</cfif>
  <cfelse>
	<cfif not isdefined("bd") and getbids.recordcount is not 0>
		No results for the criteria you selected.
	</cfif>
  <cfset totalrows = 0>
  </cfif--->
  <cfif getbids.recordcount is 0 and getawards.recordcount is 0>
  <cfelse>
  <cfoutput>
  
  <cfif isdefined("showall") and showall is "yes">
  	<cfset tempHRef = tempHRef & "&showall=yes">
	<cfif isdefined("sort")>
	<cfset tempHRef = tempHRef & "&sort=#sort#&desc=#desc#">
	</cfif>
  </cfif>
  
  
  <!---cfif (isdefined("showall1") and showall1 is "yes") or (isdefined("awd") and awd is "1") and not isdefined("bd") and getawards.recordcount is not 0>
  <p align="right"><a href="view_friendly_print_agen.cfm?userid=#session.auth.userid#&print=1&mymaxrows=#totalrows#&realstartrow=#realstartrow#&temphref1=#temphref1#" target="blank"><span class="tex2"><b>Click here for printer friendly version</b></span></a></p>
  <cfelseif (isdefined("showall") and showall is "yes") or (isdefined("bid") and bid is "1") and not isdefined("ad") and getbids.recordcount is not 0>
  <p align="right"><a href="view_friendly_print_agen.cfm?userid=#session.auth.userid#&print=1&mymaxrows=#totalrows#&realstartrow=#realstartrow#&temphref2=#temphref2#" target="blank"><span class="tex2"><b>Click here for printer friendly version</b></span></a></p>
  </cfif--->
  
           <!---cfif not url.showall> <font size="1">Page&nbsp;<cfinclude template="NextNIncludePageLinks.cfm"><!---show all link---><cfoutput><cfset tempHRef = ""><cfif isdefined("sort")><cfset tempHRef = tempHRef & "&sort=#sort#"></cfif><cfif isdefined("desc")><cfset tempHRef = tempHRef & "&desc=#desc#"></cfif></cfoutput></cfif---></font></p>
	</cfoutput>		
</div>
</cfif>