
CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

DeclareModule Logger
	#Separator$ = "------------------------------------------------------------"
	
	Declare.b Info(Message$)
	Declare.b Warning(Message$)
	Declare.b Error(Message$)
	Declare.b Devel(Message$)
EndDeclareModule

Module Logger
	EnableExplicit
	
	Procedure _Log(Message$)
		Debug Message$
	EndProcedure
	
	Procedure.b Info(Message$)
		_Log("INFO | "+Message$)
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b Warning(Message$)
		_Log("WARN | "+Message$)
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b Error(Message$)
		_Log("ERROR| "+Message$)
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b Devel(Message$)
		_Log("DEBUG| "+Message$)
		ProcedureReturn #True
	EndProcedure
EndModule

;UseModule Logger
