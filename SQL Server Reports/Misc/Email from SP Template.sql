DECLARE @Date datetime = getdate()
Declare @id int
DECLARE @GUID uniqueidentifier = NEWID()
DECLARE @personID int
DECLARE @htmlMessage varchar(MAX) = 
	'Hello World'
DECLARE @textMessage varchar(MAX) =
	'Hello World'

EXEC dbo.core_sp_save_communication
	-1
	,'system',
	1
	,'system'
	,'arena@luminate.church' --email
	,'more@luminate.church' --reply to
	,'' --cc
	,'' --bcc
	,'Prayer Request' --subject
	,@htmlMessage --html message
	,@textMessage --text message
	,''
	,0
	,0 --communication medium 0 for email 1 for text
	,0
	,0
	,'1900-01-01 00:00:00.000'
	,0
	,3
	,'system'
	,@Date
	,''
	,0
	,@ID OUTPUT

EXEC core_sp_save_person_communication @ID, 24211,'1900-01-01 00:00:00.000','Queued',@GUID, 1