--------------------------------------------------------
--  DDL for Procedure LOAD_DPCATEGORIES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."LOAD_DPCATEGORIES" 
  -- Program name - LOAD_DPCATEGORIES
  -- Created 9-26-20 to manually load lookup table, assumes table is initially blank
               
  
         IS
    
    I number default 1;
 
 
         BEGIN
 
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (1,'Alcohol');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (2,'Sex');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (3  ,'Height');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (4  ,'Smoking');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (5  ,'Substances');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (6  ,'Genetic Testing');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (7  ,'Weight/BMI');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (8  ,'Registries');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (9  ,'Disease and Injury');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (10  ,'Biochemistry');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (11  ,'Microbiology');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (12  ,'Imaging');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (13  ,'Endoscopy');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (14  ,'Other');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (15  ,'Emergency');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (16  ,'Hospitalisation');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (17  ,'Non_Surgical');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (18  ,'Surgical');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (19  ,'Drugs & Medications');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (20  ,'Family History');
insert into DPCATEGORIES (DPCATEGORYID,DPCATEGORYNAME) values (21  ,'Restrictions');
COMMIT;
             
       EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR();
             
       END;

/

