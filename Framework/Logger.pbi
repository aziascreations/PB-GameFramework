;{
; * Logger.pbi
; Version: 1.0.4
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
	
	Enumeration LoggingLevels
		#Level_Raw
		#Level_Trace
		#Level_Debug
		#Level_Info
		#Level_Warning
		#Level_Error
	EndEnumeration
	
	Declare LogMessage(Message$, Caller$, Level.b)
	
	Macro Error(Message, Caller = #PB_Compiler_Module)
		Logger::LogMessage(Message, Caller, Logger::#Level_Error)
	EndMacro
	
	Macro Warning(Message, Caller = #PB_Compiler_Module)
		Logger::LogMessage(Message, Caller, Logger::#Level_Warning)
	EndMacro
	
	Macro Info(Message, Caller = #PB_Compiler_Module)
		Logger::LogMessage(Message, Caller, Logger::#Level_Info)
	EndMacro
	
	Macro Devel(Message, Caller = #PB_Compiler_Module)
		Logger::LogMessage(Message, Caller, Logger::#Level_Debug)
	EndMacro
	
	Macro Trace(Message, Caller = #PB_Compiler_Module)
		Logger::LogMessage(Message, Caller, Logger::#Level_Trace)
	EndMacro
	
	
	; Can cause some really weird problems...
	Declare.b EnableConsole()
	
	Declare.b EnableCallerVisibility()
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		Declare.b EnableHiddenConsole()
	CompilerElse
		Macro EnableHiddenConsole()
			Logger::EnableConsole()
		EndMacro
	CompilerEndIf
	
	Declare EnableTrace()
EndDeclareModule

Module Logger
	EnableExplicit
	
	Global UseConsole.b = #False
	Global EnableTrace.b = #False
	Global ShowCaller.b = #False
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		Global UseHiddenConsole.b = #False
		Global ConsoleHandle.i = #Null
	CompilerEndIf
	
	Procedure.s GetLevelPrefix(Level.b)
		Select Level
			Case #Level_Debug
				ProcedureReturn "DEBUG"
			Case#Level_Info
				ProcedureReturn "INFO "
			Case #Level_Trace
				ProcedureReturn "TRACE"
			Case #Level_Error
				ProcedureReturn "ERROR"
			Case #Level_Warning
				ProcedureReturn "WARN "
			Default
				ProcedureReturn "UNKN "
		EndSelect
	EndProcedure
	
	Procedure LogMessage(Message$, Caller$, Level.b)
		If Level <> #Level_Raw
			If Level = #Level_Trace And Not EnableTrace
				ProcedureReturn
			EndIf
			
			If ShowCaller
				If Caller$ = #Null$
					Caller$ = "N/A"
				EndIf
				
				Message$ = GetLevelPrefix(Level)+"| "+Caller$+" | "+Message$
			Else
				Message$ = GetLevelPrefix(Level)+"| "+Message$
			EndIf
		EndIf
	
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
	
	Procedure.b EnableConsole()
		If Not UseConsole
			UseConsole = OpenConsole("Logs")
		EndIf
		
		ProcedureReturn UseConsole
	EndProcedure
	
	Procedure.b EnableCallerVisibility()
		ShowCaller = #True
		ProcedureReturn ShowCaller
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
