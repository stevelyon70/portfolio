<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>


<cfscript> 
    session.leadDetail = StructNew(); 
    StructInsert(session.leadDetail, "2342342", 'led detial content 2342342'); 
    StructInsert(session.leadDetail, "5334454", 'led detial content 5334454'); 
    StructInsert(session.leadDetail, "3453663", 'led detial content 3453663'); 
    StructInsert(session.leadDetail, "4325255", 'led detial content 4325255'); 
</cfscript> 

<cfoutput>
	#StructFind(session.leadDetail, "2342342")# <br />
	#StructFind(session.leadDetail, "5334454")# <br />
	#StructFind(session.leadDetail, "3453663")# <br />
	#StructFind(session.leadDetail, "4325255")# <br />
</cfoutput>
</body>
</html>