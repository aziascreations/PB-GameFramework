
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule ControllerTestScreen
	Declare.i GetScreen()
	Declare OnStart()
	Declare OnUpdate(TimeDelta.q)
	Declare OnRender(TimeDelta.q)
	Declare OnControllerButtonDown(UserIndex.l, ButtonPressed.w)
EndDeclareModule

Module ControllerTestScreen
	Global MainCamera
	
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("Fuck you you dumb motherfucker !",
		                                            #Null, #Null, #Null, @OnStart(),
		                                            @OnUpdate(), @OnRender(), #Null, #Null,
		                                            #Null, @OnControllerButtonDown())
	EndProcedure
	
	Procedure OnStart()
		Logger::Devel("OnStart was called for controller test screen !")
		
		MainCamera = CreateCamera(#PB_Any, 0, 0, 100, 100)
		If Not IsCamera(MainCamera)
			ScreenManager::ShowErrorScreen("Failed to create camera for model editor !")
			ProcedureReturn
		EndIf
		Resources::SetCamera("cam-model", MainCamera, #True, #True)
		CameraBackColor(MainCamera, RGB(63, 63, 63))
		
		MoveCamera(MainCamera, 50, 50, 50)
		CameraLookAt(MainCamera, 0, 0, 0)
		
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
		
		Skybox::GenerateSquareSkybox("skybox-model", "skybox-model", 64*10, 0, #PB_Material_None)
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		; Rendering 3D elements...
		RenderWorld()
		
		; Finishing.
		FlipBuffers()
	EndProcedure
	
	Procedure OnControllerButtonDown(UserIndex.l, ButtonPressed.w)
		If ButtonPressed & XInput::#XINPUT_GAMEPAD_DPAD_UP
			Debug "Up was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_DPAD_DOWN
			Debug "Down was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_DPAD_LEFT
			Debug "Left was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_DPAD_RIGHT
			Debug "Right was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_START
			Debug "Start was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_BACK
			Debug "Back was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_LEFT_THUMB
			Debug "L3 was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_RIGHT_THUMB
			Debug "R3 was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_LEFT_SHOULDER
			Debug "L1 was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_RIGHT_SHOULDER
			Debug "R1 was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_A
			Debug "A was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_B
			Debug "B was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_X
			Debug "X was pressed !"
		ElseIf ButtonPressed & XInput::#XINPUT_GAMEPAD_Y
			Debug "Y was pressed !"
		EndIf
	EndProcedure
EndModule


;- Code

Logger::Devel("Executing: "+GetFilePart(#PB_Compiler_Filename, #PB_FileSystem_NoExtension))

Global *ControllerTestScreen = ControllerTestScreen::GetScreen()

If Not *ControllerTestScreen
	Logger::Error("Failed to create controller test screen !")
	End 3
EndIf

If Not ScreenManager::RegisterScreen(*ControllerTestScreen, "controller-test", #True, #True)
	Logger::Error("Failed to register controller test screen !")
	End 4
EndIf
