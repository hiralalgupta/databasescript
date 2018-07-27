--------------------------------------------------------
--  DDL for Function BASIC_LOGIN_AUTH_CHK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SNX_IWS2"."BASIC_LOGIN_AUTH_CHK" 
    -- Created 9-7-2011 R Benzell
    -- select BASIC_LOGIN_AUTH_CHK('RBENZELL','synodex') from dual;
    -- Update History
    -- 6-18-2012 R Benzell - check that user status =ACTIVE

    (
      p_username VARCHAR2,
      p_password VARCHAR2 )
    RETURN BOOLEAN
    --return varchar2 --(for testing)
  IS
    v_Valid BOOLEAN DEFAULT false;
    v_count NUMBER;
  BEGIN
    --- should get 1 exact match on userid/password
    SELECT COUNT(*)
    INTO v_count
    FROM USERS
    WHERE upper(USERNAME) = upper(p_username)
    AND PASSWORD          = RAWTOHEX(UTL_RAW.cast_to_raw(DBMS_OBFUSCATION_TOOLKIT.MD5(input_string => p_password)))
    AND ACCOUNTSTATUS = 'ACTIVE'
    AND EFFECTIVEDATE     < systimestamp
    AND (EXPIRATIONDATE  IS NULL
    OR EXPIRATIONDATE     > systimestamp);
    --- Convert count into T/F
    IF v_count = 1 THEN
      v_Valid := TRUE;
    ELSE
      v_Valid := FALSE;
    END IF;
    -- use for debuggind testing
    --if v_Valid
    --  THEN return 'TRUE';
    --  ELSE return 'FALSE';
    --END IF;
    RETURN v_Valid; --true;
  END;

/

