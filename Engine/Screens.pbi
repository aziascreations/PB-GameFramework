
CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

DeclareModule ScreenManager
	Structure ScreenData
		ScreenName$
		
		*OnRegister
		*OnUnregister
		*OnInit
		*OnStart
		*OnUpdate
		*OnRender
		*OnLeave
		*OnQuit
	EndStructure
	
	Declare.b Init()
	
	Declare.i CreateScreen(ScreenName$ = "DefaultScreen", *OnRegister = #Null, *OnUnregister = #Null,
	                        *OnInit = #Null, *OnStart = #Null, *OnUpdate = #Null, *OnRender = #Null,
	                        *OnLeave = #Null, *OnQuit = #Null)
	
	; Returns non-zero if the screen was registered !
	Declare.b RegisterScreen(*CurrentScreen.ScreenData, ScreenKey$, Overwrite.b = #False, AutoFreeMemory.b = #True)
	
	
	Declare UpdateScreen(TimeDelta.q)
	Declare RenderScreen(TimeDelta.q)
	
	Declare SkipNextRender()
	
	Declare.b ChangeScreen(ScreenKey$)
	
	Declare.b Finish(CleanMemory.b=#True)
EndDeclareModule

Module ScreenManager
	EnableExplicit
	
	Global *CurrentScreen.ScreenData = #Null
	Global NewMap Screens.i()
	Global SkipRender.b = #False
	
	Procedure.b Init()
		*CurrentScreen = #Null
		ProcedureReturn #True
		SkipRender.b = #False
		Logger::Info("aaa")
	EndProcedure
	
	Procedure.i CreateScreen(ScreenName$ = "DefaultScreen", *OnRegister = #Null, *OnUnregister = #Null,
	                          *OnInit = #Null, *OnStart = #Null, *OnUpdate = #Null, *OnRender = #Null,
	                          *OnLeave = #Null, *OnQuit = #Null)
		Protected *NewScreen.ScreenData = AllocateStructure(ScreenData)
		
		If *NewScreen
			With *NewScreen
				\ScreenName$ = ScreenName$
				\OnRegister = *OnRegister
				\OnUnregister = *OnUnregister
				\OnInit = *OnInit
				\OnStart = *OnStart
				\OnUpdate = *OnUpdate
				\OnRender = *OnRender
				\OnLeave = *OnLeave
				\OnQuit = *OnQuit
			EndWith
		EndIf
		
		ProcedureReturn *NewScreen
	EndProcedure
	
	Procedure.b RegisterScreen(*NewScreen.ScreenData, ScreenKey$, Overwrite.b = #False, AutoFreeMemory.b = #True)
		Protected *OldScreen.ScreenData = #Null
		
		If *NewScreen And ScreenKey$ <> #Null$
			*OldScreen = Screens(ScreenKey$)
			
			If *OldScreen
				Logger::Devel("Found a screen already registered as: "+ScreenKey$)
				
				If Overwrite
					Logger::Devel("Removing old screen...")
					
					If *OldScreen\OnUnregister
						CallFunctionFast(*OldScreen\OnUnregister)
					EndIf
					
					If AutoFreeMemory
						FreeStructure(*OldScreen)
					EndIf
				Else
					Logger::Error("Unable to overwrite screen !")
					ProcedureReturn #False
				EndIf
			EndIf
			
			Logger::Devel("Registered new screen as: "+ScreenKey$)
			Screens(ScreenKey$) = *NewScreen
			
			If *NewScreen\OnRegister <> #Null
				CallFunctionFast(*NewScreen\OnRegister)
			EndIf
			
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure UpdateScreen(TimeDelta.q)
		If *CurrentScreen And *CurrentScreen\OnUpdate
			CallFunctionFast(*CurrentScreen\OnUpdate, TimeDelta)
		EndIf
	EndProcedure
	
	Procedure RenderScreen(TimeDelta.q)
		; Temporary fix
		If SkipRender
			SkipRender = #False
			ProcedureReturn
		EndIf
		
		If *CurrentScreen And *CurrentScreen\OnRender
			CallFunctionFast(*CurrentScreen\OnRender, TimeDelta)
		EndIf
	EndProcedure
	
	Procedure SkipNextRender()
		SkipRender = #True
	EndProcedure
	
	Procedure.b ChangeScreen(ScreenKey$)
		Protected *NewScreen.ScreenData = Screens(ScreenKey$)
		
		If Not *NewScreen
			Logger::Error("Failed to find screen named: "+ScreenKey$)
			ProcedureReturn #False
		EndIf
		
		If *CurrentScreen
			If *CurrentScreen\OnLeave
				CallFunctionFast(*CurrentScreen\OnLeave)
			EndIf
		EndIf
		
		*CurrentScreen = *NewScreen
		
		If *CurrentScreen\OnStart
			CallFunctionFast(*CurrentScreen\OnStart)
		EndIf
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b Finish(CleanMemory.b=#True)
		If *CurrentScreen
			If *CurrentScreen\OnLeave
				CallFunctionFast(*CurrentScreen\OnLeave)
			EndIf
			If *CurrentScreen\OnQuit
				CallFunctionFast(*CurrentScreen\OnQuit)
			EndIf
		EndIf
		
		If CleanMemory
			ForEach Screens()
				Protected *TmpScreenPtr.ScreenData = Screens()
				
				If *TmpScreenPtr
					If *TmpScreenPtr\OnUnregister
						CallFunctionFast(*TmpScreenPtr\OnUnregister)
					EndIf
					
					FreeStructure(Screens())
				EndIf
			Next
		EndIf
		
		ClearMap(Screens())
		FreeMap(Screens())
		
		ProcedureReturn #True
	EndProcedure
EndModule
