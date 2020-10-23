;{
; * ArgumentsHelper.pbi
; Version: 0.0.1
; Author: Herwin Bozet
; 
; A basic arguments parser.
;
; License: Unlicense (Public Domain)
;}

;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

XIncludeFile "./Arguments.pbi"

CompilerIf Not Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) Or #FRAMEWORK_MODULE_ARGUMENTS = "#False"
	CompilerError "The #FRAMEWORK_MODULE_ARGUMENTS constant is not defined !"
CompilerEndIf


;- Module declaration

DeclareModule ArgumentsHelper
	Declare.s GetHelpText(*RootVerb.Arguments::Verb)
	
	; SimpleRegisterVerb/Option
EndDeclareModule


;- Module

Module ArgumentsHelper
	EnableExplicit
	
	Procedure.s GetHelpText(*RootVerb.Arguments::Verb)
		Protected HelpText$ = #Null$
		
		
		
		ProcedureReturn HelpText$
	EndProcedure
EndModule
