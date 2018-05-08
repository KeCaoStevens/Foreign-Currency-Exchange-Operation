*Stepwise Regression for Feature Selection;
proc reg data=usd;
 model tipo=rsi1 rsi2 rsi3 rsi4 rsi5 rsi6 stoch1 stoch2 stoch3 stoch4 stoch5
 stoch6 ema20Slope1  ema20Slope2 ema20Slope3 ema20Slope4 ema20Slope5 ema20Slope6 ema50Slope1
 ema50Slope2 ema50Slope3 ema50Slope4 ema50Slope5 ema50Slope6 ema100Slope1 ema100Slope2 ema100Slope3
 ema100Slope4 ema100Slope5 ema100Slope6 ema200Slope1 ema200Slope2 ema200Slope3 ema200Slope4
 ema200Slope5 ema200Slope6 std1 std2 std3 std4 std5 std6 mom1 mom2 mom3 mom4 mom5 mom6
 BB_up_percen1 BB_up_percen2 BB_up_percen3 BB_up_percen4  BB_up_percen5 BB_up_percen6
 cci1 cci2 cci3 cci4 cci5 cci6 force1 force2 force3 force4 force5 force6 macd1 macd2 macd3
 macd4 macd5 macd6 bearsPower1 bearsPower2 bearsPower3 bearsPower4 bearsPower5 bearsPower6
 bullsPower1 bullsPower2 bullsPower3 bullsPower4  bullsPower5 bullsPower6 WPR1 WPR2  WPR3
 WPR4 WPR5 WPR6  close1 close2 close3 close4 close5 close6 hour dayOfWeek
/ selection=stepwise;
   run;

*check the correlation matrix of the variables;
proc corr data=usd plots=matrix PLOTS(MAXPOINTS=1000000000);
var mom1 BB_up_percen5 force3 bearsPower4 
bullsPower4 WPR5 close1 dayOfWeek tipo;
run;


*partition data set train_set=80% test_set=20%;
proc sort data=usd;
by tipo; 
run;

proc surveyselect data=usd
out=usd1
samprate=0.8  
seed=0 outall;
strata tipo;
run;


data train test;
set usd1;
if selected=1 then output train;
else output test;
run;
*logestic regression;
proc logistic data=train;
model tipo=mom1 BB_up_percen5 force3 bearsPower4 bullsPower4 WPR5 close1 dayOfWeek;
run;
data test_p;
set  test;
logit_sell=-3.2803+mom1*0.0460+BB_up_percen5*0.3875+force3*(-0.00548)+bearsPower4*31.8045+bullsPower4 *(-14.0762)
+WPR5*(-0.00633)+close1*(-1.4405)+dayOfWeek*(-0.0351);
p=exp(logit_sell)/(exp(logit_sell)+1);
if p<0.5 then sell_buy_predicted='buy ';
else sell_buy_predicted='sell';
keep tipo p sell_buy_predicted;
run; 
proc print data=test_p;
run;
*Confusion Matrix;
proc freq data=test_p;
tables tipo*sell_buy_predicted/nopercent nocol norow;
run;
proc freq data=test_p;
tables tipo*sell_buy_predicted;
run;

proc logistic data=train;
model tipo=mom1 BB_up_percen5 force3 bearsPower4 bullsPower4 WPR5 close1 dayOfWeek;
score data=test outroc=test_roc;
run;

proc univariate data=train;
var tipo;
histogram;
run;

proc univariate data=test;
var tipo;
histogram;
run;
