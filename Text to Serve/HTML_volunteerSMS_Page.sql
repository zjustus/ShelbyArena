USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_HTML_sp_VolunteerSMSPage]    Script Date: 7/30/2019 9:47:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[cust_luminate_HTML_sp_VolunteerSMSPage]
@OrganizationID INT

AS

BEGIN

--do the text
DECLARE @nextSunday date = DATEADD(day, 8-DATEPART(dw, GETDATE()), GETDATE())

--inserts all people into a list
DECLARE @smsList table
	(person_id int, position_id int, person_name varchar(100),
	service_name varchar(100), team_name varchar(100), position varchar(100), 
	serve_date datetime)
INSERT INTO @smsList
select
	person.person_id,
	position.team_position_id as 'psoition id',
	person.first_name + ' '+person.last_name as 'person',
	[service].[name] as 'service',
	team.name as 'team',
	tag.profile_name as 'position',
	[service].start_date
FROM dbo.volu_team_member as member
LEFT JOIN dbo.volu_team_position as position on member.team_position_id = position.team_position_id
LEFT JOIN dbo.volu_team as team on position.team_id = team.team_id
LEFT JOIN dbo.volu_service as service on team.service_id = service.service_id
LEFT JOIN dbo.core_profile as tag on position.profile_id = tag.profile_id
LEFT JOIN dbo.core_person as person on member.person_id = person.person_id
where CAST([service].start_date as date) = @nextSunday
and member.status = 1




DECLARE @person_key varchar(20)
SELECT @person_key = MIN(convert(varchar(10), person_id)+'~'+convert(varchar(10), position_id)) from @smsList

--the message loop
WHILE @person_key is not null
BEGIN
	
	--gets the person_id and position id seprate
	DECLARE @person_id int = (select top(1) person_id from @smsList where convert(varchar(10), person_id)+'~'+convert(varchar(10), position_id) = @person_key) 
	DECLARE @position_id int = (select top(1) position_id from @smsList where convert(varchar(10), person_id)+'~'+convert(varchar(10), position_id) = @person_key)

	--message variables
	DECLARE
		@person_name varchar(100) = (SELECT top(1) person_name from @smsList where person_id = @person_id and position_id = @position_id),
		@service_name varchar(100) = (SELECT top(1) service_name from @smsList where person_id = @person_id and position_id = @position_id), 
		@team_name varchar(100) = (SELECT top(1) team_name from @smsList where person_id = @person_id and position_id = @position_id), 
		@position varchar(100) = (SELECT top(1) position from @smsList where person_id = @person_id), 
		@serve_date varchar(20) = CONVERT(varchar(20), (SELECT top(1) serve_date from @smsList where person_id = @person_id and position_id = @position_id), 1), 
		@serve_time varchar(20) = CONVERT(varchar(20), (SELECT top(1) serve_date from @smsList where person_id = @person_id and position_id = @position_id), 8)
	
	DECLARE @textMessage varchar(MAX) = 
		@person_name+', you have been chosen to serve as a '+@position+' for the Luminate '+@team_name+' durring the '+@service_name+' service on '+@serve_date+' begining at '+@serve_time+'
		please reply yes or no to confirm availability.'

	DECLARE 
		@GUID uniqueidentifier = NEWID(),
		@date datetime = getdate(),
		@message_id int

	--makes the message
	EXEC dbo.core_sp_save_communication
	-1
	,'system',
	1
	,'Luminate Church' --sender
	,'1-626-684-4645' --email
	,'(909) 576-8850' --reply to
	,'' --cc
	,'' --bcc
	,'' --subject
	,'' --html message
	,@textMessage --text message
	,''
	,0
	,1 --communication medium 0 for email 1 for text
	,1 --show in history
	,0
	,'1900-01-01 00:00:00.000'
	,0
	,3
	,'system'
	,@Date
	,''
	,0
	,@message_id OUTPUT

	--adds the person
	EXEC core_sp_save_person_communication @message_id, @person_id,'1900-01-01 00:00:00.000','Queued',@GUID, 1

	--increments to the next person
	SELECT @person_key = MIN(convert(varchar(10), person_id)+'~'+convert(varchar(10), position_id)) from @smsList where convert(varchar(10), person_id)+'~'+convert(varchar(10), position_id) > @person_key
END

--say a thing
DECLARE @Results varchar(max) = 
'<div class="col">
	<p>texts have been sent out</p>
</div>'

SELECT @Results AS [html]

END