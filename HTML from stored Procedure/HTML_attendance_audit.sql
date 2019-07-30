USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[lumiante_HTML_sp_attendance_audit]    Script Date: 7/30/2019 9:55:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_luminate_HTML_sp_attendance_audit]
@OrganizationID INT,
@page INT,
@target_page INT,
@target_group INT = -1

AS

BEGIN

/**
	This is the first of 3 procedures to effectivly audit the head count of a given gorup
	procedure 1 (this one) is a kind of custom module that allows the user to select a given occurrence type to audit
	procedure 2 - luminate_GRID_sp_AttendanceAudit - lists occurrences by year of a given type, and allows eazy exporting to Exel for spreadsheet validation
	procedure 3 - luminate_HTML_sp_AttendanceChange - is a html buttion that goes directly to the given occurrence detail page to update the headCount

 **/

DECLARE @Results VARCHAR(MAX) --the end result

--group variables
DECLARE @groups_default varchar(max) = '<option value = "0">Select a Group</option>'
DECLARE @groups_list varchar(max) --lists the gorups
SELECT @groups_list = COALESCE(@groups_list + A, A) FROM
(SELECT
	'<option value="'+CONVERT(varchar(20), group_id)+'">'+group_name+'</option>'
	AS A
	FROM dbo.core_occurrence_type_group) AS contentA WHERE A is not NULL

--type variables
DECLARE @type_default varchar(max) = '<option value = "0">Select a Type</option>'
DECLARE @type_list varchar(max) --lists the gorups
SELECT @type_list = COALESCE(@type_list + A, A) FROM
(SELECT
	'<option value="'+CONVERT(varchar(20), occurrence_type_id)+'">'+type_name+'</option>'
	AS A
	from dbo.core_occurrence_type
	where group_id = @target_group) AS contentA WHERE A is not NULL

--group selection
DECLARE @group_select varchar(max) =
'
<div class="form-row">
	<div class="col">
		<select id="group_selector" class="form-control" name="target_group">
		'+@groups_default+@groups_list+'
		</select>
	</div>
	<div class="col">
		<a class="btn btn-primary form-control" href="" id="target_link">Select</a>
	</div>
</div>
'
--list the group name
DECLARE @group_name varchar(255)
SET @group_name = (SELECT group_name from dbo.core_occurrence_type_group where group_id = @target_group)



--type selection
DECLARE @type_select varchar(max) =
'
<h1>'+@group_name+'</h1>
<br>
<div class="form-row">
	<div class="col">
		<label for="target_date">Target Year</label>
		<input class="form-control" id="target_year" name="target_date" type="number">
	</div>
</div>
<br>
<div class="form-row">
	<div class="col">
		<label for="target_type">Target Type</label>
		<select id="type_selector" class="form-control" name="target_type">
		'+@type_default+@type_list+'
		</select>
	</div>
	<div class="col">
		<a class="btn btn-primary form-control" onclick="go_page()" href="#" id="target_page">Select</a>
	</div>
</div>
'




/** the magic script**/
DECLARE @script VARCHAR(MAX) = (SELECT '
<script type="text/javascript">
	window.addEventListener("load", pageFullyLoaded, false);
	function pageFullyLoaded(e){

	}
	//groups
	try{
		var group_selector = document.getElementById("group_selector");
		var group_selector_value = group_selector.options[group_selector.selectedIndex].value;
		var target_group = document.getElementById("target_group");

		group_selector.onchange = function(){
			target_link.setAttribute("href", "https://arena.luminate.church/default.aspx?page='+CONVERT(VARCHAR(255), @page)+'&target_group="+group_selector.value);
		};
	} catch(err){}

	//types
	function go_page(){
		vartype_selector = document.getElementById("type_selector");
		var type_selector_value = type_selector.options[type_selector.selectedIndex].value;
		var target_type = document.getElementById("target_group");
		var target_year = document.getElementById("target_year");

		window.location.href = "https://arena.luminate.church/default.aspx?page='+CONVERT(varchar(255), @target_page)+'&a_type="+type_selector.value+"&a_year="+target_year.value;

	}
</script>
')

/** Put the strings together!!! **/
SELECT @Results = (
	iif(@target_group > 0, @type_select, @group_select)+@script

)

SELECT @Results AS [html]

END
