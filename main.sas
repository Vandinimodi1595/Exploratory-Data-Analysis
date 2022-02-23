*SAS 6020 Final Project Dec 6;

*Import data;
proc import datafile = '/home/vmodi/EPG194/data/covid-19_usa_cases.csv'
 out = pg1.covid_usa_cases
 dbms = CSV;
run;
*;

*Data exploration;
PROC CONTENTS DATA=pg1.covid_usa_cases order=varnum;
RUN;


*sorted data;
proc sort data=pg1.covid_usa_cases;
	 by state date;
run;


*view raw data;
PROC PRINT DATA=pg1.covid_usa_cases noobs;
	by state;
RUN;


*data preparation;
data pg1.clean_data_covid_usa_cases;
	set pg1.covid_usa_cases;
	drop fips;
	month=MONTH(date);
	day=DAY(date);
 	format cases comma9.;
    format deaths comma9.;
run;


proc print data=pg1.clean_data_covid_usa_cases;
run;
*Means;
proc means data=pg1.clean_data_covid_usa_cases maxdec=2; 
run;

ods graphics on;
*FREQ Table;
PROC FREQ DATA=pg1.clean_data_covid_usa_cases order=freq NLEVELS;
    TABLE county/MISSING;
RUN;

*FREQ Table;
PROC FREQ DATA=pg1.clean_data_covid_usa_cases order=data;
    TABLE state/nocum plots=freqplot(ORIENT=horizontal scale=percent);
RUN;

PROC FREQ DATA=pg1.clean_data_covid_usa_cases order=data;
    TABLE deaths/nocum plots=freqplot(ORIENT=horizontal scale=percent);
RUN;

PROC FREQ DATA=pg1.clean_data_covid_usa_cases order=data;
    TABLE cases/nocum plots=freqplot(ORIENT=horizontal scale=percent);
RUN;

proc sort data=pg1.clean_data_covid_usa_cases;
	by cases;
run;

proc sort data=pg1.clean_data_covid_usa_cases;
	by deaths;
run;

proc sort data=pg1.clean_data_covid_usa_cases;
	by descending cases;
run;

proc sort data=pg1.clean_data_covid_usa_cases;
	by descending deaths;
run;

*bar chart for cases;
proc sgplot data=pg1.clean_data_covid_usa_cases; 
	vbar month/group=cases;
	title 'Cases count each month';
run;

*scatterplot;
proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of Month and Cases; 
	plot month* cases;
	run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of Month and deaths; 
	plot month* deaths;
	run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of Cases and deaths; 
	plot deaths* cases;
	run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of states and cases; 
	plot cases* state;
	run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of states and deaths; 
	plot deaths* state;
	run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of first month cases; 
	plot cases* state;
	where month= 1;
run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of Last month cases; 
	plot cases* state;
	where month= 12;
run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of First month deaths; 
	plot deaths* state;
	where month= 1;
run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of Last month deaths; 
	plot deaths* state;
	where month= 12;
run;
quit;

proc gplot data=pg1.clean_data_covid_usa_cases;
	title Scatter Plot of county and cases; 
	plot cases* county;
run;
quit;

*export data;
proc export data=pg1.clean_data_covid_usa_cases 
	outfile="/home/vmodi/EPG194/data/covid_data_export.csv"
	dbms=tab replace; 
run;
