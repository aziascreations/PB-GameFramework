;{
; * GameCommons.pbi
; 
; This file is included right after the engine is initialized.
; It should contain all your code that isn't related to the engine itself.
;}

;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

XIncludeFile "./LoadingScreen.pbi"
XIncludeFile "./MainMenuScreen.pbi"
XIncludeFile "./CameraTestScreen.pbi"
XIncludeFile "./TestingScreen.pbi"
