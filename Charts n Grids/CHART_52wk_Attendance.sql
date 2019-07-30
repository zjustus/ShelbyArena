USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_CHART_sp_52wkAttendance]    Script Date: 7/30/2019 10:04:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[cust_luminate_CHART_sp_52wkAttendance]
AS
DECLARE @today date = getdate();
DECLARE @current_year int = datepart(year, @today);
DECLARE @current_week int = datepart(week, @today);

SET DATEFIRST 1;

--current year
SELECT
	'current: AVG( '+CONVERT(varchar(10), AVG([head_count]))+')' as series_title,
	[date] as x_value,
	SUM([head_count]) as y_value
FROM
(SELECT top (53) -- this produces a 53 week attendance plot
	DATEPART(year, occurrence_start_time) as [year],
	--the folowing converts a week number into the first sunday of that week, potentially meaning the first year sunday is in last year
		DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time))), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)))) [date],
	SUM(head_count) as [head_count]
FROM dbo.core_occurrence as occurrence
LEFT JOIN dbo.core_occurrence_type as o_type on occurrence.occurrence_type = o_type.occurrence_type_id
where
	is_service = 1
	and
		(DATEPART(year, occurrence_start_time) = @current_year
		and DATEPART(week, occurrence_start_time) <= @current_week)
	or DATEPART(year, occurrence_start_time) < @current_year
group by
	DATEPART(year, occurrence_start_time),
	DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time))), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time))))
order by [year] desc, [date] desc) as tbl1
group by [date]


--last year
SELECT
	'last AVG('+CONVERT(varchar(10), AVG([head_count]))+')' as series_title,
	[date] as x_value,
	SUM([head_count]) as y_value

FROM
(SELECT top (53) -- this produces a 53 week attendance plot
	DATEPART(year, occurrence_start_time) as [year],
	--the folowing converts a week number into the first sunday of that week, potentially meaning the first year sunday is in last year
	DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1)), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1))) [date],
	SUM(head_count) as [head_count]
FROM dbo.core_occurrence as occurrence
LEFT JOIN dbo.core_occurrence_type as o_type on occurrence.occurrence_type = o_type.occurrence_type_id
where
	is_service = 1
	and
		(DATEPART(year, occurrence_start_time) = @current_year-1
		and DATEPART(week, occurrence_start_time) <= @current_week)
	or DATEPART(year, occurrence_start_time) < @current_year-1
group by
	DATEPART(year, occurrence_start_time),
	DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1)), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1)))
order by [year] desc, [date] desc) as tbl1
group by [date]

SET DATEFIRST 7;
