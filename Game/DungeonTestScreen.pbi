
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule DungeonScreen
	Declare.i GetScreen()
EndDeclareModule

Module DungeonScreen
	EnableExplicit
	
	#WorldScale = 16
	
	Enumeration Axis3D
		#Axis_Forward
		#Axis_Backward
		#Axis_Left
		#Axis_Right
		#Axis_Up
		#Axis_Down
	EndEnumeration
	
	Global CameraRotationSpeedMultiplier.f = 1.25
	Global CameraMovementSpeedMultiplier.f = 0.5
	
	Global PlayerCamera
	Global GroundMaterial, WallMaterial, PotMaterial
	Global GroundMesh, WallMesh
	Global PotBillboardGroup
	Global NewList Entities()
	
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
	
	Procedure OnStart()
		Protected FileId = ReadFile(#PB_Any, "./Data/Maps/dungeon-test.map")
		Protected MapSizeX = 0, MapSizeY = 0, MapData$ = ""
		
		; Loading map...
		If Not FileId
			ScreenManager::ShowErrorScreen("Unable to open: ./Data/Maps/dungeon-test.Map")
			ProcedureReturn
		EndIf
		While Not Eof(FileId)
			Protected Line$ = ReadString(FileId)
			
			If Left(Line$, 1) = "#"
				If FindString(Line$, "#SIZEX=")
					MapSizeX = Val(Mid(Line$, FindString(Line$, "=") + 1))
				ElseIf FindString(Line$, "#SIZEY=")
					MapSizeY = Val(Mid(Line$, FindString(Line$, "=") + 1))
				ElseIf FindString(Line$, "#END")
					Break
				EndIf
			Else
				MapData$ = MapData$ + Trim(Line$)
			EndIf
		Wend
		CloseFile(FileId)
		
		; Preparing assets...
		Skybox::GenerateSquareSkybox("skybox-grass-sky", "skybox-mainmenu", 64*100, 125)
		
		PlayerCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		CameraBackColor(PlayerCamera, RGB(245, 245, 245))
		CameraFOV(PlayerCamera, 70)
		;CameraLookAt(PlayerCamera, 0, 24, 0)
		Resources::SetCamera("dungeon-player", PlayerCamera)
		
		PotMaterial = CreateMaterial(#PB_Any, TextureID(Resources::GetTexture("pot-2")))
		MaterialFilteringMode(PotMaterial, #PB_Material_None)
		PotBillboardGroup = CreateBillboardGroup(#PB_Any, MaterialID(PotMaterial),
		                                         #WorldScale*0.75, #WorldScale*0.75)
    	
		GroundMaterial = CreateMaterial(#PB_Any, TextureID(Resources::GetTexture("ground1")))
		MaterialFilteringMode(GroundMaterial, #PB_Material_None)
		MaterialBlendingMode(GroundMaterial, #PB_Material_AlphaBlend) ; #PB_Material_Color
		
		WallMaterial = CreateMaterial(#PB_Any, TextureID(Resources::GetTexture("wall2")))
		MaterialFilteringMode(WallMaterial, #PB_Material_None)
		MaterialBlendingMode(WallMaterial, #PB_Material_AlphaBlend) ; #PB_Material_Color
		
		GroundMesh = CreatePlane(#PB_Any, #WorldScale, #WorldScale, 1, 1, 1, 1)
		WallMesh = CreateCube(#PB_Any, #WorldScale)
		
		; Parsing map...
		Protected x, y
		For y=0 To MapSizeY-1
			For x=0 To MapSizeX-1
				Select Mid(MapData$, y*MapSizeY+x+1, 1)
					Case "0"
						Resources::SetEntity("wall."+Str(x)+"."+Str(y),
						                     CreateEntity(#PB_Any, MeshID(WallMesh), MaterialID(WallMaterial),
						                                  x*#WorldScale, #WorldScale/2, y*#WorldScale))
						Continue
					Case "X"
						MoveCamera(PlayerCamera, x*#WorldScale, #WorldScale*0.5, y*#WorldScale, #PB_Absolute)
					Case "*"
    					AddBillboard(PotBillboardGroup, x*#WorldScale, #WorldScale*0.75/2, y*#WorldScale)
    				Case "."
    					
					Default
						
				EndSelect
				Resources::SetEntity("gnd."+Str(x)+"."+Str(y),
				                     CreateEntity(#PB_Any, MeshID(GroundMesh), MaterialID(GroundMaterial),
				                                  x*#WorldScale, 0, y*#WorldScale))
			Next
		Next
		
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		; Prevents long deltas caused by window events and the likes.
		If TimeDelta > 100
			ProcedureReturn
		EndIf
		
		If ExamineKeyboard()
			If KeyboardPushed(#PB_Key_Left)
				RotateGameCamera(PlayerCamera, #Axis_Left)
			EndIf
			If KeyboardPushed(#PB_Key_Right)
				RotateGameCamera(PlayerCamera, #Axis_Right)
			EndIf
			
			If KeyboardPushed(#PB_Key_Up)
				MoveGameCamera(PlayerCamera, #Axis_Forward)
			EndIf
			If KeyboardPushed(#PB_Key_Down)
				MoveGameCamera(PlayerCamera, #Axis_Backward)
			EndIf
			
			If KeyboardReleased(#PB_Key_Pad1)
				CameraRenderMode(PlayerCamera, #PB_Camera_Textured)
			EndIf
			If KeyboardReleased(#PB_Key_Pad2)
				CameraRenderMode(PlayerCamera, #PB_Camera_Wireframe)
			EndIf
		EndIf
		
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		ClearScreen(RGB(0, 0, 0))
		
		; Rendering 3D elements...
		RenderWorld()
		
		; Rendering 2D elements...
		;???
		
		; Finishing.
		FlipBuffers()
	EndProcedure
	
	Procedure OnLeave()
		Logger::Devel("Deleting screen's entities, meshes, materials and cameras...")
		
		Resources::FlushCameras(#True)
		Resources::FlushEntities(#True)
		
		FreeMesh(WallMesh)
		FreeMesh(GroundMesh)
		FreeBillboardGroup(PotBillboardGroup)
		FreeMaterial(PotMaterial)
		FreeMaterial(WallMaterial)
		FreeMaterial(GroundMaterial)
	EndProcedure
	
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("Dungeon test", #Null, #Null, #Null,
		                                            @OnStart(), @OnUpdate(), @OnRender(),
		                                            @OnLeave())
	EndProcedure
EndModule


;- Code

Logger::Devel("Executing: "+GetFilePart(#PB_Compiler_Filename, #PB_FileSystem_NoExtension))

Global *DungeonScreen = DungeonScreen::GetScreen()

If Not *DungeonScreen
	Logger::Error("Failed to create camera testing screen !")
	End 3
EndIf

If Not ScreenManager::RegisterScreen(*DungeonScreen, "dungeon-test", #True, #True)
	Logger::Error("Failed to register camera testing screen !")
	End 4
EndIf

