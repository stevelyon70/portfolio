<cfset the_dsn = "paintsquare">
<cfsetting showdebugoutput="false">

<cfquery name="sup" datasource="#the_dsn#">
	SELECT x.supplier_id, a.company_name
	FROM ss_account_company_xref x
	JOIN ss_account a ON a.account_id = x.account_id
	WHERE company_id = 2080   <!---#session.companyid#--->
</cfquery> 
<cfquery name="click_act" datasource="#the_dsn#">
	SELECT COUNT(Id) as count, section 
	FROM ss_click_tracker
	WHERE supplier_id = #sup.supplier_id#
	GROUP BY section
</cfquery>   

{
	"leg": [<cfoutput query="click_act">"#section#"<cfif currentrow neq click_act.recordcount>,</cfif></cfoutput>],
	"items": [<cfoutput query="click_act">{"value": #count#,"name": "#section#"}<cfif currentrow neq click_act.recordcount>,</cfif></cfoutput>]
}

