;{
; * Framework.pbi
; Version: N/A
; Author: Herwin Bozet
; 
; This is the engine's main file, it includes everything it and you might need.
; This file should stay untouched, there is a high risk of fucking things up you you play in here !
;}

;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

XIncludeFile "./ExitCodes.pbi"

XIncludeFile "./InternalData/DataSection-Data.Internal.pbi"
XIncludeFile "./Logger.pbi"
XIncludeFile "./Screens.pbi"

XIncludeFile "./ResourceManager.pbi"
XIncludeFile "./Helpers/HelpersCommon.pbi"
XIncludeFile "./Gui/GuiHandler.pbi"

; Optional: Imports Arguments if #FRAMEWORK_MODULE_XINPUT is defined.
CompilerIf Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) And #FRAMEWORK_MODULE_ARGUMENTS = "#True"
	XIncludeFile "./Arguments/Arguments.pbi"
	XIncludeFile "./Arguments/ArgumentsHelper.pbi"
CompilerEndIf

; Optional: Imports XInput and ControllerManager if #FRAMEWORK_MODULE_XINPUT is defined.
CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant) And #FRAMEWORK_MODULE_XINPUT = "#True"
	XIncludeFile "./Controllers/XInput.pbi"
	XIncludeFile "./Controllers/ControllerManager.pbi"
CompilerEndIf

; Optional: Imports Snappy if #FRAMEWORK_MODULE_SNAPPY is defined.
CompilerIf Defined(FRAMEWORK_MODULE_SNAPPY, #PB_Constant) And #FRAMEWORK_MODULE_SNAPPY = "#True"
	XIncludeFile "./Snappy/Snappy.pbi"
CompilerEndIf


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
	Declare.i Start(FlipMode = #PB_Screen_WaitSynchronization)
	
	Declare Update(TimeDelta.q)
	Declare Render(TimeDelta.q)
	
	Declare.b ProcessClick(MouseButton.i, PositionX.i, PositionY.i)
	
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
	
	CompilerIf Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) And #FRAMEWORK_MODULE_ARGUMENTS = "#True"
		Global SkipArguments.b = #False
	CompilerEndIf
	
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
		CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant) And #FRAMEWORK_MODULE_XINPUT = "#True"
			Logger::Devel("Initializing XInput...")
			XInputLibraryID = XInput::InitXInput()
			
			If Not XInputLibraryID
				Logger::Error("Failed to initialize XInput 1.4 !")
				ProcedureReturn #False
			EndIf
			
			If Not XInput::LoadXInputFunctions(XInputLibraryID) = #False
				Logger::Error("Failed to load functions from the XInput 1.4 library !")
				ProcedureReturn #False
			EndIf
			
			XInput::XInputEnable(#True)
		CompilerEndIf
		
		CompilerIf Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) And #FRAMEWORK_MODULE_ARGUMENTS = "#True"
			If Arguments::GetRootVerb() = #Null
				Logger::Devel("Initializing arguments parser...")
				Arguments::Init()
			Else
				SkipArguments = #True
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
	Procedure.i Start(FlipMode = #PB_Screen_WaitSynchronization)
		Logger::Devel("Starting engine...")
		
		CompilerIf Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) And #FRAMEWORK_MODULE_ARGUMENTS = "#True"
			If Not SkipArguments
				Logger::Devel("Parsing arguments...")
				If Arguments::ParseArguments(0, CountProgramParameters())
					Logger::Devel("Failed to parse launch arguments !")
					;Arguments::Finish()
					ProcedureReturn #Null
				EndIf
			EndIf
		CompilerEndIf
		
		Protected GameWindow = OpenWindow(#PB_Any, 0, 0, 1366, 768, "PureBasic - 3D Demos",
		                                  #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		If GameWindow
			If Not OpenWindowedScreen(WindowID(GameWindow), 0, 0, 1366, 768, #True, 0, 0, FlipMode)
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
		CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
			ControllerManager::Update()
		CompilerEndIf
		
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
		
		CompilerIf Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) And #FRAMEWORK_MODULE_ARGUMENTS = "#True"
			Arguments::Finish()
		CompilerEndIf
		
		;Logger::Finish(CleanMemory)
		
		; Optional: Closes XInput if #FRAMEWORK_MODULE_XINPUT is defined.
		CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant) And #FRAMEWORK_MODULE_XINPUT = "#True"
			XInput::CloseXInputLibrary(XInputLibraryID)
		CompilerEndIf
	EndProcedure
	
	Procedure.b ProcessClick(MouseButton.i, PositionX.i, PositionY.i)
		If MouseButton = #PB_MouseButton_Left Or MouseButton = #PB_Event_LeftClick
			If Not Gui::MouseClick(Gui::#GuiEvent_LeftClick, PositionX, PositionY)
				ProcedureReturn ScreenManager::ProcessClick(MouseButton, PositionX, PositionY)
			Else
				ProcedureReturn #True
			EndIf
		ElseIf MouseButton = #PB_MouseButton_Right Or MouseButton = #PB_Event_RightClick
			If Gui::MouseClick(Gui::#GuiEvent_RightClick, PositionX, PositionY)
				ProcedureReturn ScreenManager::ProcessClick(MouseButton, PositionX, PositionY)
			Else
				ProcedureReturn #True
			EndIf
		EndIf
		
		ProcedureReturn #False
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
