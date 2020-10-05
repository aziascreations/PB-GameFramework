
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule ScreenModelManipulator
	Declare.i GetScreen()
EndDeclareModule

Module ScreenModelManipulator
	EnableExplicit
	
	XIncludeFile "./ModelManipulatorMainWindow.pbf"
	XIncludeFile "./ModelManipulatorTextureWindow.pbf"
	
	Global MainCamera
	Global MainCameraHorizontalAngle.d = 0.0
	Global MainCameraVerticalAngle.d = 0.0
	
	Global MainCameraDistance.d = 20.0
	
	Global CameraHorRotSpeedMult.d = 1.25
	Global CameraVerRotSpeedMult.d = 1.25
	
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
	
	;- Mesh editor data
	Structure CustomMeshVertexData
		Name$
		X.d
		Y.d
		Z.d
		UV_X.d
		UV_Y.d
		Color.i
	EndStructure
	
	Structure CustomMeshData
		Name$
		List Vertexes.CustomMeshVertexData()
		List SubMeshes.CustomMeshData()
	EndStructure
	
	Global *MeshData.CustomMeshData
	
	Global MeshIcon, NodeIcon
	
	Procedure.b UpdateElementList(*MeshData.CustomMeshData, ClearList.b=#True)
		If *MeshData
			If ClearList
				RemoveGadgetColumn(ListIcon_Model, #PB_All)
				AddGadgetColumn(ListIcon_Model, 0, "Node name", GadgetWidth(ListIcon_Model)-4)
			EndIf
			
			AddGadgetItem(ListIcon_Model, -1, *MeshData\Name$, ImageID(MeshIcon))
			
			ForEach *MeshData\Vertexes()
				Protected *TempVertex.CustomMeshVertexData = *MeshData\Vertexes()
				
				AddGadgetItem(ListIcon_Model, -1, *MeshData\Name$ + " > " + *TempVertex\Name$, ImageID(NodeIcon))
			Next
			
			ForEach *MeshData\SubMeshes()
				Protected *TempMesh.CustomMeshData = *MeshData\SubMeshes()
				
				If Not UpdateElementList(*TempMesh, #False)
					ProcedureReturn #False
				EndIf
			Next
			
			ProcedureReturn #True
		EndIf
		
		Logger::Devel("Failed to update element list ! -> Null pointer !")
		ProcedureReturn #False
	EndProcedure
	
	
	;- Code
	
	Procedure MoveGameCamera(Camera, Direction, TimeDelta.q)
		Protected OffsetX.f = 0.0, OffsetY.f = 0.0, OffsetZ.f = 0.0
		
		If Not IsCamera(Camera)
			Debug "Not a camera !"
			ProcedureReturn
		EndIf
		
		Select Direction
			Case #Axis_Left
				MainCameraHorizontalAngle = MainCameraHorizontalAngle +
				                            (CameraHorRotSpeedMult * (TimeDelta / 1000))
			Case #Axis_Right
				MainCameraHorizontalAngle = MainCameraHorizontalAngle +
				                            (CameraHorRotSpeedMult * (TimeDelta / 1000)) * -1
			Case #Axis_Up
				MainCameraVerticalAngle = MainCameraVerticalAngle +
				                          (CameraVerRotSpeedMult * (TimeDelta / 1000))
				If Degree(MainCameraVerticalAngle) > 85 : MainCameraVerticalAngle = Radian(85.0) : EndIf
			Case #Axis_Down
				MainCameraVerticalAngle = MainCameraVerticalAngle +
				                          (CameraVerRotSpeedMult * (TimeDelta / 1000)) * -1
				If Degree(MainCameraVerticalAngle) < -85 : MainCameraVerticalAngle = Radian(-85.0) : EndIf
			Case #Axis_Forward
				MainCameraDistance = MainCameraDistance - (CameraHorRotSpeedMult * (TimeDelta / 100))
				If MainCameraDistance < 1.5 : MainCameraDistance = 1.5 : EndIf
			Case #Axis_Backward
				MainCameraDistance = MainCameraDistance + (CameraHorRotSpeedMult * (TimeDelta / 100))
			Default
				ProcedureReturn
		EndSelect
		
		MoveCamera(Camera,
		           Sin(MainCameraHorizontalAngle) * MainCameraDistance * Cos(MainCameraVerticalAngle),
		           Sin(MainCameraVerticalAngle) * MainCameraDistance,
		           Cos(MainCameraHorizontalAngle) * MainCameraDistance * Cos(MainCameraVerticalAngle),
		           #PB_Absolute)
		CameraLookAt(Camera, 0, 0, 0)
	EndProcedure
	
	Procedure OnStart()
		;{ Default stuff
		MainCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		If Not IsCamera(MainCamera)
			ScreenManager::ShowErrorScreen("Failed to create camera for model editor !")
			ProcedureReturn
		EndIf
		Resources::SetCamera("cam-model", MainCamera, #True, #True)
		CameraBackColor(MainCamera, RGB(63, 63, 63))
		
		;Skybox::GenerateSquareSkybox("skybox-test2", "skybox-test2", 64*10, 0, #PB_Material_None)
		;Skybox::GenerateSquareSkybox("skybox-mm-tmp", "skybox-mainmenu", 64*10, 0, #PB_Material_None)
		Skybox::GenerateSquareSkybox("skybox-model", "skybox-model", 64*10, 0, #PB_Material_None)
		
		MoveGameCamera(MainCamera, #Axis_Left, 0)
		
		Resources::SetMesh("line-axis-x",
		                   CreateLine3D(#PB_Any, 1000 * -1, 0, 0, RGB(255, 0, 0),
		                                1000, 0, 0, RGB(255, 0, 0)),
		                   #True, #True)
		Resources::SetMesh("line-axis-y",
		                   CreateLine3D(#PB_Any, 0, 1000 * -1, 0, RGB(0, 255, 0),
		                                0, 1000, 0, RGB(0, 255, 0)),
		                   #True, #True)
		Resources::SetMesh("line-axis-z",
		                   CreateLine3D(#PB_Any, 0, 0, 1000 * -1, RGB(0, 0, 255),
		                                0, 0, 1000, RGB(0, 0, 255)),
		                   #True, #True)
		Resources::SetEntity("line-axis-x",
		                     CreateEntity(#PB_Any,
		                                  MeshID(Resources::GetMesh("line-axis-x")),
		                                  #PB_Material_None),
		                     #True, #True)
		Resources::SetEntity("line-axis-y",
		                     CreateEntity(#PB_Any,
		                                  MeshID(Resources::GetMesh("line-axis-y")),
		                                  #PB_Material_None),
		                     #True, #True)
		Resources::SetEntity("line-axis-z",
		                     CreateEntity(#PB_Any,
		                                  MeshID(Resources::GetMesh("line-axis-z")),
		                                  #PB_Material_None),
		                     #True, #True)
		
		;}
		
		; - Model Editor start code
		Engine::RunMainWindowLoop = #False
		
		OpenWindow_ModelEditor()
		OpenWindow_UVViewer(0, 600)
		
		*MeshData = AllocateStructure(CustomMeshData)
		If Not *MeshData
			ScreenManager::ShowErrorScreen("Failed to allocate memory for mesh structure !")
			ProcedureReturn
		EndIf
		*MeshData\Name$ = "Root Mesh"
		
		MeshIcon = LoadImage(#PB_Any, "./Data/Graphics/Engine/icon-mesh.png")
		NodeIcon = LoadImage(#PB_Any, "./Data/Graphics/Engine/icon-node.png")
		
		If Not (IsImage(MeshIcon) And IsImage(NodeIcon))
			ScreenManager::ShowErrorScreen("Failed to load the tool images !")
			ProcedureReturn
		EndIf
		
		UpdateElementList(*MeshData)
		
		
		
		
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
			If KeyboardPushed(#PB_Key_Up)
				MoveGameCamera(MainCamera, #Axis_Up, TimeDelta)
			EndIf
			If KeyboardPushed(#PB_Key_Down)
				MoveGameCamera(MainCamera, #Axis_Down, TimeDelta)
			EndIf
			If KeyboardPushed(#PB_Key_Left)
				MoveGameCamera(MainCamera, #Axis_Left, TimeDelta)
			EndIf
			If KeyboardPushed(#PB_Key_Right)
				MoveGameCamera(MainCamera, #Axis_Right, TimeDelta)
			EndIf
			If KeyboardPushed(#PB_Key_Add)
				MoveGameCamera(MainCamera, #Axis_Forward, TimeDelta)
			EndIf
			If KeyboardPushed(#PB_Key_Subtract)
				MoveGameCamera(MainCamera, #Axis_Backward, TimeDelta)
			EndIf
			
			If KeyboardReleased(#PB_Key_Pad1)
				CameraRenderMode(MainCamera, #PB_Camera_Textured)
			EndIf
			If KeyboardReleased(#PB_Key_Pad2)
				CameraRenderMode(MainCamera, #PB_Camera_Wireframe)
			EndIf
		EndIf
		
		
		Protected Event
		Repeat
			Event = WindowEvent()
			
			Select EventWindow()
				Case Window_UVViewer
					
				Case Window_ModelEditor
					
				Default
					If Event = #PB_Event_CloseWindow
						Engine::IsRunning = #False
					EndIf
			EndSelect
		Until Event = 0
		
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		; Rendering 3D elements...
		RenderWorld()
		
		; Rendering 2D elements...
		
		; Finishing.
		FlipBuffers()
	EndProcedure
	
	Procedure OnLeave()
		Logger::Devel("OnLeave was called for model screen !")
		
		; Clearing out the remaining events.
		Engine::RunMainWindowLoop = #True
		Protected Event
		Repeat : Event = WindowEvent() : Until Event = 0
		
		; FIXME: Add the other resources !!!
		; And flush on error screen enter.
	EndProcedure
	
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("model screen !",
		                                            #Null,
		                                            #Null,
		                                            #Null,
		                                            @OnStart(),
		                                            @OnUpdate(),
		                                            @OnRender(),
		                                            @OnLeave())
	EndProcedure
EndModule


Logger::Devel("Executing: "+GetFilePart(#PB_Compiler_Filename, #PB_FileSystem_NoExtension))

Global *ModelManipulatorScreen = ScreenModelManipulator::GetScreen()

If Not *ModelManipulatorScreen
	Logger::Error("Failed to create loading screen !")
	End 3
EndIf

If Not ScreenManager::RegisterScreen(*ModelManipulatorScreen, "model-manipulator", #True, #True)
	Logger::Error("Failed to register loading screen !")
	End 4
EndIf