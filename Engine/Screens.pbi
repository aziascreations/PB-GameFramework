
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Modules

;-> ScreenManager

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
	
	Declare.b SetErrorScreen(*NewErrorScreen, Overwrite.b=#True, CleanMemory.b=#True)
	
	Declare.b ShowErrorScreen(Message$)
EndDeclareModule

Module ScreenManager
	EnableExplicit
	
	Global *CurrentScreen.ScreenData = #Null
	Global NewMap Screens.i()
	Global SkipRender.b = #False
	Global *ErrorScreen.ScreenData = #Null
	
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
		Protected *NewScreen.ScreenData
		
		If ScreenKey$ = "ERROR"
			*NewScreen = *ErrorScreen
		Else
			*NewScreen = Screens(ScreenKey$)
		EndIf
		
		If Not *NewScreen
			Logger::Error("Failed to find screen named: "+ScreenKey$)
			*ErrorScreen\ScreenName$ = "Failed to find screen named: "+ScreenKey$
			*NewScreen = *ErrorScreen
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
		
		If *NewScreen = *ErrorScreen
			ProcedureReturn #False
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
	
	Procedure.b SetErrorScreen(*NewErrorScreen, Overwrite.b=#True, CleanMemory.b=#True)
		Logger::Trace("Updating error screen...")
		
		If *ErrorScreen <> #Null
			If CleanMemory
				FreeStructure(*ErrorScreen)
			Else
				If Overwrite
					Logger::Warning("Potential memory leak in ScreenManager::SetErrorScreen() !")
				Else
					Logger::Error("Failed to change error screen !")
					ProcedureReturn #False
				EndIf
			EndIf
		EndIf
		
		*ErrorScreen = *NewErrorScreen
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b ShowErrorScreen(Message$)
		*ErrorScreen\ScreenName$ = Message$
		ChangeScreen("ERROR")
	EndProcedure
EndModule


;-> ErrorScreen

; This screen will only be used if a screen change has failed or if the program calls for it.
; When you enter it, you should assume that everything appart from the core loop is not working !

DeclareModule ErrorScreen
	#Id$ = "error"
	
	Declare.i Register()
EndDeclareModule

Module ErrorScreen
	EnableExplicit
	
	Global ErrorTextSprite, *Self.ScreenManager::ScreenData, ErrorCamera, StartTime.q
	
	Procedure OnStart()
		If Trim(*Self\ScreenName$) = #Null$
			*Self\ScreenName$ = "A fatal error occured !"
		EndIf
		
		; The Text3D wasn't working for me...
		ErrorTextSprite = CreateSprite(#PB_Any, 800, 600)
		StartDrawing(SpriteOutput(ErrorTextSprite))
		DrawText(10, 10, "!!! FATAL ERROR !!!", RGB(255, 0, 0), RGB(0, 0, 0))
		DrawText(20, 30, *Self\ScreenName$, RGB(255, 0, 0), RGB(0, 0, 0))
		DrawText(10, 70, "The application will stop shortly...", RGB(255, 0, 0), RGB(0, 0, 0))
		StopDrawing()
		
		ErrorCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		CameraBackColor(ErrorCamera, RGB(0, 0, 0))
		MoveCamera(ErrorCamera, 50, 50, 50, #PB_Absolute)
		CameraLookAt(ErrorCamera, 0, 0, 0)
		
		StartTime = ElapsedMilliseconds()
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		; Rendering 3D elements...
		RenderWorld()
		
		; Rendering 2D elements...
		DisplaySprite(ErrorTextSprite, 0, 0)
		
		; Finishing.
		FlipBuffers()
		
		If StartTime + 7500 < ElapsedMilliseconds()
			End 666
		EndIf
	EndProcedure
	
	Procedure OnLeave()
		FreeCamera(ErrorCamera)
		FreeSprite(ErrorTextSprite)
	EndProcedure
	
	Procedure.i Register()
		*Self = ScreenManager::CreateScreen("Error screen", #Null, #Null, #Null,
		                                    @OnStart(), #Null, @OnRender(), @OnLeave())
		
		If Not *Self
			Logger::Error("Failed to create error screen !")
			End 3
		EndIf
		
		If Not ScreenManager::RegisterScreen(*Self, #Id$, #True, #True)
			Logger::Error("Failed to register error screen !")
			End 4
		EndIf
		
		ScreenManager::SetErrorScreen(*Self, #True, #True)
	EndProcedure
EndModule
