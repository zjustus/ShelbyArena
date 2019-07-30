/*** Developed By Zachary Justus ***/
/** variable decloration **/

--a test output
DECLARE @tempA table(ida int, idb int, reason varchar(100))

--tollerance level
DECLARE @minGrade float = 0.4 -- 40% match

--catagory weights
DECLARE @w_suffix int = 7
DECLARE @w_birthday int = 10
DECLARE @w_address int = 3
DECLARE @w_phone int = 3
DECLARE @w_email int = 3

--lists information
DECLARE @ordID int = 1
DECLARE @statusID int = 255 --the connected status for a tag
DECLARE @sourceID int = 272 --the connected source for the tag

DECLARE @whiteList int = 1113 -- a list ID of thoes that have been determinied to not be duplicates
DECLARE @yelowList int = 1114 -- a list ID for thoes that could not be determinied
DECLARE @dupeList int = 1115 -- a list of ID of thoes that are duplicates

--the admin name
DECLARE @userID varchar(50) = 'SYSTEM'

--person ints 
DECLARE @p1_id int
DECLARE @p1_first_name varchar(255)
DECLARE @p1_last_name varchar(255)
DECLARE @p1_suffix int
DECLARE @p1_birthday datetime
DECLARE @p1_address varchar(255)
DECLARE @p1_phone table(phone varchar(20))
DECLARE @p1_email table(email varchar(255))
DECLARE @p2_id int
DECLARE @p2_first_name varchar(255)
DECLARE @p2_last_name varchar(255)
DECLARE @p2_suffix int
DECLARE @p2_birthday datetime
DECLARE @p2_address varchar(255)
DECLARE @p2_phone table(phone varchar(20))
DECLARE @p2_email table(email varchar(255))

--score
DECLARE @s_suffix int = 0
DECLARE @s_birthday int = 0
DECLARE @s_address int = 0
DECLARE @s_phone int = 0
DECLARE @s_email int = 0
DECLARE @s_total float = 0

--points posible
DECLARE @pp_suffix int = 0
DECLARE @pp_birthday int = 0
DECLARE @pp_address int = 0
DECLARE @pp_phone int = 0
DECLARE @pp_email int = 0
DECLARE @pp_total float = 0

DECLARE @date datetime = getdate();

/** NOTE: merge members **/
--dbo.core_sp_merge_persons

