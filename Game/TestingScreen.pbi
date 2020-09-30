
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule ScreenTest
	Declare.i GetScreen()
	Declare OnRegister()
	Declare OnInit()
	Declare OnStart()
	Declare OnUpdate(TimeDelta.q)
	Declare OnRender(TimeDelta.q)
EndDeclareModule

Module ScreenTest
	Procedure.i GetScreen()
		ProcedureReturn ScreenManager::CreateScreen("Fuck you you dumb motherfucker !",
		                                            @OnRegister(),
		                                            #Null,
		                                            @OnInit(),
		                                            @OnStart(),
		                                            @OnUpdate(),
		                                            @OnRender())
	EndProcedure
	
	Procedure OnRegister()
		Logger::Devel("OnRegister was called for testing screen !")
		
	EndProcedure
	
	Procedure OnInit()
		Logger::Devel("OnInit was called for testing screen !")
		
	EndProcedure
	
	Procedure OnStart()
		Logger::Devel("OnStart was called for testing screen !")
		
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		;Logger::Devel("OnUpdate was called for testing screen !")
		
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		;Logger::Devel("OnRender was called for testing screen !")
		
		; Rendering 3D elements...
		RenderWorld()
		
		
		; Rendering 2D elements...
		
		
		; Finishing.
		FlipBuffers()
	EndProcedure
EndModule


;- Code

Logger::Devel("Executing: "+GetFilePart(#PB_Compiler_Filename, #PB_FileSystem_NoExtension))

Global *TestingScreen = ScreenTest::GetScreen()

If Not *TestingScreen
	Logger::Error("Failed to create testing screen !")
	End 3
EndIf

If Not ScreenManager::RegisterScreen(*TestingScreen, "test", #True, #True)
	Logger::Error("Failed to register testing screen !")
	End 4
EndIf
