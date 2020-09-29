;{
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

XIncludeFile "./Logger.pbi"
XIncludeFile "./Screens.pbi"
XIncludeFile "./ResourceManager.pbi"

XIncludeFile "./InternalData/DataSection-Data.Internal.pbi"


;- Code

DeclareModule Engine
	#EngineName$ = "Bootleg Engine Ultra Deluxe Edition"
	#EngineVersion$ = "0.0.1-indev"
	
	Declare.s GetEngineInfoText()
	
	Declare.b Init()
	Declare   Start()
	
	Declare Update(TimeDelta.q)
	Declare Render()
EndDeclareModule

Module Engine
	EnableExplicit
	
	Procedure.s GetEngineInfoText()
		ProcedureReturn #EngineName$+" v"+#EngineVersion$
	EndProcedure
	
	Procedure.b Init()
		Logger::Devel("Initializing "+GetEngineInfoText()+"...")
		
		If Not InitEngine3D()
			Logger::Error("Failed to initialize 3D Engine !")
			ProcedureReturn #False
		EndIf
		
		Logger::Devel("Adding 3D archives...")
		Add3DArchive("./Data", #PB_3DArchive_FileSystem)
		
		Logger::Devel("Initializing engine core modules...")
		InitSprite()
		InitKeyboard()
		InitMouse()
		
		Logger::Devel("Initializing screen manager...")
		ScreenManager::Init()
		
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
	Procedure Start()
		Protected Result = #Null
		
		If OpenWindow(0, 0, 0, 1440, 900, "PureBasic - 3D Demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
			Result = OpenWindowedScreen(WindowID(0), 0, 0, 1440, 900, 0, 0, 0)
		EndIf
		
		ProcedureReturn Result
	EndProcedure
	
	Procedure Update(TimeDelta.q)
		ScreenManager::UpdateScreen(TimeDelta)
	EndProcedure
	
	Procedure Render()
		ScreenManager::RenderScreen()
	EndProcedure
EndModule
