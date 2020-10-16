
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf


;- Code

DeclareModule AssetInteractor
	Declare.i Start()
	Declare.b ProcessWindowEvent(Event.i)
EndDeclareModule

Module AssetInteractor
	EnableExplicit
	
	XIncludeFile "./AssetInteractorWindow.pbf"
	
	Procedure.i Start()
		OpenAI_Window()
		ProcedureReturn AI_Window
	EndProcedure
	
	Procedure.b ProcessWindowEvent(Event.i)
		
	EndProcedure
EndModule
