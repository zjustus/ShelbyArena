/** this inserts from a temp table to occurrences**/
INSERT INTO dbo.core_occurrence(
	[date_created], 
	[date_modified], 
	[created_by], 
	[modified_by], 
	[occurrence_type],
	[occurrence_name], 
	[occurrence_description],
	[occurrence_start_time],
	[occurrence_end_time],
	[check_in_start],
	[check_in_end],
	[location],
	[location_id],
	[location_address_id],
	[area_id],
	[membership_required],
	[occurrence_closed],
	[occurrence_type_template_id],
	[head_count],
	[organization_id])
SELECT
	getdate(), --date created
	getdate(), --date modified
	'Admin', --created by
	'Admin', --modified by
	temp.[type], --occurrence type
	'Attendance', --occurrence name
	'Imported attendance', --occurrence description
	temp.[Date], --occurrence start time
	temp.[Date], --occurrence end time
	'1900-01-01', --check in start time
	'1900-01-01', --check in end time
	'Kids', --location
	NULL, --location id
	NULL, --location address id
	NULL, --area ID
	0, --membership required
	1, --occurrence closed
	-1, --occurrence type template id
	temp.[count], --head count
	1 --org id
FROM dbo.luminate_TEMP_occurrence as temp

/** this drops the temp table **/
--drop table dbo.luminate_TEMP_occurrence