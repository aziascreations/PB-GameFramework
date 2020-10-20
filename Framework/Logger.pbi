;{
; * Logger.pbi
; Version: 1.0.2
; Author: Herwin Bozet
; 
; A very basic logger that can either output to the debugger or the console.
;}

;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule Logger
	#Separator$ = "------------------------------------------------------------"
	
	Declare.b Info(Message$)
	Declare.b Warning(Message$)
	Declare.b Error(Message$)
	Declare.b Devel(Message$)
	Declare.b Trace(Message$)
	
	; Can cause some really weird problems...
	Declare.b EnableConsole()
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		Declare.b EnableHiddenConsole()
	CompilerElse
		Macro EnableHiddenConsole()
			EnableConsole()
		EndMacro
	CompilerEndIf
	
	Declare EnableTrace()
EndDeclareModule

Module Logger
	EnableExplicit
	
	Global UseConsole.b = #False
	Global EnableTrace.b = #False
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		Global UseHiddenConsole.b = #False
		Global ConsoleHandle.i = #Null
	CompilerEndIf
	
	Procedure _Log(Message$)
		If UseConsole
			PrintN(Message$)
		EndIf
		
		Debug Message$
		
		CompilerIf #PB_Compiler_OS = #PB_OS_Windows
			If UseHiddenConsole And ConsoleHandle And (Not UseConsole)
				Message$ = Message$ + #CRLF$
				WriteConsole_(ConsoleHandle, @Message$, Len(Message$), #Null, #Null)
			EndIf
		CompilerEndIf
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
	
	Procedure.b Trace(Message$)
		If EnableTrace
			_Log("TRACE| "+Message$)
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b EnableConsole()
		If Not UseConsole
			UseConsole = OpenConsole("Logs")
		EndIf
		
		ProcedureReturn UseConsole
	EndProcedure
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		Procedure.b EnableHiddenConsole()
			ConsoleHandle = GetStdHandle_(#STD_OUTPUT_HANDLE)
			
			If ConsoleHandle
				UseHiddenConsole = #True
			EndIf
			
			ProcedureReturn UseHiddenConsole
		EndProcedure
	CompilerEndIf
	
	Procedure EnableTrace()
		EnableTrace = #True
	EndProcedure
EndModule
