
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
	Declare OnRender()
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
		;{ Skybox
		If Not Resources::HasMaterial("skybox-mainmenu-x+")
			Resources::SetMaterial("skybox-mainmenu-x+",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture("skybox-mm-tmp-x+"))))
			;DisableMaterialLighting(Resources::GetMaterial("skybox-mainmenu-x+"), #True)
		EndIf
		
		If Not Resources::HasMaterial("skybox-mainmenu-x-")
			Resources::SetMaterial("skybox-mainmenu-x-",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture("skybox-mm-tmp-x-"))))
			;DisableMaterialLighting(Resources::GetMaterial("skybox-mainmenu-x-"), #True)
		EndIf
		
		If Not Resources::HasMaterial("skybox-mainmenu-y+")
			Resources::SetMaterial("skybox-mainmenu-y+",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture("skybox-mm-tmp-y+"))))
			;DisableMaterialLighting(Resources::GetMaterial("skybox-mainmenu-y+"), #True)
		EndIf
		
		If Not Resources::HasMaterial("skybox-mainmenu-y-")
			Resources::SetMaterial("skybox-mainmenu-y-",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture("skybox-mm-tmp-y-"))))
			;DisableMaterialLighting(Resources::GetMaterial("skybox-mainmenu-y-"), #True)
		EndIf
		
		If Not Resources::HasMaterial("skybox-mainmenu-z+")
			Resources::SetMaterial("skybox-mainmenu-z+",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture("skybox-mm-tmp-z+"))))
			;DisableMaterialLighting(Resources::GetMaterial("skybox-mainmenu-z+"), #True)
		EndIf
		
		If Not Resources::HasMaterial("skybox-mainmenu-z-")
			Resources::SetMaterial("skybox-mainmenu-z-",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture("skybox-mm-tmp-z-"))))
			;DisableMaterialLighting(Resources::GetMaterial("skybox-mainmenu-z-"), #True)
		EndIf
		
		If Not Resources::HasMesh("skybox-plane-mainmenu")
			Resources::SetMesh("skybox-plane-mainmenu",
			                   CreatePlane(#PB_Any, #BaseSkyBoxSize, #BaseSkyBoxSize, 1, 1, 1, 1))
		EndIf
		
		If Not Resources::HasEntity("skybox-mainmenu-top")
			Resources::SetEntity("skybox-mainmenu-top",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh("skybox-plane-mainmenu")),
			                                  MaterialID(Resources::GetMaterial("skybox-mainmenu-y+")),
			                                  0, #BaseSkyBoxSize/2, 0))
			RotateEntity(Resources::GetEntity("skybox-mainmenu-top"), 180, 0, 0)
		EndIf
		
		If Not Resources::HasEntity("skybox-mainmenu-bottom")
			Resources::SetEntity("skybox-mainmenu-bottom",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh("skybox-plane-mainmenu")),
			                                  MaterialID(Resources::GetMaterial("skybox-mainmenu-y-")),
			                                  0, #BaseSkyBoxSize/2*-1, 0))
		EndIf
		
		If Not Resources::HasEntity("skybox-mainmenu-front")
			Resources::SetEntity("skybox-mainmenu-front",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh("skybox-plane-mainmenu")),
			                                  MaterialID(Resources::GetMaterial("skybox-mainmenu-x+")),
			                                  #BaseSkyBoxSize/2, 0, 0))
			RotateEntity(Resources::GetEntity("skybox-mainmenu-front"), -90, 90, 0) ;x+
		EndIf
		
		If Not Resources::HasEntity("skybox-mainmenu-back")
			Resources::SetEntity("skybox-mainmenu-back",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh("skybox-plane-mainmenu")),
			                                  MaterialID(Resources::GetMaterial("skybox-mainmenu-x-")),
			                                  #BaseSkyBoxSize/2*-1, 0, 0))
			RotateEntity(Resources::GetEntity("skybox-mainmenu-back"), -90, -90, 0) ;x-
		EndIf
		
		If Not Resources::HasEntity("skybox-mainmenu-left")
			Resources::SetEntity("skybox-mainmenu-left",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh("skybox-plane-mainmenu")),
			                                  MaterialID(Resources::GetMaterial("skybox-mainmenu-z+")),
			                                  0, 0, #BaseSkyBoxSize/2))
			RotateEntity(Resources::GetEntity("skybox-mainmenu-left"), -90, 0, 0)   ;z-
		EndIf
		
		If Not Resources::HasEntity("skybox-mainmenu-right")
			Resources::SetEntity("skybox-mainmenu-right",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh("skybox-plane-mainmenu")),
			                                  MaterialID(Resources::GetMaterial("skybox-mainmenu-z-")),
			                                  0, 0, #BaseSkyBoxSize/2*-1))
			RotateEntity(Resources::GetEntity("skybox-mainmenu-right"), 90, 0, 180) ;z+
		EndIf
		;}
		
		; Camera
		If Not Resources::HasCamera("mainmenu")
			Resources::SetCamera("mainmenu", CreateCamera(#PB_Any, 0, 0, 100, 100))
			CameraBackColor(Resources::GetCamera("mainmenu"), RGB(245, 245, 245))
			MoveCamera(Resources::GetCamera("mainmenu"), 0, 0, 0, #PB_Absolute)
			CameraLookAt(Resources::GetCamera("mainmenu"), 100, 0, 0)
			CameraFOV(Resources::GetCamera("mainmenu"), 80)
		EndIf
		
		
		;Logger::Devel("Finishing...")
		; ???
		
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		RotateCamera(Resources::GetCamera("mainmenu"), 0, TimeDelta*0.005, 0, #PB_Relative)
	EndProcedure
	
	Procedure OnRender()
		ClearScreen(RGB(0, 0, 0))
		
		; Rendering 3D elements...
		RenderWorld()
		
		; Rendering 2D elements...
		; ???
		
		; Finishing.
		FlipBuffers()
	EndProcedure
	
	Procedure OnLeave()
		Logger::Devel("OnLeave was called for main menu screen !")
		
		
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
