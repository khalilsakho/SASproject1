### SAS Project - Impact of Demographic Factors on Earned Income


## 📚 Table of Contents

- [🔍 Objective](#-objective)
- [📎 Tools Used](#-tools-used)
- [🔧 Data Manipulation & Cleaning](#-data-manipulation-and-cleaning)
- [🧪 Regression Models](#-regression-models)
- [📈 Key Findings](#-key-findings)


# 🔍 Objective

This project explores the empirical relationship between educational attainment and earned income using a detailed dataset of demographic, socioeconomic, and regional variables. The core objective is to determine how different education levels and demographic factors (e.g., age, race, health, citizenship, marital status) influence annual earnings. The analysis uses SAS to generate insights through data visualization, statistical modeling, and regression analysis.

# 📎 Tools Used

- **SAS 9.4** – Primary tool for data import, cleaning, transformation, statistical analysis, and visualization
- **PROC MEANS, PROC FORMAT, PROC SGPLOT, PROC REG** – Key SAS procedures used
- **PDF Report** – Final write-up including figures, interpretations, and model results
  
# 🔧 Data Manipulation and Cleaning

- **Feature Creation**:
  - *Import Data & Create a New Dataset*
```
DATA WORK.projdata1;
set e625data.cps_raw_sample;
```
  - *Create Race Variables*
```
	IF pehspnon eq 1 THEN hispanic = 1;
	ELSE IF pehspnon eq 2 THEN hispanic = 0;
	
	white = 0;
	black = 0;
	asian = 0;
	other = 0;
	
	IF hispanic EQ 0 AND prdtrace EQ 1 THEN white = 1;
	IF hispanic EQ 0 AND prdtrace EQ 2 THEN black = 1;
	IF hispanic EQ 0 AND prdtrace EQ 3 THEN other = 1;
	IF hispanic EQ 0 AND prdtrace EQ 4 THEN asian = 1;
	IF hispanic EQ 0 AND prdtrace EQ 5 THEN other = 1;
	IF hispanic EQ 0 AND pratrace EQ 6 THEN black = 1;
	IF hispanic EQ 0 AND pratrace EQ 7 THEN other = 1;
	IF hispanic EQ 0 AND pratrace EQ 8 THEN  asian = 1;
	IF hispanic EQ 0 AND prdtrace EQ 9 THEN other = 1;
	IF hispanic EQ 0 AND prdtrace EQ 10 THEN other = 1;
	IF hispanic EQ 0 AND prdtrace EQ 11 THEN asian = 1;
	IF hispanic EQ 0 AND pratrace EQ 12 THEN other = 1;
	IF hispanic EQ 0 AND prdtrace EQ 13 THEN other = 1;
	IF hispanic EQ 0 AND prdtrace EQ 14 THEN other = 1;
	IF hispanic EQ 0 AND prdtrace EQ 15 THEN other = 1;

	* Add labels to variables;
   label White = "White = 1 if the person is white and is not Hispanic, and = 0 otherwise"; 
   label Black = "Black = 1 if the person is black and is not Hispanic, and = 0 otherwise";
   label Asian = "Asian = 1 if the person is Asian and is not Hispanic, and = 0 otherwise";
   label Other = "Other = 1 if the person is of another race and is not Hispanic";
   label Hispanic = "hispanic = 1 if the person is Hispanic regardless of race";
```

  - *Create Citizenship & Marital Status Variables*
```
   citizen = 0;
   if PRCITSHP ge 1 and PRCITSHP le 4 then citizen = 1;

   * Create marital status variables;
   married = 0;
   widowed = 0;
   divorced = 0;
   separated = 0;
   never_married = 0;

   if A_MARITL in (1, 2, 3) then married = 1;
   else if A_MARITL = 4 then widowed = 1;
   else if A_MARITL = 5 then divorced = 1;
   else if A_MARITL = 6 then separated = 1;
   else if A_MARITL = 7 then never_married = 1;

   * Add labels to variables;
   label citizen = "= 1 if citizen; = 0 otherwise"; 
   label married = "= 1 if married; = 0 otherwise";
   label widowed = "= 1 if widowed; = 0 otherwise";
   label divorced = "= 1 if divorced; = 0 otherwise";
   label separated = "= 1 if separated; = 0 otherwise";
   label never_married = "= 1 if never_married; = 0 otherwise";
```
  - *Create Sex Variables*
```
	*Used the CPS variable A_SEX to create a variable called female = 1 for females and = 0 for males*;

	* Create female variable*;
	*Female =1 Male =0*;

	Female = 0;
	If A_Sex = 2 Then Female = 1;
	label Female = 'female = 1 for females and = 0 for males';
```
  - *Create a variable called earned_income that is equal to PEARNVAL*\
	*Create a variable called Annual_Hours that is equal to usual hours per week X number of weeks worked*\
	*Create a variable called hourly_wage that is equal to Earned_Income/Annual_Hours*;
```
	Earned_Income = PEARNVAL;
	Annual_Hours = HRSWK * WKSWORK;
	Hourly_Wage = Earned_Income / Annual_Hours;
	label Earned_Income ='is equal to PEARNVAL;Income Earned in a Year';
	label Annual_Hours ='is equal to usual hours per week X number of weeks worked';
	label Hourly_Wage ='is equal to Earned_Income/Annual_Hours';
```

 - *Create Education Variables*
```
	educ_lt_hs = 0;
	educ_eq_hs = 0;
	educ_some_college = 0;
	educ_college = 0;
	educ_ma = 0;
	educ_prof_phd = 0;
	
	if A_HGA =< 38 then educ_lt_hs = 1;
	else if A_HGA = 39 then educ_eq_hs = 1;
	else if A_HGA = 40 then educ_some_college = 1;
	else if A_HGA in (41, 42, 43) then educ_college = 1;
	else if A_HGA = 44 then educ_ma = 1;
	else if A_HGA in (45, 46) then educ_prof_phd = 1;
   

   * Add labels to variables;
   label educ_lt_hs = "= 1 if education less than a high school degree; = 0 otherwise"; 
   label educ_eq_hs = "= 1 if education= high school degree; = 0 otherwise";
   label educ_some_college = "= 1 if if education beyond high school but less than bachelors degree; = 0 otherwise";
   label educ_college = "= 1 if college graduate; = 0 otherwise";
   label educ_ma = "= 1 if if masters degree; = 0 otherwise";
   label educ_prof_phd = "= 1 if if professional or doctoral degree; = 0 otherwise";

	*Categorize New Education Variables*;
	
	educ_cat = 0;
	IF educ_lt_hs = 1 THEN educ_cat = 1;
	IF educ_eq_hs = 1 THEN educ_cat = 2;
	IF educ_some_college = 1 THEN educ_cat = 3;
	IF educ_college = 1 THEN educ_cat = 4;
	IF educ_ma = 1 THEN educ_cat = 5;
	IF educ_prof_phd = 1 THEN educ_cat = 6;
```

  - *Create A Variable Called poor_health which = 1 if health status is fair or poor and is = 0 otherwise*
```
	poor_health = 0;
	IF HEA = 4 THEN poor_health = 1;
	IF HEA = 5 THEN poor_health = 1;
	label poor_health ='= 1 if health status is fair or poor and is = 0 otherwise';
		
		
	miss_educ = 0;
	IF AXHGA ne 0 THEN miss_educ =1;
	LABEL miss_educ = "=1 if AXHGA is not = 0; 0 otherwise";
	
	miss_earn = 0;
	IF I_HRSWK ne 0 OR I_WKSWK ne 0 THEN miss_earn =1;
	LABEL miss_earn = "=1 if missing earnings information."
	
	miss_demo = 0;
	IF  AXAGE ne 0 OR
		AXHGA ne 0 OR
		I_HEA ne 0 OR
		PXHSPNON ne 0 OR
		PXMARITL not in (-1,0) OR
		PXRACE1 ne 0 THEN miss_demo = 1;
		LABEL miss_demo = "=1 if missing demographic information";

	miss_demo_earn = 0;
	IF miss_demo eq 1 OR miss_earn eq 1 THEN miss_demo_earn = 1;
	LABEL miss_demo_earn = "=1 if miss_earn or miss_demo =1";
RUN;
```

# 🧪 Regression Models

# 📈 Key Findings
