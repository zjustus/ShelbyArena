USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_CHART_sp_allCampus3yearAttendance]    Script Date: 7/30/2019 10:06:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[cust_luminate_CHART_sp_allCampus3yearAttendance]
AS

DECLARE @today date = getdate();
SET DATEFIRST 1;

--this year
SELECT
	''+CONVERT(varchar(4), DATEPART(YEAR, @today))+'' as series_title,
	DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time))), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)))) as [x_value],
	SUM([occurrence].head_count) as [y_value]
FROM dbo.core_occurrence_type as [type]
LEFT JOIN DBO.core_occurrence as [occurrence] on [type].occurrence_type_id = [occurrence].occurrence_type
where
	is_service = 1
	and DATEPART(YEAR, [occurrence].occurrence_start_time) = DATEPART(YEAR, @today)
GROUP BY DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time))), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time))));

--last year
SELECT
	''+CONVERT(varchar(4), DATEPART(YEAR, @today)-1)+'' as series_title,
	DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1)), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1))) as [x_value],
	SUM([occurrence].head_count) [y_value]
FROM dbo.core_occurrence_type as [type]
LEFT JOIN DBO.core_occurrence as [occurrence] on [type].occurrence_type_id = [occurrence].occurrence_type
where
	is_service = 1
	and DATEPART(YEAR, [occurrence].occurrence_start_time) = DATEPART(YEAR, @today)-1
GROUP BY DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1)), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+1)));

--2 years age
SELECT
	''+CONVERT(varchar(4), DATEPART(YEAR, @today)-2)+'' as series_title,
	DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+2)), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+2))) as [x_value],
	SUM([occurrence].head_count) [y_value]
FROM dbo.core_occurrence_type as [type]
LEFT JOIN DBO.core_occurrence as [occurrence] on [type].occurrence_type_id = [occurrence].occurrence_type
where
	is_service = 1
	and DATEPART(YEAR, [occurrence].occurrence_start_time) = DATEPART(YEAR, @today)-2
GROUP BY DATEADD(week, datepart(week, occurrence_start_time)-1, DATEADD(day, 7-datepart(dw, '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+2)), '1/1/'+CONVERT(varchar(4), DATEPART(YEAR, occurrence_start_time)+2)));

SET DATEFIRST 7;
