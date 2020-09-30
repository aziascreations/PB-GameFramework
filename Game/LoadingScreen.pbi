﻿
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule ScreenLoading
	Declare.i GetScreen()
	
	Declare OnRegister()
	Declare OnInit()
	Declare OnStart()
	Declare OnUpdate(TimeDelta.q)
	Declare OnRender(TimeDelta.q)
	Declare OnLeave()
EndDeclareModule

Module ScreenLoading
	EnableExplicit
	
	Global DefaultCamera
	;Global ErrorMaterial, ErrorTexture, TestMesh, TestEntity
	Global TextSprite, LogoSprite, StartTime.q
	
	Global LogoPhase.a
	Global LastOpacityTick.q
	Global CurrentSpriteOpacity.a
	
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("Loading screen !",
		                                            @OnRegister(),
		                                            #Null,
		                                            @OnInit(),
		                                            @OnStart(),
		                                            @OnUpdate(),
		                                            @OnRender(),
		                                            @OnLeave())
	EndProcedure
	
	Procedure OnRegister()
		Logger::Devel("OnRegister was called for loading screen !")
		
	EndProcedure
	
	Procedure OnInit()
		Logger::Devel("OnInit was called for loading screen !")
		
	EndProcedure
	
	Procedure OnStart()
		Logger::Devel("OnStart was called for loading screen !")
		
		DefaultCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		CameraBackColor(DefaultCamera, RGB(245, 245, 245))
		MoveCamera(DefaultCamera, 50, 50, 50, #PB_Absolute)
		CameraLookAt(DefaultCamera, 0, 0, 0)
		
		;ErrorTexture = LoadTexture(#PB_Any, "Graphics/Engine/error.png")
		;ErrorMaterial = CreateMaterial(#PB_Any, TextureID(ErrorTexture))
		;MaterialFilteringMode(ErrorMaterial, #PB_Material_None)
		;DisableMaterialLighting(ErrorMaterial, #True)
		
		;TestMesh = CreateCube(#PB_Any, 16)
		;TestEntity = CreateEntity(#PB_Any, MeshID(TestMesh), MaterialID(ErrorMaterial), 0, 0, 0)
		
		LogoSprite = LoadSprite(#PB_Any, "Data/Graphics/Developement/splashLogo.png",
		                        #PB_Sprite_AlphaBlending)
		TextSprite = LoadSprite(#PB_Any, "Data/Graphics/Developement/text-loading.png",
		                        #PB_Sprite_AlphaBlending)
		
		;TransparentSpriteColor(LogoSprite, RGB(245, 245, 245))
		;TransparentSpriteColor(TextSprite, RGB(245, 245, 245))
		
		StartTime = ElapsedMilliseconds()
		
		LogoPhase = 1 ; Debug
		CurrentSpriteOpacity = 255
		LastOpacityTick = StartTime
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		Select LogoPhase
			Case 0:
				; Logo is fading in...
				;If LastOpacityTick + 5 < ElapsedMilliseconds()
				;	LastOpacityTick = ElapsedMilliseconds()
				;	CurrentSpriteOpacity = CurrentSpriteOpacity + 1
				;EndIf
				;
				;If CurrentSpriteOpacity = 255
				;	LogoPhase = 1
				;	Logger::Devel("Logo phase 1 !")
				;EndIf
				LogoPhase = 1
			Case 1:
				; Logo is present, loading shit...
				
				;If LastOpacityTick + 2500 < ElapsedMilliseconds()
				;LastOpacityTick = ElapsedMilliseconds()
				;LogoPhase = 2
				;Logger::Devel("Logo phase 2 !")
					
				If Resources::Update() And LastOpacityTick + 1000 < ElapsedMilliseconds()
					Logger::Devel("Finished loading resources, changing screen...")
					;ScreenManager::ChangeScreen("mainmenu")
					ScreenManager::ChangeScreen("camera-test")
					ScreenManager::SkipNextRender()
				EndIf
			Default:
				; Logo is fading out...
				;If LastOpacityTick + 5 < ElapsedMilliseconds()
				;	LastOpacityTick = ElapsedMilliseconds()
				;	CurrentSpriteOpacity = CurrentSpriteOpacity - 1
				;EndIf
				;
				;If CurrentSpriteOpacity = 0
				;	ScreenManager::ChangeScreen("test")
				;	ScreenManager::SkipNextRender()
				;EndIf
				LogoPhase = 1
		EndSelect
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		
		; Rendering 3D elements...
		RenderWorld()
		
		; Rendering 2D elements...
		DisplayTransparentSprite(LogoSprite, ScreenWidth()/2 - SpriteWidth(LogoSprite)/2,
		                         ScreenHeight()/2 - SpriteHeight(LogoSprite)/2,
		                         CurrentSpriteOpacity)
		DisplayTransparentSprite(TextSprite, 20,
		                         ScreenHeight() - SpriteHeight(TextSprite) - 15,
		                         CurrentSpriteOpacity)
		
		; Finishing.
		FlipBuffers()
		;ClearScreen(RGB(0, 0, 0))
	EndProcedure
	
	Procedure OnLeave()
		Logger::Devel("OnLeave was called for loading screen !")
		
		FreeSprite(LogoSprite)
		FreeSprite(TextSprite)
		
		;FreeEntity(TestEntity)
		;FreeMesh(TestMesh)
		;FreeMaterial(ErrorMaterial)
		;FreeTexture(ErrorTexture)
		
		FreeCamera(DefaultCamera)
	EndProcedure
EndModule


;- Code

Logger::Devel("Executing: "+GetFilePart(#PB_Compiler_Filename, #PB_FileSystem_NoExtension))

Global *LoadingScreen = ScreenLoading::GetScreen()

If Not *LoadingScreen
	Logger::Error("Failed to create loading screen !")
	End 3
EndIf

If Not ScreenManager::RegisterScreen(*LoadingScreen, "loading", #True, #True)
	Logger::Error("Failed to register loading screen !")
	End 4
EndIf