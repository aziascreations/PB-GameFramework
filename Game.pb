;{
; * Game.pb
; Version: N/A
; Author: Herwin Bozet
; 
; This is the entry point of the game.
; This file should preferably stay untouched, but it is not prohibited.
;}

;- Notes

; TODO: Check ExamineScreenModes() -> In the launcher ?


;- Compiler Directives

EnableExplicit

XIncludeFile "./Framework/Framework.pbi"

If Not #PB_Compiler_Debugger
	;Logger::EnableConsole()
	Logger::EnableHiddenConsole()
EndIf
;Logger::EnableCallerVisibility()
;Logger::EnableTrace()


;- Code

;-> Initialisation

; Optional: Initialize, declare, parse and interpret the arguments and the parser.
;           Only done if #FRAMEWORK_MODULE_XINPUT is defined.
CompilerIf Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) And #FRAMEWORK_MODULE_ARGUMENTS = "#True"
	Logger::Devel("Preparing arguments structure...")
	
	Logger::Trace("Init")
	If Not Arguments::Init()
		Logger::Error("Failed to init arguments ")
		MessageRequester("Fatal error", "Argument parser initialization failure !",
		                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
		End ExitCodes::#Arguments_InitFailure
	EndIf
	
	Logger::Trace("declaring")
	If (Not ArgumentsHelper::RegisterOption('h', "help", "Prints this help text and quits")) Or
	   (Not ArgumentsHelper::RegisterOption(#Null, "width", "Window width")) Or
	   (Not ArgumentsHelper::RegisterOption(#Null, "height", "Window height")) Or
	   (Not ArgumentsHelper::RegisterOption('x', #Null$, "Window x position")) Or
	   (Not ArgumentsHelper::RegisterOption('y', #Null$, "Window y position")) Or
	   (Not ArgumentsHelper::RegisterOption('s', "screen", "Screen index")) Or
	   (Not ArgumentsHelper::RegisterOption(#Null, "show-console", "Show the logs console")) Or
	   (Not ArgumentsHelper::RegisterOption(#Null, "enable-hidden-console",
	                                        "Enables the hidden console and logging to it")) Or
	   (Not ArgumentsHelper::RegisterOption(#Null, "show-trace", "Show the trace-level logs"))
		Logger::Error("Failed to create one or more options")
		Arguments::Finish()
		MessageRequester("Fatal error", "Argument parser option creation failure !",
		                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
		End ExitCodes::#Arguments_RegisteringFailure
	EndIf
	
	Logger::Devel("Parsing arguments...")
	If Arguments::ParseArguments(1, CountProgramParameters())
		Logger::Error("Failed to parse one argument")
		Arguments::Finish()
		MessageRequester("Fatal error", "Argument parser parsing failure !",
		                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
		End ExitCodes::#Arguments_ParsingError
	EndIf
	
	Define Tmp$ = ArgumentsHelper::GetSimpleHelpText(Arguments::GetRootVerb())
	If Tmp$ = #Null$
		Debug "Error for help text"
	Else
		Debug Tmp$
	EndIf
	
	Logger::Devel("Interpreting standard arguments...")
	;If Arguments::
CompilerEndIf

; Checking if the game might be running from an archive file. (ex: Via WinRAR/7Zip)
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
		End ExitCodes::#Common_NormalExit
	EndIf
EndIf

; Prepares the engine internally.
Logger::Devel(Logger::#Separator$)
If Not Framework::Init()
	Logger::Error("Engine failed to start, now exiting...")
	MessageRequester("Fatal error", "Engine initialization failure !",
	                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
	End ExitCodes::#Framework_InitFailure
EndIf

; Starts the game window.
Logger::Devel(Logger::#Separator$)
Global GameWindow = Framework::Start()
If Not GameWindow
	Logger::Error("Failed to start engine, now exiting...")
	MessageRequester("Fatal error", "Engine start failure !",
	                 #PB_MessageRequester_Error | #PB_MessageRequester_Ok)
	End ExitCodes::#Framework_StartFailure
EndIf


;-> Game Code

Logger::Devel(Logger::#Separator$)
; Include the game's code.
XIncludeFile "./Game/GameIncluder.pbi"

; Going into the loading screen
If Not ScreenManager::ChangeScreen("loading")
	Logger::Error("Failed to switch screen !")
EndIf


;-> Main loop

Define LastTick.q = ElapsedMilliseconds(), TimeDelta.q

Logger::Devel("Entering main loop...")
Logger::Devel(Logger::#Separator$)

ExamineMouse()
ReleaseMouse(#True)

Repeat
	; Did not work !
	; ExamineMouse()
	; 
	; If ExamineMouse()
	; 	Define TempX.i = MouseX(), TempY.i = MouseY()
	; 	If MouseButton(#PB_MouseButton_Left)
	; 		Framework::ProcessClick(#PB_MouseButton_Left, TempX, TempY)
	; 	EndIf
	; 	If MouseButton(#PB_MouseButton_Right)
	; 		Framework::ProcessClick(#PB_MouseButton_Right, TempX, TempY)
	; 	EndIf
	; 	If MouseButton(#PB_MouseButton_Middle)
	; 		Framework::ProcessClick(#PB_MouseButton_Middle, TempX, TempY)
	; 	EndIf
	; EndIf
	
	; TODO: Add an external debug window here to mess around with the engine live.
	
	If Framework::RunMainWindowLoop
		Define Event
		Repeat
			Event = WindowEvent()
			Select Event
				Case #PB_Event_LeftClick
					Framework::ProcessClick(#PB_Event_LeftClick, WindowMouseX(GameWindow), WindowMouseY(GameWindow))
					
				Case #PB_Event_RightClick
					Framework::ProcessClick(#PB_Event_RightClick, WindowMouseX(GameWindow), WindowMouseY(GameWindow))
					
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

End ExitCodes::#Common_NormalExit
