USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_CHART_sp_52weekAttendacneVsGiving]    Script Date: 7/30/2019 10:03:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[cust_luminate_CHART_sp_52weekAttendacneVsGiving]
as
DECLARE @today date = getdate();
DECLARE @current_year int = datepart(year, @today);
DECLARE @current_week int = datepart(week, @today);

--current year
SELECT
	'Atendance' as series_title,
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

SELECT
	'Contributers' as series_title,
	DATEADD(week, datepart(week, contribution_date)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, contribution_date))), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, contribution_date)))) as x_value,
	COUNT(person_id) as y_value
FROM dbo.ctrb_contribution
where DATEPART(YEAR, contribution_date) = @current_year or (DATEPART(YEAR, contribution_date) = @current_year-1 and DATEPARt(WEEK, contribution_date) >= @current_week )
group by DATEADD(week, datepart(week, contribution_date)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, contribution_date))), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, contribution_date))))
order by x_value
