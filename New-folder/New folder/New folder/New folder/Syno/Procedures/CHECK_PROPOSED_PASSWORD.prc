--------------------------------------------------------
--  DDL for Procedure CHECK_PROPOSED_PASSWORD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SNX_IWS2"."CHECK_PROPOSED_PASSWORD" 
     ( P_USERNAME VARCHAR2, 
       P_PASSWORD VARCHAR2,
       P_RESULT OUT VARCHAR2,   
       P_MESSAGE OUT VARCHAR2
      )

-- program name: CHECK_PROPOSED_PASSWORD
-- created by: Richard Benzell 6-14-2012
-- typically called by screen 152    

/**** TO TEST
    declare
 l_message varchar2(2000);
 l_result  varchar2(10);

begin
  CHECK_PROPOSED_PASSWORD('RBENZELL','synodexx',l_result,l_message);
  htp.p('result: ' || l_result);
  htp.p('message: ' || l_message);
END;
****/

IS
    
    l_username varchar2(30);
    l_password varchar2(30);
    l_old_password varchar2(30);
    l_workspace_name varchar2(30);
    l_min_length_err boolean;
    l_new_differs_by_err boolean;
    l_one_alpha_err boolean;
    l_one_numeric_err boolean;
    l_one_punctuation_err boolean;
    l_one_upper_err boolean;
    l_one_lower_err boolean;
    l_not_like_username_err boolean;
    l_not_like_workspace_name_err boolean;
    l_not_like_words_err boolean;
    l_not_reusable_err boolean;
    l_password_history_days pls_integer;

    l_new_password_hashed varchar2(100);
    l_old_password_hashed varchar2(100);

    l_lf varchar2(5) default chr(13)||chr(10);  --'<br>' ;

BEGIN
    --l_username := 'SOMEBODY';
    --l_password := 'foo';
    --l_old_password := 'foo';
    --l_workspace_name := 'XYX_WS';
    -- l_password_history_days := apex_instance_admin.get_parameter ('PASSWORD_HISTORY_DAYS' || l_lf ;
    l_password_history_days := 999;
    
    BEGIN
      select password into l_old_password_hashed
          from USERS where upper(username) = upper(P_USERNAME);
      EXCEPTION WHEN OTHERS THEN 
          P_MESSAGE := P_MESSAGE || 'Username ' || P_USERNAME || ' not found in system' || l_lf ;
    END;

APEX_UTIL.STRONG_PASSWORD_CHECK(
    p_username => p_username,
    p_password => p_password,
    p_old_password => l_old_password,
    p_workspace_name => l_workspace_name,
    p_use_strong_rules => true,  --false,
    p_min_length_err => l_min_length_err,
    p_new_differs_by_err => l_new_differs_by_err,
    p_one_alpha_err => l_one_alpha_err,
    p_one_numeric_err => l_one_numeric_err,
    p_one_punctuation_err => l_one_punctuation_err,
    p_one_upper_err => l_one_upper_err,
    p_one_lower_err => l_one_lower_err,
    p_not_like_username_err => l_not_like_username_err,
    p_not_like_workspace_name_err => l_not_like_workspace_name_err,
    p_not_like_words_err => l_not_like_words_err,
    p_not_reusable_err => l_not_reusable_err);

      IF l_min_length_err THEN
        P_MESSAGE := P_MESSAGE || 'Password is too short' || l_lf ;
      END IF;

      IF l_new_differs_by_err THEN
        P_MESSAGE := P_MESSAGE || 'Password is too similar to the old password' || l_lf ;
      END IF;

      IF l_one_alpha_err THEN
        P_MESSAGE := P_MESSAGE || 'Password must contain at least one alphabetic character' || l_lf ;
      END IF;

      IF l_one_numeric_err THEN
        P_MESSAGE := P_MESSAGE || 'Password must contain at least one numeric character' || l_lf ;
      END IF;

      IF l_one_punctuation_err THEN
        P_MESSAGE := P_MESSAGE || 'Password must contain at least one punctuation character' || l_lf ;
      END IF;

      IF l_one_upper_err THEN
        P_MESSAGE := P_MESSAGE || 'Password must contain at least one upper-case character' || l_lf ;
      END IF;

      IF l_one_lower_err THEN
        P_MESSAGE := P_MESSAGE || 'Password must contain at least one lower-case character' || l_lf ;
      END IF;

      IF l_not_like_username_err THEN
        P_MESSAGE := P_MESSAGE || 'Password may not contain the username' || l_lf ;
      END IF;

      IF l_not_like_workspace_name_err THEN
        P_MESSAGE := P_MESSAGE || 'Password may not contain the workspace name' || l_lf ;
      END IF;

      IF l_not_like_words_err THEN
        P_MESSAGE := P_MESSAGE || 'Password contains one or more prohibited common words' || l_lf ;
      END IF;

      IF l_not_reusable_err THEN
        P_MESSAGE := P_MESSAGE || 'Password cannot be used because it has been used for the account within the last ' ||
         l_password_history_days||' days.' || l_lf ;
      END IF;

   --- Compare new and old hashed passwords
     l_new_password_hashed := RAWTOHEX(UTL_RAW.cast_to_raw(
           DBMS_OBFUSCATION_TOOLKIT.MD5(input_string  => P_PASSWORD)));


     IF l_new_password_hashed = l_old_password_hashed THEN
         P_MESSAGE := P_MESSAGE || 'Password cannot be used because it is the same as the previous password ' || l_lf ; 
      END IF;

   --- Determine final responsed based on presence or absence of any error message 
     IF P_MESSAGE IS NULL
       then P_RESULT := 'OK';
       else P_RESULT := 'REJECTED';
     END IF;

   EXCEPTION WHEN OTHERS THEN LOG_APEX_ERROR(1);

END;

/

