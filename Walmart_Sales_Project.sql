

-- ===================== "WALMART SALE DATA ANALYSIS" ===========================

	Create Database WalmartSale;
	use WalmartSale;
	show databases;

	create table Sales(
	Invoice_Id int not null primary key,
	Branch varchar (30) not null,
	City varchar(30) not null,
	Customet_Type varchar(40) not null,
	Gender varchar(30) not null,
	Product_Line varchar(100) not null,
	Unit_Price decimal(10,2) not null,
	Quantity int not null,
	Tax_5Percent float(6,4) not null,
	Total float(6,4) not null,
	Date date not null,
	Time time not null,
	Payment varchar(50) not null,
	Cogs decimal(10,2) not null,
	Gross_Margin_Percentage float(10,9) not null,
	Gross_Income decimal(10,4) not null,
	Rating float(4,2) not null
	);

	drop table Sales;

	create table Sales(
	Invoice_Id varchar(30) not null primary key,
	Branch varchar (30) not null,
	City varchar(30) not null,
	Customet_Type varchar(40) not null,
	Gender varchar(30) not null,
	Product_Line varchar(100) not null,
	Unit_Price decimal(10,2) not null,
	Quantity int not null,
	Tax_5Percent float(6,4) not null,
	Total decimal(12,4) not null,
	Date datetime not null,
	Time time not null,
	Payment varchar(50) not null,
	Cogs decimal(10,2) not null,
	Gross_Margin_Percentage float(11,9),
	Gross_Income decimal(12,4),
	Rating float(2,1)
	);

	alter table Sales modify column Date date;


-- =============================== ACTUAL PROJECT =======================
	
    select * from Sales;
    
-- 1.Add a new column named time_of_day to give insight of sales in the Morning, 
-- 	 Afternoon and Evening. This will help answer the question on which part of the day most sales are made.
		
        select Time,
        (case
        when 'Time' BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
		when 'Time' BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
		else "EVENING"
        end) AS Time_Of_Day
        from sales;
        
         select time,
        (case
        when 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
		when 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
		else "EVENING"
        end) AS Time_Of_Day
        from sales;
        
        alter table Sales add column Time_Of_Day varchar(30);
        
-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server

	UPDATE sales
	SET Time_Of_Day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
        

-- Add day_name column
	SELECT
	date,
	DAYNAME(date)
	FROM sales;

	ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

	UPDATE sales
	SET day_name = DAYNAME(date);



-- Add month_name column
	SELECT
	date,
	MONTHNAME(date)
	FROM sales;

	ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

	UPDATE sales
	SET month_name = MONTHNAME(date);



        
-- =================================== Generic Question  =========================================

-- 1.How many unique cities does the data have?
	select distinct city
    from sales;
	
    
-- 2.In which city is each branch?
	select distinct City, Branch
    from sales;
    
    
    
--  ========================== Product =============================

-- 3.How many unique product lines does the data have?
	select distinct Product_Line
    from sales;


-- 4.What is the most common payment method?
	select Payment,  Count(Payment) AS Total_Count from Sales
    group by Payment
    order by Total_Count desc
    limit 1;
    
    #"CASH IS MOST COMMOM PAYMENT METHOD"
    
-- 5.What is the most selling product line?
	select Product_Line, sum(Quantity) AS Total_Quantity from sales
    group by Product_Line
    order by Total_Quantity desc
    limit 1;
    
    #"ELECTRONICS AND ACCESSORIES HAS MOST SELLING PRODUCT LINE"
	
    
-- 6.What is the total revenue by month?
	select Sales.month_name, (Sales.Unit_Price)*(Sales.Quantity) AS Revenue
    from Sales;
    
    select month_name, rOUND(sum(total),2) as Revenue
    from Sales
    group by month_name
    order by Revenue;
	
	
-- 7.What month had the largest COGS?
	select month_name As Month, Sum(Cogs) As Cogs
    from Sales
    group by month_name
    order by Cogs desc;
    
    #"JANUARY MONTH HAS LARGEST COGS"
    
    
-- 8.What product line had the largest revenue?
	select Product_Line, Sum(Total) As Total_Revenue
    from Sales
    group by Product_Line
    order by Total_Revenue desc;
    
    #"FOOD AND BEVERAGE PRODUCT LINE HAD MOST REVENUE"
    
    
-- 9.What is the city with the largest revenue?
	select City, Sum(Total) As Revenue
    from Sales
    group by City
    order by Revenue desc;
    
    select City,Branch, rOUND(Sum(Total),2) As Revenue
    from Sales
    group by City, Branch
    order by Revenue desc;
    
    # "'NAYPYITAW' CITY GENERATE MOST REVENUE"
    
    
    
-- 10.What product line had the largest VAT?
	select Product_Line, Sum(Tax_5Percent) As VAT
    from Sales
    group by Product_Line
    order by VAT desc;
    
    select Product_Line, Avg(Tax_5Percent) As VAT
    from Sales
    group by Product_Line
    order by VAT desc;
    
    select Product_Line, rOUND(Avg(Tax_5Percent),2) As VAT
    from Sales
    group by Product_Line
    order by VAT desc;
    
    # "HOME AND LIFESTYLE PRODUCT LINE HAVE MOST VAT"
    
    
-- 11.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
	select Avg(Quantity) AS Avg_Quantity,
	Product_Line,
    case
    when Avg(Quantity) > 5.5 Then "Good"
    Else "Bad"
    end AS Remark
    from Sales
    group by Product_Line;
    
    
    
