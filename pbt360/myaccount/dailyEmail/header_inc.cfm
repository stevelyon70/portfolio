 <cfoutput>
		<table width="100%" cellpadding="5" cellspacing="0" border="0" bgcolor="##ffffff">
          		<tr>
          			<td width="100%" align="left">
                  	<span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:18px; font-weight:bold; padding-bottom:7px; margin-bottom:7px;"><cfif request.emailType is 'bids'>Bid Notices<cfelse>Awards & Results</cfif> - Paint BidTracker</span><span style="font-size:5px;"><br /><br /></span>
                  <span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;  font-style:italic; font-weight:bold; padding-bottom:7px; margin-bottom:7px;">Project Intelligence for the Painting Industry</span><span style="font-size:5px;"><br /><br /></span>
                    <span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px; padding-bottom:7px; margin-bottom:7px;">
                    A Product of Technology Publishing: <br />
                    <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=15&nl_versionid=#nl_versionid#&redirectid=599&pubid=1&#addt_variables#"  style="color:##2d53ac; text-decoration:none; font-style:italic;">JPCL</a> | <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=1&#addt_variables#" style="color:##2d53ac; text-decoration:none;">PaintSquare</a> | <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=642&#addt_variables#" style="color:##2d53ac; text-decoration:none; font-style:italic;">Durability + Design</a>
                        | <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=21&#addt_variables#" style="color:##2d53ac; text-decoration:none;">Paint BidTracker</a></span><span style="font-size:5px;"><br /><br /></span>
                        <span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:14px; font-weight:bold;">#dateformat(todaydate, "mmmm d, yyyy")#</span>
                        <hr size="1" color="C0C0C0">
                	</td>
          		</tr>
          	</table>
</cfoutput>