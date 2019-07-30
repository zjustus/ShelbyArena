USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_HTML_sp_AttendanceTotal]    Script Date: 7/30/2019 9:58:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_luminate_HTML_sp_AttendanceTotal]
@OrganizationID INT,
@a_type INT,
@a_year INT

AS

BEGIN

/**
	This is the third of 3 procedures to effectivly audit the head count of a given gorup
	procedure 1 is a kind of custom module that allows the user to select a given occurrence type to audit
	procedure 2 - luminate_GRID_sp_AttendanceAudit - lists occurrences by year of a given type, and allows eazy exporting to Exel for spreadsheet validation
	procedure 3 - (this one) - is a html buttion that goes directly to the given occurrence detail page to update the headCount

 **/

DECLARE @Results VARCHAR(MAX) --the end result

DECLARE @total int;
set @total =
(select SUM(head_count)
from dbo.core_occurrence
where occurrence_type = @a_type
and YEAR(occurrence_start_time) = @a_year)

--type selection
DECLARE @html varchar(max) =
'
<div class="row">
	<div class="col">
		<h1>Total Attendance: '+CONVERT(varchar(50), @total)+'</h1>
	</div>
</div>
'


/** Put the strings together!!! **/
SELECT @Results = (
	@html

)

SELECT @Results AS [html]

END
