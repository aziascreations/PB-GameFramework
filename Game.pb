;{
; * Game.pb
; Version: N/A
; Author: Herwin Bozet
; 
; This is the entry point of the game.
; This file should preferably stay untouched, but it is not prohibited.
;}

;- Notes

; TODO: Check ExamineScreenModes()


;- Compiler Directives
EnableExplicit

; Include the engine module and all the other ones.
IncludePath "./Engine/"
XIncludeFile "./EngineBootlegUltraDeluxe.pbi"

If Not #PB_Compiler_Debugger
	Logger::EnableConsole()
	;Logger::EnableTrace()
EndIf


;- Code

;-> Initialisation

; Prepares the engine internally.
If Not Engine::Init()
	Logger::Error("Engine failed to start, now exiting...")
	MessageRequester("Fatal error", "Engine initialization failure !",
	                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
	End 1
EndIf

; Starts the game window.
; May open prompts before returning !
If Not Engine::Start()
	Logger::Error("Failed to start engine, now exiting...")
	MessageRequester("Fatal error", "Engine start failure !",
	                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
	End 2
EndIf


;-> Game Code

; Include the game's code.
IncludePath "./Game/"
XIncludeFile "./GameCommons.pbi"

; Going into the game screen
If Not ScreenManager::ChangeScreen("loading")
	Logger::Devel("Failed to switch screen !")
EndIf


;-> Main loop

Define LastTick.q = ElapsedMilliseconds(), TimeDelta.q

Logger::Devel("Entering main loop...")
Logger::Devel(Logger::#Separator$)

Repeat
	Define Event
	Repeat
		Event = WindowEvent()
		Select Event
			Case #PB_Event_LeftClick
				Define ClickSound = Resources::GetSound("menu-click")
				
				If ClickSound <> #Null And IsSound(ClickSound)
					PlaySound(ClickSound, #PB_Sound_MultiChannel, 25)
				Else
					Logger::Warning("Failed to get sound: menu-click @ "+Str(ClickSound))
				EndIf
				
			Case #PB_Event_RightClick
				Define BackSound = Resources::GetSound("menu-back")
				
				If BackSound <> #Null And IsSound(BackSound)
					PlaySound(BackSound, #PB_Sound_MultiChannel, 25)
				Else
					Logger::Warning("Failed to get sound: menu-back @ "+Str(BackSound))
				EndIf
				
			Case #PB_Event_CloseWindow
				Engine::IsRunning = #False
		EndSelect
	Until Event = 0
	
	TimeDelta = ElapsedMilliseconds() - LastTick
	Engine::Update(TimeDelta)
	Engine::Render(TimeDelta)
	LastTick = ElapsedMilliseconds()
	
	; Prevents the CPU from going way too fast if vsync is disabled.
	Delay(1)
Until Not Engine::IsRunning


;-> End

If Engine::HasCrashed
	; ???
Else
	Logger::Devel("The engine is exiting gracefully !")
EndIf

Engine::Finish(#True)
End 0
