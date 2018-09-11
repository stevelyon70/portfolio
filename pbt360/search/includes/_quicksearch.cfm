<!---Quick Searches include for Dashboard Module--->
<script language="javascript">

var win = null;
function NewWindow(mypage,myname,w,h,scroll){
LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
settings =
'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',resizable'
win = window.open(mypage,myname,settings)
}

</script>
<cfquery name="getcustomerstates" datasource="#application.dataSource#">
<!---get the user states--->
select b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (1,2,3,4,5,6,7,8,9,12) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and  bid_users.bt_status = 1)
</cfquery>
<cfset states = "#valuelist(getcustomerstates.stateid)#">



<!---<cfquery name="pull_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 and tag_parentID = 1
	 and tag_parentID <> 0
 	union 
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 
	 and tag_parentID <> 0
	union
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 2
	 and tag_parentID <> 0
    union
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID not in (1,2) and pbt_tags.tag_typeID = 1
	 and tag_parentID <> 0
	 order by pbt_tags.tag
</cfquery>  --->

 <cfquery name="pull_industrial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 and tag_parentID = 1
	 and tag_parentID <> 0
	 order by pbt_tags.tag
</cfquery>    
<cfquery name="pull_commercial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 2
	 and tag_parentID <> 0
	 order by pbt_tags.tag
</cfquery> 

<!--div class="page-header">
  <h3>Quick Search <small> simple search</small></h3>
