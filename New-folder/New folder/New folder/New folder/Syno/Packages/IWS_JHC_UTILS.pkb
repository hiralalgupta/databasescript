set define off

create or replace
PACKAGE BODY IWS_JHC_UTILS AS

FUNCTION GET_META_COLUMN_NAME (P_CLIENTID  in  CLIENTS.CLIENTID%TYPE :=0)
  RETURN VARCHAR2
IS
  l_text  VARCHAR2(32767) := NULL;
BEGIN
 IF P_CLIENTID=0 THEN
  FOR CUR_REC IN (SELECT  MD.LABEL,MD.NAME AS META_NAME,MD.TYPE  FROM META_DEFINITION MD
                    WHERE  MD.SEARCHABLE='Y' ORDER BY ROWID) LOOP
       IF CUR_REC.TYPE='DATE' THEN
          L_TEXT := L_TEXT || ',to_char(' || CUR_REC.META_NAME ||',''MM-DD-YYYY'') AS "'||CUR_REC.LABEL||'"';
        
        else
    L_TEXT := L_TEXT || ',' || CUR_REC.META_NAME ||' AS "'||CUR_REC.LABEL||'"';
    end if;
  END LOOP;
 else
  FOR cur_rec IN (SELECT MD.LABEL,MC.META_NAME,md.type FROM META_DEFINITION MD,META_CLIENT MC
                    WHERE 
                    MC.CLIENTID=P_CLIENTID and
                    MD.NAME=MC.META_NAME AND  MD.SEARCHABLE='Y' AND MC.ISENABLED='Y'
                    order by MC.META_ORDER asc) LOOP
   -- l_text := l_text || ',' || cur_rec.META_NAME ||' AS "'||cur_rec.LABEL||'"';
    IF CUR_REC.TYPE='DATE' THEN
          L_TEXT := L_TEXT || ',to_char(' || CUR_REC.META_NAME ||',''MM-DD-YYYY'') AS "'||CUR_REC.LABEL||'"';
        
        else
    L_TEXT := L_TEXT || ',' || CUR_REC.META_NAME ||' AS "'||CUR_REC.LABEL||'"';
    end if;
  END LOOP;
 END IF;
 
  RETURN LTRIM(L_TEXT, ',');
END GET_META_COLUMN_NAME;

FUNCTION GET_META_COLUMN_JSON (P_CLIENTID  in  CLIENTS.CLIENTID%TYPE :=0)
  RETURN VARCHAR2
IS
  L_TEXT  varchar2(32767) := null;
