use balaji_supermarket;

create schema source;
create schema target;

drop table if exists source.client
create table source.client
(
	id int not null,
	value int not null
);
GO

alter table source.client add constraint pk_source_client primary key (id);

insert into source.client(id,value)
select 1 id, 5000 ltv union all
select 2,6000 union all
select 4, 3350 union all
select 5,8000;

select * from source.client;

drop table if exists target.client
create table target.client
(
	client_id int not null,
	client_value int not null
);

alter table target.client add constraint pk_target_client_client_id primary key(client_id);

insert into target.client(client_id,client_value)
select 1 client_id,5000 value union all
select 3,7000 union all
select 4,9000 union all
select 5,8000 union all
select 6,2000;


select * from source.client;
select * from target.client;

select sc.id source_id, sc.value source_value, tc.client_id trg_id, tc.client_value trg_value from source.client sc
left join target.client tc on sc.id=tc.client_id

union all

select sc.id source_id, sc.value source_value, tc.client_id trg_id, tc.client_value trg_value from target.client tc
left join source.client sc on tc.client_id=sc.id


--full outer join
select distinct 
	foj.source_id,foj.source_value,foj.trg_value,
case
	when source_value = trg_value then 'Match Found'
	when source_id is not null and trg_value is null then 'Missing on Target'
	when source_id is null and trg_value is not null then 'Missing on source'
	when source_value <> trg_value then 'Mismatch'
	else 'fgdfg'
end as Finding
from
(
	select sc.id source_id, sc.value source_value, tc.client_id trg_id, tc.client_value trg_value from source.client sc
	full outer join target.client tc on sc.id=tc.client_id
) foj



--left join
select distinct
	a.source_id id, a.source_value, a.trg_value,

case 
	when source_value = trg_value then 'MatchFound'
	when source_id is not null and trg_id is null then 'MissingOnTarget'
	when source_id is null and trg_id is not null then 'MissingOnSource'
	when source_value <> trg_value then 'MisMatch'
	else 'SomeotherIssue'
end as finding
from (

select sc.id source_id, sc.value source_value, tc.client_id trg_id, tc.client_value trg_value from source.client sc
left join target.client tc on sc.id=tc.client_id

union all

select sc.id source_id, sc.value source_value, tc.client_id trg_id, tc.client_value trg_value from target.client tc
left join source.client sc on tc.client_id=sc.id

) a



