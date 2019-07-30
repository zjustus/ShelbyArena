USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_CHART_sp_topXgiversCompair]    Script Date: 7/30/2019 10:10:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[cust_luminate_CHART_sp_topXgiversCompair]
@numOfTop int, @OrganizationID int
AS
DECLARE @today datetime = getdate()

DECLARE @topList table(personID int) --a list person ids of the top 50 givers the current month

insert into @topList
select top (@numOfTop)
	person_id
from dbo.ctrb_contribution
where
	datepart(month, contribution_date) = DATEPART(month, @today)
	and datepart(year, contribution_date) = datepart(year, @today)
group by person_id
order by sum(currency_amount) desc


select
	'with 50 givers' as series_title,
	CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)) as x_value,
	sum(currency_amount) as y_value
FROM dbo.ctrb_contribution
where(datepart(year, contribution_date) = datepart(year, @today) OR ((datepart(year, contribution_date) = datepart(year, @today)-1) AND (datepart(MONTH, contribution_date) > datepart(MONTH, @today))))
group by CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))
order by x_value

select
	'with out 50 givers' as series_title,
	CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)) as x_value,
	sum(currency_amount) as y_value
FROM dbo.ctrb_contribution
where person_id not in (select personID from @topList)
	and (datepart(year, contribution_date) = datepart(year, @today) OR ((datepart(year, contribution_date) = datepart(year, @today)-1) AND (datepart(MONTH, contribution_date) > datepart(MONTH, @today))))
group by CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))
order by x_value

--select top 50 * from dbo.ctrb_contribution
