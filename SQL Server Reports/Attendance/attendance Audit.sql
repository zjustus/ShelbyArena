/** this deletes duplicates **/
--delete from dbo.core_occurrence where occurrence_id in (28001)

/** this changes a bad record**/
--update dbo.core_occurrence set head_count = 18 where occurrence_id = 27589

/** this deletes all entries for a given year and given type **/
--delete from dbo.core_occurrence where occurrence_type = 139 and DATEPART(YEAR, occurrence_start_time) = 2017

/** this produces a total count of a given type for a given year **/
--SELECT SUM(head_count) from dbo.core_occurrence where year(occurrence_start_time) = 2017 and occurrence_type in (180); 

/** this lists the groups **/
--select * from dbo.core_occurrence_type_group

/** this lists the types in a group **/
--select * from dbo.core_occurrence_type where group_id = 21

/** this lists all the types by group **/
/*
select
 [type].occurrence_type_id,
 [group].group_name,
 [group].group_id,
 [type].type_name
from dbo.core_occurrence_type as [type]
left join dbo.core_occurrence_type_group as [group] on [type].group_id = [group].group_id
where [type].type_name like '%A%'
and [group].group_name like '%%'
order by group_name
*/

/** this lists occurrences of a given type for a given year **/
/*
select
	occurrence_id,
	convert(date, occurrence_start_time),
	head_count
from dbo.core_occurrence 
where occurrence_type = 194
and YEAR(occurrence_start_time) = 2017
order by convert(date, occurrence_start_time);
*/