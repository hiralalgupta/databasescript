Drop table "SNX_IWS2"."CASE_SEGMENTATIONS";
CREATE TABLE "SNX_IWS2"."CASE_SEGMENTATIONS"
  (
    "CASEID"    NUMBER,
    "STAGEID"   NUMBER,
    "SEGMENTS" NUMBER,
    file_segment_size number,
    file_segment_overflow number
  )
  TABLESPACE "SNX_IWS";
ALTER TABLE CASE_SEGMENTATIONS 
    ADD CONSTRAINT CASE_SEGMENTATIONS_PK PRIMARY KEY ( CASEID, STAGEID ) using index tablespace snx_iws_inx;
