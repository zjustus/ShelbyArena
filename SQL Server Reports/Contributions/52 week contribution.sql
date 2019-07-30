DECLARE @tithe_funds table(fund_id int)

/*
	366 - english
	367 - english non
	139 - spanish
	396 - unstoppablE
	397 - unstopabPle -non
	198 - house of glory - covina
	197 - HGN - Norwalk
	232 - living stone
	308 - PWF
	348 - SNL
	176 - french
*/

INSERT INTO @tithe_funds
values (366),(367),(139),(396),(397),(198),(197),(232),(308),(348),(176)

select
	DATEADD(week, DATEPART(week, contribution_date)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, contribution_date))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, contribution_date))+'/01/1')) as [date],
	SUM(currency_amount) as weekly_tithe
	
from dbo.ctrb_contribution as ctrb
left join dbo.ctrb_contribution_fund as ctrb_fund on ctrb.contribution_id = ctrb_fund.contribution_id
where 
	fund_id in (SELECT fund_id from @tithe_funds)
	and DATEDIFF(week, contribution_date, getdate()) <= 52
group by DATEADD(week, DATEPART(week, contribution_date)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, contribution_date))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, contribution_date))+'/01/1'))
order by [date] desc


/** search for a fund **/
--select * from dbo.ctrb_fund where fund_name like '%FRENCH%';