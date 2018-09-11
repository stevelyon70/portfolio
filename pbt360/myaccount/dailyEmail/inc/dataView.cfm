 <cfoutput>
  <cfloop from="1" to="#arraylen(arrQueryNames)#" index="_qInx">
    <cfloop query="#arrQueryNames[_qInx]#" >
		<cfquery name="tagList" datasource="paintsquare_master">
		select t.tag 
		from pbt_project_master_cats ppmc inner join pbt_tags t on t.tagID = ppmc.tagID 
		where ppmc.bidid = #bidid# 
			and t.active = 1
		</cfquery>
	<cfset status_display = "">
	<cfset status_display2 = "">
      <cfif valuetypeid is 1>
        <cfset valueT = "Total Contract">
        <cfelseif valuetypeid is 2>
        <cfset valueT = "Painting Only">
        <cfelse>
        <cfset valueT = "">
      </cfif>
      <cfquery name="getstatus" datasource="paintsquare_master" maxrows=1>
		select updateid,date_entered as moddate 
		from pbt_project_updates 
		where bidid = #bidid# and date_entered >= #todaydate#  
		order by pupdateid desc
	  </cfquery>
			
		<cfparam name="planholders" default="" />
		<cfif request.emailType is 'awards' and _qInx lt 5>	
			<cfswitch expression="#bid#">
				<cfcase value="Award"><cfset status_display = "Award"></cfcase>
				<cfcase value="Bid Results"><cfset status_display = "Bid Results"></cfcase>
				<cfdefaultcase><cfset status_display = "Bid Results"></cfdefaultcase>
			</cfswitch>
			<cfswitch expression="#getstatus.updateID#">
				<cfcase value="3"><cfset status_display2 = "Cancellation"></cfcase>
				<cfcase value="6"><cfset status_display2 = "Postponed"></cfcase>
				<cfcase value="7"><cfset status_display2 = "Low Bidders"></cfcase>
				<cfcase value="8"><cfset status_display2 = "Rejected"></cfcase>
				<cfcase value="9"><cfset status_display2 = "Rebid"></cfcase>
				<cfcase value="10"><cfset status_display2 = "Updated"></cfcase>
				<cfdefaultcase><cfset status_display2 = "Low Bidders"></cfdefaultcase>
			</cfswitch>
		</cfif>							
	  <cfif request.emailType is 'bids' and _qInx lt 3>									
      <cfswitch expression="#getstatus.updateid#">
        <cfcase value="1"><cfset status_display = "Updated"></cfcase>
        <cfcase value="2"><cfset status_display = "Bid Submittal Change"></cfcase>
        <cfcase value="3"><cfset status_display = "Cancelled"></cfcase>
        <cfcase value="4"><cfset status_display = ""></cfcase>
        <cfcase value="5"><cfset status_display = "Award"></cfcase>
        <cfcase value="6"><cfset status_display = "Postponed"></cfcase>
        <cfcase value="7"><cfset status_display = "Low Bidders"></cfcase>
        <cfcase value="8"><cfset status_display = "Rejected"></cfcase>
        <cfcase value="9"><cfset status_display = "Rebid"></cfcase>
        <cfcase value="10"><cfset status_display = "Updated"></cfcase>
        <cfcase value="11"><cfset status_display = "Commercial Painting Project"></cfcase>
        <cfcase value="12"><cfset status_display = "General Construction Project"></cfcase>
        <cfcase value="13"><cfset status_display = "Engineering & Design Project"></cfcase>
        <cfdefaultcase><cfset status_display = "#getstatus.updateid#"></cfdefaultcase>
      </cfswitch>
	  </cfif>			
      <cfif planholders neq "">
        <cfset status_display = "Planholders">
      </cfif>
      <cfif bidStage neq arrQueryNameLabels[_qInx]>
        <tr>
          <td style="background-color: ##ffc303;" colspan="6"><p align="center" style="margin-top:7px; margin-bottom:7px; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:14px; color:##000000; text-decoration:none; font-weight:bold;">#arrQueryNameLabels[_qInx]#</p></td>
        </tr>
      </cfif>
      <cfset bidStage = arrQueryNameLabels[_qInx] >
      <tr>
        <td width="20%"><span style="font-size:10px; font-style:italic; font-weight:bold; color:##df002c; vertical-align:text-top;">
			<cfif request.emailType is 'awards'>
				<cfif bid EQ "Award">
					#status_display#
				<cfelse>
					#status_display2#
				</cfif>
			<cfelse>
				#status_display#
			</cfif></span><br />
          BidID - #bidid#<br>
          <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=41&nl_versionid=#nl_versionid#&redirectid=674&userid=#user1#&bidid=#bidid#&#addt_variables#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">#projectname#</a></td>
		<cfif request.emailType is 'awards'>
			<td width="10%"><cfif isdefined("projectnum") and projectnum NEQ "">#projectnum#</cfif></td>
		</cfif>
        <td width="10%">#dateformat(submittaldate, "m/d/yyyy")#</td>
        <td width="15%">#owner#</td>
        <td width="10%"><cfif city NEQ "">
            #city#,
            <cfelseif county NEQ "">
            #county#,
          </cfif>
          #state#</td>
        <td width="30%">#valuelist(tagList.tag)#</td>
        <td width="15%">