BEGIN
 if P_CLIENTID=0 then
  for CUR_REC in (select  MD.LABEL,MD.name as META_NAME,MD.type from META_DEFINITION MD
                    where  MD.SEARCHABLE='Y' order by rowid) LOOP
    if CUR_REC.type='DATE' then
    L_TEXT := L_TEXT ||' TO_CHAR('||CUR_REC.META_NAME||',''MM-DD-YYYY'')' ||'||'||''''||'~~'||''''||'||';
    else
     L_TEXT := L_TEXT ||  CUR_REC.META_NAME||'||'||''''||'~~'||''''||'||';
     end if;
  END LOOP;
 else
  FOR cur_rec IN (SELECT MC.META_NAME,MD.type FROM META_DEFINITION MD,META_CLIENT MC
                    WHERE 
                    MC.CLIENTID=P_CLIENTID and
                    MD.NAME=MC.META_NAME AND  MD.SEARCHABLE='Y' AND MC.ISENABLED='Y'
                    order by MC.META_ORDER asc) LOOP
      if CUR_REC.type='DATE' then
    L_TEXT := L_TEXT ||' TO_CHAR('||CUR_REC.META_NAME||',''MM-DD-YYYY'')' ||'||'||''''||'~~'||''''||'||';
    else              
    L_TEXT := L_TEXT ||  CUR_REC.META_NAME||'||'||''''||'~~'||''''||'||';
    END IF;
  END LOOP;
 END IF;
     L_TEXT:=  LTRIM(L_TEXT, '~~');
     L_TEXT:=  RTRIM(L_TEXT,'||'||''''||'~~'||'''');
  RETURN L_TEXT;
END GET_META_COLUMN_JSON;

      
FUNCTION GET_META(V_CHVCODETYPE IN VARCHAR2) 
RETURN STACK_CODES_T PIPELINED AS
 r_cur SYS_REFCURSOR;
 r_cur_1       STACK_CODES_TYPE := STACK_CODES_TYPE(NULL, NULL);
    BEGIN
       Open r_cur for v_chvCodeType;
      LOOP
            FETCH r_cur 
            INTO 
                r_cur_1.Code,    
                r_cur_1.CodeDesc;
                
            EXIT WHEN r_cur%NOTFOUND;
            PIPE ROW(r_cur_1);
        END LOOP;
    CLOSE r_cur;
    RETURN;
  end GET_META;


PROCEDURE EditStack(
    caseIDs  IN VARCHAR2,
    APSOrder IN VARCHAR2,
    STACKCASEID OUT NUMBER,
    STATUSCODE OUT NUMBER ,
    STATUSMESSAGE OUT VARCHAR2, 
    USERID IN NUMBER) AS
    
    V_caseIDs    APEX_APPLICATION_GLOBAL.VC_ARR2;
    V_APSORDER    APEX_APPLICATION_GLOBAL.VC_ARR2;
    V_COUNT NUMBER:=0;
    V_NUM NUMBER :=0;
    V_STACK_CASEID NUMBER :=0;
    V_NEW_CASES CASES%ROWTYPE; 
    V_TOTAL_PAGE NUMBER:=0;
    V_SEQ NUMBER :=0;
    V_MSG VARCHAR2(3200):='';
    V_SRNUM varchar2(500) :='';
    

     V_DUP NUMBER :=0;
     V_COUNT_SEQ NUMBER :=0;
     V_NUM_SEQ number :=0;
     V_USERID NUMBER;
     V_PAGE_COUNT NUMBER :=0;
     V_APS_F_EXTENSION VARCHAR2(10);
BEGIN

   
   V_CASEIDS := APEX_UTIL.STRING_TO_TABLE(caseIDs);
   V_APSORDER := APEX_UTIL.STRING_TO_TABLE(APSORDER);
   
    STATUSCODE :=0;
   
   IF REGEXP_COUNT(CASEIDS,':')<>REGEXP_COUNT(APSORDER,':') THEN
    STATUSCODE := 100;
		STATUSMESSAGE := 'stackCaseID and APSOrder is not same size.';
    LOG_APEX_ERROR(89,'Stack Case',STATUSMESSAGE,USERID);
    RETURN;
   END IF;
   
   --Check duplicate APSOrder no.
   SELECT COUNT(DISTINCT COLUMN_VALUE) INTO V_DUP FROM TABLE(GETSPLIT(APSORDER,':'));
   IF V_DUP <> (REGEXP_COUNT(APSORDER,':')+1) THEN
        STATUSCODE := 200;
        STATUSMESSAGE := 'APSOrder array conatin either duplicate value or null.';
        LOG_APEX_ERROR(89,'Stack Case',STATUSMESSAGE,USERID);
        RETURN;
   END IF;
   
   BEGIN
     SELECT COUNT(T.COLUMN_VALUE) INTO V_DUP FROM TABLE(GETSPLIT(caseIDs,':')) T,
      CASES C WHERE (C.CASEID=T.COLUMN_VALUE OR C.STACK_CASEID=T.COLUMN_VALUE) AND C.STAGEID=31;
      IF V_DUP = 1 THEN
        STATUSCODE := 300;
        STATUSMESSAGE := 'caseIDs array is in published Stage.';
        LOG_APEX_ERROR(89,'Stack Case',STATUSMESSAGE,USERID);
        RETURN;
     end if;
       select COUNT(distinct C.CLIENTID)  into V_DUP from table(GETSPLIT(CASEIDS,':')) T,
          CASES C where C.CASEID=T.column_value;
          if V_DUP!=1 then
           STATUSCODE := 300;
           STATUSMESSAGE := 'caseIDs array is not belong in same client.';
           LOG_APEX_ERROR(89,'Stack Case',STATUSMESSAGE,USERID);
          RETURN;
          END IF;
     EXCEPTION 
      WHEN OTHERS THEN
        STATUSCODE := 300;
        STATUSMESSAGE := 'caseIDs array is in published Stage or stack case.';
        LOG_APEX_ERROR(89,'Stack Case',STATUSMESSAGE,USERID);
        RETURN;
   end;
   
   BEGIN
     SELECT COUNT(T.COLUMN_VALUE) INTO V_DUP FROM TABLE(GETSPLIT(caseIDs,':')) T,
      CASES C WHERE C.CASEID=T.COLUMN_VALUE AND C.IS_STACK='Y';
      
      IF V_DUP <>0 THEN
        STATUSCODE := 400;
        STATUSMESSAGE := 'caseIDs array are in more than 1 stack casese.';
        LOG_APEX_ERROR(89,'Stack Case',STATUSMESSAGE,USERID);
        RETURN;
      END IF;
   END;
  
 --check Stack_caseId is either fresh or not.
 begin
     SELECT DISTINCT C.STACK_CASEID INTO V_NUM FROM TABLE(GETSPLIT(CASEIDS,':')) T,
      CASES C WHERE C.CASEID=T.COLUMN_VALUE  AND C.STACK_CASEID IS NOT NULL;
      EXCEPTION
       WHEN OTHERS THEN
        SELECT COUNT(C.STACK_CASEID) INTO V_NUM FROM TABLE(GETSPLIT(CASEIDS,':')) T,
           CASES C WHERE C.CASEID=T.COLUMN_VALUE ;
end;
 
  -- iws_app_utils.Show_Stage_Status(caseid);
  BEGIN
   FOR REC IN 1..V_APSORDER.COUNT LOOP
   V_COUNT_SEQ:=V_COUNT_SEQ +1;
   
   V_NUM_SEQ :=V_APSORDER(REC);
   
   IF V_NUM_SEQ=1 THEN
   NULL;
   EXIT;
   END IF;
  
   END LOOP;
  END;



 
  
  SELECT CLIENTID,LANGUAGEID,CLIENTFILENAME,CLIENTCASENUMBER,ISTEST,ISANONYMOUS,ISPURGED,VERSION,ISINTERNALTEST ,CODE_TYPE,CODE_VERSION,HIERARCHYREVISION,ORIGINALCONTENTID,RECEIPTTIMESTAMP,PAPERSIZE,CREATED_USERID
  INTO V_NEW_CASES.CLIENTID,V_NEW_CASES.LANGUAGEID,V_NEW_CASES.CLIENTFILENAME,V_NEW_CASES.CLIENTCASENUMBER,V_NEW_CASES.ISTEST,V_NEW_CASES.ISANONYMOUS,V_NEW_CASES.ISPURGED,V_NEW_CASES.VERSION,
  V_NEW_CASES.ISINTERNALTEST ,V_NEW_CASES.CODE_TYPE,V_NEW_CASES.CODE_VERSION,V_NEW_CASES.HIERARCHYREVISION,V_NEW_CASES.ORIGINALCONTENTID,V_NEW_CASES.RECEIPTTIMESTAMP,V_NEW_CASES.PAPERSIZE,V_NEW_CASES.CREATED_USERID  FROM CASES WHERE CASEID =V_CASEIDS(V_COUNT_SEQ) AND ROWNUM=1;
   
 
   --JHC-65 : APS_FILE_NAME and CLIENTFILENAME values calculation
   --V_NEW_CASES.CLIENTFILENAME := IWS_JHC_UTILS.ST_CLIENTFILENAME(V_NEW_CASES.CLIENTFILENAME);
   SELECT SR_NUM INTO V_SRNUM FROM CASE_META WHERE CASEID=V_CASEIDS(1);
   V_NEW_CASES.CLIENTCASENUMBER := 'F1_' || V_SRNUM;
   V_NEW_CASES.CLIENTFILENAME := V_NEW_CASES.CLIENTCASENUMBER || '.pdf';
   
   If V_Num = 0 Then
          INSERT INTO CASES(CLIENTID,LANGUAGEID,CLIENTFILENAME,CLIENTCASENUMBER,IS_STACK,FILESIZE,PAPERSIZE,ORIGINALCONTENTID,RECEIPTTIMESTAMP,PRIORITY,APS_SEQUENCE,STAGEID,ISTEST,ISANONYMOUS,ISPURGED,VERSION,STATUS,ISINTERNALTEST ,CODE_TYPE,CODE_VERSION,HIERARCHYREVISION,CREATED_USERID,CREATED_STAGEID) 
          Values (V_New_Cases.Clientid,V_New_Cases.Languageid,V_New_Cases.Clientfilename,V_New_Cases.Clientcasenumber,'Y',0,V_New_Cases.Papersize,V_New_Cases.Originalcontentid,V_New_Cases.Receipttimestamp,'Normal',1,6,V_New_Cases.Istest,V_New_Cases.Isanonymous,V_New_Cases.Ispurged,V_New_Cases.Version,'Stack created',V_New_Cases.Isinternaltest ,
          V_NEW_CASES.CODE_TYPE,V_NEW_CASES.CODE_VERSION,V_NEW_CASES.HIERARCHYREVISION,V_NEW_CASES.CREATED_USERID,6)
           RETURNING CASEID INTO V_STACK_CASEID;
     
     --- FINDOUT A FILE EXTENSION NAME
       --SELECT SUBSTR(APS_FILE_NAME,-INSTR(REVERSE(APS_FILE_NAME),'.'),5) INTO V_APS_F_EXTENSION FROM  CASE_META WHERE CASEID=V_CASEIDS(V_COUNT_SEQ); 
        --V_NEW_CASES.CLIENTCASENUMBER := V_NEW_CASES.CLIENTCASENUMBER||V_APS_F_EXTENSION;
        
    INSERT INTO CASE_META(CASEID,POLICY_NUMBER,APPLICANT_NAME,AGE,FACE_VALUE,FORMAL,FIRM,OPTY,APS_COUNT,WF_INDICATOR,SUM_IND,LTC_IND,SR_NUM,SR_CREATE_DATE,APS_FILE_NAME,FRST_NAME,LST_NAME,POL_NUM,PAGE_COUNT,SB_TEAM,OPTY_ID,INS_SEX,INS_DOB,POL_FC_AMNT,OPTY_TYPE,STATUS,ICD_CD,ICD_VER,ICD_DESC,SBMT_DATE,JHUSER_ID,SOURCE_SYSTEM) 
      select V_STACK_CASEID,POLICY_NUMBER,APPLICANT_NAME,AGE,FACE_VALUE,FORMAL,FIRM,OPTY,APS_COUNT,WF_INDICATOR,SUM_IND,LTC_IND,SR_NUM,SR_CREATE_DATE,V_NEW_CASES.CLIENTFILENAME,FRST_NAME,LST_NAME,POL_NUM,PAGE_COUNT,SB_TEAM,OPTY_ID,INS_SEX,INS_DOB,POL_FC_AMNT,OPTY_TYPE,STATUS,ICD_CD,ICD_VER,ICD_DESC,SBMT_DATE,JHUSER_ID,SOURCE_SYSTEM from CASE_META where CASEID=V_CASEIDS(V_COUNT_SEQ);  
           STATUSMESSAGE:='Generate new CaseIds are ';--||V_STACK_CASEID||'.';
   
   ELSE
  begin
          V_STACK_CASEID := V_NUM; 
          SELECT USERID into V_USERID FROM casehistorysum WHERE assignmentstarttimestamp IS NOT NULL AND assignmentcompletiontimestamp IS NULL AND caseid=V_STACK_CASEID and rownum=1;
--   UPDATE CASES SET PAPERSIZE=V_NEW_CASES.PAPERSIZE,ORIGINALCONTENTID=V_NEW_CASES.ORIGINALCONTENTID,ISTEST=V_NEW_CASES.ISTEST,ISANONYMOUS=V_NEW_CASES.ISANONYMOUS,ISPURGED=V_NEW_CASES.ISPURGED,VERSION=V_NEW_CASES.VERSION,ISINTERNALTEST=V_NEW_CASES.ISINTERNALTEST ,CODE_TYPE=V_NEW_CASES.CODE_TYPE,
--   CODE_VERSION=V_NEW_CASES.CODE_VERSION,HIERARCHYREVISION=V_NEW_CASES.HIERARCHYREVISION,CREATED_USERID=V_NEW_CASES.CREATED_USERID WHERE CASEID =V_STACK_CASEID AND ROWNUM=1;
--  
--   SELECT CASEID,POLICY_NUMBER,APPLICANT_NAME,AGE,FACE_VALUE,FORMAL,FIRM,OPTY,APS_COUNT,WF_INDICATOR INTO CASEID,POLICY_NUMBER,APPLICANT_NAME,AGE,FACE_VALUE,FORMAL,FIRM,OPTY,APS_COUNT,WF_INDICATOR FROM CASE_META WHERE 
           STATUSMESSAGE:=' Updated Memeber CaseIds are ';
    EXCEPTION
      when OTHERS then
         NULL;
--       STATUSMESSAGE :='An error was encountered - '||SQLCODE||' - '||SQLERRM;
--       STATUSCODE := 401;
--        return;
  end;
   END IF;
  
  BEGIN
  
      
       FOR REC IN 1..V_CASEIDS.COUNT LOOP
        V_COUNT := V_COUNT +1;  
        
        
            SELECT COUNT(1) INTO V_SEQ FROM CASES WHERE CASEID=V_CASEIDS (REC) AND STACK_CASEID IS NOT NULL;   
        
        
        UPDATE CASES SET STACK_CASEID=V_STACK_CASEID,APS_SEQUENCE=V_APSORDER(V_COUNT) WHERE CASEID=V_CASEIDS(REC) 
              RETURNING STAGEID,USERID INTO V_NEW_CASES.STAGEID,V_NEW_CASES.USERID;
        
       
             V_MSG := V_MSG ||'['||V_CASEIDS (REC)||'::'||V_APSORDER(V_COUNT)||']';
       
         IF V_SEQ=0 THEN  
                  
             UPDATE PAGES SET CASEID=V_STACK_CASEID,ORIGINALCASEID=V_CASEIDS (REC) WHERE CASEID=V_CASEIDS (REC);
        
      
        --call updatePageNumberingForStack(stack case id)
         
          UPDATEPAGENUMBERINGFORSTACK(
                                   STACKCASEID => V_STACK_CASEID,
                                   STATUSCODE => STATUSCODE,
                                   STATUSMESSAGE => STATUSMESSAGE,
                                   USERID => USERID);
                                   
            IF STATUSCODE != 0 THEN
            ROLLBACK;
            	statusMessage := statusMessage;
              LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
            RETURN ;
            END IF;
        
            INSERT INTO QCAICODES(CASEID,DPENTRYID,RETURNSTATUS,RETURNVALUE,CONFIDENCE,REASONING,ISCODEACCEPTED,CREATED_TIMESTAMP,CREATED_USERID,CREATED_STAGEID,UPDATED_TIMESTAMP,UPDATED_USERID,UPDATED_STAGEID,RELEVANCE,RANKING,RULENAME)
              SELECT V_STACK_CASEID,DPENTRYID,RETURNSTATUS,RETURNVALUE,CONFIDENCE,REASONING,ISCODEACCEPTED,CREATED_TIMESTAMP,CREATED_USERID,CREATED_STAGEID,UPDATED_TIMESTAMP,UPDATED_USERID,UPDATED_STAGEID,RELEVANCE,RANKING,RULENAME FROM
              QCAICODES WHERE CASEID=V_CASEIDS (REC);
        
            INSERT INTO SYNIDGROUPMAP(GROUPID,GROUPNAME,ISSUPPORTING,CREATED_BY,CREATED_TIMESTAMP,UPDATED_BY,UPDATED_TIMESTAMP,CASEID)
            SELECT GROUPID,GROUPNAME,ISSUPPORTING,CREATED_BY,CREATED_TIMESTAMP,UPDATED_BY,UPDATED_TIMESTAMP,V_STACK_CASEID FROM SYNIDGROUPMAP WHERE CASEID=V_CASEIDS (REC);
            
       
        --CALL CASEHISTORY_UTILS.Stagehop
        
        	 CASEHISTORY_UTILS.STAGEHOP(
					    P_CASEID =>V_CASEIDS (REC),
					    P_STAGEID =>70,
					    P_USERID =>USERID,--V_NEW_CASES.USERID,   
					    P_ASSIGNED_TO => NULL, 
						  P_ASSIGNMENT_REASON => NULL,
						  P_NOTES => NULL
					   );
             
        ELSE
          statusMessage :=V_STACK_CASEID;
         UPDATEPAGENUMBERINGFORSTACK(
                                   STACKCASEID => V_STACK_CASEID,
                                   STATUSCODE => STATUSCODE,
                                   STATUSMESSAGE => STATUSMESSAGE,
                                   USERID => USERID);
                                   
            IF STATUSCODE != 0 THEN
            ROLLBACK;
              STACKCASEID :=V_STACK_CASEID;
            	statusMessage :='An error was encountered - '||SQLCODE||' - '||SQLERRM;
              LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
            RETURN ;
            END IF;
           END IF;
       END LOOP;
          IWS_APP_UTILS.SEGMENTFILEFORINDEXING (P_CASEID =>V_STACK_CASEID, P_CLEAR_RECORDS => 'Y');
          
           IF V_NUM = 0 OR V_USERID IS NULL THEN
          CASEHISTORY_UTILS.STAGEHOP(P_CASEID =>V_STACK_CASEID,
					    P_STAGEID =>6,
					    P_USERID =>USERID,   
					    P_ASSIGNED_TO => USERID, 
						  P_ASSIGNMENT_REASON => null,
						  P_NOTES => null);
         else
          if V_USERID is not null and  NVL(USERID,0)!=NVL(V_USERID,0) then
                
           CASEHISTORY_UTILS.STAGEHOP(P_CASEID =>V_STACK_CASEID,
					    P_STAGEID =>6,
					    P_USERID =>USERID,   
					    P_ASSIGNED_TO => V_USERID, 
						  P_ASSIGNMENT_REASON => null,
						  P_NOTES => null);
         
          END IF;
          END IF;
        
       UPDATE CASES SET TOTALPAGES=(SELECT SUM(TOTALPAGES) FROM CASES WHERE STACK_CASEID=V_STACK_CASEID) WHERE CASEID=V_STACK_CASEID RETURNING TOTALPAGES into V_PAGE_COUNT;
         UPDATE CASE_META SET PAGE_COUNT=V_PAGE_COUNT WHERE CASEID=V_STACK_CASEID;
      
    
       STATUSMESSAGE:= STATUSMESSAGE || V_MSG;
       STACKCASEID := V_STACK_CASEID;
       STATUSCODE := 0;
       LOG_APEX_ACTION (
               P_USERID  => USERID,
               P_ACTIONID  => 89,
               P_RESULTS  => 'EditStack successful',
               P_CASEID => STACKCASEID,
			         P_ORIGINALVALUE   => STATUSMESSAGE
			   );
       COMMIT;
      EXCEPTION 
        WHEN OTHERS THEN
          ROLLBACK;
          STACKCASEID := V_STACK_CASEID ;
          STATUSCODE := 301;
          statusMessage := 'An error was encountered - '||SQLCODE||' - '||SQLERRM;
          LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
      END;

End EditStack;

PROCEDURE updatePageNumberingForStack (
   stackCaseID  IN VARCHAR2,
   STATUSCODE OUT NUMBER,
   STATUSMESSAGE OUT VARCHAR2,
   USERID IN  NUMBER) As
   	v_dummy varchar2(100);
Begin
	--Check that the stack case ID is a stack; otherwise throw error code 100
	Begin
		select IS_STACK into v_dummy from cases where caseid=stackCaseID and IS_STACK='Y';
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		STATUSCODE := 107;
		statusMessage :=stackCaseID||' is not a stack.';
    LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
		return;
	END;
	
	--Check that the stack is not empty; otherwise throw error code 200
	BEGIN
		select IS_STACK into v_dummy from cases where STACK_CASEID=stackCaseID and IS_STACK='N' and rownum=1;
	EXCEPTION
	WHEN OTHERS THEN
		rollback;
		statusCode := 200;
		statusMessage := stackCaseID ||' is an empty stack.';
    LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
		return;
	END;
	
	Begin
		/*Reassign original page numbers in pages table for a stack in sequential order 
		based on APS_SEQUENCE and existing original page numbers*/
		UPDATE pages pg
		SET pg.ORIGINALPAGENUMBER =
		  (SELECT fs.newORIGINALPAGENUMBER
		  FROM
			(SELECT rownum newORIGINALPAGENUMBER, ORIGINALPAGENUMBER_APS, APS_SEQUENCE
			FROM
			  (select p1.ORIGINALPAGENUMBER_APS,c1.APS_SEQUENCE from pages p1, cases c1 where p1.caseid = stackCaseID 
					  and p1.originalCaseID = c1.caseid
					  --and p1.isdeleted = 'N'
					  group by c1.APS_SEQUENCE, p1.ORIGINALPAGENUMBER_APS
					  order by c1.APS_SEQUENCE
			  )
			) fs
		  WHERE fs.ORIGINALPAGENUMBER_APS = pg.ORIGINALPAGENUMBER_APS
			and fs.APS_SEQUENCE = (select c2.APS_SEQUENCE from cases c2 where pg.originalCaseID = c2.caseid)
		  )
		WHERE pg.caseid = stackCaseID;
		commit;
	EXCEPTION
	WHEN OTHERS THEN
		rollback;
		statusCode := 300;
		statusMessage := 'An error was encountered with stack '||stackCaseID||' - '||SQLCODE||' - '||SQLERRM;
    LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
		return;
	END;
	
	Begin		
		/*Reassign Subdocumentorder numbers in pages table for a stack in sequential order 
		based on APS_SEQUENCE and existing Subdocumentorder numbers*/
		UPDATE pages pg
		SET pg.subdocumentorder=
		  (SELECT fs.newsubdocumentorder
		  FROM
			(SELECT rownum newsubdocumentorder, subdocumentorder_APS, APS_SEQUENCE
			FROM
			  (select p1.subdocumentorder_APS, c1.APS_SEQUENCE from pages p1, cases c1 where p1.caseid = stackCaseID 
					  and p1.originalCaseID = c1.caseid
					  and p1.isdeleted = 'N'
					  group by c1.APS_SEQUENCE, p1.subdocumentorder_APS
					  order by c1.APS_SEQUENCE
			  )
			) fs
		  WHERE fs.subdocumentorder_APS = pg.subdocumentorder_APS
			and fs.APS_SEQUENCE = (select c2.APS_SEQUENCE from cases c2 where pg.originalCaseID = c2.caseid)
		  )
		WHERE pg.caseid = stackCaseID
		and isdeleted = 'N';
		commit;
	EXCEPTION
	WHEN OTHERS THEN
		rollback;
		statusCode := 400;
		statusMessage := 'An error was encountered with stack '||stackCaseID||' - '||SQLCODE||' - '||SQLERRM;
    LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
		return;
	END;
	
	Begin		
		--assign final page numbers by "descending document date + ascending document number + ascending page number"
		UPDATE pages pg
		SET pg.finalpagenumber=
		  (SELECT fs.finalpagenumber
		  FROM
			(SELECT rownum finalpagenumber,
			  pageid
			FROM
			  (SELECT pageid
			  FROM pages
			  WHERE caseid = stackCaseID
			  AND isdeleted='N'
			  ORDER BY DOCUMENTDATE DESC,
				SUBDOCUMENTORDER ASC,
				SUBDOCUMENTPAGENUMBER ASC
			  )
			) fs
		  WHERE fs.pageid = pg.pageid
		  )
		WHERE pg.caseid = stackCaseID
		and isdeleted = 'N';
		commit;
	EXCEPTION
	WHEN OTHERS THEN
		rollback;
		statusCode := 500;
		statusMessage := 'An error was encountered with stack '||stackCaseID||' - '||SQLCODE||' - '||SQLERRM;
    LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
		return;
	END;
End updatePageNumberingForStack;

FUNCTION GETSPLIT
(
    P_LIST VARCHAR2,
    P_DEL VARCHAR2 := ','
) RETURN SPLIT_TBL PIPELINED
IS
    L_IDX    PLS_INTEGER;
    L_LIST    VARCHAR2(32767) := P_LIST;

    L_VALUE VARCHAR2(32767);
BEGIN
    LOOP
        L_IDX := INSTR(L_LIST,P_DEL);
        IF L_IDX > 0 THEN
            PIPE ROW(SUBSTR(L_LIST,1,L_IDX-1));
            L_LIST := SUBSTR(L_LIST,L_IDX+LENGTH(P_DEL));

        ELSE
            PIPE ROW(L_LIST);
            EXIT;
        END IF;
    END LOOP;
    RETURN;
END GETSPLIT;

PROCEDURE DeleteCasesFromStack (CASEIDS IN VARCHAR2,STATUSCODE OUT NUMBER,STATUSMESSAGE OUT VARCHAR2,USERID IN NUMBER)
AS
V_DUMMY NUMBER :=0;
V_COUNT NUMBER :=0;
V_MSG_RM_CASES VARCHAR2(2000):='';
V_TOTALPAGES NUMBER :=0;
V_STACK_CASEID NUMBER :=0;
V_PAGE_COUNT NUMBER :=0;
BEGIN

  SELECT COUNT(1) INTO V_DUMMY FROM TABLE(GETSPLIT(CASEIDS,':')) T ,
      CASES C WHERE C.CASEID=T.COLUMN_VALUE AND (C.STAGEID=31 OR C.STACK_CASEID IS NULL);
      IF V_DUMMY = 1 THEN
        ROLLBACK;
        STATUSCODE := 600;
        STATUSMESSAGE := 'caseIDs array is in either published Stage or not in Stack cases.';
        LOG_APEX_ERROR(89,'Stack Case',STATUSMESSAGE,USERID);
        RETURN;
     END IF;
    
  BEGIN  
  SELECT distinct C.STACK_CASEID INTO V_DUMMY FROM TABLE(GETSPLIT(CASEIDS,':')) T ,
      CASES C WHERE C.CASEID=T.COLUMN_VALUE GROUP BY C.STACK_CASEID;
  EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        STATUSCODE := 600;
        STATUSMESSAGE := 'caseIDs array is in more then one Stack cases.';
        LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
        RETURN;
  END;
    
    BEGIN 
    
    SELECT  SUM(TOTALPAGES),STACK_CASEID INTO V_TOTALPAGES,V_STACK_CASEID FROM CASES WHERE CASEID IN (SELECT T.COLUMN_VALUE FROM TABLE(GETSPLIT(CASEIDS,':')) T)
      GROUP BY STACK_CASEID;  
    
     UPDATE CASES SET TOTALPAGES=TOTALPAGES-V_TOTALPAGES WHERE CASEID=V_STACK_CASEID RETURNING TOTALPAGES INTO V_PAGE_COUNT;
     UPDATE CASE_META SET PAGE_COUNT=V_PAGE_COUNT  WHERE CASEID=V_STACK_CASEID;

    
      UPDATE CASES SET STACK_CASEID=NULL, APS_SEQUENCE=1 WHERE CASEID IN (SELECT T.COLUMN_VALUE FROM TABLE(GETSPLIT(CASEIDS,':')) T);
   
      UPDATE PAGES SET CASEID=originalCaseID, ORIGINALPAGENUMBER=ORIGINALPAGENUMBER_APS,SUBDOCUMENTORDER=SUBDOCUMENTORDER_APS, FINALPAGENUMBER=FINALPAGENUMBER_APS
       WHERE originalCaseID IN (SELECT T.COLUMN_VALUE FROM TABLE(GETSPLIT(CASEIDS,':')) T);
    
       DELETE FROM QCAICODES  WHERE CASEID = V_DUMMY;
       DELETE FROM SYNIDGROUPMAP  WHERE CASEID = V_DUMMY;
       
       V_MSG_RM_CASES := 'Successfully removed CaseId(s) [';
       FOR I IN (SELECT T.COLUMN_VALUE FROM TABLE(GETSPLIT(CASEIDS,':')) T) LOOP
        BEGIN
        V_MSG_RM_CASES := V_MSG_RM_CASES||I.COLUMN_VALUE||',';
        
        CASEHISTORY_UTILS.STAGEHOP(P_CASEID =>I.COLUMN_VALUE,
					    P_STAGEID =>6,
					    P_USERID =>USERID,   
					    P_ASSIGNED_TO => NULL, 
						  P_ASSIGNMENT_REASON => NULL,
						  P_NOTES => NULL);
        END;
       END LOOP;
        V_MSG_RM_CASES := RTRIM(V_MSG_RM_CASES,',');
        V_MSG_RM_CASES :=V_MSG_RM_CASES|| '] from the StackCaseId: '||V_DUMMY||'.';
      EXCEPTION
       WHEN OTHERS THEN
        ROLLBACK;
        STATUSCODE := 700;
        STATUSMESSAGE := 'An error was encountered - '||SQLCODE||' - '||SQLERRM;
        LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
        RETURN;
   END;
   
   
   
   BEGIN
   
   
   
   --No member case attached with existning Stack case
  
   SELECT COUNT(1) INTO V_COUNT FROM CASES WHERE STACK_CASEID=V_DUMMY;
   IF V_COUNT= 0 THEN
   
   CASEHISTORY_UTILS.STAGEHOP(P_CASEID =>V_DUMMY,
					    P_STAGEID =>70,
					    P_USERID =>USERID,   
					    P_ASSIGNED_TO => NULL, 
						  P_ASSIGNMENT_REASON => NULL,
						  P_NOTES => NULL);
    UPDATE CASES SET IS_STACK='N',APS_SEQUENCE=0 WHERE CASEID=V_DUMMY;
    ELSE
    --If any member case is attached with existing Stack case.
    --Maintain Ordering after remove member case from existing stack.
     BEGIN
        MERGE INTO CASES U
        USING (
          SELECT CASEID, ROW_NUMBER() OVER (ORDER BY APS_SEQUENCE) RNUM 
          FROM CASES WHERE  STACK_CASEID =V_DUMMY
        ) S
        ON (U.CASEID = S.CASEID)
        WHEN MATCHED THEN UPDATE SET U.APS_SEQUENCE = S.RNUM;
        
        begin
       -- FOR I IN (SELECT CASEID FROM CASES WHERE STACK_CASEID=V_DUMMY) LOOP
        UPDATEPAGENUMBERINGFORSTACK (
                    STACKCASEID  =>V_DUMMY,
                    STATUSCODE =>STATUSCODE,
                    STATUSMESSAGE =>STATUSMESSAGE,
                    USERID => USERID);
       -- END LOOP;
        END;
           EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                STATUSCODE := 701;
                STATUSMESSAGE := 'An error was encountered - '||SQLCODE||' - '||SQLERRM;
                LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
                RETURN;
        END;
   END IF;
   END;
   
   STATUSCODE :=0;
   STATUSMESSAGE :=V_MSG_RM_CASES;
   LOG_APEX_ACTION (
               P_USERID  => USERID,
               P_ACTIONID  => 89,
               P_RESULTS  => 'DeleteCasesFromStack successful',
               P_CASEID => V_STACK_CASEID,
			         P_ORIGINALVALUE   => STATUSMESSAGE
			   );
   COMMIT;
  EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
        STATUSCODE := 800;
        STATUSMESSAGE := 'An error was encountered - '||SQLCODE||' - '||SQLERRM;
        LOG_APEX_ERROR(89,'Stack Case',statusMessage,USERID);
        RETURN;
 --DBMS_OUTPUT.PUT_LINE('test');
END DELETECASESFROMSTACK;

FUNCTION ST_CLIENTFILENAME(
    P_FILENAME IN VARCHAR2)
  RETURN VARCHAR2
AS
  V_STR_FILENAME VARCHAR2(500):='';
  V_STR          varchar2(500):='';
  V_TXT          VARCHAR2(2)  :='';
  V_UNDERSCORE   VARCHAR2(1)  :='';
  V_COUNT NUMBER       :=0;
 
BEGIN
  SELECT SUBSTR(P_FILENAME,-INSTR(REVERSE(P_FILENAME),'.'),5)
  INTO V_STR_FILENAME
  FROM DUAL;
  SELECT SUBSTR(P_FILENAME,1,LENGTH(P_FILENAME)-INSTR(REVERSE(P_FILENAME),'.'))
  INTO V_STR
  FROM DUAL;


 -- V_UNDERSCORE   := SUBSTR(V_STR,INSTR(V_STR,REGEXP_SUBSTR(V_STR,'[[:digit:]]+$'))-1,1);
    SELECT  SUBSTR(REVERSE(V_STR),LENGTH(REGEXP_SUBSTR(V_STR,'[[:digit:]]+$'))+1,1) INTO V_UNDERSCORE FROM DUAL;
  IF V_UNDERSCORE ='_' THEN
    V_COUNT := INSTR(V_STR,'_',1,  REGEXP_COUNT(V_STR,'_'));
    V_STR := SUBSTR(V_STR,1,V_COUNT);
    V_STR := V_STR||'ST'||V_STR_FILENAME;
  ELSE
    IF  SUBSTR(V_STR,-1,1)='_' THEN
        V_STR := V_STR||'ST'||V_STR_FILENAME;
    ELSE
        V_STR := V_STR||'_ST'||V_STR_FILENAME;
    END IF;
  END IF;
  

  RETURN V_STR;
END;
/* This function used to check datatype for search screen*/
FUNCTION FINDOUTDATE(P_DATE IN VARCHAR2,P_VALUE IN VARCHAR2)
RETURN VARCHAR2
AS
v_str_type VARCHAR2(1000):='';
v_str_label VARCHAR2(1000):='';
V_STR  VARCHAR2(32000):='';
BEGIN
 SELECT TYPE,T.COLUMN_VALUE INTO V_STR_TYPE,V_STR_LABEL FROM META_DEFINITION,(SELECT COLUMN_VALUE FROM TABLE(IWS_JHC_UTILS.GETSPLIT(P_DATE))) T WHERE 
     label=t.COLUMN_VALUE and rownum=1;
     IF V_STR_TYPE='DATE' THEN
           V_STR := ' and trunc(To_date("'||P_DATE||'",''MM-DD-YYYY'')) = trunc(to_date('''||P_VALUE||''',''MM-DD-YYYY'')) ';
--        ELSIF V_STR_TYPE  ='TIMESTAMP' THEN
--             V_STR :=  ' and trunc("'||P_DATE||'") = trunc(to_date('''||P_VALUE||''',''MM-DD-YYYY'')) ';
        ELSIF V_STR_TYPE  ='TIMESTAMP' THEN
             IF LENGTH(P_VALUE)=10 THEN
               V_STR :=  ' and TO_CHAR("'||P_DATE||'",''MM-DD-YYYY'')='''||P_VALUE||''' ';
             ELSE
             V_STR :=  ' and TO_CHAR("'||P_DATE||'",''MM-DD-YYYY'') BETWEEN '||P_VALUE||' ';
             END IF;
        ELSIF V_STR_TYPE  ='NUMOPERATOR' then
             V_STR := ' and upper("'||P_DATE||'") '||P_VALUE||'  ';
        ELSIF   V_STR_TYPE='LOV' THEN
             V_STR :=   ' and upper("'||P_DATE||'") = upper('''||P_VALUE||''') ';
        ELSE
             V_STR := ' and instr(upper("'||P_DATE||'"),upper('''||P_VALUE||''')) > 0 ';       
    END IF;
    v_str := v_str;
  RETURN v_str;
END FINDOUTDATE;

PROCEDURE AUTOSTACK
-- Created new stackcases and genrate sequence for member cases order by receipttimestamp desc.
-- Cursor used to fetch of stackcases for their member cases
AS
 CURSOR REC IS SELECT CASEIDS,APS_SEQUENCES,POL_NUM,CLIENTID,SR_NUM,APS_COUNT FROM
(SELECT LISTAGG(CASEID, ',') within GROUP (ORDER BY APS_SEQUENCE) AS CASEIDS,
  LISTAGG(APS_SEQUENCE, ',') WITHIN GROUP (ORDER BY APS_SEQUENCE) AS APS_SEQUENCES,
  APS_COUNT,  POL_NUM,CLIENTID,SR_NUM
FROM
  (SELECT C.RECEIPTTIMESTAMP,
    CM.CASEID,
    CM.APS_COUNT,
    CM.POL_NUM,CM.SR_NUM,
    ROW_NUMBER() over (partition BY CM.POL_NUM,CL.CLIENTID order by RECEIPTTIMESTAMP ASC) APS_SEQUENCE,
    CL.CLIENTID
  FROM CASE_META CM,
    CASES C,
    CLIENTS CL,
    USERS U,
    GET_CASE_STAGE_STATUS_V H
  WHERE CM.APS_COUNT        > 1
  --AND NVL(CM.SUM_IND,1)     = 1
  and  C.CASEID             = CM.CASEID
  and CL.CLIENTID           = C.CLIENTID
  AND CM.CASEID             = C.CASEID
  AND C.CASEID              = H.CASEID
  AND C.IS_STACK            = 'N'
  AND H.USERID              = U.USERID (+)
  AND NVL(C.APS_SEQUENCE,1)<>0
  AND H.STAGEID=6
  AND H.USERID IS NULL
 
  )
GROUP BY APS_COUNT,SR_NUM,
  POL_NUM,CLIENTID) WHERE POL_NUM IS NOT NULL AND SR_NUM IS NOT NULL AND (REGEXP_COUNT(CASEIDS,',')+1) = APS_COUNT;
  
 V_STATUSCODE number:=0; 
 V_STATUSMESSAGE varchar2(100):='Automatic Stack Case';
 V_STACKCASEID number;
 V_MSG VARCHAR2(2000):='';
 V_SR_SUM NUMBER :=0;
 V_POL_NUM NUMBER :=0;
 V_COUNT NUMBER :=0; 
 V_NUM number :=0; 
 V_CHK_STACK NUMBER :=0;
begin
FOR I IN REC LOOP
  
    --  SELECT COUNT(SR_NUM),COUNT(POL_NUM) INTO V_SR_SUM,V_POL_NUM FROM CASE_META WHERE POL_NUM=I.POL_NUM AND SR_NUM=I.SR_NUM AND CASEID NOT IN (SELECT CASEID FROM CASES WHERE APS_SEQUENCE=0 AND IS_STACK='Y');
    --   IF V_SR_SUM=V_POL_NUM  THEN
    --  DBMS_OUTPUT.PUT_LINE('test2 ::'||V_MSG);
       I.CASEIDS := REPLACE(I.CASEIDS,',',':');
       I.APS_SEQUENCES := REPLACE(I.APS_SEQUENCES,',',':');
        EDITSTACK(
          CASEIDS  =>I.CASEIDS,
          APSORDER =>I.APS_SEQUENCES,
          STACKCASEID =>V_STACKCASEID,
          STATUSCODE =>V_STATUSCODE ,
          STATUSMESSAGE=>V_STATUSMESSAGE, 
          USERID =>NULL);
          V_MSG := V_MSG || V_STACKCASEID;
          
        IF V_STATUSCODE=0 THEN
         LOG_APEX_ACTION (
               P_STAGEID => 6,
               P_ACTIONID  => 89,
               P_RESULTS  => 'Automatic stacking successful',
               P_CASEID => V_STACKCASEID,
			         P_ORIGINALVALUE   => V_STATUSMESSAGE
			   );
        ELSE
          LOG_APEX_ERROR(P_ACTIONID =>89,P_ACTIONNAME =>'Automatic Stack Case',P_CONTENT =>V_STATUSMESSAGE);
        END IF;
     -- END IF;
END LOOP;
---call Canceled Stack procedure
 CANCELLED_STACKCASE;
 
SELECT COUNT(1) INTO V_COUNT FROM CASES WHERE IS_STACK='Y' AND APS_SEQUENCE=1 AND (CASEID  IN (SELECT CASEID FROM CASE_META WHERE SUM_IND=0))
 AND CASEID IN (SELECT CASEID FROM GET_CASE_STAGE_STATUS_V WHERE STAGEID=6 AND USERID IS NULL);
 
 SELECT COUNT(1) INTO V_NUM FROM CASES WHERE IS_STACK='N' AND STACK_CASEID IS NULL AND APS_SEQUENCE=1 AND (CASEID  IN (SELECT CASEID FROM CASE_META WHERE SUM_IND=0 AND APS_COUNT=1))
 AND CASEID IN (SELECT CASEID FROM GET_CASE_STAGE_STATUS_V WHERE STAGEID=6 AND USERID IS NULL);
 
 IF V_COUNT<>0 THEN
  FOR REC IN (SELECT A.CASEID  FROM CASES A, CLIENTS C, USERS U, GET_CASE_STAGE_STATUS_V H,CASE_META CM where
 
                   C.CLIENTID          = A.CLIENTID
                    AND CM.CASEID      = A.CASEID
                    AND A.CASEID              = H.CASEID
                    AND H.USERID              = U.USERID (+)
                    AND NVL(A.APS_SEQUENCE,1)<>0 
                    AND H.STAGEID      = 6
                    AND CM.SUM_IND     = 0
                    AND H.USERID IS NULL
                    and a.IS_STACK='Y') LOOP
                    
          
          
            CASEHISTORY_UTILS.STAGEHOP(P_CASEID => REC.CASEID,
					    P_STAGEID =>12,
					    P_USERID =>NULL,   
					    P_ASSIGNED_TO => NULL, 
						  P_ASSIGNMENT_REASON => null,
						  P_NOTES => null);
       
    END LOOP;   
  END IF;
---
IF V_NUM<>0 THEN
   FOR REC IN (SELECT A.CASEID,CM.APS_COUNT  FROM CASES A, CLIENTS C, USERS U, GET_CASE_STAGE_STATUS_V H,CASE_META CM where
 
                   C.CLIENTID          = A.CLIENTID
                    AND CM.CASEID      = A.CASEID
                    AND A.CASEID       = H.CASEID
                    AND A.IS_STACK     = 'N'
                    AND H.USERID       = U.USERID (+)
                    AND NVL(A.APS_SEQUENCE,1)<>0 
                    AND H.STAGEID       = 6
                    AND CM.SUM_IND      = 0
                    AND H.USERID IS NULL
                    AND CM.APS_COUNT    = 1
                    ) LOOP
        
              CASEHISTORY_UTILS.STAGEHOP(P_CASEID => REC.CASEID,
					    P_STAGEID =>12,
					    P_USERID =>NULL,   
					    P_ASSIGNED_TO => NULL, 
						  P_ASSIGNMENT_REASON => NULL,
						  P_NOTES => NULL);
            
    END LOOP;     
END IF;
 
EXCEPTION
 WHEN OTHERS THEN
   ROLLBACK;
END AUTOSTACK;

PROCEDURE "GET_NEXT_JHC_CASE"
  --1) user presses "Get Next Case" button.
  
  -- Update History
  --  6-19-2015 Amathur
  --     Clarified response message
  -- Pulls the Next CASEID from the WorkQueue
  -- maximum limits of OP and QA files per user controlled by
  -- CONFIG_SWITCHES values of MAX_CASES_PER_OP,
  -- Record results in AUDIT_LOG
  --   62 - Failed to GetNext File
  --   64 - Obtained GetNext File
  --   65 - No File Available
  (
    P_USERID   IN NUMBER,
    P_ROLE     IN VARCHAR2,
    P_CLIENTID IN VARCHAR2,
    P_CASEID OUT NUMBER,
    P_RESULT OUT VARCHAR2,
    P_Execmode IN VARCHAR2 DEFAULT 'RUN') -- 'TEST' does not actually pull )
IS
  v_CaseId               NUMBER;
  v_max_case_cnt         NUMBER;
  v_current_case_cnt     NUMBER;
  V_Max_Case_Switch_Name VARCHAR2(25);
  v_USER_FUNCTION_GROUP  VARCHAR2(5);
  --v_SQL                  VARCHAR2(4000);
  v_Exe_SQL              VARCHAR2(30000);
  v_min_page_cnt_rl      NUMBER DEFAULT 0;
  v_min_page_cnt         NUMBER DEFAULT 0;
  v_max_page_cnt_rl      NUMBER DEFAULT 0;
  v_max_page_cnt         NUMBER DEFAULT 0;
  v_min_age_cnt_rl       NUMBER DEFAULT 0;
  v_min_age_cnt          NUMBER DEFAULT 0;
  v_max_age_cnt_rl       NUMBER DEFAULT 0;
  v_max_age_cnt          NUMBER DEFAULT 0;
  v_page_cnt             NUMBER DEFAULT 0;
  v_age                  NUMBER DEFAULT 0;
  v_ranking              NUMBER DEFAULT 0;
  v_timestamp TIMESTAMP DEFAULT '';
  v_Result VARCHAR2(80);
  V_SR_RESULT varchar2(30000);
  v_Sr_num varchar2(200);
  V_CASE_ID     number;
 
--------
  TYPE CUR_RESULT IS REF CURSOR;
  V_CUR_RESULT CUR_RESULT;
  V_CUR_CASEID NUMBER;
  V_CUR_TIMESTAMP TIMESTAMP DEFAULT '';
  V_CUR_PAGE_CNT  NUMBER DEFAULT 0;
  V_CUR_AGE  NUMBER DEFAULT 0;
  V_CUR_RANKING number default 0;
  V_SR_NUM_MT varchar2(200);
  V_COUNT number :=0; 
  V_STAGEID number;
  V_ROLE varchar2(10);
  V_1OP_1QA number;
  V_ROLE_ID number(10);
  V_2OP_ROLE NUMBER(5);
  V_STR_1OP_1QA varchar2(4000);
  V_CASE NUMBER;
--------
BEGIN
  --Make note that we started
  LOG_APEX_ACTION( P_ACTIONID => 64, P_OBJECTTYPE => P_EXECMODE || '_GET_NEXT_' || P_ROLE, P_RESULTS => 'Invoke Feeder File', P_ORIGINALVALUE => P_ROLE, P_MODIFIEDVALUE => P_RESULT, P_USERID => P_USERID, P_CASEID => v_CASEID);
  --- Set internal variable mapping based on Roles
  CASE
  WHEN P_Role               = 'OP' THEN
    V_Max_Case_Switch_Name := 'MAX_CASES_PER_OP';
    v_USER_FUNCTION_GROUP  := 'OP';
  ELSE
    NULL;
  END CASE;
  --- See how many cases of this role-type are already assigned, if any
  v_max_case_cnt := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', V_Max_Case_Switch_Name) ;
  -- DBMS_OUTPUT.PUT_LINE('Starting debugging ');
  -- see how many cases are assigned
  SELECT COUNT(*)
  INTO v_current_case_cnt
  from GET_CASE_STAGE_STATUS_V where userid=P_USERID and stageid=6 and iscompleted='N';

 -- DBMS_OUTPUT.PUT_LINE('Starting debugging count -  ' || v_current_case_cnt);
 -- DBMS_OUTPUT.PUT_LINE('Starting debugging max case count -  ' || v_max_case_cnt);
  --- If we have exceeded our allow count of files, no need to process furtner
  IF v_current_case_cnt < v_max_case_cnt THEN
    --- Proceed with trying to find matching cases
    --Generate Sql based on the following conditon follow JIRA JHC-37     
      v_Exe_SQL := 'select c.caseid,c.receipttimestamp, m.page_count, m.age,  ';
      --check user has 'Minimum_Page_Count' if yes then check count follow JIRA JHC-37 
      SELECT COUNT(1)
      INTO v_min_page_cnt_rl
      FROM USERROLES USR,
        ROLES R
      WHERE USR.ROLEID     =R.ROLEID
      AND R.ROLENAME       ='Minimum_Page_Count'
      AND USR.USERID       =P_USERID and rownum =1;
      --check count 
      IF v_min_page_cnt_rl = 1 THEN
        v_min_page_cnt    := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'ROLE_MINIMUM_PAGE_COUNT') ;
        v_Exe_SQL         := v_Exe_SQL || ' case when m.page_count > '||v_min_page_cnt||' then 1 else 0 end + ';
      ELSE
        v_Exe_SQL := v_Exe_SQL || ' case when m.page_count > 0 then 1 else 0 end + ';
      END IF;
      
     -- DBMS_OUTPUT.PUT_LINE('Starting debugging min page v_Exe_SQL -  ' || v_Exe_SQL);
      --check user has 'Maximum_Page_Count' if yes then check count  follow JIRA JHC-37     
      SELECT COUNT(1)
      INTO v_max_page_cnt_rl
      FROM USERROLES USR,
        ROLES R
      WHERE USR.ROLEID     =R.ROLEID
      AND R.ROLENAME       ='Maximum_Page_Count'
      AND USR.USERID       =P_USERID;
      IF v_max_page_cnt_rl = 1 THEN
        v_max_page_cnt    := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'ROLE_MAXIMUM_PAGE_COUNT') ;
        v_Exe_SQL         := v_Exe_SQL || 'case when m.page_count < '|| v_max_page_cnt ||' then 1 else 0 end + ';
      ELSE
        v_Exe_SQL := v_Exe_SQL || ' case when m.page_count < 9999 then 1 else 0 end + ';
      END IF;
      
     -- DBMS_OUTPUT.PUT_LINE('Starting debugging max page  v_Exe_SQL -  ' || v_Exe_SQL);
      --- check user has 'ROLE_MINIMUM_AGE' if yes then check count follow JIRA JHC-37     
      SELECT COUNT(1)
      INTO v_min_age_cnt_rl
      FROM USERROLES USR,
        ROLES R
      WHERE USR.ROLEID    =R.ROLEID
      AND R.ROLENAME      ='Minimum_Age'
      AND USR.USERID      =P_USERID;
      IF v_min_age_cnt_rl = 1 THEN
        v_min_age_cnt    := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'ROLE_MINIMUM_AGE') ;
        v_Exe_SQL        := v_Exe_SQL || ' case when m.age > '||v_min_age_cnt ||' then 1 else 0 end  + ';
      ELSE
        v_Exe_SQL := v_Exe_SQL || ' case when m.age > 0 then 1 else 0 end + ';
      END IF;
     -- DBMS_OUTPUT.PUT_LINE('Starting debugging min age v_Exe_SQL -  ' || v_Exe_SQL);
      
      
       --- check user has 'ROLE_MAXIMUM_AGE' if yes then check count follow JIRA JHC-37
      SELECT COUNT(1)
      INTO v_max_age_cnt_rl
      FROM USERROLES USR,
        ROLES R
      WHERE USR.ROLEID    =R.ROLEID
      AND R.ROLENAME      ='Maximum_Age'
      AND USR.USERID      =P_USERID;
      IF v_max_age_cnt_rl = 1 THEN
        v_max_age_cnt    := IWS_APP_UTILS.GETCONFIGSWITCHVALUE('', 'ROLE_MAXIMUM_AGE') ;
        v_Exe_SQL        := v_Exe_SQL || ' case when m.age < '||v_max_age_cnt || ' then 1 else 0 end  ';
      ELSE
        v_Exe_SQL := v_Exe_SQL || ' case when m.age < 9999 then 1 else 0 end  ';
      END IF;
   --   DBMS_OUTPUT.PUT_LINE('Starting debugging max age  v_Exe_SQL -  ' || v_Exe_SQL);
      
      
--      v_Exe_SQL := v_Exe_SQL || ' ranking from cases c, case_meta m where c.caseid=m.caseid    
--  and iws_app_utils.Show_Stage_Status(c.caseid)=''Step-2-OP (6). ''    
--  and (c.IS_STACK=''Y'' or (c.IS_STACK=''N'' and m.aps_count=1)) and rownum=1 order by ranking desc, c.receipttimestamp ';
--  
    V_SR_RESULT := V_EXE_SQL;
   --Modified by Hira start-- 8/14/2015
  --if V_2OP_ROLE is not null and V_2OP_ROLE=3 then
--    V_EXE_SQL := V_EXE_SQL || ' ranking from cases c, case_meta m,GET_CASE_STAGE_STATUS_V V
--    R where c.caseid=m.caseid  AND V.CASEID=C.CASEID AND V.USERID IS NULL  AND exists (select 1 from PAGES P where C.CASEID=P.CASEID and P.ISDELETED=''N'')  
--    and iws_app_utils.Show_Stage_Status(c.caseid)=''Step-2-OP (6). ''
--     and m.SUM_IND=1 
--     and (c.IS_STACK=''Y'' or (c.IS_STACK=''N'' and m.aps_count=1)) and rownum=1 ';
    V_EXE_SQL := V_EXE_SQL || ' ranking from cases c, case_meta m,GET_CASE_STAGE_STATUS_V V,USERROLES USR,
    roles R where c.caseid=m.caseid  AND V.CASEID=C.CASEID AND V.USERID IS NULL  AND exists (select 1 from PAGES P where C.CASEID=P.CASEID and P.ISDELETED=''N'')  
    and iws_app_utils.Show_Stage_Status(c.caseid)=''Step-2-OP (6). ''
    and m.SUM_IND=1 
    and (c.IS_STACK=''Y'' or (c.IS_STACK=''N'' and m.aps_count=1)) and USR.ROLEID=R.ROLEID
    and R.ROLEID=3 and USR.USERID ='||P_USERID||' and rownum=1 ';
--  IF  V_MIN_PAGE_CNT_RL = 1  THEN
--    V_EXE_SQL := V_EXE_SQL||' AND m.page_count > '||V_MIN_PAGE_CNT||' ';
--  ELSIF V_MAX_PAGE_CNT_RL = 1  THEN
--   V_EXE_SQL := V_EXE_SQL||' AND m.page_count < '||v_max_page_cnt||' ';
--  ELSIF   v_min_age_cnt_rl = 1  THEN
--   V_EXE_SQL := V_EXE_SQL||' AND m.age > '||v_min_age_cnt||' ';
--  ELSIF v_max_age_cnt_rl = 1   THEN
--   V_EXE_SQL := V_EXE_SQL||' AND m.age > '||v_max_age_cnt||' ';
--  END IF;
   V_EXE_SQL := V_EXE_SQL ||' order by ranking desc, c.receipttimestamp ';
  --end-- 8/14/2015
  DBMS_OUTPUT.PUT_LINE('Final  v_Exe_SQL -  ' || v_Exe_SQL);
  begin
          EXECUTE Immediate v_Exe_SQL INTO v_CaseId,
          v_timestamp,
          V_PAGE_CNT,
          v_age,
          V_RANKING;
          CASEHISTORY_UTILS.STAGEHOP(P_CASEID => V_CASEID, P_STAGEID =>6, P_USERID =>P_USERID, P_ASSIGNED_TO => P_USERID, P_ASSIGNMENT_REASON => 'AUTO ASSIGNMENT', P_NOTES => null);
          EXCEPTION
          WHEN others THEN
          V_Caseid    := NULL;
          v_timestamp := NULL;
          v_page_cnt  := NULL;
          v_age       := NULL;
          V_RANKING   := null;
  ---Changes based on SR Number ---------------------------------------------------------
      -- for user having a role
        begin
                 begin
                        select COUNT(1) into V_1OP_1QA
                        FROM USERROLES USR,
                        ROLES R
                        where USR.ROLEID    =R.ROLEID
                        and R.ROLEID      in (1,2)
                        And Usr.Userid      =P_Userid;
      
                        begin
            Select R.ROLEID into v_role_id
          FROM USERROLES USR,
          ROLES R
          Where Usr.Roleid    =R.Roleid
          and R.ROLEID     =1
          And Usr.Userid      =P_Userid;
          exception
            When No_Data_Found Then
            Null;
            begin
              Select R.ROLEID into v_role_id
              FROM USERROLES USR,
              ROLES R
              Where Usr.Roleid    =R.Roleid
              And R.Roleid     =2
              And Usr.Userid      =P_Userid;
              Exception
              When No_Data_Found Then
              null;
              end;
              end;
          END;
        if V_1OP_1QA=2 then
          V_STR_1OP_1QA :=  ' and (IWS_APP_UTILS.Show_Stage_Status(c.caseid)=''Step-1-OP (4). ''  or IWS_APP_UTILS.Show_Stage_Status(c.caseid)=''Step-1-QA (5). '') ';
        ELSIF V_ROLE_ID=1 then
          V_STR_1OP_1QA := ' and (IWS_APP_UTILS.Show_Stage_Status(c.caseid)=''Step-1-OP (4). '') ';
       elsif V_ROLE_ID=2 then
         V_STR_1OP_1QA := ' and (IWS_APP_UTILS.Show_Stage_Status(c.caseid)=''Step-1-QA (5). '') ';
      end if;
    if v_CaseId is null AND P_EXECMODE = 'RUN' then
        v_Sr_result := v_Sr_result || ' ranking from cases c, case_meta m,GET_CASE_STAGE_STATUS_V V where c.caseid=m.caseid  AND V.CASEID=C.CASEID  AND V.USERID IS NULL 
        AND exists (select 1 from PAGES P where C.CASEID=P.CASEID and P.ISDELETED=''N'') '; 
        V_SR_RESULT := V_SR_RESULT ||V_STR_1OP_1QA;
        v_Sr_result := v_Sr_result ||' order by ranking desc, c.receipttimestamp ';
        begin
          open V_CUR_RESULT for V_SR_RESULT;
          LOOP
          FETCH V_CUR_RESULT into V_CUR_CASEID,
          V_CUR_TIMESTAMP,
          V_CUR_PAGE_CNT,
          V_CUR_AGE,
          V_CUR_RANKING;
          EXIT when V_CUR_RESULT%NOTFOUND;
          V_COUNT := V_COUNT +1;
          if V_COUNT =1 then
             select CM.SR_NUM,V.STAGEID into V_SR_NUM,V_STAGEID  from CASE_META CM,GET_CASE_STAGE_STATUS_V V  where V.CASEID=CM.CASEID AND CM.CASEID=V_CUR_CASEID  and rownum=1;
              if V_STAGEID =4  then
                  V_ROLE := 'OP';
                  update PARALLELCASESTATUS set USERID =P_USERID,UPDATED_USERID=P_USERID where CASEID=V_CUR_CASEID and USERID is null;  
                  commit;
                  V_CASE := V_CUR_CASEID;
                ELSE
                  V_ROLE := 'QA';
                  V_CASE := V_CUR_CASEID;
                  CASEHISTORY_UTILS.STAGEHOP(P_CASEID => V_CUR_CASEID, P_STAGEID =>V_STAGEID, P_USERID =>P_USERID, P_ASSIGNED_TO => P_USERID, P_ASSIGNMENT_REASON => 'AUTO ASSIGNMENT', P_NOTES => null);
              END IF;
          else
              select CM.SR_NUM,V.STAGEID into V_SR_NUM_MT,V_STAGEID  from CASE_META CM,GET_CASE_STAGE_STATUS_V V  where CM.CASEID=V_CUR_CASEID and CM.CASEID=V.CASEID AND ROWNUM=1;
          end if;
        if V_SR_NUM = V_SR_NUM_MT then
            if V_STAGEID =4 then
                V_ROLE := 'OP';
                Update Parallelcasestatus Set Userid =P_Userid,UPDATED_USERID=P_USERID Where Caseid=V_Cur_Caseid And Userid Is Null;  
                commit;
                V_CASE := V_CUR_CASEID;
              ELSE
                V_ROLE := 'QA';
                V_CASE := V_CUR_CASEID;
                Casehistory_Utils.Stagehop(P_Caseid => V_Cur_Caseid, P_Stageid =>V_Stageid, P_Userid =>P_Userid, P_Assigned_To => P_Userid, P_Assignment_Reason => 'AUTO ASSIGNMENT', P_Notes => Null);
             END IF;
          END IF;
        end LOOP;
       close V_CUR_RESULT;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_Caseid    := NULL;
        v_timestamp := NULL;
        v_page_cnt  := NULL;
        V_AGE       := null;
        v_ranking   := NULL;
      WHEN OTHERS THEN
        V_Caseid    := NULL;
        v_timestamp := NULL;
        v_page_cnt  := NULL;
        v_age       := NULL;
        v_ranking   := NULL;
        LOG_APEX_ACTION( P_ACTIONID => 64, P_OBJECTTYPE => P_EXECMODE || '_GET_NEXT_JHC_CASE ' || P_ROLE, P_RESULTS => 'EXCEPTION', P_ORIGINALVALUE => v_Exe_SQL, P_MODIFIEDVALUE => SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||CHR(13) || SQLERRM,1,3500), P_USERID => P_USERID, P_CASEID => v_CASEID);
      end;
         
     --  ELSIF V_CASEID is not null and P_EXECMODE = 'RUN'	 then
     --   CASEHISTORY_UTILS.STAGEHOP(P_CASEID => V_CASEID, P_STAGEID =>6, P_USERID =>P_USERID, P_ASSIGNED_TO => P_USERID, P_ASSIGNMENT_REASON => 'AUTO ASSIGNMENT', P_NOTES => null);
        
    end if;
   
  -- end if;
      ---end for Sr_Num--------------------------------------------------------------------
    Exception     
      WHEN OTHERS THEN
        V_Caseid    := NULL;
        v_timestamp := NULL;
        v_page_cnt  := NULL;
        v_age       := NULL;
        v_ranking   := NULL;
        LOG_APEX_ACTION( P_ACTIONID => 64, P_OBJECTTYPE => P_EXECMODE || '_GET_NEXT_JHC_CASE ' || P_ROLE, P_RESULTS => 'EXCEPTION', P_ORIGINALVALUE => V_EXE_SQL, P_MODIFIEDVALUE => SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||CHR(13) || SQLERRM,1,3500), P_USERID => P_USERID, P_CASEID => V_CASEID);
      end;  
      END;
  ELSE
      V_RESULT:= 'Case Assignment limit of ' || V_MAX_CASE_CNT || ' exceeded.  Currently assigned ' || V_CURRENT_CASE_CNT || ' cases across all clients. ';
      LOG_APEX_ACTION( P_ACTIONID => 62, P_OBJECTTYPE => P_EXECMODE || '_GET_NEXT_JHC_CASE ' || P_ROLE, P_RESULTS => 'Case Assignment Limit Reached.', P_ORIGINALVALUE => P_Result , P_MODIFIEDVALUE => NULL, P_USERID => P_USERID, P_Caseid => V_Caseid );
  end if;
 
 -- DBMS_OUTPUT.PUT_LINE('Final  caseId -  ' || v_CaseId);
  --- Return Caseid and Results Message to screen via result variable
  -- P_Caseid := v_CaseId;
 -- DBMS_OUTPUT.PUT_LINE('case id '||v_CaseId);
  -- ASSIGN CASE TO THE USER. WITH RUN MODE NOT IN TEST MODE
--  IF V_Caseid IS NOT NULL AND P_EXECMODE = 'RUN'	 THEN
--    CASEHISTORY_UTILS.STAGEHOP(P_CASEID => V_Caseid, P_STAGEID =>6, P_USERID =>P_USERID, P_ASSIGNED_TO => P_USERID, P_ASSIGNMENT_REASON => 'AUTO ASSIGNMENT', P_NOTES => NULL);
--  END IF ;
  --- Catchall no-assignment message
    IF  V_CUR_CASEID IS NULL and V_CASEID IS  NULL  THEN
        V_RESULT  := 'No Case assigned as per the Role Slice.'; -- ' No POP Case Assigned. ';
    else
        if V_ROLE is null and  V_CASEID is not null then
            V_RESULT := 'Assigned Case: ' || V_CASEID || ' Role Slice: ' || P_ROLE;
          else
            V_RESULT := 'Assigned Case: ' || V_CASE || ' Role Slice: ' || V_ROLE;
          END IF;
    END IF;
  --apex_application.g_print_success_message :=  'POP Result Was: ' || v_Result;
  P_RESULT := v_RESULT;
EXCEPTION
WHEN OTHERS THEN
  LOG_APEX_ERROR(15);
END GET_NEXT_JHC_CASE;  



PROCEDURE CANCELLED_STACKCASE
AS
V_COUNT NUMBER :=0;
STATUSMESSAGE VARCHAR2(2000):=' Canceled Stackcases';
V_REASON PAGES.DELETEREASON%TYPE;
V_CHK_STACK NUMBER :=0;
--Stackcase contains two members case while one having excluded all page and other have.
CURSOR CUR IS SELECT   C.CASEID,C.STACK_CASEID FROM CASES C,
(SELECT COUNT(CASEID) COUNTPAGES, ORIGINALCASEID, COUNT(DECODE(ISDELETED,'Y',ISDELETED)) COUNTDELPAGES FROM PAGES --WHERE CASEID=7530
GROUP BY ORIGINALCASEID) P,CASE_META CM ,GET_CASE_STAGE_STATUS_V H,USERS U,CLIENTS CL
WHERE C.CASEID=P.ORIGINALCASEID
AND  COUNTPAGES=COUNTDELPAGES
AND C.CASEID=CM.CASEID
AND H.CASEID=C.CASEID AND  H.STAGEID       = 70
AND C.CLIENTID          = CL.CLIENTID  AND H.USERID       = U.USERID (+)
AND CM.APS_COUNT > 1 AND C.IS_STACK='N' 
AND C.IMAGEREJECTREASON IS NULL
AND C.CASEID IN (SELECT CS.CASEID FROM CASES CS
WHERE CS.STACK_CASEID IN (SELECT DISTINCT PG.CASEID FROM PAGES PG,GET_CASE_STAGE_STATUS_V V  WHERE PG.ISDELETED='N' AND PG.CASEID=V.CASEID AND V.STAGEID=6 ))
order by C.APS_SEQUENCE desc;

BEGIN

FOR REC IN CUR LOOP
 --Findout the reason for why did the pages exclude.
SELECT P.DELETEREASON INTO V_REASON FROM PAGES P WHERE ORIGINALCASEID IN (SELECT CASEID FROM CASES WHERE CASEID=REC.CASEID) AND ROWNUM=1;
--updated member for SUM_IND=0
UPDATE CASES SET  APS_STATUS  = 'Canceled (Scrubbed)' , IMAGEREJECTREASON =V_REASON WHERE  CASEID IN (SELECT CASEID FROM CASE_META WHERE (CASEID=REC.CASEID) AND SUM_IND=0) ;

--updated member for SUM_IND=1
UPDATE CASES SET  APS_STATUS  = 'Canceled (Scrubbed and Summarized)' , IMAGEREJECTREASON = V_REASON WHERE  CASEID IN (SELECT CASEID FROM CASE_META WHERE  (CASEID=REC.CASEID) AND SUM_IND=1);

END LOOP;

--- check canceled stack/case 
SELECT count(distinct c.caseid) INTO V_COUNT FROM CASES C,(SELECT COUNT(CASEID) COUNTPAGES, CASEID, COUNT(DECODE(ISDELETED,'Y',ISDELETED)) COUNTDELPAGES FROM PAGES 
GROUP BY CASEID) P,CASE_META CM ,GET_CASE_STAGE_STATUS_V H,USERS U,CLIENTS CL
WHERE C.CASEID=P.CASEID  AND C.CASEID=CM.CASEID AND C.STACK_CASEID IS NULL AND COUNTPAGES=COUNTDELPAGES
AND ((CM.APS_COUNT=1 AND C.IS_STACK='N') or (CM.APS_COUNT > 1 AND C.IS_STACK='Y')) AND H.CASEID=C.CASEID AND  H.STAGEID       = 6  AND H.USERID IS NULL
AND  C.CLIENTID          = CL.CLIENTID  AND H.USERID       = U.USERID (+);

IF V_COUNT<>0 THEN
FOR REC IN (SELECT CS.CASEID,T.APS_COUNT FROM CASES CS,
(SELECT DISTINCT C.CASEID,CM.APS_COUNT FROM CASES C,(SELECT COUNT(CASEID) COUNTPAGES, CASEID, COUNT(DECODE(ISDELETED,'Y',ISDELETED)) COUNTDELPAGES FROM PAGES 
GROUP BY CASEID) P,CASE_META CM ,GET_CASE_STAGE_STATUS_V H,USERS U,CLIENTS CL
WHERE C.CASEID=P.CASEID  AND C.CASEID=CM.CASEID AND C.STACK_CASEID IS NULL AND COUNTPAGES=COUNTDELPAGES
and ((CM.APS_COUNT=1 and C.IS_STACK='N') or (CM.APS_COUNT > 1 and C.IS_STACK='Y'))  and H.CASEID=C.CASEID and  H.STAGEID       = 6  and H.USERID is null
and  C.CLIENTID          = CL.CLIENTID  and H.USERID       = U.USERID (+)) T where CS.CASEID=T.CASEID or CS.STACK_CASEID=T.CASEID
ORDER BY CS.APS_SEQUENCE ASC) LOOP
BEGIN 

select COUNT(1) into V_CHK_STACK from CASES where STACK_CASEID = REC.CASEID;

--Findout the reason for why did the pages exclude.
IF V_CHK_STACK<>0 THEN
  SELECT DELETEREASON  INTO V_REASON  FROM PAGES WHERE CASEID =REC.CASEID AND DELETEREASON IS NOT NULL AND ROWNUM=1;
ELSE
  SELECT P.DELETEREASON INTO V_REASON FROM PAGES P WHERE P.ORIGINALCASEID=REC.CASEID AND ROWNUM=1;
END IF;

--SELECT P.DELETEREASON INTO V_REASON FROM PAGES P WHERE ORIGINALCASEID IN (SELECT CASEID FROM CASES WHERE  STACK_CASEID= REC.CASEID OR CASEID=REC.CASEID) AND ROWNUM=1;


--updated member and stackcase for SUM_IND=0
UPDATE CASES SET  APS_STATUS  = 'Canceled (Scrubbed)' , IMAGEREJECTREASON =V_REASON WHERE  CASEID IN (SELECT CASEID FROM CASE_META WHERE CASEID=REC.CASEID AND SUM_IND=0);
--updated member and stackcase for SUM_IND=1

UPDATE CASES SET  APS_STATUS  = 'Canceled (Scrubbed and Summarized)' , IMAGEREJECTREASON = V_REASON WHERE  CASEID IN (SELECT CASEID FROM CASE_META WHERE CASEID=REC.CASEID AND SUM_IND=1) ;

 
--Move the case to Ready to Generate stage
IF V_CHK_STACK <>0 OR REC.APS_COUNT=1 THEN
 CASEHISTORY_UTILS.STAGEHOP(P_CASEID => REC.CASEID,
					    P_STAGEID =>12,
					    P_USERID =>NULL,   
					    P_ASSIGNED_TO => NULL, 
						  P_ASSIGNMENT_REASON => NULL,
						  P_NOTES => NULL);

 END IF;
  LOG_APEX_ACTION (
               P_USERID  => null,
               P_ACTIONID  => 89,
               P_RESULTS  => 'Case(s) canceled successfully',
               P_CASEID => REC.CASEID,
			         P_ORIGINALVALUE   => STATUSMESSAGE
			   );


COMMIT;
EXCEPTION
WHEN OTHERS THEN
 STATUSMESSAGE := 'An error was encountered - '||SQLCODE||' - '||SQLERRM;
        LOG_APEX_ERROR(89,'Stack Case for canceled (Scrubbed).',STATUSMESSAGE,null);
END;

END LOOP;
END IF;
      
COMMIT;
DBMS_OUTPUT.PUT_LINE('Successfully');
EXCEPTION
WHEN OTHERS THEN
 ROLLBACK;

END CANCELLED_STACKCASE;


END IWS_JHC_UTILS;
/