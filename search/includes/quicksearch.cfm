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


<!--div class="page-header">
  <h3>Quick Search <small> simple search</small></h3>
</div-->
<div class="row">
  <div class="col-sm-12"> 
      <cfoutput>
        
          <cfform name="searchForm" action="#request.rootpath#search/?action=qsresults" method="GET" enctype="multipart/form-data" role="form" class="form-horizontal">
          <input type="hidden" name="search_history" value="1">
          <input type="hidden" name="action" value="qsresults">
          <input type="hidden" name="filter" value="and">
          <input type="hidden" name="qt_required">
          <!---<input type="hidden" name="projecttype" value="1" />--->
            <div class="form-group">
              <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                <label for="contractor_name"> </label>
                <input type="text" name="bidid" placeholder="Enter Project ID" size="40" value="" class="form-control" />
              </div>
              <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                <label for="contractor_name"> </label>
                <input type="text" name="qt" placeholder="Enter Keyword(s)" size="40" value="" class="form-control" />
              </div>
	    </div>
            <div class="form-group">
              <div class="col-sm-12">
                <label for="company_type_field"></label>
		<select placeholder="> Select Stages" name="project_stage" multiple="multiple" id="stages" class="form-control search-select-structure">
                  <option value="1,2,3,4,5,6,7,8,9,10,11,15"> All Stages</option>
		  		  <option value="1,2,3,4,5">Current Contracts and Notices</option>
                  <option value="6,7,8,9">Bid Results</option>
                  <option value="10,11,15">Archive of Expired Reports</option>
		</select>
                <cfif isdefined("inf") and inf is 1>
                  <font color="red">Please enter criteria.</font>
                </cfif>
              </div>
            </div>
            <div class="form-group">
              <div class="col-sm-12">
                <label for="state"></label>
                <cfquery name="state" datasource="#application.datasource#">
					select distinct fullname,stateid 
					from state_master 
					where stateid in (#states#) 
						and   countryid = 73  
					order by fullname  
				</cfquery>
				<select placeholder="> Select States" name="state" multiple="multiple" id="state" class="form-control search-select-structure">
					<option value="66">All States</option>
					<cfloop query="state">
						<option value="#stateid#" >#fullname#</option>
					</cfloop>
				</select>
              </div> 
			  </div>
             <div class="form-group">
              <div class="col-sm-12">
                <label for="structures"></label>
					<select placeholder="> Select Structures" name="structures" multiple="multiple" id="structures" class="form-control search-select-structure">
						
						<cfoutput><option value="#valuelist(session.model.formStructureDropOptions.tagID)#" >All Structures Below</option></cfoutput>								
						<cfloop query="session.model.formStructureDropOptions">
							<cfquery name="check_subs" datasource="#application.datasource#">
							 select pbt_tags.tag,pbt_tags.tagID
							 from pbt_tags
							 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
							 and tag_parentID <> 0
							 order by pbt_tags.tag
							</cfquery>											
							<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
							<cfif check_subs.recordcount GT 0>
							   <cfloop query="check_subs">
									<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
							   </cfloop>
							</cfif>	
						</cfloop>
						
					</select>
                <cfif isdefined("inf") and inf is 1>
                  <font color="red">Please enter criteria.</font>
                </cfif>
              </div>             
            </div>
            
            <div class="form-group">
              <div class="col-xs-1">
                <input class="btn btn-primary" type="submit" value="Search" id="submit">
              </div>
            </div>
          </cfform>
      
      </cfoutput> 
  </div>
</div>