-- 12.Which branch sold more products than average product sold?
	select Branch, Sum(Quantity), Avg(Quantity) from Sales
    group by Branch
    Having Sum(Quantity) > (select Avg(Quantity)from Sales);
    
    
    
-- 13.What is the most common product line by gender?
	select Gender, Product_Line, 
    Count(Gender) As Total_Count from Sales
    group by Gender, Product_Line
    order by Total_Count Desc;
    
    # "'FEMALE' BUYS FASHION ACCESSORIES"
    
    
    
-- 14.What is the average rating of each product line?
	select Product_Line, Avg(Rating) As Avg_Rating from Sales
    group by Product_Line
    order by Avg_Rating desc;
    
    select Product_Line, Round(Avg(Rating),2) As Avg_Rating from Sales
    group by Product_Line
    order by Avg_Rating desc;
    
    
    
-- =============================== Sales ==========================

-- 15.Number of sales made in each time of the day per weekday
	select time_of_day, Count(*) AS Total_Sale from Sales
    where day_name = "Sunday"
    group by time_of_day
    order by Total_Sale Desc;
    


-- 16.Which of the customer types brings the most revenue?
	select Customer_Type, Sum(Total) As Revenue
    from Sales
    group by Customer_Type
    order by Revenue Desc;
    
    select Customer_Type, Round(Sum(Total),2) As Revenue
    from Sales
    group by Customer_Type
    order by Revenue Desc;
    
    # "'MEMBER' CUSTOMER TYPE BRING THE MOST REVENUE"


-- 17.Which city has the largest tax percent/ VAT (Value Added Tax)?
	select City, Round(Sum(Tax_5Percent),2) As Large_Tax
    from Sales
    group by City
    order by Large_Tax Desc;
    
    # "'NAYPYITAW' CITY HAS LARGEST TAX PERCENT"
    
    
-- 18.Which customer type pays the most in VAT?
	alter table Sales rename column Customet_Type to Customer_Type;
    
    select Customer_Type, Round(Avg(Tax_5Percent),2) As Total_Tax
    from Sales
    group by Customer_Type
    order by Total_Tax Desc;
    
    # "MEMBER CUSTOMER TYPE PAYS MOST TAX"




-- ========================== Customer ===========================

-- 19.How many unique customer types does the data have?
	select Distinct Customer_Type from Sales;
    
	select Distinct Customer_Type, COUNT(Customer_Type) from Sales
    group by Customer_Type;



-- 20.How many unique payment methods does the data have?
	select Distinct Payment from Sales;
    
    # "WE HAVE 3 UNIQUE PAYMENT METHODS"
    
    
-- 21.What is the most common customer type?
	select Count(Customer_Type) from Sales;
    
	select Customer_Type, 
    Count(Customer_Type) As No_Of_Customer
    from Sales
    group by Customer_Type
    order by No_Of_Customer Desc;
    
    Select customer_type,
	count(*) as count
	FROM sales
	GROUP BY customer_type
	ORDER BY count DESC;
    
    
    
    
-- 22.Which customer type buys the most?
	select Customer_Type, Count(Quantity) AS Quantity
    from Sales
    group by Customer_Type
    order by Quantity Desc;
    
    Select customer_type,
    COUNT(*)
	FROM sales
	GROUP BY customer_type;
    
    # "MEMBER CUSTOMER TYPE BUY THE MOST WITH OVERALL QUANTITY OF 499"
    
    
    
-- 23.What is the gender of most of the customers?
	select Gender, count(Gender) AS Total_Count
    from Sales
    group by Gender
    order by Total_Count Desc;
    
    # "AMONG ALL CUSTOMER 'MALES' HAVE MORE NUMBER WITH A COUNT OF 498"
    
    
    
    
    
-- 24.What is the gender distribution per branch?
	select Branch, Gender, 
    Count(Gender) AS Gender_Count
    from Sales
    group by Branch, Gender
    order by Gender_Count
    Desc;
    
    # "MALES OF BRACH 'A' HAVE MORE DISTRIBUTION"
    
    
    
-- 25.Which time of the day do customers give most ratings?
	select time_of_day, Count(Rating) As RTNG from Sales
    group by time_of_day
    order by RTNG Desc;
    
    
    select time_of_day, Avg(Rating) As Avg_Rating 
    from Sales
    group by time_of_day
    order by Avg_Rating Desc;
    
    # "AT THE TIME OF AFTERNOON CUSTOMER GIVE MOST RATING"
    
    
    
-- 26.Which time of the day do customers give most ratings per branch?
	select Branch, time_of_day, AVG(Rating) As Avg_Rating
    from Sales
    group by Branch, time_of_day
    order by Avg_Rating Desc;
    
    # "BRANCH 'A' GIVES MOST RATING AT THE TIME OF AFTERNOON"
    
    
    
-- 27.Which day fo the week has the best avg ratings?
	select day_name , AVG(Rating) AS Avg_Rating  from Sales
    group by day_name
    order by Avg_Rating Desc;
    
    # "MONDAY, FRIDAY & TUESDAY HAS BEST AVG RATING"
    
-- 28.Which day of the week has the best average ratings per branch?
	select day_name , Branch, AVG(Rating) AS Avg_Rating  from Sales
    group by day_name, Branch
    order by Avg_Rating Desc;
    
    # "FRIDAY OF BRANCH 'A' HAS THE BEST AVG RATING"