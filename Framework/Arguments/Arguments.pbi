
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

CompilerIf Not Defined(FRAMEWORK_MODULE_ARGUMENTS, #PB_Constant) Or #FRAMEWORK_MODULE_ARGUMENTS = "#False"
	CompilerError "The #FRAMEWORK_MODULE_ARGUMENTS constant is not defined !"
CompilerEndIf


;- Module

DeclareModule Args
	Structure Argument
		Short.c
		Long.s
	EndStructure
	
	Declare Free()
EndDeclareModule

Module Args
	; It's only useful if you parse the whole thing at once...
	; (?:(?:\s?\-\-(?<la>[a-zA-Z]+))|(?:\s?\-(?<sa>[a-zA-Z]+))|(?<ae>\s?\-\-)|(?:\s?\"(?<tx1>[^\"]+)\")|(?:\s?(?<tx2>[^\s]+)))/g
	#ArgumentsRegex$ = "(?:(?:\s?\-\-(?<la>[a-zA-Z]+))|(?:\s?\-(?<sa>[a-zA-Z]+))|(?<ae>\s?\-\-)|(?:\s?\"+
	                   #DQUOTE$+"(?<tx1>[^\"+#DQUOTE$+"]+)\"+#DQUOTE$+")|(?:\s?(?<tx2>[^\s]+)))/g"
	
	Global NewList Arguments.i()
	
	Procedure Parse()
		
	EndProcedure
	
	Procedure Free()
		ForEach Arguments()
			FreeStructure(Arguments())
		Next
		
		FreeList(Arguments())
	EndProcedure
EndModule
