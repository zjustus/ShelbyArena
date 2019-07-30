/** scripts for follow up system **/

--stp 1, enable sms on that persons record
--stp 2, 1. Email & Text - 1st sunday - 1102
--stp 3, move to next tag
--stp 4, 2. email - 1st Wednesday - 1103
--stp 5, move to next tag
--stp 6, 3. email - 1st Friday - 1104
--stp 7, move to next tag
--stp 8, 4. text - 1st Saturday - 1105
--stp 9, move to next tag
--stp 10, 5. call - 2nd Wednesday - 1106
--stp 11, 6. text - 2nd Friday - 1107
--stp 12 move to next tag
--stp 13, 7. email - 2nd Saturday - 1108
--stp 14 move to next tag
--stp 15 8. email - 3rd Friday -1109
--stp 16 clear final tag

--SUNDAY IS FIRST DAY OF WEEK

--list the people in a tag
--select person_id from dbo.core_profile_member where profile_id = 1102

--increments the tag
/*
update dbo.core_profile_member
SET profile_id = 1103
where profile_id = 1102
*/

--update numbers in tag to make them sms enabled
/*
DECLARE @person_id int
SELECT @person_id =  min(person_id) from dbo.core_profile_member where profile_id = 1102

while @person_id is not null
begin
	update dbo.core_person_phone
	set sms_enabled = 1
	where person_id = @person_id
	SELECT @person_id =  min(person_id) from dbo.core_profile_member where profile_id = 1102 and person_id > @person_id
end
*/


--sends a communicaiton to a given tag
/*
EXEC dbo.luminate_COMMUNICATION_sp_sendCommunicationFromTag 
	1102, --tag id 
	120, --template
	0 --communication medium | 0 for email | 1 for sms
*/

--time testing
/*
declare @today datetime = getdate()
print datepart(weekday, @today)
PRINT DATEPART(HOUR, @today)
*/

--adds members of a tag to calling campaign
/*
DECLARE @family_id int
select @family_id = min(family_id)
from dbo.core_profile_member as tag
left join dbo.core_family_member as fam on tag.person_id = fam.person_id
where tag.profile_id = 1102

while @family_id is not null
begin
	DECLARE @cpgn_family_id int
	exec dbo.cpgn_sp_save_campaignFamily -1, 3, @family_id, -1, '1900-1-1', 1, @cpgn_family_id OUTPUT, 1
	--
	select @family_id = min(family_id)
	from dbo.core_profile_member as tag
	left join dbo.core_family_member as fam on tag.person_id = fam.person_id
	where tag.profile_id = 1102 and family_id > @family_id
end
*/

--deletes members from a tag
--delete from dbo.core_profile_member where profile_id = 1109