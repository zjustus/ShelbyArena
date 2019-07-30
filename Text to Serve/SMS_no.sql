USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_sms_sp_no]    Script Date: 7/30/2019 9:50:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[cust_luminate_sms_sp_no]
(
	@FromNumber VARCHAR(20)
	, @PossiblyFrom VARCHAR(200)
	, @ToNumber VARCHAR(20)
	, @ToNumberID INT
	, @Message VARCHAR(2000)
	, @OutStatus INT = 0 OUTPUT
	, @OutMessage VARCHAR(2000) = '' OUTPUT
)
AS
SET @FromNumber = dbo.fn_StripPhone(@FromNumber)
DECLARE @LogicTest INT
SELECT @LogicTest = 
(
/** Logic test to check if the phone number exists in the database **/
SELECT TOP 1 ph.person_id 
FROM
	core_person_phone ph
	JOIN core_person p ON ph.person_id = p.person_id
	JOIN core_family_member f ON p.person_id = f.person_id
WHERE
	ph.phone_number_stripped = RIGHT(@FromNumber,10)
	OR ph.phone_number_stripped + phone_ext = RIGHT(@FromNumber,10)
ORDER BY
	CASE WHEN ph.phone_luid = 282 THEN -1 ELSE ph.phone_luid END
	, f.role_luid
	, p.birth_date
	, p.gender
)

--If person exists
IF @LogicTest <> '' OR @LogicTest IS NOT NULL
BEGIN

--Mark this number as SMS Enable
	UPDATE core_person_phone
	SET sms_enabled = 1
	WHERE
		phone_number_stripped = RIGHT(@FromNumber,10)
		OR phone_number_stripped + phone_ext = RIGHT(@FromNumber,10)
	
-- if they are schedjuled to serve
DECLARE @nextSunday date = DATEADD(day, 8-DATEPART(dw, GETDATE()), GETDATE())
IF @LogicTest IN
	(select person.person_id
	FROM dbo.volu_team_member as member
	LEFT JOIN dbo.volu_team_position as position on member.team_position_id = position.team_position_id
	LEFT JOIN dbo.volu_team as team on position.team_id = team.team_id
	LEFT JOIN dbo.volu_service as service on team.service_id = service.service_id
	LEFT JOIN dbo.core_profile as tag on position.profile_id = tag.profile_id
	LEFT JOIN dbo.core_person as person on member.person_id = person.person_id
	where CAST([service].start_date as date) = @nextSunday)
BEGIN
	--creates the variable list
	DECLARE @smsList table
		(person_id int, team_member_id int,
		service_id int, team_id int, 
		serve_date datetime)
	INSERT INTO @smsList
	select
		member.person_id,
		member.team_member_id,
		[service].service_id as 'service',
		team.team_id as 'team',
		[service].start_date
	FROM dbo.volu_team_member as member
	LEFT JOIN dbo.volu_team_position as position on member.team_position_id = position.team_position_id
	LEFT JOIN dbo.volu_team as team on position.team_id = team.team_id
	LEFT JOIN dbo.volu_service as service on team.service_id = service.service_id
	where CAST([service].start_date as date) = @nextSunday and member.person_id = @LogicTest

	--mark the record as cannot serve
	UPDATE dbo.volu_team_member
	SET status = 3
	where team_member_id in (SELECT team_member_id from @smsList)
	SELECT @OutMessage = 'Thank you for canceling'
	
	declare @person_name varchar(50) = (select first_name+', '+last_name from dbo.core_person where person_id = @LogicTest)

		--gets the owner id and the volunteer position
	declare @owner_list table(owner_id int, position_id int, service_name varchar(50), team_name varchar(50), position_name varchar(50))

	INSERT INTO @owner_list SELECT
		owner.owner_id as 'owner_id',
		position.profile_id as 'position_id',
		service.name as 'service',
		team.name as 'team name',
		tag.profile_name as 'position'
	FROM dbo.volu_team_owner as owner
	LEFT JOIN dbo.volu_team as team on owner.team_id = team.team_id
	LEFT JOIN dbo.volu_team_position as position on team.team_id = position.team_id
	LEFT JOIN dbo.core_profile as tag on position.profile_id = tag.profile_id
	LEFT JOIN dbo.volu_service as service on team.service_id = service.service_id
	LEFT JOIN dbo.volu_team_member as member on position.team_position_id = member.team_position_id
	where CAST([service].start_date as date) = @nextSunday
		AND member.person_id = @LogicTest

	
	--loop needs to start here
	DECLARE @owner_key varchar(20) = (select MIN(convert(varchar(10), owner_id)+'~'+convert(varchar(10), position_id)) from @owner_list)
	WHILE @owner_key is not null
	BEGIN

	--gets the owner id and position id seprate
	DECLARE @owner_id int = (select top(1) owner_id from @owner_list where convert(varchar(10), owner_id)+'~'+convert(varchar(10), position_id) = @owner_key)
	DECLARE @position_id int = (select top(1) position_id from @owner_list where convert(varchar(10), owner_id)+'~'+convert(varchar(10), position_id) = @owner_key)

	--grabs information about the position
	DECLARE 
		@service varchar(50) = (select top 1 service_name from @owner_list where owner_id = @owner_id and position_id = @position_id),
		@team varchar(50) = (select top 1 team_name from @owner_list where owner_id = @owner_id and position_id = @position_id),
		@position varchar(50) = (select top 1 position_name from @owner_list where owner_id = @owner_id and position_id = @position_id)
		--send email to volunteer cordinators -28439

	DECLARE @Date datetime = getdate()
	Declare @email_id int
	DECLARE @GUID uniqueidentifier = NEWID()
	DECLARE @htmlMessage varchar(MAX) = 
		@person_name+' Cannot Volunteer for the volunteer role of '+@position+' on the '+@team+' for the '+@service+' service'
	DECLARE @textMessage varchar(MAX) =
		@person_name+' Cannot Volunteer for the volunteer role of '+@position+' on the '+@team+' for the '+@service+' service'

	EXEC dbo.core_sp_save_communication
		-1
		,'system',
		1
		,'system'
		,'arena@luminate.church' --email
		,'more@luminate.church' --reply to
		,'' --cc
		,'' --bcc
		,'Volunteer confermation' --subject
		,@htmlMessage --html message
		,@textMessage --text message
		,''
		,0
		,0 --communication medium 0 for email 1 for text
		,1 --show in history
		,0
		,'1900-01-01 00:00:00.000'
		,0
		,3
		,'system'
		,@Date
		,''
		,0
		,@email_id OUTPUT

	EXEC core_sp_save_person_communication @email_id, @owner_id,'1900-01-01 00:00:00.000','Queued',@GUID, 1

	--increments the loop
		SELECT @owner_key = MIN(convert(varchar(10), owner_id)+'~'+convert(varchar(10), position_id)) from @owner_list where convert(varchar(10), owner_id)+'~'+convert(varchar(10), position_id) > @owner_key

END --ends the email loop
END --ends the if schedjuled to serve
ELSE BEGIN
SELECT @OutMessage = 'you are not set to cancle anything'
END 
END --ends the if person exists
ELSE BEGIN
	SELECT @OutMessage = 'Your phone number is not found in our system, if you believe this to be an error, please alert a staff member.'
END

SET @OutStatus = 1