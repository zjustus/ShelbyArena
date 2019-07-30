USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_GRID_sp_MonthlyGiverAmmount]    Script Date: 7/30/2019 10:11:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[cust_luminate_GRID_sp_MonthlyGiverAmmount]
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
	tbla.month,
	tbla.[top Givers],
	tblB.[other givers],
	tblC.[all givers]
 from
(select
	CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)) as month,
	sum(currency_amount) as 'top Givers'
FROM dbo.ctrb_contribution
where person_id in (select personID from @topList)
	and (datepart(year, contribution_date) = datepart(year, @today) OR ((datepart(year, contribution_date) = datepart(year, @today)-1) AND (datepart(MONTH, contribution_date) > datepart(MONTH, @today))))
group by CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))) as tbla
LEFT JOIN
(select
	CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)) as month,
	sum(currency_amount) as 'other givers'
FROM dbo.ctrb_contribution
where person_id not in (select personID from @topList)
	and (datepart(year, contribution_date) = datepart(year, @today) OR ((datepart(year, contribution_date) = datepart(year, @today)-1) AND (datepart(MONTH, contribution_date) > datepart(MONTH, @today))))
group by CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))) as tblB on tbla.month = tblB.month
left join
(select
	CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)) as month,
	sum(currency_amount) as 'all givers'
FROM dbo.ctrb_contribution
WHERE (datepart(year, contribution_date) = datepart(year, @today) OR ((datepart(year, contribution_date) = datepart(year, @today)-1) AND (datepart(MONTH, contribution_date) > datepart(MONTH, @today))))
group by CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))) as tblC on tbla.month = tblC.month
order by tbla.month desc

--select top 50 * from dbo.ctrb_contribution
