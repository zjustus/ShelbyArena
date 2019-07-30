USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_HTML_sp_RedirectButton]    Script Date: 7/30/2019 9:58:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_luminate_HTML_sp_RedirectButton]
@OrganizationID INT,
@target_page INT

AS

BEGIN

--the end result
DECLARE @Results varchar(max) =
'<div class="col">
	<a class="btn btn-primary form-control" href="https://arena.luminate.church/default.aspx?page='+CONVERT(VARCHAR(255), @target_page)+'" id="target_page">Send the Command</a>
</div>'

SELECT @Results AS [html]

END
