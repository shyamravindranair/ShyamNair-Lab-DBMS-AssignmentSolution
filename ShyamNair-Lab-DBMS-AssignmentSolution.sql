create schema `E-Commerce`;
use `E-Commerce`;

/* 1) You are required to create tables for supplier,customer,category,product,productDetails,order,rating to store the data for the E-commerce with the schema definition given below. */
create table Supplier
(
	SUPP_ID int primary key not null,
    SUPP_NAME varchar(50),
    SUPP_CITY varchar(50),
    SUPP_PHONE varchar(10)
);

create table Customer
(
	CUS_ID int primary key not null,
    CUS_NAME varchar(50),
    CUS_PHONE varchar(10),
    CUS_CITY varchar(50),
    CUS_GENDER char(1)
);

create table Category
(
	CAT_ID int primary key not null,
    CAT_NAME varchar(50)
);

create table Product
(
	PRO_ID int primary key not null,
    PRO_NAME varchar(50),
    PRO_DESC varchar(180),
    CAT_ID int not null,
    foreign key (CAT_ID) references Category(CAT_ID)
);

create table ProductDetails
(
	PROD_ID int primary key not null,
    PRO_ID int not null,
    SUPP_ID int not null,
    PRICE float,
    foreign key (PRO_ID) references Product(PRO_ID),
    foreign key (SUPP_ID) references Supplier(SUPP_ID)
);

create table `Order`
(
	ORD_ID int primary key not null,
    ORD_AMOUNT float,
    ORD_DATE date,
    CUS_ID int not null,
    PROD_ID int not null,
    foreign key (CUS_ID) references Customer(CUS_ID),
    foreign key (PROD_ID) references ProductDetails(PROD_ID)
);

create table Rating
(
	RAT_ID int primary key not null,
    CUS_ID int not null,
    SUPP_ID int not null,
    RAT_RATSTARS int,
    foreign key (CUS_ID) references Customer(CUS_ID),
    foreign key (SUPP_ID) references Supplier(SUPP_ID)
);

/* 2) Insert the following data in the table created above */
insert into Supplier values
(1, 'Rajesh Retails', 'Delhi', '1234567890'),
(2, 'Appario Ltd.', 'Mumbai', '2589631470'),
(3, 'Knome products', 'Bangalore', '9785462315'),
(4, 'Bansal Retails', 'Kochi' , '8975463285'),
(5, 'Mittal Ltd.', 'Lucknow', '7898456532');

insert into Customer values
(1, 'AAKASH', '9999999999', 'DELHI', 'M'),
(2, 'AMAN', '9785463215', 'Noida', 'M'),
(3, 'NEHA', '9999999999', 'MUMBAI', 'F'),
(4, 'MEGHA', '9994562399', 'KOLKATA', 'F'),
(5, 'PULKIT', '7895999999', 'LUCKNOW', 'M');

insert into Category values
(1, 'BOOKS'),
(2, 'GAMES'),
(3, 'GROCERIES'),
(4, 'ELECTRONICS'),
(5, 'CLOTHES');

insert into Product values
(1, 'GTA V', 'DFJDJFDJFDJFDJFJF', 2),
(2, 'TSHIRT', 'DFDFJDFJDKFD', 5),
(3, 'ROG LAPTOP', 'DFNTTNTNTERND', 4),
(4, 'OATS', 'REURENTBTOTH', 3),
(5, 'HARRY POTTER', 'NBEMCTHTJTH', 1);

insert into ProductDetails values
(1, 1, 2, 1500),
(2, 3, 5, 30000),
(3, 5, 1, 3000),
(4, 2, 3, 2500),
(5, 4, 1, 1000);

insert into `Order` values
(20, 1500, '2021-10-12', 3, 5),
(25, 30500, '2021-09-16', 5, 2),
(26, 2000, '2021-10-05', 1, 1),
(30, 3500, '2021-08-16', 4, 3),
(50, 2000, '2021-10-06', 2, 1);

insert into Rating values
(1, 2, 2, 4),
(2, 3, 4, 3),
(3, 5, 1, 5),
(4, 1, 3, 2),
(5, 4, 5, 4);

/* 3) Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.*/
select c.CUS_GENDER as Gender, count(o.CUS_ID) as NoOfCustomers 
from Customer c, `Order` o 
where c.CUS_ID = o.CUS_ID and o.ORD_AMOUNT >= 3000 
group by c.CUS_GENDER; 

/* 4)  Display all the orders along with the product name ordered by a customer having Customer_Id=2. */
select o.*, p.PRO_NAME
from `Order` o inner join ProductDetails pd
on o.PROD_ID = pd.PROD_ID
inner join Product p
on pd.PRO_ID = p.PRO_ID
where o.CUS_ID = 2;

/* 5) Display the Supplier details who can supply more than one product. */
select s.*
from Supplier s, ProductDetails pd
where s.SUPP_ID = pd.SUPP_ID
group by pd.SUPP_ID
having count(pd.SUPP_ID) > 1;

/* 6) Find the category of the product whose order amount is minimum. */
select c.CAT_NAME, o.ORD_AMOUNT from Category c
inner join Product p on p.CAT_ID = c.CAT_ID
inner join ProductDetails pd on pd.PRO_ID = p.PRO_ID
inner join `Order` o on o.PROD_ID = pd.PROD_ID
having min(o.ORD_AMOUNT);

/* 7) Display the Id and Name of the Product ordered after “2021-10-05” */
select p.PRO_ID, p.PRO_NAME
from Product p
inner join ProductDetails pd on pd.PRO_ID = p.PRO_ID
inner join `Order` o on o.PROD_ID = pd.PROD_ID
where o.ORD_DATE > "2021-10-05"
order by p.PRO_ID;

/* 8) Print the top 3 supplier name and id and their rating on the basis of their rating along with the customer name who has given the rating. */
select s.SUPP_ID, s.SUPP_NAME, r.RAT_RATSTARS, c.CUS_NAME
from Supplier s
inner join Rating r on s.SUPP_ID = r.SUPP_ID
inner join Customer c on c.CUS_ID = r.CUS_ID
order by r.RAT_RATSTARS desc limit 3;

/* 9) Display customer name and gender whose names start or end with character 'A'. */
select CUS_NAME, CUS_GENDER
from Customer
where CUS_NAME like '%a'
or CUS_NAME like 'a%'
order by CUS_NAME;

/* 10) Display the total order amount of the male customers. */
select sum(o.ORD_AMOUNT) as 'total order amount'
from `Order` o
inner join Customer c on c.CUS_ID = o.CUS_ID
where c.CUS_GENDER = 'M';

/* 11) Display all the Customers left outer join with the orders. */
select * 
from Customer c 
left outer join `Order` o on c.CUS_ID = o.CUS_ID; 

/* 12) Create a stored procedure to display the Rating for a Supplier if any along with the 
Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.*/
delimiter &&
create procedure proc()
begin

select s.SUPP_ID, s.SUPP_NAME, r.RAT_RATSTARS,

case
when r.RAT_RATSTARS>4
then 'Genuine Supplier'
when r.RAT_RATSTARS>2
then 'Average Supplier'
else 'Supplier should not be considered'
end as verdict

from Supplier s inner join Rating r
on r.SUPP_ID = s.SUPP_ID;
end &&

call proc();