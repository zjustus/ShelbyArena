USE [ArenaDB]
GO
/****** Object:  StoredProcedure [dbo].[luminate_CHART_sp_newGivers]    Script Date: 7/30/2019 10:08:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[cust_luminate_CHART_sp_newGivers]
as
DECLARE @today date = getdate()

--selects toal givers
select
	'Total Givers' as series_title,
	CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date)) as x_value,
	COUNT(person_id) as y_value
FROM dbo.ctrb_contribution
where(datepart(year, contribution_date) = datepart(year, @today) OR ((datepart(year, contribution_date) = datepart(year, @today)-1) AND (datepart(MONTH, contribution_date) > datepart(MONTH, @today))))
GROUP BY CONVERT(date, DATEADD(day, -datepart(day, contribution_date)+1, contribution_date))
order by x_value desc

--select new givers
select
	'New Givers' as series_title,
	CONVERT(date, DATEADD(day, -datepart(day, firstGift.firstGift)+1, firstGift.firstGift)) as x_value,
	COUNT(CONVERT(date, DATEADD(day, -datepart(day, firstGift.firstGift)+1, firstGift.firstGift))) as y_value
from
	(select person_id
	from dbo.ctrb_contribution
	where(datepart(year, contribution_date) = datepart(year, @today) OR ((datepart(year, contribution_date) = datepart(year, @today)-1) AND (datepart(MONTH, contribution_date) > datepart(MONTH, @today))))
	) as people
left join
	(select
		person_id,
		min(contribution_date) as firstGift
	from dbo.ctrb_contribution
	group by person_id
	) as firstGift on people.person_id = firstGift.person_id
where
	(datepart(year, firstGift.firstGift) = datepart(year, @today) OR ((datepart(year, firstGift.firstGift) = datepart(year, @today)-1) AND (datepart(MONTH, firstGift.firstGift) > datepart(MONTH, @today))))
group by CONVERT(date, DATEADD(day, -datepart(day, firstGift.firstGift)+1, firstGift.firstGift))
order by x_value desc