<cfif request.emailType is 'bids'>			
			<cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0" and maximumvalue is not "" and projectsize is "">
          	  <cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">
          	  #bidvalue#
            <cfelseif minimumvalue is not "" and minimumvalue is not "0" and (maximumvalue is "0" or maximumvalue is "") and projectsize is "">
            <!---if only min--->
           	 <cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">
           	 #bidvalue#
            <cfelseif (maximumvalue is not "0" and maximumvalue is not "" and projectsize is  "") and (minimumvalue is "0" or minimumvalue is "") >
            <!---if only max--->
				<cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">
				#bidvalue#
            <cfelseif projectsize is not "" and (maximumvalue is "" or maximumvalue is "0") and (minimumvalue is "0" or minimumvalue is "")>
				<cfset bidvalue = #projectsize#>
				#bidvalue#
            <cfelseif projectsize is not "" and (maximumvalue is not "" and maximumvalue is not "0") and (minimumvalue is not "" and minimumvalue is not "0")>
				<cfset bidvalue =  "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# - #projectsize#" >
				#bidvalue#
            <cfelseif projectsize is not "" and (maximumvalue is not "" and maximumvalue is not "0") >
				<cfset bidvalue =  "#dollarformat(maximumvalue)# - #projectsize#" >
				#bidvalue#
            <cfelseif projectsize is not "" and (minimumvalue is not "" and minimumvalue is not "0")>
				<cfset bidvalue = "#dollarformat(minimumvalue)#  - #projectsize#" >
				#bidvalue#
            <cfelse>
            </cfif>
</cfif>
<cfif request.emailType is 'awards' and _qInx lt 5>
								<cfquery name="getlow" datasource="paintsquare_master">
									select top 3 supplier_master.companyname,a.amount,a.awarded,a.supplierid,pa.supplierID as paintsub
									from pbt_award_contractors a
									inner join pbt_project_stage b on a.stageID = b.stageID
									left outer join pbt_project_award_stage_detail c on c.stageID = b.stageID
									left outer join supplier_master on supplier_master.supplierid = a.supplierid 
									left outer join pbt_award_contractors pa on a.stageid = pa.stageid and pa.typeID = 3
									where b.bidid = #bidID# and a.supplierid <> 9000 
									order by a.awarded desc,a.amount
								</cfquery>
								<cfloop query="getlow">								
								<font face="Arial" size="1" color="black">#companyname#</font>
								<br><font size=1>#dollarformat(amount)#</font><br><br>
								</cfloop>
</cfif>
	  </td>
      </tr>
      <tr>
        <td colspan="7"><hr size="1" color="C0C0C0"></td>
      </tr>
    </cfloop>
  </cfloop>
</cfoutput> 