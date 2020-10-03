
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

XIncludeFile "./GuiHandler.pbi"

;- Commons


;- Module

DeclareModule GuiButton
	Structure GuiBtn Extends Gui::GuiElement
		ButtonText$
		IsDisabled.b
		
		*OnClick
	EndStructure
	
	Declare.b OnMouseClickPlaceholder(*Self.GuiBtn, MouseButton.i, MouseX.i, MouseY.i)
	
	Declare.i CreateButton(Id$, X.i, Y.i, Width.i, Height.i, ButtonText$, *Callback = #Null)
	
	Declare.b SetButtonText(*GuiButton.GuiBtn, Text$)
EndDeclareModule

Module GuiButton
	
	Procedure.i CreateButton(Id$, X.i, Y.i, Width.i, Height.i, ButtonText$, *Callback = #Null)
		Protected *GuiButton.GuiBtn
		
		*GuiButton = Gui::PopulateGui(AllocateStructure(GuiBtn), Id$, X, Y, Width, Height)
		
		If *GuiButton
			*GuiButton\ButtonText$ = ButtonText$
			
			If *Callback = #Null
				*Callback = @OnMouseClickPlaceholder()
			EndIf
			
			*GuiButton\OnClick = *Callback
		EndIf
		
		ProcedureReturn *GuiButton
	EndProcedure
	
	
	;- Default object function
	
	Procedure.b OnMouseClickPlaceholder(*Self.GuiBtn, MouseButton.i, MouseX.i, MouseY.i)
		If Not *Self
			Logger::Error("Gui pointer was null !")
			ProcedureReturn #False
		EndIf
		
		If Not Gui::IsClickInside(*Self, MouseX, MouseY)
			Logger::Devel("Gui "+*Self\Id$+" does not contain the point !")
			ProcedureReturn #False
		EndIf
		
		;Define ClickSound = Resources::GetSound("menu-click")
		;
		;If ClickSound <> #Null And IsSound(ClickSound)
		;	PlaySound(ClickSound, #PB_Sound_MultiChannel, 25)
		;Else
		;	Logger::Warning("Failed to get sound: menu-click @ "+Str(ClickSound))
		;EndIf
		
		Logger::Devel("Gui "+*Self\Id$+" has processed the click !")
		ProcedureReturn #True
	EndProcedure
	
	
	;- Helpers
	
	Procedure.b SetButtonText(*GuiButton.GuiBtn, Text$)
		If *GuiButton
			*GuiButton\ButtonText$ = Text$
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
EndModule
