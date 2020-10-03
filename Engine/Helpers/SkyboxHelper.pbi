
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Code

DeclareModule Skybox
	#DefaultSizeOffset = 0
	#DefaultMaterialFiltering = #PB_Material_None
	#DefaultMaterialLightingDisabled = #True
	
	Declare GenerateSquareSkybox(TexturePrefix$, DerivedResourcePrefix$, Size.i,
	                             SizeOffset.i = #DefaultSizeOffset,
	                             MaterialFilteringMode = #DefaultMaterialFiltering,
	                             MaterialDisabledLightingStatus = #DefaultMaterialLightingDisabled)
EndDeclareModule

Module Skybox
	;#SkyboxCubeMeshKey$ = "skybox-square-panel"
	
	Procedure GenerateSquareSkybox(TexturePrefix$, DerivedResourcePrefix$, Size.i,
	                               SizeOffset.i = #DefaultSizeOffset,
	                               MaterialFilteringMode = #DefaultMaterialFiltering,
	                               MaterialDisabledLightingStatus = #DefaultMaterialLightingDisabled)
		; Materials
		
		If Not Resources::HasMaterial(DerivedResourcePrefix$+"-x+")
			Resources::SetMaterial(DerivedResourcePrefix$+"-x+",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture(TexturePrefix$+"-x+"))))
		EndIf
		DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-x+"), MaterialDisabledLightingStatus)
		MaterialFilteringMode(Resources::GetMaterial(DerivedResourcePrefix$+"-x+"), MaterialFilteringMode)
		
		If Not Resources::HasMaterial(DerivedResourcePrefix$+"-x-")
			Resources::SetMaterial(DerivedResourcePrefix$+"-x-",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture(TexturePrefix$+"-x-"))))
			DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-x-"), #True)
		EndIf
		DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-x-"), MaterialDisabledLightingStatus)
		MaterialFilteringMode(Resources::GetMaterial(DerivedResourcePrefix$+"-x-"), MaterialFilteringMode)
		
		If Not Resources::HasMaterial(DerivedResourcePrefix$+"-y+")
			Resources::SetMaterial(DerivedResourcePrefix$+"-y+",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture(TexturePrefix$+"-y+"))))
			DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-y+"), #True)
		EndIf
		DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-y+"), MaterialDisabledLightingStatus)
		MaterialFilteringMode(Resources::GetMaterial(DerivedResourcePrefix$+"-y+"), MaterialFilteringMode)
		
		If Not Resources::HasMaterial(DerivedResourcePrefix$+"-y-")
			Resources::SetMaterial(DerivedResourcePrefix$+"-y-",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture(TexturePrefix$+"-y-"))))
			DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-y-"), #True)
		EndIf
		DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-y-"), MaterialDisabledLightingStatus)
		MaterialFilteringMode(Resources::GetMaterial(DerivedResourcePrefix$+"-y-"), MaterialFilteringMode)
		
		If Not Resources::HasMaterial(DerivedResourcePrefix$+"-z+")
			Resources::SetMaterial(DerivedResourcePrefix$+"-z+",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture(TexturePrefix$+"-z+"))))
			DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-z+"), #True)
		EndIf
		DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-z+"), MaterialDisabledLightingStatus)
		MaterialFilteringMode(Resources::GetMaterial(DerivedResourcePrefix$+"-z+"), MaterialFilteringMode)
		
		If Not Resources::HasMaterial(DerivedResourcePrefix$+"-z-")
			Resources::SetMaterial(DerivedResourcePrefix$+"-z-",
			                       CreateMaterial(#PB_Any,
			                                      TextureID(Resources::GetTexture(TexturePrefix$+"-z-"))))
			DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-z-"), #True)
		EndIf
		DisableMaterialLighting(Resources::GetMaterial(DerivedResourcePrefix$+"-z-"), MaterialDisabledLightingStatus)
		MaterialFilteringMode(Resources::GetMaterial(DerivedResourcePrefix$+"-z-"), MaterialFilteringMode)
		
		; Mesh
		If Not Resources::HasMesh(DerivedResourcePrefix$+"-panel")
			Resources::SetMesh(DerivedResourcePrefix$+"-panel",
			                   CreatePlane(#PB_Any, Size+SizeOffset, Size+SizeOffset, 1, 1, 1, 1))
		EndIf
		
		; Entities
		If Not Resources::HasEntity(DerivedResourcePrefix$+"-top")
			Resources::SetEntity(DerivedResourcePrefix$+"-top",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh(DerivedResourcePrefix$+"-panel")),
			                                  MaterialID(Resources::GetMaterial(DerivedResourcePrefix$+"-y+")),
			                                  0, Size/2, 0))
			RotateEntity(Resources::GetEntity(DerivedResourcePrefix$+"-top"), 180, 180, 0)
		EndIf
		
		If Not Resources::HasEntity(DerivedResourcePrefix$+"-bottom")
			Resources::SetEntity(DerivedResourcePrefix$+"-bottom",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh(DerivedResourcePrefix$+"-panel")),
			                                  MaterialID(Resources::GetMaterial(DerivedResourcePrefix$+"-y-")),
			                                  0, Size/2*-1, 0))
		EndIf
		
		If Not Resources::HasEntity(DerivedResourcePrefix$+"-front")
			Resources::SetEntity(DerivedResourcePrefix$+"-front",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh(DerivedResourcePrefix$+"-panel")),
			                                  MaterialID(Resources::GetMaterial(DerivedResourcePrefix$+"-x+")),
			                                  Size/2, 0, 0))
			RotateEntity(Resources::GetEntity(DerivedResourcePrefix$+"-front"), -90, 90, 0) ;x+
		EndIf
		
		If Not Resources::HasEntity(DerivedResourcePrefix$+"-back")
			Resources::SetEntity(DerivedResourcePrefix$+"-back",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh(DerivedResourcePrefix$+"-panel")),
			                                  MaterialID(Resources::GetMaterial(DerivedResourcePrefix$+"-x-")),
			                                  Size/2*-1, 0, 0))
			RotateEntity(Resources::GetEntity(DerivedResourcePrefix$+"-back"), -90, -90, 0) ;x-
		EndIf
		
		If Not Resources::HasEntity(DerivedResourcePrefix$+"-left")
			Resources::SetEntity(DerivedResourcePrefix$+"-left",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh(DerivedResourcePrefix$+"-panel")),
			                                  MaterialID(Resources::GetMaterial(DerivedResourcePrefix$+"-z+")),
			                                  0, 0, Size/2))
			RotateEntity(Resources::GetEntity(DerivedResourcePrefix$+"-left"), -90, 0, 0)   ;z-
		EndIf
		
		If Not Resources::HasEntity(DerivedResourcePrefix$+"-right")
			Resources::SetEntity(DerivedResourcePrefix$+"-right",
			                     CreateEntity(#PB_Any,
			                                  MeshID(Resources::GetMesh(DerivedResourcePrefix$+"-panel")),
			                                  MaterialID(Resources::GetMaterial(DerivedResourcePrefix$+"-z-")),
			                                  0, 0, Size/2*-1))
			RotateEntity(Resources::GetEntity(DerivedResourcePrefix$+"-right"), 90, 0, 180) ;z+
		EndIf
	EndProcedure
EndModule
