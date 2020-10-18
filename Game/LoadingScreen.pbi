
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule ScreenLoading
	Declare.i GetScreen()
	
	Declare OnStart()
	Declare OnUpdate(TimeDelta.q)
	Declare OnRender(TimeDelta.q)
	Declare OnLeave()
EndDeclareModule

Module ScreenLoading
	EnableExplicit
	
	Global DefaultCamera
	Global TextSprite, LogoSprite, StartTime.q
	
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("Loading screen",
		                                            #Null,
		                                            #Null,
		                                            #Null,
		                                            @OnStart(),
		                                            @OnUpdate(),
		                                            @OnRender(),
		                                            @OnLeave())
	EndProcedure
	
	Procedure OnStart()
		Logger::Devel("OnStart was called for loading screen !")
		
		LogoSprite = Resources::GetSprite("loading-logo")
		TextSprite = Resources::GetSprite("loading-text")
		
		DefaultCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		CameraBackColor(DefaultCamera, RGB(245, 245, 245))
		MoveCamera(DefaultCamera, 50, 50, 50, #PB_Absolute)
		CameraLookAt(DefaultCamera, 0, 0, 0)
		Resources::SetCamera("loading-camera", DefaultCamera, #True, #True)
		
		StartTime = ElapsedMilliseconds()
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		If LogoSprite = Resources::ErrorSprite And Resources::HasSprite("loading-logo")
			LogoSprite = Resources::GetSprite("loading-logo")
		EndIf
		If TextSprite = Resources::ErrorSprite And Resources::HasSprite("loading-text")
			TextSprite = Resources::GetSprite("loading-text")
		EndIf
		
		If Resources::Update() And StartTime + 1000 < ElapsedMilliseconds()
			Logger::Devel("Finished loading resources, changing screen...")
			
			;ScreenManager::ChangeScreen("mainmenu")
			ScreenManager::ChangeScreen("controller-test")
			;ScreenManager::ChangeScreen("model-manipulator")
			;ScreenManager::ChangeScreen("camera-test")
			;ScreenManager::ChangeScreen("dungeon-test")
			ScreenManager::SkipNextRender()
			Logger::Devel(Logger::#Separator$)
		EndIf
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		RenderWorld()
		
		If LogoSprite <> Resources::ErrorSprite
			DisplayTransparentSprite(LogoSprite, ScreenWidth()/2 - SpriteWidth(LogoSprite)/2,
			                         ScreenHeight()/2 - SpriteHeight(LogoSprite)/2,
			                         255)
		EndIf
		
		If TextSprite <> Resources::ErrorSprite
			DisplayTransparentSprite(TextSprite, 20,
			                         ScreenHeight() - SpriteHeight(TextSprite) - 15,
			                         255)
		EndIf
		
		FlipBuffers()
	EndProcedure
	
	Procedure OnLeave()
		Logger::Devel("OnLeave was called for loading screen !")
		Resources::FlushCameras(#True)
	EndProcedure
EndModule


;- Code

Global *LoadingScreen = ScreenLoading::GetScreen()

If Not *LoadingScreen
	ScreenManager::ShowErrorScreen("Failed to create loading screen !")
EndIf

If Not ScreenManager::RegisterScreen(*LoadingScreen, "loading", #True, #True)
	ScreenManager::ShowErrorScreen("Failed to register loading screen !")
EndIf
