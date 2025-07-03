ODS RTF FILE = '/home/u63221136/ECO625/e625proj/proj_RTF_Sakho.RTF'
BODYTITLE
SASDATE
STYLE = journal;
***
Programmer: Khalil Sakho
Class: ECO 625
Professor: Dr. Christopher Swann, Phd
Date: November 27 2023

Final Project
***;

*Question 1*;
PROC MEANS DATA=e625proj.analysis_data n nmiss mean min max maxdec=3;


*Question 2-4*;
PROC SGPLOT DATA= e625proj.analysis_data;
HISTOGRAM earned_income / scale=percent;
TITLE "Histogram of Earned Income";

PROC SGPLOT DATA= e625proj.analysis_data;
VBAR educyrs;
TITLE "Vertical Bar Chart of Years of Education";

PROC FORMAT;
VALUE edufmt
	1 = "Less than High School"
	2 = "High School Diploma"
	3 = "Some College"
	4 = "College Graduate"
	5 = "Masters Degree"
	6 = "Professional or Doctorate Degree";

PROC SGPLOT DATA= e625proj.analysis_data;
VBAR educ_cat;
FORMAT educ_cat edufmt.;
TITLE "Vertical Bar Chart of Education Categories";
RUN;	


*Question 5-7*;
PROC SGPLOT DATA = e625proj.analysis_data;
SCATTER X =educyrs Y=earned_income;
TITLE "Scatter Plot of Years of Education and Earned Income";

PROC MEANS DATA=e625proj.analysis_data n nmiss mean min max maxdec=3;
TITLE "Average Earned Income by Education Categories";
CLASS educ_cat;
VAR earned_income;
FORMAT educ_cat edufmt.;

PROC SGPANEL DATA=e625proj.analysis_data;
TITLE "Histogram of Earned Income by Education Categories";
PANELBY educ_cat/ NOVARNAME;
HISTOGRAM earned_income;
FORMAT educ_cat edufmt.;
RUN;


*Question 8*; *******************************;
PROC FORMAT;
VALUE missinfo
	0 = "Not Allocated/Imputed"
	1 = "Allocated/Imputed";
	
PROC FREQ DATA=e625proj.analysis_data NOPRINT;
TABLE miss_demo*miss_earn / NOCOL NOFREQ NOPERCENT OUT=MissingDataCrossTabulations;
FORMAT miss_demo missinfo. miss_earn missinfo.;

PROC PRINT DATA=MissingDataCrossTabulations;
TITLE "Table of Cross Tabulations of miss_demo and miss_earn";
	

*Question 9*; *******************************;
PROC REG DATA= e625proj.analysis_data PLOTS=NONE;
TITLE "Regression with Earned Income and Years of Education -12";
MODEL earned_income = educyrs12;
RUN;


*Question 10*; *******************************;

PROC FORMAT;
VALUE missinfo
	0 = "Not Allocated/Imputed"
	1 = "Allocated/Imputed";
PROC FREQ DATA=e625proj.analysis_data NOPRINT;
TABLE miss_demo*miss_earn / NOCOL NOFREQ NOPERCENT OUT=MissingDataCrossTabulations;
WHERE miss_demo = 1 AND miss_earn = 1;
FORMAT miss_demo missinfo. miss_earn missinfo.;  

PROC PRINT DATA=MissingDataCrossTabulations;
TITLE "Table of Cross Tabulations of miss_demo and miss_earn";
RUN;


*Question 11-13*;
PROC REG DATA= e625proj.analysis_data PLOTS=NONE;
TITLE "Multiple Regression Without Imputed/Allocated Demographic or Earnings Data";
WHERE miss_demo = 0 & miss_earn = 0;
MODEL earned_income = educ_eq_hs educ_some_college educ_college educ_ma educ_prof_phd 
		  age18 poor_health female black hispanic asian other citizen married divorced 
		  separated widowed median_income northeast midwest west;
RUN;

PROC REG DATA= e625proj.analysis_data PLOTS=NONE;
TITLE "Multiple Regression Without Imputed/Allocated Demographic or Earnings Data (T)";
WHERE miss_demo = 0 & miss_earn = 0;
MODEL earned_income = educ_eq_hs educ_some_college educ_college educ_ma educ_prof_phd 
		  age18 poor_health female black hispanic asian other citizen married divorced 
		  separated widowed median_income northeast midwest west;
TEST educ_eq_hs = 0, educ_some_college = 0, educ_college = 0, educ_ma = 0, educ_prof_phd = 0;
RUN;

PROC REG DATA= e625proj.analysis_data PLOTS=NONE;
TITLE "Multiple Regression on Imputed/Allocated Demographic or Earnings Data";
WHERE miss_demo = 1 & miss_earn = 1;
MODEL earned_income = educ_eq_hs educ_some_college educ_college educ_ma educ_prof_phd 
		  age18 poor_health female black hispanic asian other citizen married divorced 
		  separated widowed median_income northeast midwest west;
RUN;
ODS RTF CLOSE;