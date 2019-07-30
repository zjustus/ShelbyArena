USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_HTML_sp_AttendanceChange]    Script Date: 7/30/2019 9:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_luminate_HTML_sp_AttendanceChange]
@OrganizationID INT,
@target_page INT

AS

BEGIN

/**
	This is the third of 3 procedures to effectivly audit the head count of a given gorup
	procedure 1 is a kind of custom module that allows the user to select a given occurrence type to audit
	procedure 2 - luminate_GRID_sp_AttendanceAudit - lists occurrences by year of a given type, and allows eazy exporting to Exel for spreadsheet validation
	procedure 3 - (this one) - is a html buttion that goes directly to the given occurrence detail page to update the headCount

 **/

DECLARE @Results VARCHAR(MAX) --the end result


--type selection
DECLARE @type_select varchar(max) =
'
<div class="form-row">
	<div class="col">
		<label for="target_occurrence">Target Occurrence</label>
		<input class="form-control" id="target_occurrence" name="target_occurrence" type="number">
	</div>
</div>
<br>
<div class="form-row">
	<div class="col">
		<a class="btn btn-primary form-control" href="" id="target_page">Select</a>
	</div>
</div>
'


/** the magic script**/
DECLARE @script VARCHAR(MAX) = (SELECT '
<script type="text/javascript">
	window.addEventListener("load", pageFullyLoaded, false);
	function pageFullyLoaded(e){

	}
	//types
	try{
		var target_occurrence = document.getElementById("target_occurrence");
		target_occurrence.onchange = function(){
			target_page.setAttribute("href", "https://arena.luminate.church/default.aspx?page='+CONVERT(VARCHAR(255), @target_page)+'&OccurrenceID="+target_occurrence.value);
		};
	} catch(err){
	}
</script>
')

/** Put the strings together!!! **/
SELECT @Results = (
	@type_select+@script

)

SELECT @Results AS [html]

END