</div-->
<div class="row">
  <div class="col-sm-12"> 
    <!-- start: TEXT FIELDS PANEL -->
    <div class="panel panel-default">
      <div class="panel-heading"> <i class="fa fa-external-link-square"></i> Filter By </div>
      <cfoutput>
        <div class="panel-body">
          <cfform name="searchForm" action="#request.rootpath#search/?action=qsresults" method="GET" enctype="multipart/form-data" role="form" class="form-horizontal">
          <input type="hidden" name="search_history" value="1">
          <input type="hidden" name="action" value="qsresults">
          <input type="hidden" name="filter" value="and">
          <input type="hidden" name="qt_required">
          <input type="hidden" name="projecttype" value="1" />
            <div class="form-group">
              <div class="col-xs-4">
                <label for="contractor_name"> </label>
                <input type="text" name="qt" placeholder="Enter Keyword(s) or BidID" size="40" value="" />
              </div>
			</div>
            <div class="form-group">
              <div class="col-sm-12">
                <label for="company_type_field">Stages:</label>
		<select placeholder="Select Stages" name="project_stage" multiple="multiple" id="stages" class="form-control search-select-structure">
                  <option value="1,2,3,4,5,6,7,8,9,10,11,15">--- All Stages ---</option>
		  <option value="1,2,3,4,5">Current Contracts and Notices</option>
                  <option value="6,7,8,9">Bid Results</option>
                  <option value="10,11,15">Archive of Expired Reports</option>
		</select>
                <!---<select name="project_stage" multiple>
                  <option value="1,2,3,4,5">Current Contracts and Notices</option>
                  <option value="6,7,8,9">Bid Results</option>
                  <option value="10,11,15">Archive of Expired Reports</option>
                  <option value="1,2,3,4,5,6,7,8,9,10,11,15" selected>All Stages</option>
                </select>--->
                <cfif isdefined("inf") and inf is 1>
                  <font color="red">Please enter criteria.</font>
                </cfif>
              </div>
            </div>
            <div class="form-group">
              <div class="col-sm-12">
                <label for="state">States:</label>
                <cfquery name="state" datasource="#application.datasource#">
		select distinct fullname,stateid from state_master where stateid in (#states#) and   countryid = 73  order by fullname  
		</cfquery>
		<select placeholder="Select States" name="state" multiple="multiple" id="state" class="form-control search-select-structure">
			<option value="66">--- All States ---</option>
			<cfloop query="state">
				<option value="#stateid#" >#fullname#</option>
			</cfloop>
		</select>
		<!---<cfselect name="state" size="5" query="state" value="stateid" selected="66" display="fullname" multiple="true">
		<option value="66" selected>All States</option>
		</cfselect>--->
              </div> 
              <div class="col-sm-12">
                <label for="structures">Structures:</label>
		<select placeholder="Select Structures" name="structures" multiple="multiple" id="structures" class="form-control search-select-structure">
			<cfoutput><option value="#valuelist(pull_industrial_structures.tagID)#,#valuelist(pull_commercial_structures.tagID)#" >--- All Structures ---</option></cfoutput>
			<cfoutput><option value="#valuelist(pull_industrial_structures.tagID)#" >--- All Industrial Structures Below ---</option></cfoutput>								
			<cfloop query="pull_industrial_structures">
				<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
			</cfloop>
			<cfoutput><option value="#valuelist(pull_commercial_structures.tagID)#" >--- All Commercial Structures Below ---</option></cfoutput>
			<cfloop query="pull_commercial_structures">
				<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
			</cfloop>
		</select>
                <!---<cfselect name="structures" size="5" query="pull_structures" value="tagID" display="tag" multiple="true">
                  <option value="1,2,3,4,5,6,7,8,9,10,11,15" selected>All Structures</option>
                </cfselect>--->
                <cfif isdefined("inf") and inf is 1>
                  <font color="red">Please enter criteria.</font>
                </cfif>
              </div>             
            </div>
            
            <div class="form-group">
              <div class="col-xs-1">
                <input class="btn btn-blue" type="submit" value="Search" id="submit">
              </div>
            </div>
          </cfform>
        </div>
      </cfoutput> </div>
    <!-- end: TEXT FIELDS PANEL --> 
  </div>
</div>
<!---cfoutput>
  <table cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr>
      <td class="dashTab" width="200"> Quick Search </td>
      <td></td>
    </tr>
    <tr>
      <td class="dashLine" colspan="2"></td>
    </tr>
  </table>
  <table cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr class="dash">
      <td colspan="3" class="smaller"><div align="left">
        <cfform name="CFForm_1" action="/search/?action=qsresults" method="GET" enctype="multipart/form-data">
          <input type="hidden" name="search_history" value="1">
          <input type="hidden" name="action" value="qsresults">
          <input type="hidden" name="filter" value="or">
          <table cellSpacing="0" cellPadding="0" border="0" width="100%">
          <tbody>
          <tr>
          <td vAlign="top">
          <table>
            <tr bgColor="white">
              <input type="hidden" name="qt_required">
              <td colSpan="2"><font size="2" face="Arial">
                <input type="text" name="qt" size="40" value="Enter Keyword(s) or BidID" onFocus="if ( value == 'Enter Keyword(s) or BidID' ) { value = ''; }" onBlur="if ( value == '' ) { value = 'Enter Keyword(s) or BidID'; }" >
                &nbsp;<span class="tex">
                <select name="project_stage">
                  <option value="1,2,3,4,5">Current Contracts and Notices</option>
                  <option value="6,7,8,9">Bid Results</option>
                  <option value="10,11,15">Archive of Expired Reports</option>
                  <option value="1,2,3,4,5,6,7,8,9,10,11,15" selected>All</option>
                </select>
                <cfif isdefined("inf") and inf is 1>
                  <font color="red">Please enter criteria.</font>
                </cfif>
                </span></font></td>
            </tr>
            <cfoutput>
              <input type="hidden" name="userid" value="#session.auth.userid#">
            </cfoutput>
            <tr bgColor="white">
              <td colSpan="2"><span class="tex">
                <cfquery name="state" datasource="#application.datasource#">
select distinct fullname,stateid from state_master where stateid in (#states#,66) and   countryid = 73  order by fullname  
</cfquery>
                <cfselect name="state" size="1" query="state" value="stateid" display="fullname" selected="66"></cfselect>
                </span> &nbsp;&nbsp;
                <input type="submit" name="Search" value="Search" style="background-color:##ffc303;"></td>
            </tr>
            <tr bgColor="white">
              <td align="left" colSpan="2"><cfoutput><a href="projectsearch/"></cfoutput><span class="tex2">Advanced Search</span></a> | <a href="search_tips.cfm" onclick="NewWindow(this.href,'legend','600','400','yes');return false;"><span class="tex2">Search Tips&nbsp;</span></a></td>
            </tr>
          </table>
        </cfform></td>
    </tr>
      </tbody>
    
  </table>
  </div>
  </td>
  </tr>
  </table>
</cfoutput---> 