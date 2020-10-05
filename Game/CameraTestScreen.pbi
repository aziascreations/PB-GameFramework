
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule CameraTestScreen
	Declare.i GetScreen()
	Declare OnStart()
	Declare OnUpdate(TimeDelta.q)
	Declare OnRender(TimeDelta.q)
	Declare OnLeave()
EndDeclareModule

Module CameraTestScreen
	EnableExplicit
	
	Global CameraRotationSpeedMultiplier.f = 1.25
	Global CameraMovementSpeedMultiplier.f = 1.0
	
	Enumeration Axis3D
		#Axis_Forward
		#Axis_Backward
		#Axis_Left
		#Axis_Right
		#Axis_Up
		#Axis_Down
	EndEnumeration
	
	Global TestingCamera, ErrorCubeMat, ErrorCubeMesh, ErrorCubeEnt
	Global GroundMat, GroundMesh, GroundEnt, PlayerCamera
	Global IsUsingPlayerCam = #False
	Global NewList LineEntities()
	
	Procedure MoveGameCamera(Camera, Direction)
		Protected OffsetX.f = 0.0, OffsetY.f = 0.0, OffsetZ.f = 0.0
		
		If Not IsCamera(Camera)
			Debug "Not a camera !"
			ProcedureReturn
		EndIf
		
		Select Direction
			Case #Axis_Forward
				MoveCamera(Camera,
				           CameraDirectionX(Camera) * CameraMovementSpeedMultiplier,
				           CameraDirectionY(Camera) * CameraMovementSpeedMultiplier,
				           CameraDirectionZ(Camera) * CameraMovementSpeedMultiplier,
				           #PB_Relative | #PB_Local)
			Case #Axis_Backward
				MoveCamera(Camera,
				           CameraDirectionX(Camera) * CameraMovementSpeedMultiplier * (-1),
				           CameraDirectionY(Camera) * CameraMovementSpeedMultiplier * (-1),
				           CameraDirectionZ(Camera) * CameraMovementSpeedMultiplier * (-1),
				           #PB_Relative | #PB_Local)
			Case #Axis_Left
				MoveCamera(Camera, -CameraMovementSpeedMultiplier, 0, 0)
			Case #Axis_Right
				MoveCamera(Camera, CameraMovementSpeedMultiplier, 0, 0)
			Case #Axis_Up
				MoveCamera(Camera, 0, 1.0 * CameraMovementSpeedMultiplier, 0, #PB_Relative | #PB_Local)
			Case #Axis_Down
				MoveCamera(Camera, 0, -1.0 * CameraMovementSpeedMultiplier, 0, #PB_Relative | #PB_Local)
			Default
				ProcedureReturn
		EndSelect
	EndProcedure
	
	Procedure RotateGameCamera(Camera, Direction)
		If Not IsCamera(Camera)
			Debug "Not a camera !"
			ProcedureReturn
		EndIf
		
		Select Direction
			Case #Axis_Left
				RotateCamera(Camera, 0, CameraRotationSpeedMultiplier, 0, #PB_Relative)
			Case #Axis_Right
				RotateCamera(Camera, 0, -CameraRotationSpeedMultiplier, 0, #PB_Relative)
			Case #Axis_Up
				RotateCamera(Camera, CameraRotationSpeedMultiplier, 0, 0, #PB_Relative)
			Case #Axis_Down
				RotateCamera(Camera, -CameraRotationSpeedMultiplier, 0, 0, #PB_Relative)
			Default
				ProcedureReturn
		EndSelect
	EndProcedure
	
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("Camera test",
		                                            #Null,
		                                            #Null,
		                                            #Null,
		                                            @OnStart(),
		                                            @OnUpdate(),
		                                            @OnRender(),
		                                            @OnLeave())
	EndProcedure
	
	Procedure OnStart()
		Logger::Devel("OnStart was called for camera testing screen !")
		
		ErrorCubeMat = CreateMaterial(#PB_Any, TextureID(Resources::GetTexture("dev-grid-32")))
		ErrorCubeMesh = CreateCube(#PB_Any, 32)
		ErrorCubeEnt = CreateEntity(#PB_Any, MeshID(ErrorCubeMesh), MaterialID(ErrorCubeMat), 0, 16, 0)
		
		GroundMat = CreateMaterial(#PB_Any, TextureID(Resources::GetTexture("dev-grid-64")))
		GroundMesh = CreatePlane(#PB_Any, 64*100, 64*100, 100, 100, 100, 100)
		GroundEnt = CreateEntity(#PB_Any, MeshID(GroundMesh), MaterialID(GroundMat), 0, 0, 0)
		
		;Skybox::GenerateSquareSkybox("skybox-mm-tmp", "skybox-mainmenu", 64*100)
		Skybox::GenerateSquareSkybox("skybox-grass-sky", "skybox-mainmenu", 64*100, 125)
		;Skybox::GenerateSquareSkybox("skybox-miramar", "skybox-mainmenu", 64*100, 10)
		
		If Resources::SetMaterial("dev-uv-map-01",
		                          CreateMaterial(#PB_Any,
		                                         TextureID(Resources::GetTexture("dev-uv-map-01"))),
		                          #True, #True)
			MaterialFilteringMode(Resources::GetMaterial("dev-uv-map-01"), #PB_Material_None)
		EndIf
		If Resources::SetEntity("cube-1-test",
		                        CreateEntity(#PB_Any,
		                                     MeshID(Resources::GetMesh("cube-1")),
		                                     MaterialID(Resources::GetMaterial("dev-uv-map-01")),
		                                     -64, 16, -64),
		                        #True, #True)
			ScaleEntity(Resources::GetEntity("cube-1-test"), 64/4, 64/4, 64/4, #PB_Absolute)
		EndIf
		
		PlayerCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		CameraBackColor(PlayerCamera, RGB(245, 245, 245))
		MoveCamera(PlayerCamera, 100, 24, 100, #PB_Absolute)
		CameraLookAt(PlayerCamera, 0, 24, 0)
		
		TestingCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		;CameraBackColor(TestingCamera, RGB(245, 245, 245))
		CameraBackColor(TestingCamera, RGB(0, 0, 0))
		MoveCamera(TestingCamera, 100, 100, 100, #PB_Absolute)
		CameraLookAt(TestingCamera, 0, 0, 0)
		IsUsingPlayerCam = #False
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		; Prevents long deltas caused by window events and the likes.
		If TimeDelta > 100
			ProcedureReturn
		EndIf
		
		; Keyboard events
		; FIXME: Weird error when quitting, right after having clicked the red cross button.
		;  [ERROR] OpenScreen() Or OpenWindowedScreen() must be called before using any Keyboard commands.
		If ExamineKeyboard()
			If KeyboardReleased(#PB_Key_Multiply)
				If IsUsingPlayerCam
					IsUsingPlayerCam = #False
					SwitchCamera(PlayerCamera, TestingCamera)
					CameraBackColor(TestingCamera, RGB(245, 245, 245))
				Else
					IsUsingPlayerCam = #True
					SwitchCamera(TestingCamera, PlayerCamera)
					CameraBackColor(PlayerCamera, RGB(245, 245, 245))
				EndIf
			EndIf
			
			If KeyboardReleased(#PB_Key_F1)
				;Screen3DRequester_ShowStats = 1-Screen3DRequester_ShowStats ; Switch the ShowStats on/off
			EndIf
			If KeyboardReleased(#PB_Key_D)
				
			EndIf
			If KeyboardPushed(#PB_Key_W)
				If IsUsingPlayerCam
					MoveGameCamera(PlayerCamera, #Axis_Forward)
				Else
					MoveGameCamera(TestingCamera, #Axis_Forward)
				EndIf
			EndIf
			If KeyboardPushed(#PB_Key_S)
				If IsUsingPlayerCam
					MoveGameCamera(PlayerCamera, #Axis_Backward)
				Else
					MoveGameCamera(TestingCamera, #Axis_Backward)
				EndIf
			EndIf
			If KeyboardPushed(#PB_Key_A)
				If IsUsingPlayerCam
					MoveGameCamera(PlayerCamera, #Axis_Left)
				Else
					MoveGameCamera(TestingCamera, #Axis_Left)
				EndIf
			EndIf
			If KeyboardPushed(#PB_Key_D)
				If IsUsingPlayerCam
					MoveGameCamera(PlayerCamera, #Axis_Right)
				Else
					MoveGameCamera(TestingCamera, #Axis_Right)
				EndIf
			EndIf
			If KeyboardPushed(#PB_Key_Space)
				If IsUsingPlayerCam
					; Fire !
					AddElement(LineEntities())
					LineEntities() = CreateLine3D(#PB_Any, CameraX(PlayerCamera), CameraY(PlayerCamera),
					                              CameraZ(PlayerCamera), RGB(255, 127, 127),
					                              CameraX(PlayerCamera)+(CameraDirectionX(PlayerCamera)*200),
					                              CameraY(PlayerCamera)+(CameraDirectionY(PlayerCamera)*200),
					                              CameraZ(PlayerCamera)+(CameraDirectionZ(PlayerCamera)*200),
					                              RGB(127, 63, 63))
				Else
					MoveGameCamera(TestingCamera, #Axis_Up)
				EndIf
			EndIf
			If KeyboardPushed(#PB_Key_C)
				MoveGameCamera(TestingCamera, #Axis_Down)
			EndIf
			If KeyboardPushed(#PB_Key_Escape)
				; Release mouse
			EndIf
			
			If KeyboardPushed(#PB_Key_Up)
				RotateGameCamera(TestingCamera, #Axis_Up)
			EndIf
			If KeyboardPushed(#PB_Key_Down)
				RotateGameCamera(TestingCamera, #Axis_Down)
			EndIf
			If KeyboardPushed(#PB_Key_Left)
				If IsUsingPlayerCam
					RotateGameCamera(PlayerCamera, #Axis_Left)
				Else
					RotateGameCamera(TestingCamera, #Axis_Left)
				EndIf
			EndIf
			If KeyboardPushed(#PB_Key_Right)
				If IsUsingPlayerCam
					RotateGameCamera(PlayerCamera, #Axis_Right)
				Else
					RotateGameCamera(TestingCamera, #Axis_Right)
				EndIf
			EndIf
			
			If KeyboardReleased(#PB_Key_Pad1)
				CameraRenderMode(TestingCamera, #PB_Camera_Textured)
			EndIf
			If KeyboardReleased(#PB_Key_Pad2)
				CameraRenderMode(TestingCamera, #PB_Camera_Wireframe)
			EndIf
		EndIf
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		ClearScreen(RGB(0, 0, 0))
		
		; Rendering 3D elements...
		RenderWorld()
		
		
		; Rendering 2D elements...
		
		; Finishing.
		FlipBuffers()
	EndProcedure
	
	Procedure OnLeave()
		Logger::Devel("Deleting entities, meshes, materials and cameras...")
		
		ForEach LineEntities()
			Protected TempEntity = LineEntities()
			If IsEntity(TempEntity)
				FreeEntity(TempEntity)
			EndIf
		Next
		FreeList(LineEntities())
		
		FreeCamera(TestingCamera)
		FreeCamera(PlayerCamera)
		Resources::FlushCameras(#True)
		
		FreeEntity(ErrorCubeEnt)
		FreeEntity(GroundEnt)
		Resources::FlushEntities(#True)
		
		FreeMesh(ErrorCubeMesh)
		FreeMesh(GroundMesh)
		FreeMaterial(ErrorCubeMat)
		FreeMaterial(GroundMat)
	EndProcedure
EndModule


;- Code

Logger::Devel("Executing: "+GetFilePart(#PB_Compiler_Filename, #PB_FileSystem_NoExtension))

Global *CameraTestScreen = CameraTestScreen::GetScreen()

If Not *CameraTestScreen
	Logger::Error("Failed to create camera testing screen !")
	End 3
EndIf

If Not ScreenManager::RegisterScreen(*CameraTestScreen, "camera-test", #True, #True)
	Logger::Error("Failed to register camera testing screen !")
	End 4
EndIf
