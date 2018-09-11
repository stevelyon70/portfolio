<!---select ads for this newsletter version--->
<cfquery name="get_ads" datasource="paintsquare_master">
select distinct supplier_master.companyname,nl_sponsors.nl_sponsorid,nl_sponsors_versions.sponsor_sort,nl_sponsor_ads.nl_adid,nl_sponsor_ads.image_location,nl_sponsor_ads.adname,nl_sponsor_ads.adheadline,nl_sponsors_schedule.nl_skedID
from nl_sponsors
inner join nl_sponsor_ads on nl_sponsor_ads.nl_sponsorid = nl_sponsors.nl_sponsorid
inner join nl_sponsors_versions on nl_sponsors_versions.nl_adid = nl_sponsor_ads.nl_adid
inner join supplier_master on supplier_master.supplierid = nl_sponsors.supplierid
inner join nl_sponsors_schedule on nl_sponsors_schedule.nl_skedID = nl_sponsors_versions.nl_skedID
where nl_sponsors_versions.nl_versionid = #nl_versionid#  AND (nl_sponsors_schedule.nl_positionID = 1)
<cfif isdefined("ad_group") and ad_group is 1>and nl_sponsors_versions.sponsor_sort in (1,2,3,4,5,6,7)<cfelseif isdefined("ad_group") and ad_group is 2>and nl_sponsors_versions.sponsor_sort in (8,9,10,11,12,13,14)<cfelseif isdefined("ad_group") and ad_group is 3>and nl_sponsors_versions.sponsor_sort in (15,16,17,18,19,20,21) </cfif>
order by nl_sponsors_versions.sponsor_sort
</cfquery>


<cfif get_ads.recordcount gt 0>
<table width="100%" cellpadding="0" cellspacing="0">
                        	<tr>
                        		<td style="background-color: #5a7775;"><p align="center" style="margin-top:7px; margin-bottom:7px;"><span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:14px; color:#ffffff;"><em><strong>Advertisers</strong></em></span></p>                                </td>
                            </tr>
										
                            <tr>
                                <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #ffffff; PADDING-BOTTOM: 18px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; MARGIN-BOTTOM: 18px; PADDING-TOP: 0px; border: solid 1px #5a7775; border-top: 0px;">
                                    
							   <cfloop query="get_ads">
								   	<cfoutput>
								    <cfquery name="get_detail" datasource="paintsquare_master">
									select nl_sponsor_ads.adcontent
									from  nl_sponsor_ads 
									where nl_sponsor_ads.nl_adid = #nl_adid#
									</cfquery>      
										<p style="margin-top:7px; margin-bottom:7px;">
			                                <span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px;">
				                                <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=15&nl_versionid=#nl_versionid#&nl_adid=#nl_adid#&nl_skedID=#nl_skedID#&redirectid=11&#addt_variables#"> 
												<cfif image_location is not ""><img border="0" src="http://www.paintsquare.com/newsletter/#image_location#" width="175" height="100"></cfif><br>
				                                <b>#adheadline#</b>
												</a><br>
				        						<cfloop query="get_detail">#adcontent#</cfloop>
											</span>
		                                </p>
		                                <hr size="1" color="C0C0C0">
									</cfoutput>
								</cfloop>			
								
                                </td>
                       		</tr>
                     	</table>
</cfif>
