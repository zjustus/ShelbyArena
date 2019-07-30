--DECLARE @group_id int = 56
--DECLARE @group_id int = 58 --2017 fall
--DECLARE @group_id int = 59 --2018 spring
DECLARE @group_id int = 60 --2018 fall

--DECLARE @person_id int = 26559


DECLARE 
	@date datetime = getdate(),
	@date_inactive datetime = NULL,
	@created_by varchar(50) = 'system',
	@roll_luid int = 24,
	@uniform int = -1,
	@active int = 1,
	@org_id int = 1

--adds person into small group
--EXEC dbo.smgp_sp_save_member @group_id, @person_id, @created_by, @roll_luid, @uniform, @date, '', @active, @date_inactive, @org_id

--lists the small group and the members of

--SELECT group_id, group_name FROM dbo.smgp_group where group_id = @group_id
--SELECT * FROM dbo.smgp_member where group_id = @group_id


DECLARE 
	@occurrenceID int = 23326
	,@ID int

-- DECLARE @person_id int = 26559
-- DECLARE @person_id int = 28111
-- DECLARE @person_id int = 27884
-- DECLARE @person_id int = 26659
-- DECLARE @person_id int = 24844
-- DECLARE @person_id int = 17736
-- DECLARE @person_id int = 26996
-- DECLARE @person_id int = 2092
-- DECLARE @person_id int = 13110
-- DECLARE @person_id int = 27023
-- DECLARE @person_id int = 20211
-- DECLARE @person_id int = 14737
-- DECLARE @person_id int = 26209
-- DECLARE @person_id int = 25937
-- DECLARE @person_id int = 25694
-- DECLARE @person_id int = 26995
-- DECLARE @person_id int = 26937
-- DECLARE @person_id int = 26785
-- DECLARE @person_id int = 14426
-- DECLARE @person_id int = 25929
-- DECLARE @person_id int = 24397
-- DECLARE @person_id int = 26558
-- DECLARE @person_id int = 28150
-- DECLARE @person_id int = 20125
-- DECLARE @person_id int = 26365
-- DECLARE @person_id int = 26946
-- DECLARE @person_id int = 13694
-- DECLARE @person_id int = 13109
-- DECLARE @person_id int = 16620
-- DECLARE @person_id int = 26555
-- DECLARE @person_id int = 25358
-- DECLARE @person_id int = 26208
-- DECLARE @person_id int = 26856



--marks attendance to an occurence
--EXEC dbo.core_sp_save_occurrence_attendance -1, @occurrenceID, @person_id, 1, '', '1900-01-01 00:00:00.000', '1900-01-01 00:00:00.000', '','',NULL,1,1,@ID


--lists the occurrences for the given group
SELECT
	group_id
	,smgp.occurrence_id
	,occurrence_name 
FROM
	dbo.smgp_group_occurrence as smgp
LEFT JOIN dbo.core_occurrence on smgp.occurrence_id = core_occurrence.occurrence_id
where group_id = @group_id

SELECT * FROM dbo.core_occurrence_attendance where occurrence_id = @occurrenceID
