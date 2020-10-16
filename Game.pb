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
IncludePath "./Framework/"
XIncludeFile "./Framework.pbi"

If Not #PB_Compiler_Debugger
	Logger::EnableConsole()
EndIf
;Logger::EnableTrace()


;- Code

;-> Initialisation

If Framework::IsRunningInArchive() Or Framework::IsRunningInArchive(#False, #Null$, "./Data") Or
   (Framework::IsRunningInArchive(#False, "Engine3d.dll") And
    Framework::IsRunningInArchive(#False, "Engine3D.dll"))
	Define MsgResult.i = MessageRequester("Warning",
	                                      "We detected that the game might be missing some"+#CRLF$+
	                                      "important files or might be running from an archive."+#CRLF$+#CRLF$+
	                                      "If you are running it from an archive, please"+#CRLF$+
	                                      "extract it before running it to avoid errors !"+#CRLF$+#CRLF$+
	                                      "Do you still wish to continue and run the game ?",
	                                      #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo)
	If MsgResult = #PB_MessageRequester_No
		End 0
	EndIf
EndIf


; Prepares the engine internally.
If Not Framework::Init()
	Logger::Error("Engine failed to start, now exiting...")
	MessageRequester("Fatal error", "Engine initialization failure !",
	                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
	End 1
EndIf

; Starts the game window.
; May open prompts before returning !
Global GameWindow = Framework::Start()
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

; Going into the loading screen
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
	
	; TODO: Add an external debug window here to mess around with the engine live.
	
	If Framework::RunMainWindowLoop
		Define Event
		Repeat
			Event = WindowEvent()
			Select Event
				Case #PB_Event_LeftClick
					Gui::MouveClick(Gui::#GuiEvent_LeftClick, MouseX(), MouseY())
					
				Case #PB_Event_RightClick
					Gui::MouveClick(Gui::#GuiEvent_RightClick, MouseX(), MouseY())
					
				Case #PB_Event_CloseWindow
					;If EventWindow() = GameWindow
					Framework::IsRunning = #False
					;EndIf
			EndSelect
		Until Event = 0
	EndIf
	
	; Calculating the time delta
	TimeDelta = ElapsedMilliseconds() - LastTick
	LastTick = ElapsedMilliseconds()
	
	; Calling the screen functions
	Framework::Update(TimeDelta)
	Framework::Render(TimeDelta)
	
	; Prevents the CPU from going way too fast if vsync is disabled.
	; This is a bad way of doing it, but it works, so...
	;Delay(1)
Until Not Framework::IsRunning


;- End

If Framework::HasCrashed
	; ???
	; Do something with the on-line library ?
Else
	Logger::Devel("The engine is exiting gracefully !")
EndIf

Framework::Finish(#True)
End 0
