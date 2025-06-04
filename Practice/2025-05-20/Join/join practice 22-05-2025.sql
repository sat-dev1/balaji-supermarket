use balaji_supermarket;

CREATE SCHEMA sourcea;

create schema targeta;

create table sourcea.source
(
	source_id int not null,
	source_value int,
)
GO
alter table sourcea.source 
add constraint pk_sourcea_source_source_id 
primary key (source_id);

insert into sourcea.source(source_id,source_value)
select 1 source_id,9000 source_value union all
select 2,4500 union all
select 3,10000 union all
select 5,2000 union all
select 7,3500;

select * from sourcea.source;

create table targeta.target
(
	trg_id int not null,
	trg_value int
)
GO

alter table targeta.target 
add constraint pk_targeta_target_trg_id 
primary key(trg_id);

insert into targeta.target(trg_id,trg_value)
select 1 trg_id,9000 trg_value union all
select 2,3000 union all
select 4,15000 union all
select 5,2000 union all
select 6,6000 union all
select 7,2500;


select * from targeta.target;

SELECT
a.source_id,a.source_value,a.trg_id,a.trg_value,

CASE
	WHEN a.source_value=a.trg_value THEN 'Matching Found'
	WHEN a.source_id is not null AND a.trg_id is null THEN 'Missing on Tatget'
	WHEN a.source_id is null AND a.trg_id is not null THEN 'Missing on source'
	WHEN a.source_value <> a.trg_value THEN 'Mismatch'
	ELSE 'value not found'
END AS Finding
FROM
(
	SELECT * FROM sourcea.source ss	LEFT JOIN targeta.target tt ON ss.source_id=tt.trg_id
	UNION ALL
	SELECT * FROM targeta.target tt	LEFT JOIN sourcea.source ss ON tt.trg_id=ss.source_id
)a

-- getting NULL values from two table without using FULL OUTER JOIN
SELECT * 
FROM
	sourcea.source ss
left JOIN
	targeta.target tt
ON 
	ss.source_id=tt.trg_id 
WHERE
	tt.trg_id is NULL
	
UNION ALL

SELECT *
FROM
	targeta.target tt
LEFT JOIN
	sourcea.source ss

ON
	tt.trg_id=ss.source_id
WHERE
	ss.source_id is null
   	








