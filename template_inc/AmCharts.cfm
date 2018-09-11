// JavaScript Document
<cftry>
<!---state name
# of active projects
last 24 hours
top 3 scope of work tags
--->	
<cfquery datasource="#application.datasource#" name="qStates" result="r0" cachedWithin = "#CreateTimeSpan(1, 6, 0, 0)#">	
	select distinct ppmg.state as state, ppmg.stateID as id
	from pbt_project_master_gateway as ppmg
	where state is not null
	order by ppmg.state
</cfquery>
<cftry>
<cfoutput>#qStates.recordcount#</cfoutput>
<cfcatch>
<cfquery datasource="#application.datasource#" name="qStates" result="r0">	
	select distinct ppmg.state as state
	from pbt_project_master_gateway as ppmg
	where state is not null
	order by ppmg.state
</cfquery>
</cfcatch></cftry>
<cfquery datasource="#application.datasource#" name="qProjectsActive" result="r1" cachedWithin = "#CreateTimeSpan(0, 6, 0, 0)#">	
	select distinct ppmg.state, count(*) as projects
	from pbt_project_master_gateway as ppmg
		left outer join pbt_project_master_cats as cats on cats.bidID = ppmg.bidID
		left outer join pbt_tags as tag on tag.tagID = cats.tagID
	where 0=0
		and ppmg.stageID in (5,6)
		and tag.active = 1 
		and ppmg.state is not null 
<!---		--and ppmg.state = '#state#'--->
	group by ppmg.state
	order by ppmg.state
</cfquery>
<cfquery datasource="#application.datasource#" name="qProjects24" result="r2" cachedWithin = "#CreateTimeSpan(0, 6, 0, 0)#">	
	select distinct ppmg.state, count(*) as projects
	from pbt_project_master_gateway as ppmg
		left outer join pbt_project_master_cats as cats on cats.bidID = ppmg.bidID
		left outer join pbt_tags as tag on tag.tagID = cats.tagID
	where 0=0
		and tag.active = 1 
		and ppmg.state is not null
		<!---		--and ppmg.state = '#state#'--->
		and paintpublishdate >= '#dateformat(createodbcdatetime(dateadd('d', now(), -1)), 'yyyy-mm-dd hh:mm:ss')#'
	group by ppmg.state
	order by ppmg.state
</cfquery>
<cfquery datasource="#application.datasource#" name="qTop3" result="r3" cachedWithin = "#CreateTimeSpan(0, 6, 0, 0)#">	
select distinct ppmg.state, count(*) as projects, tag.tag 
	from pbt_project_master_gateway as ppmg
		left outer join pbt_project_master_cats as cats on cats.bidID = ppmg.bidID
		left outer join pbt_tags as tag on tag.tagID = cats.tagID
	where 0=0 
		and tag.active = 1 
		and ppmg.state is not null 
		and tag.tagID <> 67
		<!---		--and ppmg.state = '#state#'--->
	group by ppmg.state, tag.tag
	order by ppmg.state, projects desc
</cfquery>		
<cfset request.calloutList = 'DE,DC,HI,MD,MA,NJ,RI,CT'/>
var map = AmCharts.makeChart( "chartdiv", {

  "type": "map",

  "theme": "light",

  "colorSteps": 1,

  "dataProvider": {

    "map": "usaLow",

    "areas": [				
<cfoutput query="qStates">			
<cfquery dbtype="query" name="qProjectsActiveSub">	
	select projects
	from qProjectsActive
	where 0=0
	and state = '#state#'
	order by state
</cfquery>

<cfquery dbtype="query" name="qProjects24Sub">	
	select projects
	from qProjects24
	where 0=0
	and state = '#state#'
	order by state
</cfquery>
<cfquery dbtype="query" name="qTop3Sub" maxrows="3">	
	select projects, tag
	from qTop3
	where 0=0
	and state = '#state#'
	order by projects desc
</cfquery>		
<cfquery name="getcustomerstates" datasource="#application.dataSource#">
<!---get the user states--->
select b.stateid 
from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  
	--and b.packageid in (1,2,3,4,5,6,7,8,9,12) 
	and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and  bid_users.bt_status = 1)
	and b.stateid = #qStates.id#
</cfquery>
	
			{"id":"US-#state#",color: "##<cfif getcustomerstates.recordcount>244999<cfelse>bfbfbf</cfif>" ,"outlineThickness":1, "outlineColor": "##e1e1e1","value":"", "balloonText" : "#state#<br/>Active Projects : #qProjectsActiveSub.projects#<br />Last 24 Hours : #qProjects24Sub.projects#<br />Top 3 Scope Tags : <cfloop query="qTop3Sub">#tag# #qTop3Sub.projects#<br /></cfloop>"<cfif listfind(request.calloutList, state)>, "callout": false</cfif> }<cfif currentrow neq recordcount>,</cfif> 

<cfflush />
</cfoutput>	
<cfcatch><cfdump var="#cfcatch#" /></cfcatch></cftry>   

    ]

  },

  "areasSettings": {

    "autoZoom": true,

    "selectedColor": "#244999"

  },

 

} );



map.addListener( "init", function() {



  // small areas

  var small = [ "US-MA", "US-RI", "US-CT", "US-NJ", "US-DE", "US-MD", "US-DC" ];



  // set up a longitude exceptions for certain areas

  var longitude = {

    "US-CA": -130,

    "US-FL": 120,

    "US-TX": 1,

    "US-LA": 40

  };



  var latitude = {

    "US-AK": -83

  };

  

  // Positions of callouts

  var callouts = [

    70, 60, 46, 26, 3, -20, -40, -56

  ];

  

  var offset = 10;


/*
  setTimeout( function() {

    // iterate through areas and put a label over center of each

    //map.dataProvider.images = [];

    for ( x in map.dataProvider.areas ) {

      var area = map.dataProvider.areas[ x ];

      area.groupId = area.id;

      var image = new AmCharts.MapImage();

      image.title = area.title;

      image.linkToObject = area;

      image.groupId = area.id;

      

      // callout or regular label

      if ( area.callout ) {

        image.latitude = callouts.shift();

        image.longitude = 165;

        image.label = area.value;

        image.type = "rectangle";

        image.color = area.color;

        image.shiftX = offset;

        image.width = 22;

        image.height = 22;

        

        // create additional image

        var image2 = new AmCharts.MapImage();

        image2.latitude = image.latitude;

        image2.longitude = image.longitude;

        image2.label = area.id.split( '-' ).pop();

        image2.labelColor = "#000";

        image2.labelShiftX = 24;

        image2.groupId = area.id;

        map.dataProvider.images.push( image2 );

      }

      else {

        image.latitude = latitude[ area.id ] || map.getAreaCenterLatitude( area );

        image.longitude = longitude[ area.id ] || map.getAreaCenterLongitude( area );

        image.label = area.id.split( '-' ).pop() + "\n" + area.value;

      }

      

      map.dataProvider.images.push( image );

    }

    map.validateData();

  }, 100 )*/

} );