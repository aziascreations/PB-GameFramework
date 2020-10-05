﻿;{
; * EngineBootlegUltraDeluxe.pbi
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

XIncludeFile "./Arguments.pbi"
XIncludeFile "./Logger.pbi"
XIncludeFile "./Screens.pbi"
XIncludeFile "./ResourceManager.pbi"

XIncludeFile "./Helpers/HelpersCommon.pbi"
XIncludeFile "./Gui/GuiHandler.pbi"


;- Code

DeclareModule Engine
	#EngineName$ = "Bootleg Engine Ultra Deluxe Edition"
	#EngineVersion$ = "0.0.1-indev"
	
	Global IsRunning.b = #False
	Global HasCrashed.b = #False
	Global RunMainWindowLoop.b = #True
	
	Declare.s GetEngineInfoText()
	
	Declare.b Init()
	Declare Start(FlipMode = #PB_Screen_WaitSynchronization)
	
	Declare Update(TimeDelta.q)
	Declare Render(TimeDelta.q)
	
	; Shuts down the engine properly.
	; No part of the engine should be used afterward !
	Declare Finish(CleanMemory.b=#True)
EndDeclareModule

Module Engine
	EnableExplicit
	
	Procedure.s GetEngineInfoText()
		ProcedureReturn #EngineName$+" v"+#EngineVersion$
	EndProcedure
	
	Procedure.b Init()
		Logger::Devel("Initializing "+GetEngineInfoText()+"...")
		
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
		Resources::ReadIndexFiles("./Data/", "./Maps")
		Resources::ReadIndexFiles("./Data/", "./Models")
		Resources::ReadIndexFiles("./Data/", "./Musics")
		Resources::ReadIndexFiles("./Data/", "./Sounds")
		Resources::ReadIndexFiles("./Data/", "./Trash")
		
		;Logger::Devel("Processing game.json...")
		; Load datasection config
		
		Logger::Devel("Done !")
		ProcedureReturn #True
	EndProcedure
	
	; Starts the window and/or prompts.
	Procedure Start(FlipMode = #PB_Screen_WaitSynchronization)
		Logger::Devel("Starting engine...")
		
		Protected GameWindow = #Null
		;1440, 900
		If OpenWindow(0, 0, 0, 1366, 768, "PureBasic - 3D Demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
			GameWindow = OpenWindowedScreen(WindowID(0), 0, 0, 1440, 900, 0, 0, 0, FlipMode)
		Else
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
	EndProcedure
EndModule
