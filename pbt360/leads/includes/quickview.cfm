<cfstoredproc procedure="pbt_project_detail" datasource="#application.datasource#" >
<cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#bidid#">
<cfprocresult name="getdetail" resultset="1">
</cfstoredproc>
    	   
<cfquery name="getlow" datasource="#application.datasource#">
	select supplier_master.companyname,supplier_master.contactname,pbt_project_award_stage_detail.post_date as postdate,pbt_project_award_stage_detail.award_editornote as editornotes,
	supplier_master.websiteurl,supplier_master.billingaddress,supplier_master.city,supplier_master.postalcode,
	supplier_master.emailaddress,supplier_master.phonenumber,supplier_master.faxnumber,state_master.state,
	pbt_award_contractors.amount,pbt_award_contractors.awarded,pbt_award_contractors.supplierid 
	from pbt_project_stage
	left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.stageID = pbt_project_stage.stageID
	left outer join pbt_award_contractors on pbt_project_stage.stageID = pbt_award_contractors.stageID 
	left outer join supplier_master on supplier_master.supplierid = pbt_award_contractors.supplierid 
	left outer join state_master on state_master.stateid = supplier_master.stateid 
	where pbt_project_stage.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> and pbt_award_contractors.supplierid <> 9000 
	and pbt_project_stage.stageID = (select max(stageID) from pbt_project_stage where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">)
	and pbt_award_contractors.typeID <> 3
	order by pbt_award_contractors.awarded desc,pbt_award_contractors.amount
</cfquery>
<!---Run check for O results--->
<cfif getlow.recordcount EQ 0>
	<cfquery name="getlow_text" datasource="#application.datasource#">
		select bidID,companyname,amount,address,city,state,postalcode,emailaddress,firstname + lastname as contactname,lowbidder
		from pbt_project_onvia_award_results
		left outer join state_master on state_master.stateid = pbt_project_onvia_award_results.stateid 
		where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">
	</cfquery>
</cfif>  

<cfquery name="getnotes" datasource="#application.datasource#">
	select distinct pbt_project_award_stage_detail.award_editornote as editornotes 
	from pbt_project_award_stage_detail 
	where bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">
</cfquery>

<!---<cfquery name="get_tags" datasource="#application.datasource#">
		select distinct pbt_project_master_cats.tagID,pbt_tags.tag
		from pbt_project_master_cats
		left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
		where pbt_tags.active = 1 and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#bidID#" CFSQLType = "CF_SQL_INTEGER">
		and pbt_tags.tag_typeID <> 9
		order by tag 
</cfquery>--->

<!--- TRACKING INSERT QUERIES --->
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<cfquery name="insertbid" datasource="#application.datasource#">
	insert into bid_user_viewed_log
	(bidid,userid,dateviewed)
	values('#bidid#',<cfif isdefined("userID") and userID NEQ "">#userid#<cfelse>NULL</cfif>,#date#)
</cfquery>

<cfquery name="insert_usage" datasource="#application.datasource#">
	INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
	VALUES(<cfif isdefined("userID") and userID NEQ "">#userid#<cfelse>NULL</cfif>,'#cfid#',#date#,52,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>

<CFSCRIPT>		
// Capitalize first char of each word
function CapsFirst(string)
{
// Define local variables
VAR outstring="";
VAR c1=0;
VAR c2=0; 
// Loop through string
for (i=1; i LTE Len(string); i=i+1)
{
// Is this the first char in string?
if (i IS 1)
{
// First is always upper case
c1=UCase(Mid(string, i, 1));
}
else
{
// Get char and previous char
c1=Mid(string, i, 1);
c2=Mid(string, i-1, 1); 

// If Previous char is . or space
if ((c2 IS ".") OR (c2 IS ' '))
// then upper case
c1=UCase(c1);
else
// else lower case
c1=LCase(c1);
} 


// And put the string back together
outstring=outstring & c1;
} 

return outstring;
}
</CFSCRIPT>
<cfset map_address = "">

<cfoutput query="getdetail">

	<div class="col-sm-12">
	  <span class="h3">Project: #projectname#</span>
	</div>		
										
	<div class="page-header col-md-12">
		<table>
			<tr>
				<td width="125">BidID:</td>
				<td>#bidID#</td>
			</tr>
			<cfif projectnum NEQ "">
			<tr>
				<td width="125">Project Number:</td>
				<td>#projectnum#</td>
			</tr>
			</cfif>
			<tr>
				<td width="125" valign="top">Owner:</td>
				<td>								
				<cfif isdefined("supplierID") and supplierID NEQ "">
					<a href="#request.rootpath#agency/?agency&supplierID=#supplierID#&userid=#userid#"><strong>#owner#</strong></a>
				<cfelse>								
					#owner#
				</cfif>	
				</td>
			</tr>
			<tr>
				<td width="125">Date Posted:</td>
				<td>#dateformat(paintpublishdate, "m/d/yyyy")#</td>
			</tr>
			<CFIF ISDEFINED("EDITDATE")>
				<tr>
					<td>Updated on:</td> 
					<td>
						<cfif dateformat(edate) NEQ dateformat(paintpublishdate)>
							#dateformat(EDATE, "mmmm d, yyyy")#
						</cfif>								
					</td>
				</tr>
			</cfif>	
			<cfif prebid NEQ "">
				<tr>
					<td>Pre-Bid Meeting Date:</td> 
					<td>#prebid#</td>
				</tr>
			</cfif>		
			<cfif prebidnotes NEQ "">
				<tr>	
					<td width="125" valign="top">Pre-Bid Notes:</td> 
					<td>#prebidnotes#</td>
				</tr>
			</cfif>		
			<cfif (minimumvalue NEQ "" and minimumvalue NEQ "0") or (maximumvalue NEQ "" and maximumvalue NEQ "0")>
				<tr>
					<td width="125" valign="top">Cost Estimate:</td> 
					<td>
						<cfif minimumvalue NEQ "" and minimumvalue NEQ "0">
							$#numberformat(minimumvalue)#
						</cfif> 
						<cfif minimumvalue NEQ "" and minimumvalue NEQ "0" and maximumvalue NEQ "" and maximumvalue NEQ "0">-</cfif> 
						<cfif maximumvalue NEQ "" and maximumvalue NEQ "0">$#numberformat(maximumvalue)#</cfif>
					</td>
				</tr>	
			</cfif>
			<tr>		
				<td>Stage:</td> 
				<td>#stage#</td>	
			</tr>	
			<cfif valuetypeid is 1 or valuetypeid is 2>
				<tr>
				<td>Type of Contract:</td> 
				<td>
					<cfif valuetypeid EQ 1>General Contract<cfelseif valuetypeid EQ 2>Painting</cfif>
				</td>
				</tr>
			</cfif>	
			<cfif city NEQ "" or county NEQ "" or primary_location_state NEQ "" or zipcode NEQ "">
				<tr>
					<td width="125" valign="top">Location:</td> 
					<td>
						<cfif city NEQ "">
							#capsfirst(city)#,
							<cfset map_address = listappend(map_address,city)>
						<cfelse> 
							<cfif county NEQ "">
								#capsfirst(county)#
								<cfset map_address = listappend(map_address,county)>
							</cfif>
						</cfif>
						<cfif primary_location_state NEQ "">
							#primary_location_state#
							<cfset map_address = listappend(map_address,primary_location_state)>
						</cfif> 
						<cfif zipcode NEQ "">
							#zipcode#
							<cfset map_address = listappend(map_address,zipcode)>
						</cfif>
					</td>
				</tr>
			</cfif>								
			<cfif submittaldate NEQ "">
				<tr>
					<td>Submittal Date:</td> 
					<td>#dateformat(submittaldate, "m/d/yyyy")#</td>
				</tr>
			</cfif>
			<cfif planprice NEQ "">
				<tr>
					<td>Plan Price:</td> 
					<td>#planprice#</td>
				</tr>
			</cfif>
			<cfif projectstartdate NEQ "">
				<tr>
					<td>Project Start Date:</td> 
					<td>#projectstartdate#</td>
				</tr>
			</cfif>
			<cfif projectsize NEQ "">
				<tr>
					<td>Project Size:</td> 
					<td>#projectsize#</td>
				</tr>
			</cfif>																																																																																																																																																																																																																	
		</table>																		
	</div>								
				
</cfoutput> 

<cfif isdefined("getdetail.bidtypeID") and (getdetail.bidtypeID EQ "5" or getdetail.bidtypeID EQ "6")  and ((getlow.recordcount GT 0) or (isdefined("getdetail.award_editornotes") and getdetail.award_editornotes NEQ ""))>
	<div class="col-sm-12">
		<hr style="border-top: 1px solid #8c8b8b;">
		<cfif isdefined("getlow.supplierid") and getlow.supplierid is not "" and getlow.supplierid is not 9000>
		  <h5>APPARENT LOW BIDDERS</h5>
		</cfif>

		<cfif isdefined("getlow.supplierid") and getlow.supplierid is not "" and getlow.supplierid is not 9000>
		<table cellpadding="0" cellspacing="0" border="0" >
			<cfoutput query="getlow" maxrows="3"> 
				<cfif supplierid is not 9000>
					<tr>
						<td colspan="2"><cfif awarded is "1"><img border="0" src="http://app.paintbidtracker.com/images/bidwinner.gif" ></cfif></td>
					</tr>
					<tr>
						<td width="1%"><b>#currentrow#.&nbsp;</b></td>
						<td width="49%">
							<cfif isdefined("getlow.supplierID") and getlow.supplierID is not "">
								<a href="#request.rootpath#contractor/?contractor&supplierID=#getlow.supplierID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
									#companyname#
								</a>
							<cfelse>
								#companyname#
							</cfif>
						</td>
						<td width="50%">Bid	Amount:&nbsp; #dollarformat(amount)#</td>
					</tr>
					<cfif billingaddress is not "" or city is not "" or state is not "" or postalcode is not "">
						<tr>
							<td width="1%">&nbsp;</td>
							<td colspan="3">
								<cfif billingaddress NEQ "">#billingaddress#<br></cfif>
								<cfif city NEQ ""> #city#,</cfif>
								<cfif state NEQ ""> #state#</cfif>
								<cfif postalcode NEQ "">&nbsp; #postalcode#</cfif>
							</td>
						</tr>
					</cfif>
					<cfif contactname is not "">
						<tr>
							<td width="1%">&nbsp;</td>
							<td colspan="3" >Contact Name: #contactname#<cfif contactname is "">Not Available</cfif></td>
						</tr>
					</cfif> 
					<cfif phonenumber is not "">
						<tr>
							<td width="1%">&nbsp;</td>
							<td colspan="3" >Telephone: #phonenumber#<cfif phonenumber is "">Not Available</cfif></td>
						</tr>
					</cfif>
					<cfif faxnumber is not "">
						<tr>
							<td width="1%">&nbsp;</td>
							<td colspan="3" >Fax: #faxnumber#<cfif faxnumber is "">Not Available</cfif></td>
						</tr>
					</cfif>
					<cfif emailaddress is not "">
						<tr>
						<td width="1%">&nbsp;</td>
						<td colspan="3" >Email Address: <a href="mailto:#emailaddress#">#emailaddress#</a><cfif emailaddress is "">Not Available</cfif></td>
						</tr>
					</cfif>
					<cfif currentrow EQ 1>	
						<cfquery name="getlow2" datasource="#application.datasource#">
							select supplier_master.companyname,supplier_master.contactname,pbt_project_award_stage_detail.post_date as postdate,pbt_project_award_stage_detail.award_editornote as editornotes,
							supplier_master.websiteurl,supplier_master.billingaddress,supplier_master.city,supplier_master.postalcode,
							supplier_master.emailaddress,supplier_master.phonenumber,supplier_master.faxnumber,state_master.state,
							pbt_award_contractors.amount,pbt_award_contractors.awarded,pbt_award_contractors.supplierid 
							from pbt_project_stage
							left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.stageID = pbt_project_stage.stageID
							left outer join pbt_award_contractors on pbt_project_stage.stageID = pbt_award_contractors.stageID 
							left outer join supplier_master on supplier_master.supplierid = pbt_award_contractors.supplierid 
							left outer join state_master on state_master.stateid = supplier_master.stateid 
							where pbt_project_stage.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> and pbt_award_contractors.supplierid <> 9000 
							and pbt_project_stage.stageID = (select max(stageID) from pbt_project_stage where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">)
							and pbt_award_contractors.typeID = 3
							order by pbt_award_contractors.awarded desc,pbt_award_contractors.amount
						</cfquery>

						<cfif getlow2.recordcount is not 0 and getlow2.supplierid is not "" and getlow2.supplierid is not 9000>		  										  		  		  
							<tr>
								<td width="1%">&nbsp;</td>
								<td colspan="3" >										
									<table border="0" width="100%">
										<tr>
											<td width="100%" colspan="3"><h3>Painting Subcontractor:</h3></td>
										</tr>
										<tr>
											<td width="6%"></td>
											<td width="59%">#getlow2.companyname#</td>
											<td width="41%">Painting Amount: <cfif getlow2.amount is "">N/A<cfelse>#dollarformat(getlow2.amount)#</cfif></td>
										</tr>
										<cfif getlow2.billingaddress is not "" or getlow2.city is not "" or getlow2.state is not "" or getlow2.postalcode is not "">
											<tr>
												<td width="6%"></td>
												<td width="94%" colspan="2"><cfif getlow2.billingaddress is ""><cfelse>#getlow2.billingaddress#<br></cfif><cfif getlow2.city is not ""> #getlow2.city#,</cfif><cfif getlow2.state is not ""> #getlow2.state#</cfif><cfif getlow2.postalcode is not "">&nbsp; #getlow2.postalcode#</cfif></td>
											</tr>
										</cfif>
										<cfif getlow2.contactname is not " ">
											<tr>
												<td width="6%">&nbsp;</td>
												<td width="94%" colspan="2" >Contact Name: #getlow2.contactname#<cfif getlow2.contactname is "">Not Available</cfif></td>
											</tr>
										</cfif>
										<cfif getlow2.phonenumber is not "">
											<tr>
												<td width="6%"></td>
												<td width="94%" colspan="2" >Telephone:	#getlow2.phonenumber#<cfif getlow2.phonenumber is "">Not Available</cfif></td>
											</tr>
										</cfif>
										<cfif getlow2.faxnumber is not "">
											<tr>
												<td width="6%"></td>
												<td width="94%" colspan="2">Fax: #getlow2.faxnumber#<cfif getlow2.faxnumber is "">Not Available</cfif></td>
											</tr>
										</cfif>
										<cfif getlow2.emailaddress is not "">
											<tr>
												<td width="6%"></td>
												<td width="94%" colspan="2">Email Address: <a href="mailto:#getlow2.emailaddress#">#getlow2.emailaddress#</a><cfif getlow2.emailaddress is "">Not Available</cfif></td>
											</tr>
										</cfif>
									</table>
								</td>
							</tr>									
						</cfif>

					</cfif>
					<tr><td colspan="4"><hr></td></tr>
				</cfif>
			</cfoutput> 
			</table> 
			<cfif getlow.recordcount GT 3>				
				<p><b><cfoutput>#getlow.recordcount# Total bidders, <a href="../leads/?bidid=#bidID#">view full details</a> to see all.</cfoutput></b></p>			
			</cfif>			
		</cfif>

		<cfif isdefined("getdetail.awarddate") and getdetail.awarddate NEQ "">				
			<p>Award Date: <cfoutput>#dateformat(getdetail.awarddate, "m/d/yyyy")#</cfoutput><p>			
		</cfif>					
		<cfif isdefined("getdetail.award_editornotes") and getdetail.award_editornotes NEQ "">			
			<p>Award Note: <cfoutput>#getdetail.award_editornotes#</cfoutput></p>			
		</cfif>
		 
	</div>
	
<cfelseif getlow.recordcount EQ 0 and getlow_text.recordcount GT 0>

	<div class="col-sm-12">	
		<hr style="border-top: 1px solid #8c8b8b;">			    
		<h5>APPARENT LOW BIDDERS</h5>

		<table cellpadding="0" cellspacing="0" border="0" >
			<cfoutput query="getlow_text"> 
				<tr>
					<td width="1%"><b>#currentrow#.&nbsp;</b></td>
					<td width="49%">#companyname#<cfif lowbidder EQ "Yes"><img border="0" src="http://app.paintbidtracker.com/images/bidwinner.gif" ></cfif></td>
					<td width="50%">Bid	Amount:&nbsp; #dollarformat(amount)#</td>
				</tr>
				<cfif address is not "" or city is not "" or state is not "" or postalcode is not "">
					<tr>
						<td width="1%">&nbsp;</td>
						<td colspan="3">
							<cfif address is ""><cfelse>#address#<br></cfif>
							<cfif city is not ""> #city#,</cfif>
							<cfif state is not ""> #state#</cfif>
							<cfif postalcode is not "">&nbsp; #postalcode#</cfif>
						</td>
					</tr>
				</cfif>
				<cfif contactname is not " ">
					<tr>
						<td width="1%">&nbsp;</td>
						<td colspan="3">Contact Name: #contactname#<cfif contactname is "">Not Available</cfif></td>
					</tr>
				</cfif> 
				<cfif emailaddress is not "">
					<tr>
						<td width="1%">&nbsp;</td>
						<td width="562" colspan="3" >Email Address: <a href="mailto:#emailaddress#">#emailaddress#</a><cfif emailaddress is "">Not Available</cfif>&nbsp;</td>
					</tr>
				</cfif>
			</cfoutput>  
		</table>	
		
		<cfif getlow_text.recordcount GT 3>				
			<p><b><cfoutput>#getlow_text.recordcount# Total bidders, <a href="../leads/?bidid=#bidID#">view full details</a> to see all.</cfoutput></b></p>			
		</cfif>			

	</div>
	
</cfif>



<cfif isdefined("getdetail.editornotes") and trim(getdetail.editornotes) NEQ "">
	<div class="col-sm-12">
		<hr style="border-top: 1px solid #8c8b8b;">	
		<h5>EDITOR NOTES</h5> <cfoutput><p>#getdetail.editornotes#</p></cfoutput> 
	</div>	
</cfif>

<!---<cfif get_tags.recordcount GT 0>
	<div class="col-sm-12">
		<h3>Relevant Tags:</h3> <cfoutput>#valuelist(get_tags.tag)#</cfoutput> 
	</div>
</cfif>	--->
	
