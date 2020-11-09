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
	Declare.s GetSimpleHelpText(*RootVerb.Arguments::Verb)
	
	Declare.b RegisterOption(Token.c, Name.s, Description.s = #Null$, Flags.i = 0, *ParentVerb = #Null)
	; SimpleRegisterVerb/Option
EndDeclareModule


;- Module

Module ArgumentsHelper
	EnableExplicit
	
	Procedure.s GetSimpleHelpText(*RootVerb.Arguments::Verb)
		Protected HelpText$ = #Null$
		Protected LongestOption.i = 0
		
		If *RootVerb
			ForEach *RootVerb\Options()
				If *RootVerb\Options()\Name <> #Null$
					If Len(*RootVerb\Options()\Name) > LongestOption
						LongestOption = Len(*RootVerb\Options()\Name)
					EndIf
				EndIf
			Next
			
			HelpText$ = "> "+"tmp.exe"+#CRLF$
			
			ForEach *RootVerb\Options()
				HelpText$+Space(4)
				
				If *RootVerb\Options()\Token <> #Null
					HelpText$+"-"+Chr(*RootVerb\Options()\Token)
				Else
					HelpText$+"  "
				EndIf
				
				If *RootVerb\Options()\Name <> #Null$
					HelpText$+", --"+*RootVerb\Options()\Name
				Else
					HelpText$+Space(2+2+LongestOption)
				EndIf
				
				If LongestOption <> 0
					HelpText$+Space(4)
				Else
					HelpText$+Space(2)
				EndIf
				
				HelpText$+Space(4)+*RootVerb\Options()\Description+#CRLF$
			Next
		EndIf
		
		ProcedureReturn HelpText$
	EndProcedure

	Procedure.b RegisterOption(Token.c, Name.s, Description.s = #Null$, Flags.i = 0, *ParentVerb = #Null)
		Protected Option = Arguments::CreateOption(Token, Name, Description, Flags)
		
		If Option
			If Arguments::RegisterOption(Option, *ParentVerb)
				ProcedureReturn #True
			Else
				Arguments::FreeOption(Option)
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
EndModule