/** begins the search for duplicates **/
--posibly need to change the while loops / functions for cursors .... not sure though
SET @p1_id = (select MIN(person_id) from dbo.luminate_funct_get_duplicate_list(@whiteList, @yelowList))
WHILE @p1_id is not null
BEGIN
	/** sets p1 variables **/
	SET @p1_first_name = (select first_name from dbo.luminate_funct_get_duplicate_list(@whiteList, @yelowList) where person_id = @p1_id)
	SET @p1_last_name = (select last_name from dbo.luminate_funct_get_duplicate_list(@whiteList, @yelowList) where person_id = @p1_id)
	SET @p1_suffix = (select suffix_luid from dbo.core_person where person_id = @p1_id)
	SET @p1_birthday = (select birth_date from dbo.core_person where person_id = @p1_id)
	SET @p1_address = (
		select lower(street_address_1 + ' '+city+' '+state) as address
		from dbo.core_person_address as p_address
		left join dbo.core_address as a_address on p_address.address_id = a_address.address_id
		where person_id = @p1_id and primary_address = 1
	)
	insert into @p1_phone select phone_number_stripped from dbo.core_person_phone where person_id = @p1_id and phone_number != ''
	insert into @p1_email select email from dbo.core_person_email where person_id = @p1_id

	/** begin duplicate matching **/
	SET @p2_id = (
	SELECT MIN(person_id) 
	FROM dbo.luminate_funct_get_duplicate_list(@whiteList, @yelowList) 
	WHERE person_id != @p1_id and first_name = @p1_first_name and last_name = @p1_last_name)
	WHILE @p2_id is not null
	BEGIN
		/** set p2 variables -- name not required as it is already matched **/
		SET @p2_suffix = (select suffix_luid from dbo.core_person where person_id = @p2_id)
		SET @p2_birthday = (select birth_date from dbo.core_person where person_id = @p2_id)
		SET @p2_address = (
			select lower(street_address_1 + ' '+city+' '+state) as address
			from dbo.core_person_address as p_address
			left join dbo.core_address as a_address on p_address.address_id = a_address.address_id
			where person_id = @p2_id and primary_address = 1
		)
		insert into @p2_phone select phone_number_stripped from dbo.core_person_phone where person_id = @p2_id and phone_number != ''
		insert into @p2_email select email from dbo.core_person_email where person_id = @p2_id

		/** The Matching Algorithm! **/

		/** step 1. assign posible points and score **/
		IF @p1_suffix is not null or @p2_suffix is not null 
		BEGIN --suffix
			set @pp_suffix = @w_suffix
			IF @p1_suffix = @p2_suffix set @s_suffix = @w_suffix
		END
		IF @p1_birthday != '1-1-1900' or @p2_birthday != '1-1-1900'
		BEGIN --birthday
			set @pp_birthday = @w_birthday
			IF @p1_birthday = @p2_birthday set @s_birthday = @s_birthday
		END
		IF @p1_address is not null and @p2_address is not null 
		BEGIN --address
			set @pp_address = @w_address
			IF @p1_address = @p2_address set @s_address = @w_address
		END
		IF (select top 1 phone from @p1_phone) is not null and (select top 1 phone from @p2_phone) is not null 
		BEGIN --phone
			set @pp_phone = @w_phone
			IF(select top(1) b.phone from @p1_phone as a left join @p2_phone as b on a.phone = b.phone order by b.phone desc, a.phone desc) is not null
				set @s_phone = @w_phone
		END
		IF (select top 1 email from @p1_email) is not null and (select top 1 email from @p2_email) is not null
		BEGIN --email
			set @pp_email = @w_email
			IF(select top(1) b.email from @p1_email as a left join @p2_email as b on a.email = b.email order by b.email desc, a.email desc) is not null
				set @s_email = @w_email
		END
		
		/** step 2, 3. calculate & action **/
		set @s_total = @s_address + @s_birthday + @s_email + @s_phone + @s_suffix
		set @pp_total = @pp_address + @pp_birthday + @pp_email + @pp_phone + @pp_suffix

		IF(@pp_total = 0) --if there was not enough information
		BEGIN
			insert into @tempA values (@p1_id, @p2_id,'inconclusive')
			--exec dbo.core_sp_save_profile_member @yelowList, @p1_id, @userID, @sourceID, @statusID, '', '12-31-9999', '12-31-9999', @date, '12-31-9999', @ordID
			--exec dbo.core_sp_save_profile_member @yelowList, @p2_id, @userID, @sourceID, @statusID, '', '12-31-9999', '12-31-9999', @date, '12-31-9999', @ordID
		END
		ELSE
		begin
			IF(@s_total / @pp_total) >= @minGrade  --if  it is a duplicate
			BEGIN
				insert into @tempA values (@p1_id, @p2_id,'duplicate')
				exec dbo.core_sp_save_profile_member @dupeList, @p1_id, @userID, @sourceID, @statusID, '', '12-31-9999', '12-31-9999', @date, '12-31-9999', @ordID
				exec dbo.core_sp_save_profile_member @dupeList, @p2_id, @userID, @sourceID, @statusID, '', '12-31-9999', '12-31-9999', @date, '12-31-9999', @ordID
			END
			ELSE --if its not a duplicate
			BEGIN
				insert into @tempA values (@p1_id, @p2_id,'clear')
				--exec dbo.core_sp_save_profile_member @whiteList, @p1_id, @userID, @sourceID, @statusID, '', '12-31-9999', '12-31-9999', @date, '12-31-9999', @ordID
				--exec dbo.core_sp_save_profile_member @whiteList, @p2_id, @userID, @sourceID, @statusID, '', '12-31-9999', '12-31-9999', @date, '12-31-9999', @ordID
			END
		end

		/** step 4. clear variables **/
		SET @s_suffix = 0
		SET @s_birthday = 0
		SET @s_address = 0
		SET @s_phone = 0
		SET @s_email = 0
		SET @s_total = 0
		SET @pp_suffix = 0
		SET @pp_birthday = 0
		SET @pp_address = 0
		SET @pp_phone = 0
		SET @pp_email = 0
		SET @pp_total = 0

		/** clear p2 variables **/
		delete from @p2_phone
		delete from @p2_email
		/** itterate to the next match **/
		SET @p2_id = (
		SELECT MIN(person_id) 
		from dbo.luminate_funct_get_duplicate_list(@whiteList, @yelowList) 
		where person_id != @p1_id and first_name = @p1_first_name and last_name = @p1_last_name and person_id > @p2_id)
	END

	/** clear p1 variables **/
	delete from @p1_phone
	delete from @p1_email

	/** itterate to the next person **/
	SET @p1_id = (select MIN(person_id) from dbo.luminate_funct_get_duplicate_list(@whiteList, @yelowList) where person_id > @p1_id)
END

/** Statistic test tables **/
select 'duplicates', count(reason) from @tempA  where reason = 'duplicate'-- order by ida, idb
union
select 'clear', count(reason) from @tempA  where reason = 'clear'
union
select 'inconclusive', count(reason) from @tempA  where reason = 'inconclusive'


select * from @tempA where ida = 20153 and idb = 28518