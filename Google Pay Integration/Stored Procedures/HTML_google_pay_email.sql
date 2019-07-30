USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[lumiante_HTML_sp_google_pay_email]    Script Date: 7/30/2019 10:50:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_lumiante_HTML_sp_google_pay_email]
@OrganizationID INT,
@ID INT,
@sjwt varchar(max)

AS

BEGIN

DECLARE @GUID uniqueidentifier = NEWID()
DECLARE @Comm_ID INT
DECLARE @Date datetime = getdate()
DECLARE @htmlMessage varchar(MAX) =
	'<p>Thank you for signing up for Luminate Church Mobil Check-In program</p>
	<p><a href="https://pay.google.com/gp/v/save/'+@sjwt+'">Click here to add to google play</a></p>'
DECLARE @textMessage varchar(MAX) =
	'Thank you for signing up for Luminate Church Mobil Check-In program, copy and paist this link into your browser to add to google play
	https://pay.google.com/gp/v/save/'+@sjwt+''
EXEC dbo.core_sp_save_communication
	-1
	,'system',
	1
	,'Luminate Kids'
	,'children@luminate.church' --send from
	,'more@luminate.church' --reply to
	,'' --cc
	,'' --bcc
	,'Mobil Check-In' --subject
	,@htmlMessage --html message
	,@textMessage --text message
	,''
	,0
	,0 --communication medium 0 for email 1 for text
	,0
	,0
	,'1900-01-01 00:00:00.000' --send when, leave default
	,0
	,3
	,'system'
	,@Date
	,''
	,0
	,@Comm_ID OUTPUT

EXEC core_sp_save_person_communication @Comm_ID, @ID,'1900-01-01 00:00:00.000','Queued',@GUID, 1





DECLARE @Results VARCHAR(MAX) --the end result

/** Put the strings together!!! **/
--enter string parts here
SELECT @Results = ('
	<div><p>Email Will be sent soon :)</p></div>
')

SELECT @Results AS [html]

END
