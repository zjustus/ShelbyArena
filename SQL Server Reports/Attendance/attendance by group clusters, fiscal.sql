DECLARE @date date = '12/31/2018'

/** English **/
SELECT 
	'Luminate Covina (English)' as church,
	current_year,
	last_year,
	current_year - last_year as "difference"
FROM
(SELECT
	AVG(head_count) as 'current_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (21, 30) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)+1)+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblA
LEFT JOIN
(SELECT
	AVG(head_count) as 'last_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (21, 30) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-2)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblB on tblA.link = tblB.link

/** Spanish **/
UNION
SELECT 
	'Luminate Covina (Spanish)' as church,
	current_year,
	last_year,
	current_year - last_year as "difference"
FROM
(SELECT
	AVG(head_count) as 'current_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (22, 31) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)+1)+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblA
LEFT JOIN
(SELECT
	AVG(head_count) as 'last_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (22, 31) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-2)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblB on tblA.link = tblB.link

/** Chino Indonesian **/
UNION
SELECT 
	'Power of the Faithfull Church' as church,
	current_year,
	last_year,
	current_year - last_year as "difference"
FROM
(SELECT
	AVG(head_count) as 'current_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (25) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)+1)+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblA
LEFT JOIN
(SELECT
	AVG(head_count) as 'last_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (25) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-2)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblB on tblA.link = tblB.link

/** Covina Indonesian **/
UNION
SELECT 
	'House Of Glory Covina' as church,
	current_year,
	last_year,
	current_year - last_year as "difference"
FROM
(SELECT
	AVG(head_count) as 'current_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (23) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)+1)+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblA
LEFT JOIN
(SELECT
	AVG(head_count) as 'last_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (23) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-2)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblB on tblA.link = tblB.link

/** Norwalk Indonesian **/
UNION
SELECT 
	'House of Glory Norwalk' as church,
	current_year,
	last_year,
	current_year - last_year as "difference"
FROM
(SELECT
	AVG(head_count) as 'current_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (24) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)+1)+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblA
LEFT JOIN
(SELECT
	AVG(head_count) as 'last_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (24) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-2)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblB on tblA.link = tblB.link

/** Pamona Indonesian **/
UNION
SELECT 
	'Intl Living Stone Pomona' as church,
	current_year,
	last_year,
	current_year - last_year as "difference"
FROM
(SELECT
	AVG(head_count) as 'current_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (26) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)+1)+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblA
LEFT JOIN
(SELECT
	AVG(head_count) as 'last_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (26) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-2)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblB on tblA.link = tblB.link

/** Total **/
UNION
SELECT 
	'Total' as church,
	current_year,
	last_year,
	current_year - last_year as "difference"
FROM
(SELECT
	AVG(head_count) as 'current_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (21,30,22,31,25,23,24,26) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time >= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01')
	and
	occurrence_start_time <= CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)+1)+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblA
LEFT JOIN
(SELECT
	AVG(head_count) as 'last_year',
	'total' as link
FROM
(SELECT
	DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1')) [date],
	SUM(head_count) as head_count
FROM dbo.core_occurrence as [occurrence]
LEFT JOIN dbo.core_occurrence_type as [type] on [occurrence].occurrence_type = [type].occurrence_type_id
WHERE group_id in (21,30,22,31,25,23,24,26) --occurrence group here!
and is_service = 1
and  
	((
	DATEPART(MONTH, @date) <= 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-2)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01'))
	OR(
	DATEPART(MONTH, @date) > 6 and
	occurrence_start_time > CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date)-1)+'-07-01')
	and
	occurrence_start_time < CONVERT(date, CONVERT(varchar(4), DATEPART(year, @date))+'-07-01'))
	)
GROUP BY DATEADD(week, DATEPART(week, occurrence_start_time)-1, DATEADD(day, -(DATEPART(dw, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))+1, CONVERT(varchar(4), DATEPART(year, occurrence_start_time))+'/01/1'))
) as tbl1) as tblB on tblA.link = tblB.link