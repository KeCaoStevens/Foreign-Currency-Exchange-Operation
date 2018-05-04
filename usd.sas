PROC IMPORT OUT= WORK.usd 
            DATAFILE= "C:\Users\38933\Downloads\class\517\dataset01_euru
sd4h.csv\dataset01_eurusd4h.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
