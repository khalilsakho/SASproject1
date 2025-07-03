***
Programmer: Khalil Sakho
Class: ECO 625
Professor: Christopher Swann, PhD
Date: November 27 2023

Final Project
***;

PROC CONTENTS DATA=e625data.cps_raw_sample;

PROC MEANS DATA=e625data.cps_raw_sample n nmiss mean min max maxdec=3;
RUN;

DATA WORK.projdata1;
set e625data.cps_raw_sample;

	* Question 1: Create Race Variables  *;
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
   
   * Question 2: Add variables to Proc Means at the bottom of the program *;
   

   * Create citizenship variable;
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


	*Use the CPS variable A_SEX to create a variable called female = 1 for females and = 0 for males*;

	* Create female variable*;
	*Female =1 Male =0*;

	Female = 0;
	If A_Sex = 2 Then Female = 1;
	label Female = 'female = 1 for females and = 0 for males';

	*Question 2*
	*Create a variable called earned_income that is equal to PEARNVAL*
	*Create a variable called Annual_Hours that is equal to usual hours per week X number of weeks worked*
	*Create a variable called hourly_wage that is equal to Earned_Income/Annual_Hours*;

	Earned_Income = PEARNVAL;
	Annual_Hours = HRSWK * WKSWORK;
	Hourly_Wage = Earned_Income / Annual_Hours;
	label Earned_Income ='is equal to PEARNVAL;Income Earned in a Year';
	label Annual_Hours ='is equal to usual hours per week X number of weeks worked';
	label Hourly_Wage ='is equal to Earned_Income/Annual_Hours';

	*QUESTION 3*;
	
	*educ_lt_hs = 1 if education less than a high school degree and = 0 otherwise
	educ_eq_hs = 1 if high school degree and = 0 otherwise
	educ_some_college = 1 if education beyond high school but less than bachelors degree and = 0 otherwise
	educ_college = 1 if college graduate and = 0 otherwise
	educ_ma = 1 if masters degree and = 0 otherwise
	educ_prof_phd = 1 if professional or doctoral degree and = 0 otherwise.;

	* Create education variables;
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


	*Categorize New Education Variables *;
	
	educ_cat = 0;
	IF educ_lt_hs = 1 THEN educ_cat = 1;
	IF educ_eq_hs = 1 THEN educ_cat = 2;
	IF educ_some_college = 1 THEN educ_cat = 3;
	IF educ_college = 1 THEN educ_cat = 4;
	IF educ_ma = 1 THEN educ_cat = 5;
	IF educ_prof_phd = 1 THEN educ_cat = 6;



	*create a variable called poor_health which = 1 if health status is fair or poor and is = 0 otherwise;

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
	
PROC MEANS DATA=WORK.projdata1;
TITLE "DESCRIPTIVE STATISTICS FOR VARIABLES WITHIN WORK.projdata1";
RUN;

PROC CONTENTS DATA=e625data.cps_hh_file;
TITLE "CONTENTS OF E625DATA.CPS_HH_FILE";

PROC MEANS DATA=e625data.cps_hh_file n nmiss mean min max maxdec=3;
TITLE "DESCRIPTIVE STATISTICS FOR VARIABLES WITHIN E625DATA.CPS_HH_FILE";

PROC SORT DATA=e625data.cps_hh_file out=hhfile; 
BY hhid; 

PROC SORT DATA=e625u6.unit6 out=unit6; 
BY hhid; 
RUN;

DATA temp;
MERGE hhfile unit6;
BY hhid;

	south = 0;
	northeast = 0; 
	midwest = 0; 
	west = 0;
	
	IF GEREG = 1 THEN northeast = 1;
	IF GEREG = 2 THEN midwest = 1;
	IF GEREG = 3 THEN south = 1;
	IF GEREG = 4 THEN west = 1;

	LABEL south = 'South Region';
	LABEL northeast = 'Northeast Region'; 
	LABEL midwest = 'Midwest Region'; 
	LABEL west = 'West Region';
RUN; 

PROC MEANS DATA=TEMP;
TITLE "DESCRIPTIVE STATISTICS FOR VARIABLES WITHIN TEMP";

PROC SORT DATA= temp;
BY gestfips;	

PROC MEANS DATA = temp NOPRINT;
BY gestfips;
OUTPUT OUT = medianinc MEDIAN(earned_income) = median_income;
TITLE "DESCRIPTIVE STATISTICS FOR VARIABLES WITHIN TEMP by gestfips";
RUN;

DATA WORK.projdata2;
MERGE temp medianinc;
BY gestfips;
LABEL median_income = "State Median Income";
	
PROC SORT DATA=work.projdata2 out=projd2; 
BY PERIDNUM; 
  
PROC SORT DATA=e625data.cps_additional_variables out=add_vars; 
BY PERIDNUM;
  
PROC SORT DATA=work.projdata1 out=projd1; 
BY PERIDNUM;
RUN;

DATA WORK.projdata3;
MERGE projd1 projd2 add_vars;
BY PERIDNUM;

PROC MEANS DATA= work.projdata3;
TITLE "DESCRIPTIVE STATISTICS FOR VARIABLES WITHIN work.projdata3";
RUN;

DATA e625proj.analysis_data;
SET work.projdata3;
KEEP earned_income educ_eq_hs educ_some_college educ_college educ_ma educ_prof_phd 
	age18 poor_health female black hispanic asian other citizen married 
	divorced separated widowed median_income northeast midwest west educyrs educ_cat miss_demo educyrs12 miss_earn miss_demo_earn;
RUN;

PROC MEANS DATA= e625proj.analysis_data;
TITLE "DESCRIPTIVE STATISTICS FOR FINAL VARIABLES";
PROC CONTENTS DATA= e625proj.analysis_data;
RUN;