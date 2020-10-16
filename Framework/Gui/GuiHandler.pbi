
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule Gui
	Enumeration GuiEventParams
		#GuiEvent_LeftClick
		#GuiEvent_RightClick
	EndEnumeration
	
	Structure GuiElement
		Id$
		X.i
		Y.i
		Width.i
		Height.i
		
		IsActive.b
		
		; Callbacks
		; Only *OnFree is set by default.
		*OnUpdate
		*OnRender
		*OnRegister
		*OnShown
		*OnHidden
		*OnUnregister
		*OnFree
		
		; Common event callbacks
		*OnMouseMoved
		*OnMouseEnter
		*OnMouseLeave
		*OnMouseClick
		*OnMouseWheel
	EndStructure

	Declare.i CreateGui(Id$, X.i, Y.i, Width.i, Height.i)
	Declare.i PopulateGui(*Gui.GuiElement, Id$, X.i, Y.i, Width.i, Height.i)
	
	Declare Update(TimeDelta.q)
	Declare Render(TimeDelta.q)
	
	;Declare.b PropagateEvent(GuiEventId.i, )
	Declare FlushGuis(CleanMemory.b = #True)
	
	Declare OnFreePlaceholder(*GuiElement)
	
	; Events
	Declare.b MouveMoved()
	Declare.b MouveClick(MouseButton.i, MouseX.i, MouseY.i)
	Declare.b MouveWheel(Amount.i)
	
	; Helpers
	Declare.b IsClickInside(*Gui.GuiElement, MouseX.i, MouseY.i)
EndDeclareModule

Module Gui
	; Not good for ordered rendering !!!
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
	
	Procedure Update(TimeDelta.q)
		
	EndProcedure
	
	Procedure Render(TimeDelta.q)
		
	EndProcedure
	
	Procedure FlushGuis(CleanMemory.b = #True)
		If CleanMemory
			ForEach Guis()
				Protected *TempPtr
				If *TempPtr
					FreeStructure(*TempPtr)
				EndIf
			Next
		EndIf
		
		ClearMap(Guis())
	EndProcedure
	
	Procedure OnFreePlaceholder(*GuiElement)
		If *GuiElement
			FreeStructure(*GuiElement)
		EndIf
	EndProcedure
	
	
	;- Events
	
	Procedure.b MouveMoved()
		ForEach Guis()
			Protected *Gui.GuiElement
			If *Gui And *Gui\OnMouseMoved
				;CallCFunctionFast(*Gui\OnMouseMoved)
			EndIf
		Next
	EndProcedure
	
	Procedure.b MouveClick(MouseButton.i, MouseX.i, MouseY.i)
		ForEach Guis()
			Protected *Gui.GuiElement
			If *Gui And *Gui\OnMouseClick
				CallCFunctionFast(*Gui\OnMouseClick, *Gui, MouseButton, MouseX, MouseY)
			EndIf
		Next
	EndProcedure
	
	Procedure.b MouveWheel(Amount.i)
		ForEach Guis()
			Protected *Gui.GuiElement
			If *Gui And *Gui\OnMouseClick
				CallCFunctionFast(*Gui\OnMouseWheel, *Gui, Amount)
			endif
		Next
	EndProcedure
	
	
	;- Helpers
	
	Procedure.b IsClickInside(*Gui.GuiElement, MouseX.i, MouseY.i)
		If *Gui
			If *Gui\X <= MouseX And *Gui\Y <= MouseY And (*Gui\X+*Gui\Width >= MouseX) And
			   (*Gui\Y+*Gui\Height >= MouseY)
				ProcedureReturn #True
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
EndModule


;- Submodules

XIncludeFile "./GuiButton.pbi"
