create or replace
PACKAGE BODY UCM_UTILS
AS
PROCEDURE get_file(
    caseid IN NUMBER,
    doctype    VARCHAR2,
    outputfile VARCHAR2)
IS
  vblob BLOB;
  vstart  NUMBER := 1;
  bytelen NUMBER := 32000;
  LEN     NUMBER;
  my_vr RAW(32000);
  x NUMBER;
  l_output utl_file.file_type;
BEGIN
  -- define output directory
  l_output := utl_file.fopen('DATA_PUMP_DIR', outputfile,'wb', 32760);
  vstart   := 1;
  bytelen  := 32000;
  -- get length of blob and select blob into variable
  SELECT dbms_lob.getlength(f.bfiledata),
    f.bfiledata
  INTO LEN,
    vblob
  FROM cases c,
    snx_ocs.revisions r,
    snx_ocs.filestorage f
  WHERE f.did       =r.did
  AND r.ddoctype    =doctype
  AND f.drenditionid='primaryFile'
  AND c.caseid      =caseid
  AND rownum        =1
  ORDER BY r.dindate DESC;
  -- save blob length
  x := LEN;
  -- if small enough for a single write
  IF LEN < 32760 THEN
    utl_file.put_raw(l_output,vblob);
    utl_file.fflush(l_output);
  ELSE -- write in pieces
    vstart      := 1;
    WHILE vstart < LEN AND bytelen > 0
    LOOP
      dbms_lob.read(vblob,bytelen,vstart,my_vr);
      utl_file.put_raw(l_output,my_vr);
      utl_file.fflush(l_output);
      -- set the start position for the next cut
      vstart := vstart + bytelen;
      -- set the end position if less than 32000 bytes
      x         := x - bytelen;
      IF x       < 32000 THEN
        bytelen := x;
      END IF;
    END LOOP;
    utl_file.fclose(l_output);
  END IF;
EXCEPTION
WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR (-20001, SQLERRM);
END get_file;

PROCEDURE DISPLAY_FILE(
    p_caseID  NUMBER,
    p_docType VARCHAR2)
AS
  v_mime_type VARCHAR2(48);
  v_length    NUMBER;
  v_filename  VARCHAR2(400);
  vblob BLOB;
  v_message VARCHAR2(32000);
BEGIN
  -- create synonym APEX_PUBLIC_USER.ucm_utils for snx_iws2.ucm_utils;
  -- grant execute ON snx_iws2.UCM_UTILS to APEX_PUBLIC_USER;
  -- Add UCM_UTILS.DISPLAY_FILE to apex_04000.wwv_flow_epg_include_mod_local function
  /* to test
  https://virnwjhpv04clnx.newjersey.innodata.net:7788/pls/apex/UCM_UTILS.DISPLAY_FILE?p_caseID=2228&p_docType=IMRS3File
  */
  SELECT dformat,
    bloblength,
    doriginalname,
    bfiledata
  INTO v_mime_type,
    v_length,
    v_filename,
    vblob
  FROM
    (SELECT d.dformat,
      dbms_lob.getlength(f.bfiledata) bloblength,
      d.doriginalname,
      f.bfiledata
    FROM snx_ocs.docmeta dm,
      snx_ocs.revisions r,
      snx_ocs.documents d,
      snx_ocs.filestorage f
    WHERE f.did       =r.did
    AND d.did         =r.did
    AND r.ddoctype    =p_docType
    AND f.drenditionid='primaryFile'
    AND d.disprimary  =1
    AND dm.did        = r.did
    AND dm.xcaseid    =p_caseID
    ORDER BY r.dindate DESC
    )
  WHERE rownum =1;
  
  --
  if (p_docType = 'CompanionFile' or p_docType = 'BatchInfoFile') then
    v_mime_type := 'text/html';
  end if;
  
  -- Set mime type and the size so the browser knows how much it will be downloading.
  owa_util.mime_header(v_mime_type, FALSE );
  htp.p( 'Content-length: ' || v_length);
  -- The filename will be used by the browser if the users does a "Save as"
  htp.p( 'Content-Disposition: filename="' || v_filename || '"' );
  owa_util.http_header_close;
  -- Download the BLOB
  wpg_docload.download_file( vblob );
EXCEPTION
WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR (-20001, SQLERRM);
END DISPLAY_FILE;

--added p_tName for RPT-41 Modify Embargo screen to show PDF reports from different templates for a single case
PROCEDURE DISPLAY_FILE_T(
    p_caseID  NUMBER,
    p_docType VARCHAR2,
    p_tName VARCHAR2 Default '' )
AS
  v_mime_type VARCHAR2(48);
  v_length    NUMBER;
  v_filename  VARCHAR2(400);
  vblob BLOB;
  v_message VARCHAR2(32000);
BEGIN
  -- create synonym APEX_PUBLIC_USER.ucm_utils for snx_iws2.ucm_utils;
  -- grant execute ON snx_iws2.UCM_UTILS to APEX_PUBLIC_USER;
  -- Add UCM_UTILS.DISPLAY_FILE to apex_04000.wwv_flow_epg_include_mod_local function
  /* to test
  https://virnwjhpv04clnx.newjersey.innodata.net:7788/pls/apex/UCM_UTILS.DISPLAY_FILE?p_caseID=2228&p_docType=IMRSTFile&p_tName=Sar1
  */
  SELECT dformat,
    bloblength,
    doriginalname,
    bfiledata
  INTO v_mime_type,
    v_length,
    v_filename,
    vblob
  FROM
    (SELECT d.dformat,
      dbms_lob.getlength(f.bfiledata) bloblength,
      d.doriginalname,
      f.bfiledata
    FROM snx_ocs.docmeta dm,
      snx_ocs.revisions r,
      snx_ocs.documents d,
      snx_ocs.filestorage f
    WHERE f.did       =r.did
    AND d.did         =r.did
    AND r.ddoctype    =p_docType
    AND f.drenditionid='primaryFile'
    AND d.disprimary  =1
    AND dm.did        = r.did
    AND dm.xcaseid    =p_caseID
	AND nvl(dm.xXSLTemplate,'') = p_tName
    ORDER BY r.dindate DESC
    )
  WHERE rownum =1;
  -- Set mime type and the size so the browser knows how much it will be downloading.
  owa_util.mime_header(v_mime_type, FALSE );
  htp.p( 'Content-length: ' || v_length);
  -- The filename will be used by the browser if the users does a "Save as"
  htp.p( 'Content-Disposition: filename="' || v_filename || '"' );
  owa_util.http_header_close;
  -- Download the BLOB
  wpg_docload.download_file( vblob );
EXCEPTION
WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR (-20001, SQLERRM);
END DISPLAY_FILE_T;

END UCM_UTILS;