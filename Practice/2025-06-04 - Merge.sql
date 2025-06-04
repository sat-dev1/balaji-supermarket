
DROP TABLE if exists dbo.customer_infromation
CREATE TABLE dbo.customer_information
(
	customer_id INT not null Identity(1,1),
	name varchar(30) not null,
	email_id nvarchar(30) not null,
	birth_date datetime not null,
	created_at datetime not null,
	updated_at datetime
)

ALTER TABLE dbo.customer_information
ADD CONSTRAINT pk_dbo_customer_information_customer_id PRIMARY KEY(customer_id);

alter table dbo.customer_information
add constraint df_dbo_customer_information_created_at_datetime
default getdate() for created_at;
	
INSERT INTO dbo.customer_information(name,email_id,birth_date)
SELECT 'Sathya' customer_id,'sathya.v81@gmail.com' email_id,2000-05-08 birth_date union all
SELECT 'Nithya','nithya@gmail.com',2001-05-09 union all
SELECT 'Varun','varun123@gmail.com',2003-11-28 union all
SELECT 'Banu','banuABC@gmail.com',1999-07-15

SELECT * FROM dbo.customer_information;

DROP TABLE if exists dbo.transaction_information
CREATE TABLE dbo.transaction_information
(
	transaction_id INT not null IDENTITY(1,1),
	customer_id int not null,
	amount numeric(8,2),
	product_id int not null,
	created_date datetime,
	updated_at datetime
)

INSERT INTO dbo.transaction_information(customer_id,amount,product_id)
SELECT 2 customer_id,4000 amount,2 product_id union all
SELECT 3,7000,4 union all
SELECT 4,12000,12 union all
SELECT 5,6000,5 

ALTER TABLE transaction_information
ADD CONSTRAINT pk_dbo_transaction_information_transaction_id PRIMARY KEY(transaction_id);

ALTER TABLE transaction_information
ADD CONSTRAINT df_dbo_transaction_information_created_date_datetime 
DEFAULT GETDATE() FOR created_date;

SELECT * FROM dbo.transaction_information;
SELECT * FROM dbo.customer_information;


DROP TABLE if EXISTS #target_table
CREATE TABLE #target_table
(
	customer_id int,
	transaction_id int,
	customer_name varchar(30),
	product_id int,
	amount numeric(8,2),
	created_at datetime ,
	updated_at datetime
)
with target_table AS
(
	SELECT
		dci.customer_id,
		dci.name AS customer_name,
		dti.transaction_id,
		dti.product_id,
		dti.amount
	FROM
		dbo.customer_information dci
	LEFT JOIN dbo.transaction_information dti ON dci.customer_id = dti.customer_id
)
INSERT INTO  #target_table (customer_id,transaction_id,customer_name,product_id,amount)
SELECT
	tt.customer_id,
	tt.transaction_id,
	tt.customer_name,
	tt.product_id,
	tt.amount
FROM
	target_table tt
		
SELECT * FROM #target_table;

DROP TABLE if EXISTS #source_table
CREATE TABLE #source_table
(
	customer_id int,
	transaction_id int,
	customer_name varchar(30),
	product_id int,
	amount numeric(8,2),
	created_at datetime ,
	updated_at datetime
)
with source_table AS
(
	SELECT
		dci.customer_id,
		dci.name AS customer_name,
		dti.transaction_id,
		dti.product_id,
		dti.amount
	FROM
		dbo.transaction_information dti
	LEFT JOIN dbo.customer_information dci ON dci.customer_id = dti.customer_id
)
INSERT INTO  #source_table (customer_id,transaction_id,customer_name,product_id,amount)
SELECT
	st.customer_id,
	st.transaction_id,
	st.customer_name,
	st.product_id,
	st.amount
FROM
	source_table st

SELECT * FROM #target_table;
SELECT * FROM #source_table;

MERGE INTO #target_table tt
USING #source_table st
ON tt.customer_id = st.customer_id
WHEN MATCHED THEN
	UPDATE SET
		tt.customer_id=st.customer_id,
		tt.customer_name=st.customer_name
WHEN NOT MATCHED THEN
	INSERT(customer_id,customer_name) 
	VALUES(st.customer_id,st.customer_name);


UPDATE #source_table
SET amount=9000
WHERE customer_id=4;

SELECT * FROM #Source_table;

SELECT * FROM dbo.customer_information;
SELECT * FROM dbo.transaction_information;
SELECT * FROM #target_table;
SELECT * FROM #source_table;

