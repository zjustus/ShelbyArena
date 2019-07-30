USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_CHART_sp_threeYearGivers]    Script Date: 7/30/2019 10:09:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[cust_luminate_CHART_sp_threeYearGivers]
as
DECLARE @today date = getdate()
--current year
select distinct
	CONVERT(varchar(4), DATEPART(YEAR, @today)) as series_title,
	CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)) as x_value,
	COUNT(person_id) as y_value
from dbo.ctrb_contribution
where DATEPART(YEAR, contribution_date) = DATEPART(YEAR, @today)
group by CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))
--last year
select distinct
	CONVERT(varchar(4), DATEPART(YEAR, @today)-1) as series_title,
	CONVERT(date, DATEADD(YEAR, 1, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))) as x_value,
	COUNT(person_id) as y_value
from dbo.ctrb_contribution
where DATEPART(YEAR, contribution_date) = DATEPART(YEAR, @today)-1
group by CONVERT(date, DATEADD(YEAR, 1, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)))
--2 years ago
select distinct
	CONVERT(varchar(4), DATEPART(YEAR, @today)-2) as series_title,
	CONVERT(date, DATEADD(YEAR, 2, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))) as x_value,
	COUNT(person_id) as y_value
from dbo.ctrb_contribution
where DATEPART(YEAR, contribution_date) = DATEPART(YEAR, @today)-2
group by CONVERT(date, DATEADD(YEAR, 2, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)))
