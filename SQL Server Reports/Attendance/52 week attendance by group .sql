DECLARE 
	@cols varchar(max),
	@query varchar(max)

SELECT @cols = STUFF((
	SELECT DISTINCT ',['+group_name +']'
	from dbo.core_occurrence_type as [type]
	left join dbo.core_occurrence_type_group as [group] on [type].group_id = [group].group_id
	where is_service = 1
	FOR XML PATH(''), TYPE).value('.', 'varchar(max)'),1,1,'')

SELECT @query =
'SELECT [year], [week], '+@cols+'from(
	select
		[group].group_name,
		datepart(year, occurrence.occurrence_start_time) as [year],
		datepart(week, occurrence.occurrence_start_time) as [week],
		head_count
	from dbo.core_occurrence as occurrence
	left join dbo.core_occurrence_type as [type] on occurrence.occurrence_type = [type].occurrence_type_id
	left join dbo.core_occurrence_type_group as [group] on [type].group_id = [group].group_id
	where datediff(week, occurrence.occurrence_start_time, getdate()) between 0 and 53
	and is_service = 1
	) as x
PIVOT(
	SUM(head_count)
	FOR group_name in ('+@cols+')) as p
ORDER BY [year] desc, [week] desc'

EXECUTE(@query)