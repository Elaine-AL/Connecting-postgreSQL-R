--create the table you wish to fill the data into
drop table if exists temp_table, my_table
create table my_table(
	username bigint,
	First_Name character varying(100),
	Second_Name character varying(100),
	Amount varchar, 
	Transactions integer,
	First_trans date,
	Last_trans date);

--change the datestyle settings
set datestyle to MDY;

--create a temporary table to allow for manipulation of the copied data before inserting it into the main/final table
create temp table temp_table(
	username bigint,
	First_Name character varying(100),
	Second_Name character varying(100),
	Amount varchar, 
	Transactions integer); 

--copy the data from the csv file into the temporary table
copy temp_table (username, First_Name, Second_Name, Amount, Transactions, First_trans, Last_trans)
	from 'C:\my_table pathe\my_table.csv'
	with (format CSV, header true, encoding WIN1251);

--insert the results data from the temporary table to the main table only selecting the desired columns
insert into my_table(username, First_Name, Second_Name,Amount, Transactions)
	select username, First_Name, Second_Name, Amount, Transactions
	from temp_table;

--convert the column containing numeric values as text by removing the comma(,) character then converting to double type 
update my_table
	set Amount = cast(replace(Amount, ',', '') as double precision);
	
--change the datatype of the manipulated column
alter table my_table
	alter column Amount type INT using Amount::integer;

---create distinct user data

drop table if exists distinct_amount;
create table distinct_amount as 
	select username, sum(Amount) as Total_amount 
	from my_table 
	group by username
	order by sum(Amount) desc;

--finding duplicated records
select username, count(*)
	from my_table 
	group by username
	having count(*) >1;

	
