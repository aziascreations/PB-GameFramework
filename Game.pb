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
If ScreenManager::ChangeScreen("loading")
	Logger::Devel("Switched screen to: loading !")
Else
	Logger::Devel("Failed to switch screen !")
EndIf


;-> Main loop

Define LastTick.q = ElapsedMilliseconds()
Define Quit = #False

Logger::Devel("Entering main loop...")
Logger::Devel(Logger::#Separator$)

Repeat
	Define Event
	Repeat
		Event = WindowEvent()
		Select Event
			Case #PB_Event_LeftClick
				;Debug "click !"
				
			Case #PB_Event_CloseWindow
				Quit = #True
		EndSelect
	Until Event = 0
	
	Engine::Update(ElapsedMilliseconds() - LastTick)
	LastTick = ElapsedMilliseconds()
	
	Engine::Render()
	
	; Prevents the CPU from going way too fast if vsync is disabled.
	Delay(1)
Until Quit


;-> End

Logger::Info("Quitting the game...")
End 0
