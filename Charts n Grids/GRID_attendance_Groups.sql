USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_GRID_sp_attendanceGroups]    Script Date: 7/30/2019 10:11:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[cust_luminate_GRID_sp_attendanceGroups] as
BEGIN

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
'SELECT [date], '+@cols+'from(
	select
		[group].group_name,
		DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+''/01/1''))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+''/01/1'')) as [date],
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
ORDER BY [date] desc'

EXECUTE(@query)
END;
