create or replace
TRIGGER "DPENTRYCODES_DPECID_TGR" before
  INSERT ON DPENTRYCODES FOR EACH row DECLARE criticality VARCHAR2(1);
  BEGIN
    IF inserting THEN
      SELECT CURRENT_TIMESTAMP INTO :new.CREATED_TIMESTAMP FROM dual;
      IF :NEW.DPECID IS NULL THEN
        SELECT DPENTRYCODES_SEQ.nextval INTO :NEW.DPECID FROM dual;
      END IF;
      --Set CODEID based on MASTERCODES table
      IF :NEW.CODEID IS NULL THEN
        SELECT MASTERCODES.CODEID INTO :NEW.CODEID
        FROM MASTERCODES WHERE code   =:NEW.CODE AND code_type=:NEW.CODETYPE AND version  =:NEW.VERSION AND status   ='ACTIVE';
      END IF;
      --For user-entered codes, set critical flag based on criticalicdlist table and client
      IF :NEW.Status     = 'user' THEN
        :NEW.ISCRITICAL := 'N';
        BEGIN
          SELECT cr.scale INTO criticality
          FROM dpentries dpe, pages p, cases c,  clients cl, mastercodes mc, criticalicdlist cr
          WHERE 1            =1
          AND dpe.dpentryid  = :NEW.DPENTRYID
          AND mc.codeid      = :NEW.CODEID
          AND dpe.pageid     = p.pageid AND p.caseid = c.caseid AND c.clientid = cl.clientid
          AND cl.clientname  = cr.clientname AND mc.code_alias = cr.code_alias;
          -- if scale is 2, it's critical
          IF criticality     = '2' THEN
            :NEW.ISCRITICAL := 'Y';
          END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          :NEW.ISCRITICAL := 'N';
        END;
      END IF;
    END IF;
  END;
  /