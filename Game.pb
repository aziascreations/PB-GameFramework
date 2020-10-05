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
EndIf
;Logger::EnableTrace()


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
Global GameWindow = Engine::Start()
If Not GameWindow
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

ExamineMouse()
ReleaseMouse(#True)

Repeat
	ExamineMouse()
	
	If Engine::RunMainWindowLoop
		Define Event
		Repeat
			Event = WindowEvent()
			Select Event
				Case #PB_Event_LeftClick
					Gui::MouveClick(Gui::#GuiEvent_LeftClick, MouseX(), MouseY())
					
				Case #PB_Event_RightClick
					Gui::MouveClick(Gui::#GuiEvent_RightClick, MouseX(), MouseY())
					
				Case #PB_Event_CloseWindow
					If EventWindow() = GameWindow
						Engine::IsRunning = #False
					EndIf
			EndSelect
		Until Event = 0
	EndIf
	
	; Calculating the time delta
	TimeDelta = ElapsedMilliseconds() - LastTick
	LastTick = ElapsedMilliseconds()
	
	; Calling the screen functions
	Engine::Update(TimeDelta)
	Engine::Render(TimeDelta)
	
	; Prevents the CPU from going way too fast if vsync is disabled.
	; This is a bad way of doing it, but it works, so...
	;Delay(1)
Until Not Engine::IsRunning


;- End

If Engine::HasCrashed
	; ???
Else
	Logger::Devel("The engine is exiting gracefully !")
EndIf

Engine::Finish(#True)
End 0
