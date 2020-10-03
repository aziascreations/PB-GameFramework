
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule MainMenuScreen
	Declare.i GetScreen()
	Declare OnRegister()
	Declare OnInit()
	Declare OnStart()
	Declare OnUpdate(TimeDelta.q)
	Declare OnRender(TimeDelta.q)
	Declare OnLeave()
EndDeclareModule

Module MainMenuScreen
	#BaseSkyBoxSize = 64*500
	
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("Main Menu",
		                                            @OnRegister(),
		                                            #Null,
		                                            @OnInit(),
		                                            @OnStart(),
		                                            @OnUpdate(),
		                                            @OnRender(),
		                                            @OnLeave())
	EndProcedure
	
	Procedure OnRegister()
		Logger::Devel("OnRegister was called for main menu screen !")
		
	EndProcedure
	
	Procedure OnInit()
		Logger::Devel("OnInit was called for main menu screen !")
		
	EndProcedure
	
	Procedure OnStart()
		Logger::Devel("OnStart was called for main menu screen !")
		
		Logger::Devel("Preparing resources...")
		Skybox::GenerateSquareSkybox("skybox-mm-tmp", "skybox-mainmenu", #BaseSkyBoxSize)
		
		; Camera
		If Not Resources::HasCamera("mainmenu")
			Resources::SetCamera("mainmenu", CreateCamera(#PB_Any, 0, 0, 100, 100))
			CameraBackColor(Resources::GetCamera("mainmenu"), RGB(245, 245, 245))
			MoveCamera(Resources::GetCamera("mainmenu"), 0, 0, 0, #PB_Absolute)
			CameraLookAt(Resources::GetCamera("mainmenu"), 100, 0, 0)
			CameraFOV(Resources::GetCamera("mainmenu"), 80)
		EndIf
		
		GuiButton::CreateButton("button-test01", 10, 10, 200, 25, "Fuck !")
		;Logger::Devel("Finishing...")
		; ???
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		If TimeDelta > 100
			ProcedureReturn
		EndIf
		
		RotateCamera(Resources::GetCamera("mainmenu"), 0, TimeDelta*0.005, 0, #PB_Relative)
		Gui::Update(TimeDelta)
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		ClearScreen(RGB(0, 0, 0))
		
		; Rendering 3D elements...
		RenderWorld()
		
		; Rendering 2D elements...
		Gui::Render(TimeDelta)
		;DisplaySprite()
		
		; Finishing.
		FlipBuffers()
	EndProcedure
	
	Procedure OnLeave()
		Logger::Devel("OnLeave was called for main menu screen !")
		
		Logger::Devel("Deleting entities and cameras...")
		Resources::FlushCameras(#True)
		Resources::FlushEntities(#True)
		
		Gui::FlushGuis(#True)
	EndProcedure
EndModule


;- Code

Logger::Devel("Executing: "+GetFilePart(#PB_Compiler_Filename, #PB_FileSystem_NoExtension))

Global *MainMenuScreen = MainMenuScreen::GetScreen()

If Not *MainMenuScreen
	Logger::Error("Failed to create main menu screen !")
	End 3
EndIf

If Not ScreenManager::RegisterScreen(*MainMenuScreen, "mainmenu", #True, #True)
	Logger::Error("Failed to register main menu screen !")
	End 4
EndIf
