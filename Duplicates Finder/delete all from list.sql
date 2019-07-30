--select * from dbo.core_profile_member
--where profile_id = 951

--exec dbo.core_sp_save_profile_member @pid, @personID, @userIDstring, @sourceID, @statusID, @nodesstring, @datePending, @dareReview, @dateActive, @dateDormant, @ordID


DECLARE @whiteList int = 1113 -- a list ID of thoes that have been determinied to not be duplicates
DECLARE @yelowList int = 1114 -- a list ID for thoes that could not be determinied
DECLARE @dupeList int = 1115 -- a list of ID of thoes that are duplicates

delete from dbo.core_profile_member where profile_id in (@whiteList, @yelowList, @dupeList)