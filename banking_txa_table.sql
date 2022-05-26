create table customerz
(
cust_id number (2) primary key, 
cust_name varchar(20),
address varchar(25),
gender char(1),
email varchar(30),
phone_no varchar(10),
city_name varchar(20),
state_name varchar(20),
country_name varchar(20));

insert all
into customerz values(1,'SMITH','rr nagar','F','smith962@rediff.com',9743519898,'bangalore','karnataka','india')
into customerz values(2,'ALLEN','koramangala','M','allenbroad@yahoo.com',9876541230,'bangalore','karnataka','india')
into customerz values(3,'JONES','kanakapura','F','jackjones@gmail.com','null','bangalore','karnataka','india')
into customerz values(4,'CLARK','bannerghatta','F','clarkkent@gmail.com',9988776655,'bangalore','karnataka','india')
into customerz values(5,'TURNER','santa cruz','M','joshturner@yahoo.com','null','mumbai','maharashtra','india')
into customerz values(6,'SCOTT','lalbagh','F','scotttiger@rediff.com',null,'bangalore','karnataka','india')
into customerz values(7,'ADDAMS','ring road','M','addamsfamily@gmail.com',9595656862,'bangalore','karnataka','india')
into customerz values(8,'BLAKE','dollars colony','F','blake989@yahoo.com',9852145620,'bangalore','karnataka','india')
into customerz values(9,'FORD','jayanagar','M','bradford@gmail.com','null','bangalore','karnataka','india')
into customerz values(10,'MILLER','t nagar','F','jamesmiller@rediff.com',9874565698,'chennai','tamil nadu','india')
select * from dual;
commit;
update customerz
set phone_no = null
where cust_name = 'JONES' or cust_name = 'TURNER' or cust_name = 'FORD' ;
commit;
select * from customerz;

create table accounts
(
a_no number(5) primary key,
a_type varchar(20),
balance number(8),
a_open_date date,
a_status varchar(20),
cust_id number (2),
foreign key (cust_id)references customerz(cust_id));

insert all
into accounts values(10000,'saving account',12569845,'26-nov-2021','opened',5)
into accounts values(10001,'fixed account',12500845,'25-nov-2021','closed',6)
into accounts values(10002,'floating account',12549845,'15-aug-2020','new',7)
into accounts values(10003,'current account',12568845,'26-nov-2020','opened',9)
into accounts values(10004,'fixed account',12569805,'26-nov-2019','closed',8)
into accounts values(10005,'floating account',12589845,'27-jan-2017','new',10)
into accounts values(10006,'current account',12560845,'04-mar-2009','new',9)
into accounts values(10007,'saving account',12564545,'10-sep-2016','closed',4)
into accounts values(10008,'saving account',12561245,'11-may-2013','opened',4)
into accounts values(10009,'current account',12569845,'16-dec-2012','opened',2)
into accounts values(10010,'fixed account',12569445,'14-jun-2015','closed',1)
select * from dual;
commit;
select * from accounts;

create table txn
(
txn_id varchar(4) primary key,
txn_type varchar(20),
txn_amount number(6),
txn_date date,
a_no number(5),
foreign key (a_no)references accounts(a_no));

insert all
into txn values('txn1','debit',145630,'26-nov-2021',10000)
into txn values('txn2','credit',147852,'26-nov-2020',10009)
into txn values('txn3','cheque',123654,'27-aug-2016',10008)
into txn values('txn4','debit',145930,'14-feb-2020',10004)
into txn values('txn5','credit',125896,'16-dec-2020',10003)
into txn values('txn6','debit',148536,'17-nov-2010',10006)
into txn values('txn7','credit',123698,'09-mar-2014',10008)
into txn values('txn8','cheque',178390,'15-jul-2017',10007)
select * from dual;
commit;

-----Write a query to display all the customer names who do not have a phone
select cust_name
from customerz
where phone_no is null;
select * from customerz;

----Write a query to display all the customers and the number of accounts they hold
select cust_name,count(a_no)
from customerz c,accounts a
where c.cust_id=a.cust_id
group by cust_name;

----Display the customer who have the highest balance across all account types
select cust_name,a_type,balance
from customerz c, accounts a
where c.cust_id=a.cust_id and balance in (select max(balance)
from accounts);
select * from accounts;

----Display the customer name who have the highest balance in individual account type
select cust_name,a_type,balance
from customerz c, accounts a
where c.cust_id=a.cust_id and (balance,a_type) in (select max(balance),a_type
from accounts
group by a_type);
----Display the State wise no of accounts opened in the previous year
select state_name, count(a_no) opened_accounts
from customerz c,accounts a
where c.cust_id=a.cust_id and to_char(a_open_date,'yyyy')= to_char(sysdate,'yyyy')-1
group by state_name;
select * from accounts;
----Display the customers who hold  2 accounts of the same type
select cust_name,a_type,count(a_no)
from customerz c,accounts a
where c.cust_id=a.cust_id 
group by cust_name,a_type
having count(a_no)=2;
----Display customer name and transaction type wise transaction amounts. (Consider two types of transactions which are Debit and Credit)
select cust_name,txn_type,sum(txn_amount)
from customerz c,accounts a,txn t
where c.cust_id=a.cust_id and a.a_no=t.a_no and txn_type in('debit','credit')
group by cust_name,txn_type
order by txn_type;
---Display city wise no of male and female customers
select city_name,count(case when gender='M' then cust_id end) no_of_males,
count(case when gender='F' then cust_id end) no_of_females
from customerz
group by city_name
order by city_name;
select * from customerz;
----Display the customers who has only savings accout.
select cust_name,count(a_no)
from customerz c,accounts a
where c.cust_id=a.cust_id
and a_type='saving account'
group by cust_name
having count(a_no)=1;
select * from accounts;
select * from customerz;
-----Display the cities that have more number of customers than the city HYD
select city_name,count(cust_id)
from customerz
group by city_name
having count(cust_id) > (select count(cust_id)
from customerz
where city_name='mumbai');

select * from customerz;
select * from accounts;
select * from txn;
insert into accounts values(10011,'fixed account',12384403,'12-jan-15','new',9);
commit;

--WAQTD to update changes when name of city ' BANGALORE ' is changed to ' BENGALURU '
update customerz
set city_name= 'bengaluru'
where city_name='bangalore';



