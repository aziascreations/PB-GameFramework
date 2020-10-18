;{
; * Framework.pbi
; Version: N/A
; Author: Herwin Bozet
; 
; This is the engine's main file, it includes everything it will need and with declare itself as a module.
; This file should stay untouched, there is a high risk of fucking things up you you play in here !
;}

;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

XIncludeFile "./InternalData/DataSection-Data.Internal.pbi"

; TODO: Include module common

; Optional: Imports XInput if #FRAMEWORK_MODULE_XINPUT is defined.
CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
	XIncludeFile "./Controllers/XInput.pbi"
CompilerEndIf

XIncludeFile "./Arguments.pbi"
XIncludeFile "./Logger.pbi"
XIncludeFile "./Screens.pbi"
XIncludeFile "./ResourceManager.pbi"

XIncludeFile "./Helpers/HelpersCommon.pbi"
XIncludeFile "./Gui/GuiHandler.pbi"


;- Code

DeclareModule Framework
	#EngineName$ = "Bootleg Framework - Ultra Deluxe Edition"
	#EngineVersion$ = "0.0.1-indev"
	
	Global IsRunning.b = #False
	Global HasCrashed.b = #False
	Global RunMainWindowLoop.b = #True
	
	CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
		Global XInputLibraryID.i = #Null
	CompilerEndIf
	
	Declare.s GetFrameworkInfoText()
	
	Declare.b Init()
	Declare Start(FlipMode = #PB_Screen_WaitSynchronization)
	
	Declare Update(TimeDelta.q)
	Declare Render(TimeDelta.q)
	
	; Shuts down the engine properly.
	; No part of the engine should be used afterward !
	Declare Finish(CleanMemory.b=#True)
	
	Declare.b IsRunningInArchive(CheckCurrentDirectory.b = #True, CheckFile$ = #Null$, CheckFolder$ = #Null$)
	
	Macro IsXInputEnabled()
		Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
	EndMacro
EndDeclareModule

Module Framework
	EnableExplicit
	
	Procedure.s GetFrameworkInfoText()
		ProcedureReturn #EngineName$+" v"+#EngineVersion$
	EndProcedure
	
	Procedure.b Init()
		Logger::Devel("Initializing "+GetFrameworkInfoText()+"...")
		
		Logger::Devel("Initializing 3D engine...")
		If Not InitEngine3D()
			Logger::Error("Failed to initialize 3D engine !")
			ProcedureReturn #False
		EndIf
		
		Logger::Devel("Adding 3D archives...")
		Add3DArchive("./Data", #PB_3DArchive_FileSystem)
		Logger::Trace("Added: ./Data")
		
		Logger::Devel("Initializing engine core modules...")
		InitSprite()
		InitKeyboard()
		InitMouse()
		
		Logger::Devel("Initializing screen manager...")
		ScreenManager::Init()
		ErrorScreen::Register()
		
		Logger::Devel("Initializing resource manager...")
		Resources::Init()
		Resources::ReadIndexFiles("./Data/", "./Graphics")
		Resources::ReadIndexFiles("./Data/", "./Materials")
		Resources::ReadIndexFiles("./Data/", "./Models")
		Resources::ReadIndexFiles("./Data/", "./Musics")
		Resources::ReadIndexFiles("./Data/", "./Sounds")
		
		; Optional: Initialize XInput if #FRAMEWORK_MODULE_XINPUT is defined.
		CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
			Logger::Devel("Initializing XInput...")
			XInputLibraryID = XInput::InitXInput()
			
			If Not XInputLibraryID
				Logger::Error("Failed to initialize XInput 1.4 !")
				ProcedureReturn #False
			EndIf
		CompilerEndIf
		
; 		Logger::Devel("Processing game.json...")
; 		; Load datasection config
; 		Protected GameJson = CatchJSON(#PB_Any, InternalData:: game_json_start,
; 		                               InternalData::game_json_stop - InternalData::game_json_start)
; 		If IsJSON(GameJson)
; 			
; 			FreeJSON(GameJson)
; 		Else
; 			Logger::Devel("Failed to parse JSON: "+JSONErrorMessage()+"@"+
; 			              JSONErrorLine()+":"+JSONErrorPosition())
; 		EndIf
		
		Logger::Devel("Done !")
		ProcedureReturn #True
	EndProcedure
	
	; Starts the window and/or prompts.
	Procedure Start(FlipMode = #PB_Screen_WaitSynchronization)
		Logger::Devel("Starting engine...")
		
		Protected GameWindow = #Null
		;1440, 900
		;1366, 768
		
		GameWindow = OpenWindow(#PB_Any, 0, 0, 1366, 768, "PureBasic - 3D Demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		If GameWindow
			If Not OpenWindowedScreen(WindowID(GameWindow), 0, 0, 1366, 768, 0, 0, 0, FlipMode)
				Logger::Error("Failed to open windowed screen !")
				ProcedureReturn #False
			EndIf
		Else
			Logger::Error("Failed to open main window !")
			ProcedureReturn #False
		EndIf
		
		Logger::Devel("Starting resource manager...")
		Resources::Start()
		
		IsRunning = #True
		
		ProcedureReturn GameWindow
	EndProcedure
	
	Procedure Update(TimeDelta.q)
		ScreenManager::UpdateScreen(TimeDelta)
	EndProcedure
	
	Procedure Render(TimeDelta.q)
		ScreenManager::RenderScreen(TimeDelta)
	EndProcedure
	
	Procedure Finish(CleanMemory.b=#True)
		Logger::Devel("Finishing engine...")
		
		Gui::FlushGuis(CleanMemory)
		Resources::Finish(CleanMemory)
		ScreenManager::Finish(CleanMemory)
		;Args::Finish(CleanMemory)
		;Logger::Finish(CleanMemory)
		
		; Optional: Closes XInput if #FRAMEWORK_MODULE_XINPUT is defined.
		CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
			XInput::CloseXInputLibrary(XInputLibraryID)
		CompilerEndIf
	EndProcedure
	
	Procedure.b IsRunningInArchive(CheckCurrentDirectory.b = #True, CheckFile$ = #Null$, CheckFolder$ = #Null$)
		If CheckCurrentDirectory
			If FindString(GetCurrentDirectory(), GetTemporaryDirectory())
				ProcedureReturn #True
			EndIf
		EndIf
		
		If CheckFile$ <> #Null$
			If Not (FileSize(CheckFile$) >= 0)
				ProcedureReturn #True
			EndIf
		EndIf
		
		If CheckFolder$ <> #Null$
			If FileSize(CheckFolder$) <> -2
				ProcedureReturn #True
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
EndModule
