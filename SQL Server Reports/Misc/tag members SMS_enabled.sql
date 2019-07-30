
DECLARE @event_id int = 1086
/*
SELECT
	reg.person_id,
	phone.phone_number,
	phone.sms_enabled
FROM dbo.evnt_registrant as reg
LEFT JOIN dbo.core_person_phone as phone on reg.person_id = phone.person_id
where profile_id = @event_id
*/

/** This updates phone numbers of a given event tag to enable SMS to true **/
UPDATE dbo.core_person_phone
SET sms_enabled = 1
where person_id IN 
	(SELECT person_id from dbo.evnt_registrant where profile_id = @event_id)
AND phone_number IS NOT NULL
