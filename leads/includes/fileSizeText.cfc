<CFCOMPONENT DISPLAYNAME="FileSizeText" 
        HINT="Returns a translated byte/KB/Mb/Gb value">


        <CFFUNCTION NAME="getText"
                 ACCESS="public"
                OUTPUT="false" RETURNTYPE="string">
        
        <!--- 
        <CFINVOKE COMPONENT="FileSizeText" 
                METHOD="getText" 
                RETURNVARIABLE="[RETURNVARIABLE]">
        
                <CFINVOKEARGUMENT NAME="size"
                        VALUE="[int]">
        </CFINVOKE>

        Returns: [RETURNVARIABLE] = string
         --->

                
        <CFARGUMENT NAME="size" 
                DEFAULT="0"
                REQUIRED="yes">

        <CFIF (NOT IsNumeric(ARGUMENTS.size)) OR (ARGUMENTS.size
LTE 0)>
                <CFSET outText = "Size Unknown">
        <CFELSEIF ARGUMENTS.size LT 1024>
                <CFSET outText = 
                "#ARGUMENTS.size# bytes">
        <CFELSEIF ARGUMENTS.size LT 1048576>
                <CFSET outText =
                "#NumberFormat(ARGUMENTS.size/1024, "_")# Kb">
        <CFELSEIF ARGUMENTS.size LT 1073741824>
                <CFSET outText =
                "#DecimalFormat(ARGUMENTS.size/1048576)# Mb">
        <CFELSE>
                <CFSET outText =
                "#DecimalFormat(ARGUMENTS.size/1073741824)# Gb">
        </CFIF>

        <CFRETURN outText>

        </CFFUNCTION>

</CFCOMPONENT>