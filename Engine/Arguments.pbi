
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule Args
	Structure Argument
		Short.c
		Long.s
	EndStructure
	
	Declare Free()
EndDeclareModule

Module Args
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
