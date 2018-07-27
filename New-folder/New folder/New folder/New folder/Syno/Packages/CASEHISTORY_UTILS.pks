create or replace package CASEHISTORY_UTILS
as
	/* Stage starts when a case is placed at that stage.
	   This function creates an entry in CASEHISTORYSUM for the case and stage,
	   and populates STAGESTARTTIMESTAMP. p_userID should be CREATED_USERID.
	   It returns the CHID of the new entry.
	 */
	Function startStage(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER   
					   ) return Number;
					   
	/* Stage completes when a case is moved out of that stage.
	   This procedure populates STAGECOMPLETIONTIMESTAMP of the open stage entry in CASEHISTORYSUM,
	   looks up the open assignment entry for the current stage, and if found, populates ASSIGNMENTCOMPLETIONTIMESTAMP.
	   p_userID is to be used to populate UPDATED_USERID.
	 */
	Procedure completeStage(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER,   
              			p_reason IN VARCHAR2
					   );
	Procedure completeStage(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER   
					   );
					   
	/* This function looks up open assignment entry for the current stage,
	   if no entry exists, it will create a new entry with USERID and ASSIGNMENTSTARTTIMESTAMP;
	   if an entry exists but not for the assignee, it will populate ASSIGNMENTCOMPLETIONTIMESTAMP for that entry 
	   and then create a new entry with USERID and ASSIGNMENTSTARTTIMESTAMP;
	   if an entry exists for the assignee, it won't do anything.
	   It returns the CHID of the new entry or the existing entry for the assignee.
	 */
	Function assignStageToUser(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_assigned_to IN NUMBER,
						p_assigned_by IN NUMBER,
						p_assignment_reason IN VARCHAR2,
						p_notes IN VARCHAR2
					   ) return Number;

	/* Similar to assignStageToUser but simplier.
	   Is called only when other processed have determined there is no open assignment
	   it will create a new entry with USERID and ASSIGNMENTSTARTTIMESTAMP;
	   It returns the CHID of the new entry or the existing entry for the assignee.
	 */
	Function assignUser(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_assigned_to IN NUMBER,
						p_assigned_by IN NUMBER,
						p_assignment_reason IN VARCHAR2,
						p_notes IN VARCHAR2
					   ) return Number;

					   
	/* Helper procedure to manually move a case to the specified stage, and optionally assign it to the specified user.
	   It will complete the current stage(s) and start the new stage.
	   If the case is already at the stage, no stage movement will happen.
	   If the case is already assigned to the user, no assignment change will happen.
	   p_userID is for auditing.
	 */
	Procedure stageHop(
					    p_caseID IN NUMBER,
					    p_stageID IN NUMBER,
					    p_userID IN NUMBER,   
					    p_assigned_to IN NUMBER default null,
						p_assignment_reason IN VARCHAR2 default null,
						p_notes IN VARCHAR2 default null
					   );
					   


	/* Comprehensive procedure to move a case to the specified stage, and optionally assign it to the specified user.
	   Like StageHop
	   It will complete the current stage(s) and start the new stage.
	   If the case is already at the stage, no stage movement will happen.
	   If the case is already assigned to the user, no assignment change will happen.
	   p_userID is for auditing.
	   If the new stage is parallel, it will not close other parallel stages 
	 */
	Procedure stageAssignHandler(
					    p_caseID IN NUMBER,
				        P_Thread in Number default null,
					    p_new_stageID IN NUMBER,
					    p_new_assigned_to IN NUMBER default null,
						p_assignment_reason IN VARCHAR2 default null, 
						p_notes IN VARCHAR2 default null,
						p_userID IN NUMBER,   -- for auditing
						P_message in out varchar2
					   );
					   

	/* Get the ThreadNum for a ClientsStage		 */
	Function GetThreadNumByClientStage(
					    p_ClientID IN NUMBER,
					    p_stageID IN NUMBER
					   ) return Number;


	/* Get the ThreadNum for a ClientsStage		 */
	Function GetThreadNumByCaseStage(
					    p_CaseID IN NUMBER,
					    p_stageID IN NUMBER
					   ) return Number;


end CASEHISTORY_UTILS;
/