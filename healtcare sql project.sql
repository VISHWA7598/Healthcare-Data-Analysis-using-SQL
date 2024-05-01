-- Created a MySQL database named "healthcare".
create database healthcare;

/* Created table "diabetes_prediction" with columns: employeename, patient_id, gender, age, hypertension, heart_disease, 
smoking_history, bmi, hba1c_level, blood_glucose_level, diabetes*/
create table diabetes_prediction (employeename varchar(100),
patient_id varchar(100) , gender varchar(10) , age int , 
hypertension int , heart_disease varchar(50) , smoking_history varchar(60) ,
bmi double , hba1c_level double , blood_glucose_level int , diabetes int);

-- Describes the structure of the "diabetes_prediction" table.
desc diabetes_prediction;

-- imported large file using infile command 
LOAD DATA INFILE 'C:\\mysql\\Data\\healthcare\\Copy of Diabetes_prediction.csv'
INTO TABLE diabetes_prediction
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(employeename, patient_id, gender, age, hypertension, heart_disease, smoking_history, bmi, hba1c_level, blood_glucose_level, diabetes);



-- 1 retrive the patient_id and ages of all patients 
select patient_id , age from diabetes_prediction;

-- 2 select all female patients who are older than 40 
select gender , age from diabetes_prediction where gender = 'female' and age>40;

-- 3 calculate the average bmi of patients 
select avg(bmi) as average_bmi from diabetes_prediction;

-- 4 list patients in descending order of blood glucose levels .
select employeename , blood_glucose_level from diabetes_prediction order by blood_glucose_level desc ; 

-- 5 find patients who have hypertension and diabetes .
select employeename , hypertension , diabetes from diabetes_prediction
 where hypertension=1 and diabetes = 1;
 
 -- 6 determine the number of patients with heart disease 
 select count(*) as Total_no_of_heart_disease  from diabetes_prediction
 where heart_disease=1;
 
 -- 7 group patients by smoking history and count how many smokers and non smokers are there 
 select smoking_history ,count(*) as Total_no_of_patients  from diabetes_prediction 
 group by smoking_history ;

-- 8 retrieve the patient_ids of patients who have a bmi greater than average bmi 
select patient_id , bmi from diabetes_prediction where bmi > 
(select avg(bmi) from diabetes_prediction);

-- 9 find the patient with the higest hba1c level and the patient with teh lowest hba1c_level
select  employeename , patient_id , hba1c_level from diabetes_prediction
where hba1c_level =(select max(hba1c_level) from diabetes_prediction)
union all
select employeename , patient_id , hba1c_level from diabetes_prediction 
where hba1c_level =(select min(hba1c_level) from diabetes_prediction);

-- 10 calculate the age of patients in years assuming the current date as of now 
select patient_id , employeename , age as age_in_years from diabetes_prediction;

-- 11 rank patients by blood glucose level within each gender group
select employeename , gender , blood_glucose_level , 
dense_rank() over (partition by gender order by blood_glucose_level desc ) as ranl_no
from diabetes_prediction;

-- 12 update the smoking history of patients who are older than 50 to "ex-smoker ."
update diabetes_prediction set smoking_history = "ex-smoker" 
where age > 50 ;

-- 13 insert a new patient into the database with sample data 
insert into diabetes_prediction values
('thomas', 'pt759898', ' male', 45,0,0,'never' , 20.31,6.5,190,0);

-- 14 find patients who have hypertention but not diabetes using the except operator
select * from diabetes_prediction where hypertension = 1 
except 
select * from diabetes_prediction where diabetes = 1;

-- 15 create a view that displays the patient_ids , ages and bmi  of patient 
create view patient_details as(select patient_id , age , bmi from diabetes_prediction);
 
 select * from patient_details;
       