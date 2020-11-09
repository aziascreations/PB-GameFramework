
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule ExitCodes
	Enumeration ExitCodes
		#Common_NormalExit = 0
		
		#Framework_InitFailure
		#Framework_StartFailure
		
		; Optional: Declares Arguments error codes if #FRAMEWORK_MODULE_XINPUT is defined.
		CompilerIf Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) And #FRAMEWORK_MODULE_ARGUMENTS = "#True"
			#Arguments_InitFailure
			#Arguments_RegisteringFailure
			#Arguments_ParsingError
		CompilerEndIf
		
		; Optional: Declares XInput and ControllerManager error codes if #FRAMEWORK_MODULE_XINPUT is defined.
		CompilerIf Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant) And #FRAMEWORK_MODULE_XINPUT = "#True"
			
		CompilerEndIf
		
		; Optional: Declares Snappy error codes if #FRAMEWORK_MODULE_SNAPPY is defined.
		CompilerIf Defined(FRAMEWORK_MODULE_SNAPPY, #PB_Constant) And #FRAMEWORK_MODULE_SNAPPY = "#True"
			
		CompilerEndIf
	EndEnumeration
	
	#Common_GracefulExit = #Common_NormalExit
	#Common_NoError = #Common_NormalExit
EndDeclareModule

Module ExitCodes
	; Nothing...
EndModule
