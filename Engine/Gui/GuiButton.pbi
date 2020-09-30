
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

XIncludeFile "./GuiHandler.pbi"

;- Commons


;- Module

DeclareModule GuiButton
	Structure GuiGtn Extends Gui::GuiElement
		ButtonText$
		IsDisabled.b
	EndStructure
	
	;Declare OnUpdate(DeltaTime.q)
	;Declare OnRender(DeltaTime.q)
	;Declare OnRegister()
	;Declare OnShown()
	;Declare OnHidden()
	;Declare OnUnregister()
	
	Declare.b SetButtonText(*GuiButton.GuiGtn, Text$)
EndDeclareModule

Module GuiButton
	
	Procedure.b SetButtonText(*GuiButton.GuiGtn, Text$)
		If *GuiButton
			*GuiButton\ButtonText$ = Text$
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
EndModule
