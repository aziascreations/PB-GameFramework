;{
; * MeshHelper.pbi
; Version: N/A
; Author: Herwin Bozet
; 
; ???
;}

;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule MeshHelper
	Declare.i ParseMeshFile(FilePath$)
EndDeclareModule

Module MeshHelper
	EnableExplicit
	
	Procedure.i ParseMeshFile(FilePath$)
		Protected FileId, ReturnedMeshID = #Null
		
		Protected Scale.d = 1.0
		
		FileId = ReadFile(#PB_Any, FilePath$)
		If FileId
			ReturnedMeshID = CreateMesh(#PB_Any, #PB_Mesh_TriangleList, #PB_Mesh_Static)
			
			If ReturnedMeshID
				While Not Eof(FileId)
					Protected Line$ = ReadString(FileId)
					
					If Line$ = #Null$
						Continue
					EndIf
					
					Select Left(Line$, 1)
						Case "#"
							Continue
						Case "s"
							Scale = ValD(StringField(Line$, 2, " "))
							Logger::Trace("Setting scale: '"+Line$+"' => '"+StrD(Scale)+"'")
						Case "v"
							MeshVertexPosition(ValD(StringField(Line$, 2, " "))*Scale,
							                   ValD(StringField(Line$, 3, " "))*Scale,
							                   ValD(StringField(Line$, 4, " "))*Scale)
						Case "c"
							MeshVertexColor(RGB(Val(StringField(Line$, 3, " ")),
							                    Val(StringField(Line$, 4, " ")),
							                    Val(StringField(Line$, 5, " "))))
						Case "t"
							MeshVertexTextureCoordinate(ValD(StringField(Line$, 3, " ")),
							                            ValD(StringField(Line$, 4, " ")))
						Case "f"
							MeshFace(Val(StringField(Line$, 2, " ")),
							         Val(StringField(Line$, 3, " ")),
							         Val(StringField(Line$, 4, " ")))
						Default
							Logger::Error("Unknown mesh command: "+Line$)
					EndSelect
				Wend
				NormalizeMesh(ReturnedMeshID)
				BuildMeshTangents(ReturnedMeshID)
				
				; FIXME: Can crash here if no vertex is defined !
				FinishMesh(#True)
			Else
				Logger::Error("Failed to create mesh !")
			EndIf
			
			CloseFile(FileId)
		Else
			Logger::Error("Failed to read mesh file: "+FilePath$)
		EndIf
		
		ProcedureReturn ReturnedMeshID
	EndProcedure
EndModule
