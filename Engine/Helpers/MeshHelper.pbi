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
		
		Protected Scale.d = 1.0, HasDefinedVertices = #False
		
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
						Case "m"
							AddSubMesh()
						Case "s"
							Scale = ValD(StringField(Line$, 2, " "))
							Logger::Trace("Setting scale: '"+Line$+"' => '"+StrD(Scale)+"'")
						Case "v"
							MeshVertexPosition(ValD(StringField(Line$, 2, " "))*Scale,
							                   ValD(StringField(Line$, 3, " "))*Scale,
							                   ValD(StringField(Line$, 4, " "))*Scale)
							HasDefinedVertices = #True
						Case "c"
							If CountString(Line$, " ") >= 4
								MeshVertexColor(RGB(Val(StringField(Line$, 3, " ")),
								                    Val(StringField(Line$, 4, " ")),
								                    Val(StringField(Line$, 5, " "))))
							Else
								MeshVertexColor(RGB(Val(StringField(Line$, 2, " ")),
								                    Val(StringField(Line$, 3, " ")),
								                    Val(StringField(Line$, 4, " "))))
							EndIf
						Case "t"
							If CountString(Line$, " ") >= 3
								MeshVertexTextureCoordinate(ValD(StringField(Line$, 3, " ")),
								                            ValD(StringField(Line$, 4, " ")))
							Else
								MeshVertexTextureCoordinate(ValD(StringField(Line$, 2, " ")),
								                            ValD(StringField(Line$, 3, " ")))
								
							EndIf
						Case "f"
							MeshFace(Val(StringField(Line$, 2, " ")),
							         Val(StringField(Line$, 3, " ")),
							         Val(StringField(Line$, 4, " ")))
						Default
							Logger::Error("Unknown mesh command: "+Line$)
					EndSelect
				Wend
				
				; Prevents a crash is the model has not defined any vertices.
				If Not HasDefinedVertices
					MeshVertexPosition(0.0, 0.0, 0.0)
				EndIf
				
				NormalizeMesh(ReturnedMeshID)
				BuildMeshTangents(ReturnedMeshID)
				BuildMeshShadowVolume(ReturnedMeshID)
				
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
