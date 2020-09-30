
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule Gui
	Structure GuiElement
		Id$
		X.i
		Y.i
		Width.i
		Height.i
		
		; Callbacks
		; Only *OnFree is set by default.
		*OnUpdate
		*OnRender
		*OnRegister
		*OnShown
		*OnHidden
		*OnUnregister
		*OnFree
	EndStructure

	Declare.i CreateGui(Id$, X.i, Y.i, Width.i, Height.i)
	Declare.i PopulateGui(*Gui.GuiElement, Id$, X.i, Y.i, Width.i, Height.i)
	
	Declare OnFreePlaceholder(*GuiElement)
EndDeclareModule

Module Gui
	Global NewMap Guis.i()
	
	Procedure.i CreateGui(Id$, X.i, Y.i, Width.i, Height.i)
		ProcedureReturn PopulateGui(AllocateStructure(GuiElement), Id$, X, Y, Width, Height)
	EndProcedure
	
	Procedure.i PopulateGui(*Gui.GuiElement, Id$, X.i, Y.i, Width.i, Height.i)
		If *Gui
			*Gui\Id$ = Id$
			*Gui\X = X
			*Gui\Y = Y
			*Gui\Width = Width
			*Gui\Height = Height
			
			; Set on free
			*Gui\OnFree = Gui::@OnFreePlaceholder()
		EndIf
		
		ProcedureReturn *Gui
	EndProcedure
	
	Procedure RegisterGui(*Gui.GuiElement, Id$, Overwrite.b=#False, CleanMemory.b=#True)
		; Recheck the id and on free !
	EndProcedure
	
	Procedure OnFreePlaceholder(*GuiElement)
		If *GuiElement
			FreeStructure(*GuiElement)
		EndIf
	EndProcedure
EndModule


;- Submodules

XIncludeFile "./GuiButton.pbi"
