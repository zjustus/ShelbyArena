create function dbo.luminate_funct_get_duplicate_list
(@whiteList int,
@yelowList int)
RETURNS TABLE
as
RETURN(
select distinct
	p1.person_id as person_id,
	lower(p1.first_name) as first_name,
	lower(p1.last_name) as last_name
from dbo.core_person as p1
left join dbo.core_person as p2 on p1.first_name = p2.first_name and p1.last_name = p2.last_name and p1.person_id != p2.person_id
where
p2.person_id is not null
--ignore the people on the white or yello list
and p1.person_id not in (select person_id from dbo.core_profile_member where profile_id in (@whiteList, @yelowList))
)