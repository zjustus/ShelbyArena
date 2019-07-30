Select
	[ArenaDB].[dbo].core_occurrence_type.group_id as "groupID"
	,occurrence_type_id
	,group_name
	,type_name
from [ArenaDB].[dbo].core_occurrence_type
LEFT JOIN [ArenaDB].[dbo].core_occurrence_type_group ON [ArenaDB].[dbo].core_occurrence_type.group_id = [ArenaDB].[dbo].core_occurrence_type_group.group_id
order by groupID ASC