create or replace
TRIGGER PARALLELCASESTATUS_S_WF_TGR After UPDATE OF COMPLETIONCOUNT ON PARALLELCASESTATUS_STAGE FOR EACH ROW 
  DECLARE 
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_parallelism INTEGER;
  v_nextstageid Integer;
  v_dummy number;
  v_segments integer;
  err_code Varchar2(50);
  err_msg Varchar2(2000);
  BEGIN
	--get parallelism of the stage
	select parallelism into v_parallelism from stages where stageid=:NEW.Stageid;
	
	--get next stage
	select w.nextstageid into v_nextstageid
		from workflows w, cases c
		where w.clientid = c.clientid
		and c.caseid = :NEW.CaseId
		and w.stageid = :NEW.Stageid
		and w.condition='COMPLETION';
		
	--for segmented stages
	if v_parallelism = 9999 then
		select segments into v_segments from case_segmentations
			where caseid = :NEW.CaseId and stageid = :NEW.Stageid;
		--move case to next stage if all segments are done for the caseid and stageid
		if :NEW.COMPLETIONCOUNT = v_segments then
			--IWN-1091: When all segments are completed at Step-1-OP, re-number all pages in their final order
			if (:NEW.Stageid = 4) then
				/*Reassign Subdocumentorder numbers in pages table for a case in sequential order 
				based on file segments and existing Subdocumentorder numbers (when completing segmented step-1-op)*/
				UPDATE pages pg
				SET pg.subdocumentorder=
				  (SELECT fs.newsubdocumentorder
				  FROM
					(SELECT rownum newsubdocumentorder, subdocumentorder, file_segment
					FROM
					  (select subdocumentorder,file_segment from pages where caseid = :NEW.CaseId
							  and isdeleted = 'N'
							  group by file_segment, subdocumentorder
							  order by file_segment
					  )
					) fs
				  WHERE fs.subdocumentorder = pg.subdocumentorder and fs.file_segment = pg.file_segment
				  )
				WHERE pg.caseid = :NEW.CaseId
				and isdeleted = 'N';
				--JHC-11: Populate SUBDOCUMENTORDER_APS during sorting in Step 1
				UPDATE pages pg
				SET pg.subdocumentorder_aps=pg.subdocumentorder
				WHERE pg.caseid = :NEW.CaseId;
				commit;
				
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
					  WHERE caseid = :NEW.CaseId
					  AND isdeleted='N'
					  ORDER BY DOCUMENTDATE DESC,
						--FILE_SEGMENT ASC,
						SUBDOCUMENTORDER ASC,
						SUBDOCUMENTPAGENUMBER ASC
					  )
					) fs
				  WHERE fs.pageid = pg.pageid
				  )
				WHERE pg.caseid = :NEW.CaseId
				and isdeleted = 'N';
				--JHC-12: Populate PAGES.FINALPAGENUMBER_APS when finishing step 1
				UPDATE pages pg
				SET pg.finalpagenumber_aps=pg.finalpagenumber
				WHERE pg.caseid = :NEW.CaseId;
				commit;
			end if;
			
			--move case to next stage
			CASEHISTORY_UTILS.completeStage(:NEW.CaseId, :NEW.Stageid, 127);
			v_dummy := CASEHISTORY_UTILS.startStage(:NEW.CaseId, v_nextStageId, 127);
		end if;
	else
	--for POP stages
		--move case to next stage if all parallel slots are done for the caseid and stageid
		if :NEW.COMPLETIONCOUNT = v_parallelism then
			CASEHISTORY_UTILS.completeStage(:NEW.CaseId, :NEW.Stageid, 127);
			v_dummy := CASEHISTORY_UTILS.startStage(:NEW.CaseId, v_nextStageId, 127);
		End if;
	end if;
  Exception
  When others Then
  	rollback;
    err_code := SQLCODE;
    err_msg := substr(SQLERRM, 1, 2000);
  	insert into errorlog (actionid, actionname, message, content, CREATED_STAGEID, CREATED_TIMESTAMP) 
      values (87, 'IWS Step Completed', err_code ||' raised from PARALLELCASESTATUS_S_WF_TGR', err_msg, :NEW.Stageid, current_timestamp);
	commit;
  END;
/