SELECT distinct
	FORMAT(a.occurrence_start_time, 'MM/dd/yy', 'en-US') as "Date"
	,DATEPART(week, a.occurrence_start_time) as "Week"
	,a.head_count AS "9am"
	,b.head_count AS "11am"
	,a.head_count+b.head_count AS "Total"
FROM
	ArenaDB.dbo.core_occurrence as a
	,ArenaDB.dbo.core_occurrence as b
WHERE
	a.occurrence_start_time=b.occurrence_start_time
	AND a.occurrence_type = 133
	AND b.occurrence_type = 134
	AND Datepart(year, a.occurrence_start_time) = 2018
ORDER BY "Date"