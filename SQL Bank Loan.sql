exec sp_help --for 2021--


Select top 10 * from Bank_loan

---------------KPI----------------------
--Q. 1 Total Loan Application--
Select count(id) as Loan_applications  from bank_loan

--Q.2 Total Funded Amount--
Select sum(loan_amount) as Total_funded_amount from bank_loan
where month(issue_date) = 11

Select concat('$', sum(loan_amount)) as Total_funded_amount from bank_loan

--Q.3 Total Amount Recieved--
Select sum(total_payment) as Total_recieved_amount from bank_loan

--Q.4 Average Intrest rates
Select round(avg(int_rate),4) * 100 as Avg_intrest_rate  from Bank_loan

--Q.5 Average Debt to Income Ratio--
select cast(avg(dti) as decimal(10,2))*100 as Avg_dti from Bank_loan

-----------Good Loan KPIs----------

--Q.6 Good Loan Percentage--
Select count(case	
				when loan_status = 'Fully Paid' or loan_status = 'Current' then id 
				end) *100 / count(id) as Good_loan_percentage
from Bank_loan

--Q.7 Good Loan Applications--
Select count(case	
				when loan_status = 'Fully Paid' or loan_status = 'Current' then id 
				end) as Good_loan_applications
from Bank_loan


--Q.8 Good Loan Funded Amount--
Select sum(loan_amount) as Good_funded_amount from Bank_loan
where loan_status like '%fully%' or loan_status like '%curre%'

--Q.9 Good Loan Amount Recieved --
Select sum(total_payment) as Good_funded_amount_recieved from Bank_loan
where loan_status in ('Fully Paid' , 'Current')


 ------------- Bad Loan KPIs-------------------

 --Q.10 Bad Loan Applications--
 Select count(case	
				when loan_status = 'Charged off' then id 
				end) as Bad_loan_applications
from Bank_loan

--Q.11 Bad Loan Percentage 
Select count(case	
				when loan_status = 'Charged off' then id 
				end) *100 / count(id) as Bad_loan_Perecentage
from Bank_loan 

--Q.12 Bad Loan Funded Amount--
Select sum(loan_amount) as bad_funded_amount from Bank_loan
where loan_status not like '%fully%' or loan_status like '%curre%'

--Q.13 Bad Loan Amount Recieved--
Select sum(total_payment) as bad_funded_amount from Bank_loan
where loan_status not like '%fully%' or loan_status like '%curre%'


-- Q.14 Loan Matrix according to Loan status --
Select  loan_status, 
		count(id) as Loan_applications,
		sum(loan_amount) as Total_funded_amount ,
		sum(total_payment) as Total_recieved_amount,
		round(avg(int_rate),4) * 100 as Avg_intrest_rate, 
		cast(avg(dti) as decimal(10,4))*100 as Avg_dti
from Bank_loan
group by loan_status

 ----------------Charts-----------------
 Select Top 10 * from Bank_loan
 -- Q.15 Loan Issuance trend--

Select month(issue_date) as Month , count(id) as Loan_Issued,sum(loan_amount) as Total_funded_amount ,
		sum(total_payment) as Total_recieved_amount  from Bank_loan
group by month(issue_date)
order by month(issue_date) 

-- Q.16 Regional Analysis of Loan trend --
Select address_state, count(id) as Loan_Issued, sum(loan_amount) as Total_funded_amount ,
		sum(total_payment) as Total_recieved_amount  from Bank_loan
group by address_state
order by address_state


-- Q.17 Loan trend over the term of duration for the loan--
Select term, count(id) *100.0/ (select count(id) from Bank_loan) as Term_percentage,   
count(id) as Loan_Issued, sum(loan_amount) as Total_funded_amount ,
		sum(total_payment) as Total_recieved_amount  from Bank_loan
group by term
order by term

-- Q.18 Loan Trend over the employee working duration --
Select emp_length , count(id) as Loan_Issued, sum(loan_amount) as Total_funded_amount ,
		sum(total_payment) as Total_recieved_amount  from Bank_loan
group by emp_length
order by emp_length

--Q.19 Loan trend across the purpose of loan --
Select purpose , count(id) as Loan_Issued, sum(loan_amount) as Total_funded_amount ,
		sum(total_payment) as Total_recieved_amount,
		round(sum(total_payment) *100.0 / sum(loan_amount), 2 ) AS Loan_return_ratio
		from Bank_loan
group by purpose
order by Loan_Issued desc

-- Q.20 Loan trend across the Home Ownership Status--
Select home_ownership, count(id) as Loan_Issued, sum(loan_amount) as Total_funded_amount ,
		sum(total_payment) as Total_recieved_amount,
		cast(sum(total_payment) *100.0 / sum(loan_amount) as decimal (10, 2) ) AS Loan_return_ratio
		from Bank_loan
group by home_ownership
order by Loan_Issued desc


Select min(loan_amount), max(loan_amount) from Bank_loan