--------------------------------------------------------
--  DDL for Procedure GEN_MATRIX_CSV
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."GEN_MATRIX_CSV" (p_batchid INTEGER) AS
  FILENAME varchar2(500);
  PROVIDERNAME varchar2(500);
  DATEOFSERVICE varchar2(100);
  PATIENTFIRSTNAME varchar2(500);
  PATIENTLASTNAME varchar2(500);
  CAREMGMTREFERRAL varchar2(4000);
  PCPOUTREACH varchar2(4000);
  EMERGENTMEDICAL varchar2(4000);
  EDUCATION varchar2(4000);
  CSVHEADER varchar2(500) := 'Case File Name,Provider name,Date of Service,Patient name,Care management referral sent,'||
                             'PCP outreach completed,Emergent Medical Need,Education provided';
  
  cursor c_batch (p_batchid INTEGER) is
    select caseid from batchpayload where batchid=p_batchid;

BEGIN
  dbms_output.put_line(CSVHEADER);
  for r_case in c_batch(p_batchid) loop
    select originalpdffilename into FILENAME from batchpayload where caseid=r_case.caseid;
    
    select nvl(nodevalue,'') into PROVIDERNAME from infopathdata where NODENAME='Name_Sig_Provider_Name' and caseid=r_case.caseid;
    select nvl(nodevalue,'') into DATEOFSERVICE from infopathdata where NODENAME='Name_Sig_Provider_Date' and caseid=r_case.caseid;
    select nvl(nodevalue,'') into PATIENTFIRSTNAME from infopathdata where NODENAME='Patient_First_Name' and caseid=r_case.caseid;
    select nvl(nodevalue,'') into PATIENTLASTNAME from infopathdata where NODENAME='Patient_Last_Name' and caseid=r_case.caseid;
    
    SELECT nvl2(LISTAGG(nvl(nodevalue,''), '') WITHIN GROUP (ORDER BY NODENAME),'Y','N') into CAREMGMTREFERRAL
    from infopathdata where NODENAME IN 
    ('Summary_COPD','Summary_Asthma','Summary_Cancer','Summary_CHF','Summary_CKD','Summary_Pain','Summary_CAD','Summary_Diabetes',
    'Summary_Weight_Loss','Summary_comorbidities','Summary_Care','Summary_Reports','Summary_Goals','Summary_Continues','Summary_Hospice',
    'Summary_Lacks_Knowledge','Summary_Medical_Other','Summary_Medical_Other_Box','Summary_Prescriptions','Summary_PT','Summary_Multiple',
    'Summary_Side_Effects','Summary_RX','Summary_Oral','Summary_Statins','Summary_BP','Summary_ACE','Summary_Agent','Summary_Depression',
    'Summary_ETOH','Summary_Anxiety','Summary_MH_Other','Summary_Active','Summary_Impairment','Summary_MH_Worse','Summary_Mental_Status',
    'Summary_Dementia','Summary_Confusion','Summary_Refuses','Summary_Unable_to_See','Summary_Unable_to_Hear','Summary_HX','Summary_ADL',
    'Summary_Unable_Food','Summary_Unable_Meds','Summary_Unable_Self_Manage','Summary_Caregiver_Availability','Summary_Caregiver_Capability',
    'Summary_Lack_Support','Summary_Social_Isolation','Summary_Financial_Instability','Summary_Unable_Medication','Summary_Housing_Instability',
    'Summary_Transportation','Summary_Poor_PCP','Summary_ER','Summary_ER_Visit_1','Summary_ER_Visit_2','Summary_ER_Visit_3','Summary_IP',
    'Summary_IP_Visit_1','Summary_IP_Visit_2','Summary_Rehab_Discharge','Summary_Depression_Box','Summary_MH_Other_Box')
    AND caseid=r_case.caseid;
    
    SELECT nvl2(LISTAGG(nvl(nodevalue,''), '') WITHIN GROUP (ORDER BY NODENAME),'Y','N') into PCPOUTREACH
    from infopathdata where NODENAME IN 
    ('Summary_Spoke_With','Summary_Left_Message','Summary_Left_Message_Date','Summary_Name_Box','Summary_Medications_PCP',
    'Summary_PCP_Side_Effects','Summary_Dosage','Summary_Non_Compliance','Summary_Symptoms','Summary_Specify_Box','Summary_Tests',
    'Summary_Cholesterol','Summary_Colorect','Summary_Mamm','Summary_Flu','Summary_PCP_Other','Summary_PCP_Other_Box','Summary_See_Patient',
    'Summary_Call_Patient','Summary_Referral','Summary_Spec','Summary_SW','Summary_Outcome_PT','Summary_HH')
    AND caseid=r_case.caseid;
    
    SELECT nvl2(LISTAGG(nvl(nodevalue,''), '') WITHIN GROUP (ORDER BY NODENAME),'Y','N') into EMERGENTMEDICAL
    from infopathdata where NODENAME IN 
    ('Summary_Medical_Need','Summary_911','Summary_Other_Transport','Summary_Notified','Summary_Notified_Box')
    AND caseid=r_case.caseid;
    
    SELECT nvl2(LISTAGG(nvl(nodevalue,''), '') WITHIN GROUP (ORDER BY NODENAME),'Y','N') into EDUCATION
    from infopathdata where NODENAME IN 
    ('Summary_Disease','Summary_Medication','Summary_PSS','Summary_Risk','Summary_Falls','Summary_Smoking','Summary_Home_Safety',
    'Summary_Education_Other','Summary_Wellness','Summary_Physical_Activity','Summary_Nutrition','Summary_Bladder_Control',
    'Summary_Disease_Box','Summary_Home_Safety_Box','Summary_Education_Other_Box')
    AND caseid=r_case.caseid;
    
    dbms_output.put_line('"'||FILENAME||'","'||PROVIDERNAME||'",'||DATEOFSERVICE||',"'||PATIENTFIRSTNAME||' '||PATIENTLASTNAME||'",'||
                         CAREMGMTREFERRAL||','||PCPOUTREACH||','||EMERGENTMEDICAL||','||EDUCATION);
  
  end loop;
  
END GEN_MATRIX_CSV;

/

