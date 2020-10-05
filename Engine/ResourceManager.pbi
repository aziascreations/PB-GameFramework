;{
; * ResourceManager.pbi
; Version: 0.2.0-indev
; Author: Herwin Bozet
; 
; This modules stores and handles all the indexed resources for the game.
;}

;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit

XIncludeFile "./Helpers/MeshHelper.pbi"

If Not InitSound()
	Logger::Error("Failed to start sound engine !")
	End 5
EndIf

UsePNGImageDecoder()


;- ----------------------------------------
;- Module Declaration

DeclareModule Resources
	Enumeration ResourceTypes
		#ResourceType_Texture
		#ResourceType_Material
		#ResourceType_Mesh
		#ResourceType_Entity
		#ResourceType_Camera
		#ResourceType_Sound
		#ResourceType_Other
		#ResourceType_Sprite
		#ResourceType_Image
		#ResourceType_FigureItOut
	EndEnumeration
	
	; The error resources are kept out of the maps for faster access
	;  and To protect them from being flushed.
	Global ErrorTexture, ErrorMaterial
	
	;-> Basics
	Declare.b Init()
	Declare.b Start()
	Declare.b Finish(CleanMemory.b = #True)
	
	Declare.q ReadIndexFiles(RealParentFolder$, Folder$)
	
	Declare.b Update()
	Declare.b UpdateAll()
	
	;-> Checkers
	Declare.i HasResource(ResourceId$, ResourceType.i)
	Macro HasTexture(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Texture)
	EndMacro
	Macro HasMaterial(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Material)
	EndMacro
	Macro HasMesh(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Mesh)
	EndMacro
	Macro HasEntity(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Entity)
	EndMacro
	Macro HasCamera(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Camera)
	EndMacro
	Macro HasSound(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Sound)
	EndMacro
	Macro HasOther(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Other)
	EndMacro
	Macro HasImage(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Image)
	EndMacro
	Macro HasSprite(ResourceId)
		Resources::HasResource(ResourceId, Resources::#ResourceType_Sprite)
	EndMacro
	Macro Has(ResourceId, ResourceType)
		Resources::HasResource(ResourceId, ResourceType)
	EndMacro
	
	;-> Getters
	Declare.i GetResource(ResourceId$, ResourceType.i, FallbackValue.i = #Null)
	Macro GetTexture(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Texture, Resources::ErrorTexture)
	EndMacro
	Macro GetMaterial(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Material, Resources::ErrorMaterial)
	EndMacro
	Macro GetMesh(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Mesh)
	EndMacro
	Macro GetEntity(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Entity)
	EndMacro
	Macro GetCamera(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Camera)
	EndMacro
	Macro GetSound(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Sound)
	EndMacro
	Macro GetOther(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Other)
	EndMacro
	Macro GetImage(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Image)
	EndMacro
	Macro GetSprite(ResourceId)
		Resources::GetResource(ResourceId, Resources::#ResourceType_Sprite)
	EndMacro
	Macro Get(ResourceId, ResourceType, FallbackValue = #Null)
		Resources::GetResource(ResourceId, ResourceType, FallbackValue)
	EndMacro
	
	;-> Setters
	Declare.i SetResource(ResourceId$, Resource.i, ResourceType.i, Overwrite.b = #False,
	                      FreeOverwritten.b = #True, FreeNewOnError.b = #True)
	Macro SetTexture(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Texture, Over, FreeOv, #True)
	EndMacro
	Macro SetMaterial(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Material, Over, FreeOv, #True)
	EndMacro
	Macro SetMesh(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Mesh, Over, FreeOv, #True)
	EndMacro
	Macro SetEntity(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Entity, Over, FreeOv, #True)
	EndMacro
	Macro SetCamera(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Camera, Over, FreeOv, #True)
	EndMacro
	Macro SetSound(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Sound, Over, FreeOv, #True)
	EndMacro
	Macro SetImage(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Image, Over, FreeOv, #True)
	EndMacro
	Macro SetSprite(RscId, Rsc, Over = #False, FreeOv = #True)
		Resources::SetResource(RscId, Rsc, Resources::#ResourceType_Sprite, Over, FreeOv, #True)
	EndMacro
	Macro Set(ResourceId, Resource, ResourceType, Overwrite = #False,
	          FreeOverwritten = #True, FreeNewOnError = #True)
		Resources::SetResource(ResourceId, Resource, ResourceType, Overwrite, FreeOverwritten, FreeNewOnError)
	EndMacro
	
	;-> Deleters
	Declare.b DeleteEntity(ResourceId$, CleanMemory.b = #True)
	Declare.b DeleteCamera(ResourceId$, CleanMemory.b = #True)
	Declare.b FreeResource(ResourceId$, ResourceType.i, RemoveFromMap.b = #True)
	Declare.b FreeDirectResource(Resource.i, ResourceType.i = #ResourceType_FigureItOut)
	
	;-> Flushers
	Declare FlushTextures(CleanMemory.b = #True)
	Declare FlushMaterials(CleanMemory.b = #True)
	Declare FlushMeshes(CleanMemory.b = #True)
	Declare FlushEntities(CleanMemory.b = #True)
	Declare FlushCameras(CleanMemory.b = #True)
	Declare FlushSounds(CleanMemory.b = #True)
	Declare FlushImages(CleanMemory.b = #True)
	Declare FlushSprites(CleanMemory.b = #True)
	Declare FlushAll(CleanMemory.b = #True)
EndDeclareModule


;- ----------------------------------------
;- Module Definition

Module Resources
	EnableExplicit
	
	; This is more complicated than it should be because PB can be pretty retarded at times...
	Structure ResourceRegistration
		ResourceRealParentPath$
		ResourceArchivePath$
		ResourceFilePath$
		ResourceKey$
		ResourceType.i
	EndStructure
	
	; Could be grouped inside a single map, but it would decrease performances for no good reason.
	Global NewMap Textures.i()
	Global NewMap Materials.i()
	Global NewMap Meshes.i()
	Global NewMap Entities.i()
	Global NewMap Cameras.i()
	Global NewMap Sounds.i()
	Global NewMap Images.i()
	Global NewMap Sprites.i()
	Global NewMap Others.i()
	
	Global NewList UnloadedResources.ResourceRegistration()
	
	
	;-> Basics
	
	Procedure.b Init()
		;Logger::Devel("Resources::Init() was called !")
		
	EndProcedure
	
	Procedure.b Start()
		Logger::Trace("Starting resource manager...")
		Logger::Trace("Checking error resources...")
		
		; Texture
		If Not IsTexture(ErrorTexture)
			Logger::Trace("Creating error texture...")
			ErrorTexture = CreateTexture(#PB_Any, 2, 2)
			StartDrawing(TextureOutput(ErrorTexture))
			Box(0, 0, 2, 2, RGB(0, 0, 0))
			Box(1, 0, 1, 1, RGB(255, 0, 255))
			Box(0, 1, 1, 1, RGB(255, 0, 255))
			StopDrawing()
		EndIf
		
		; Material
		If Not IsMaterial(ErrorMaterial)
			Logger::Trace("Creating error material...")
			ErrorMaterial = CreateMaterial(#PB_Any, TextureID(ErrorTexture))
			MaterialFilteringMode(ErrorMaterial, #PB_Material_None)
		EndIf
	EndProcedure
	
	Procedure.b Finish(CleanMemory.b = #True)
		FlushAll(CleanMemory)
		
		If CleanMemory
			FreeMaterial(ErrorMaterial)
			FreeTexture(ErrorTexture)
		EndIf
	EndProcedure
	
	Procedure.q ReadIndexFiles(RealParentFolder$, Folder$)
		Protected NewResourceCount.q = 0
		
		If Not (Right(RealParentFolder$, 1) = "/" Or Right(RealParentFolder$, 1) = "\")
			RealParentFolder$ = RealParentFolder$ + "/"
		EndIf
		
		If Not (Right(Folder$, 1) = "/" Or Right(Folder$, 1) = "\")
			Folder$ = Folder$ + "/"
		EndIf
		
		Logger::Devel("Searching for index files in: "+RealParentFolder$+Folder$)
		
		; Textures
		If FileSize(RealParentFolder$+Folder$ + "index-textures.json") > 0
			Logger::Devel("Found a texture index !")
			
			Protected TextureIndexJson = LoadJSON(#PB_Any, RealParentFolder$+Folder$ + "index-textures.json")
			
			If Not TextureIndexJson
				Logger::Error("Failed to load: "+RealParentFolder$+Folder$+"index-textures.json")
				Logger::Error("-> "+JSONErrorMessage()+" @ "+JSONErrorLine()+":"+JSONErrorPosition())
				ProcedureReturn NewResourceCount
			EndIf
			
			Protected NewMap TextureList.s()
			ExtractJSONMap(JSONValue(TextureIndexJson), TextureList())
			
			ForEach TextureList()
				If Left(MapKey(TextureList()), 1) = "_"
					Continue
				EndIf
				
				AddElement(UnloadedResources())
				UnloadedResources()\ResourceRealParentPath$ = RealParentFolder$
				UnloadedResources()\ResourceArchivePath$ = Folder$
				UnloadedResources()\ResourceFilePath$ = TextureList()
				UnloadedResources()\ResourceKey$ = MapKey(TextureList())
				UnloadedResources()\ResourceType = #ResourceType_Texture
			Next
			
			FreeMap(TextureList())
			FreeJSON(TextureIndexJson)
		EndIf
		
		; Sounds
		If FileSize(RealParentFolder$+Folder$ + "index-sounds.json") > 0
			Logger::Devel("Found a sound index !")
			
			Protected SoundIndexJson = LoadJSON(#PB_Any, RealParentFolder$+Folder$ + "index-sounds.json")
			
			If Not SoundIndexJson
				Logger::Error("Failed to load: "+RealParentFolder$+Folder$+"index-sounds.json")
				Logger::Error("-> "+JSONErrorMessage()+" @ "+JSONErrorLine()+":"+JSONErrorPosition())
				ProcedureReturn NewResourceCount
			EndIf
			
			Protected NewMap SoundList.s()
			ExtractJSONMap(JSONValue(SoundIndexJson), SoundList())
			
			ForEach SoundList()
				If Left(MapKey(SoundList()), 1) = "_"
					Continue
				EndIf
				
				AddElement(UnloadedResources())
				UnloadedResources()\ResourceRealParentPath$ = RealParentFolder$
				UnloadedResources()\ResourceArchivePath$ = Folder$
				UnloadedResources()\ResourceFilePath$ = SoundList()
				UnloadedResources()\ResourceKey$ = MapKey(SoundList())
				UnloadedResources()\ResourceType = #ResourceType_Sound
			Next
			
			FreeMap(SoundList())
			FreeJSON(SoundIndexJson)
		EndIf
		
		; Meshes
		If FileSize(RealParentFolder$+Folder$ + "index-meshes.json") > 0
			Logger::Devel("Found a mesh index !")
			
			Protected MeshIndexJson = LoadJSON(#PB_Any, RealParentFolder$+Folder$ + "index-meshes.json")
			
			If Not MeshIndexJson
				Logger::Error("Failed to load: "+RealParentFolder$+Folder$+"index-meshes.json")
				Logger::Error("-> "+JSONErrorMessage()+" @ "+JSONErrorLine()+":"+JSONErrorPosition())
				ProcedureReturn NewResourceCount
			EndIf
			
			Protected NewMap MeshList.s()
			ExtractJSONMap(JSONValue(MeshIndexJson), MeshList())
			
			ForEach MeshList()
				If Left(MapKey(MeshList()), 1) = "_"
					Continue
				EndIf
				
				AddElement(UnloadedResources())
				UnloadedResources()\ResourceRealParentPath$ = RealParentFolder$
				UnloadedResources()\ResourceArchivePath$ = Folder$
				UnloadedResources()\ResourceFilePath$ = MeshList()
				UnloadedResources()\ResourceKey$ = MapKey(MeshList())
				UnloadedResources()\ResourceType = #ResourceType_Mesh
			Next
			
			FreeMap(MeshList())
			FreeJSON(MeshIndexJson)
		EndIf
		
		ProcedureReturn NewResourceCount
	EndProcedure
	
	Procedure.b Update()
		If ListSize(UnloadedResources()) > 0
			FirstElement(UnloadedResources())
			Logger::Devel("Loading ressource: "+UnloadedResources()\ResourceKey$)
			
			Select UnloadedResources()\ResourceType
				Case #ResourceType_Texture
					Protected NewTexture = LoadTexture(#PB_Any, UnloadedResources()\ResourceArchivePath$ +
					                                            UnloadedResources()\ResourceFilePath$)
					
					If IsTexture(NewTexture)
						SetTexture(UnloadedResources()\ResourceKey$, NewTexture, #True, #True)
					Else
						Logger::Error("Failed to load texture !")
					EndIf
				Case #ResourceType_Sound
					Protected NewSound = LoadSound(#PB_Any,
					                               UnloadedResources()\ResourceRealParentPath$ +
					                               UnloadedResources()\ResourceArchivePath$ +
					                               UnloadedResources()\ResourceFilePath$)
					If IsSound(NewSound)
						SetSound(UnloadedResources()\ResourceKey$, NewSound, #True, #True)
					Else
						Logger::Error("Failed to load sound !")
					EndIf
				Case #ResourceType_Mesh
					Protected NewMesh = MeshHelper::ParseMeshFile(UnloadedResources()\ResourceRealParentPath$ +
					                                              UnloadedResources()\ResourceArchivePath$ +
					                                              UnloadedResources()\ResourceFilePath$)
					If IsMesh(NewMesh)
						SetMesh(UnloadedResources()\ResourceKey$, NewMesh, #True, #True)
					Else
						Logger::Error("Failed to load mesh !")
					EndIf
				Default
					Logger::Error("Unknown resource type !!!")
			EndSelect
			
			DeleteElement(UnloadedResources())
			
			ProcedureReturn #False
		EndIf
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b UpdateAll()
		While Not Update() : Wend
		ProcedureReturn #True
	EndProcedure
	
	
	;-> Checker
	
	Procedure.i HasResource(ResourceId$, ResourceType.i)
		If ResourceId$ <> #Null$
			Select ResourceType
				Case #ResourceType_Texture
					ProcedureReturn FindMapElement(Textures(), ResourceId$)
				Case #ResourceType_Material
					ProcedureReturn FindMapElement(Materials(), ResourceId$)
				Case #ResourceType_Mesh
					ProcedureReturn FindMapElement(Meshes(), ResourceId$)
				Case #ResourceType_Entity
					ProcedureReturn FindMapElement(Entities(), ResourceId$)
				Case #ResourceType_Camera
					ProcedureReturn FindMapElement(Cameras(), ResourceId$)
				Case #ResourceType_Sound
					ProcedureReturn FindMapElement(Sounds(), ResourceId$)
				Case #ResourceType_Image
					ProcedureReturn FindMapElement(Images(), ResourceId$)
				Case #ResourceType_Sprite
					ProcedureReturn FindMapElement(Sprites(), ResourceId$)
			EndSelect
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	
	;-> Getter
	
	Procedure.i GetResource(ResourceId$, ResourceType.i, FallbackValue.i = #Null)
		Protected ReturnValue.i = #Null
		
		Select ResourceType
			Case #ResourceType_Texture
				ReturnValue = Textures(ResourceId$)
			Case #ResourceType_Material
				ReturnValue = Materials(ResourceId$)
			Case #ResourceType_Mesh
				ReturnValue = Meshes(ResourceId$)
			Case #ResourceType_Entity
				ReturnValue = Entities(ResourceId$)
			Case #ResourceType_Camera
				ReturnValue = Cameras(ResourceId$)
			Case #ResourceType_Sound
				ReturnValue = Sounds(ResourceId$)
			Case #ResourceType_Other
				ReturnValue = Others(ResourceId$)
			Case #ResourceType_Image
				ReturnValue = Images(ResourceId$)
			Case #ResourceType_Sprite
				ReturnValue = Sprites(ResourceId$)
			Default
				Logger::Warning("Invalid resource type given: "+Str(ResourceType))
		EndSelect
		
		If ReturnValue <> #Null
			ProcedureReturn ReturnValue
		Else
			ProcedureReturn FallbackValue
		EndIf
	EndProcedure
	
	
	;-> Setter
	
	Procedure.i SetResource(ResourceId$, Resource.i, ResourceType.i, Overwrite.b = #False, FreeOverwritten.b = #True, FreeNewOnError.b = #True)
		Protected DoesResourceExist.b = #False
		
		If ResourceId$ <> #Null$ And Resource <> #Null And ResourceType <> #ResourceType_FigureItOut
			If HasResource(ResourceId$, ResourceType)
				If Overwrite
					If FreeOverwritten
						FreeResource(ResourceId$, #False)
					EndIf
				Else
					Logger::Error("Failed to register resource, key already exists: "+ResourceId$)
					
					If FreeNewOnError
						FreeDirectResource(Resource, #ResourceType_FigureItOut)
					EndIf
					
					ProcedureReturn #False
				EndIf
			EndIf
			
			Logger::Trace("Registering resource under: "+ResourceId$+" ("+Str(Resource)+")")
			Select ResourceType
				Case #ResourceType_Texture
					Textures(ResourceId$) = Resource
				Case #ResourceType_Material
					Materials(ResourceId$) = Resource
				Case #ResourceType_Mesh
					Meshes(ResourceId$) = Resource
				Case #ResourceType_Entity
					Entities(ResourceId$) = Resource
				Case #ResourceType_Camera
					Cameras(ResourceId$) = Resource
				Case #ResourceType_Sound
					Sounds(ResourceId$) = Resource
				Case #ResourceType_Other
					Others(ResourceId$) = Resource
				Case #ResourceType_Image
					Images(ResourceId$) = Resource
				Case #ResourceType_Sprite
					Sprites(ResourceId$) = Resource
				Default
					Logger::Error("Unable to find the resourceType for '"+ResourceId$+"' !")
					If FreeNewOnError
						FreeDirectResource(Resource, #ResourceType_FigureItOut)
					EndIf
					ProcedureReturn #False
			EndSelect
			
			ProcedureReturn #True
		EndIf
		
		Logger::Error("The resource '"+ResourceId$+"' failed to meet some of the basic criterias to register !")
		If FreeNewOnError
			FreeDirectResource(Resource, #ResourceType_FigureItOut)
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	
	;-> Deleters
	
	Procedure.b DeleteEntity(ResourceId$, CleanMemory.b = #True)
		If ResourceId$ <> #Null$
			Protected Resource = FindMapElement(Entities(), ResourceId$)
			
			If Resource
				If CleanMemory
					If IsEntity(Resource)
						FreeEntity(Resource)
					Else
						Logger::Warning("Failed to remove entity individually !")
					EndIf
				EndIf
				
				DeleteMapElement(Entities(), ResourceId$) 
			EndIf
		EndIf
	EndProcedure
	
	Procedure.b DeleteCamera(ResourceId$, CleanMemory.b = #True)
		If ResourceId$ <> #Null$
			Protected Resource = FindMapElement(Cameras(), ResourceId$)
			
			If Resource
				If CleanMemory
					If IsCamera(Resource)
						FreeCamera(Resource)
					Else
						Logger::Warning("Failed to remove camera individually !")
					EndIf
				EndIf
				
				DeleteMapElement(Cameras(), ResourceId$) 
			EndIf
		EndIf
	EndProcedure
	
	Procedure.b FreeResource(ResourceId$, ResourceType.i, RemoveFromMap.b = #True)
		Logger::Warning("FreeResource() is not finished !")
		ProcedureReturn #False
	EndProcedure
	
	Procedure.b FreeDirectResource(Resource.i, ResourceType.i = #ResourceType_FigureItOut)
		If Resource <> #Null And ResourceType <> #ResourceType_Other
			If ResourceType = #ResourceType_FigureItOut
				If IsTexture(Resource)
					ResourceType = #ResourceType_Texture
				ElseIf IsMaterial(Resource)
					ResourceType = #ResourceType_Material
				ElseIf IsMesh(Resource)
					ResourceType = #ResourceType_Mesh
				ElseIf IsEntity(Resource)
					ResourceType = #ResourceType_Entity
				ElseIf IsCamera(Resource)
					ResourceType = #ResourceType_Camera
				ElseIf IsSound(Resource) Or IsSound3D(Resource)
					ResourceType = #ResourceType_Sound
				ElseIf IsSprite(Resource)
					ResourceType = #ResourceType_Sprite
				ElseIf IsImage(Resource)
					ResourceType = #ResourceType_Image
				Else
					Logger::Warning("Failed to find the resource type for @"+Str(Resource))
					ProcedureReturn #False
				EndIf
			EndIf
			
			Select ResourceType
				Case #ResourceType_Texture
					FreeTexture(Resource)
				Case #ResourceType_Material
					FreeMaterial(Resource)
				Case #ResourceType_Mesh
					FreeMaterial(Resource)
				Case #ResourceType_Entity
					FreeEntity(Resource)
				Case #ResourceType_Camera
					FreeCamera(Resource)
				Case #ResourceType_Sound
					If IsSound3D(Resource)
						FreeSound3D(Resource)
					Else
						FreeSound(Resource)
					EndIf
				Case #ResourceType_Sprite
					FreeSprite(Resource)
				Case #ResourceType_Image
					FreeImage(Resource)
				Default
					Logger::Error("Failed to free the resource @"+Str(Resource))
					ProcedureReturn #False
			EndSelect
			
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	
	;-> Flushers
	
	Procedure FlushTextures(CleanMemory.b = #True)
		If CleanMemory
			ForEach Textures()
				Protected TempResource = Textures()
				
				If IsTexture(TempResource)
					FreeTexture(TempResource)
				EndIf
			Next
		EndIf
		
		ClearMap(Textures())
	EndProcedure
	
	Procedure FlushMaterials(CleanMemory.b = #True)
		If CleanMemory
			ForEach Materials()
				Protected TempMaterial = Materials()
				
				If IsMaterial(TempMaterial)
					FreeMaterial(TempMaterial)
				EndIf
			Next
		EndIf
		
		ClearMap(Materials())
	EndProcedure
	
	Procedure FlushMeshes(CleanMemory.b = #True)
		If CleanMemory
			ForEach Meshes()
				Protected TempMesh = Meshes()
				
				If IsMesh(TempMesh)
					FreeMesh(TempMesh)
				EndIf
			Next
		EndIf
		
		ClearMap(Meshes())
	EndProcedure
	
	Procedure FlushEntities(CleanMemory.b = #True)
		If CleanMemory
			ForEach Entities()
				Protected TempEntity = Entities()
				
				If IsEntity(TempEntity)
					FreeEntity(TempEntity)
				EndIf
			Next
		EndIf
		
		ClearMap(Entities())
	EndProcedure
	
	Procedure FlushCameras(CleanMemory.b = #True)
		If CleanMemory
			ForEach Cameras()
				Protected TempCamera = Cameras()
				
				If IsCamera(TempCamera)
					FreeCamera(TempCamera)
				EndIf
			Next
		EndIf
		
		ClearMap(Cameras())
	EndProcedure
	
	Procedure FlushSounds(CleanMemory.b = #True)
		If CleanMemory
			ForEach Sounds()
				Protected TempSound = Sounds()
				
				If IsSound(TempSound)
					FreeSound(TempSound)
				ElseIf IsSound3D(TempSound)
					FreeSound3D(TempSound)
				Else
					Logger::Warning("Failed to free sound !")
				EndIf
			Next
		EndIf
		
		ClearMap(Sounds())
	EndProcedure
	
	Procedure FlushImages(CleanMemory.b = #True)
		If CleanMemory
			ForEach Images()
				Protected TempImage = Images()
				
				If IsImage(TempImage)
					FreeImage(TempImage)
				EndIf
			Next
		EndIf
		
		ClearMap(Images())
	EndProcedure
	
	Procedure FlushSprites(CleanMemory.b = #True)
		If CleanMemory
			ForEach Sprites()
				Protected TempSprite = Sprites()
				
				If IsSprite(TempSprite)
					FreeSprite(TempSprite)
				EndIf
			Next
		EndIf
		
		ClearMap(Sprites())
	EndProcedure
	
	Procedure FlushAll(CleanMemory.b = #True)
		FlushSprites(CleanMemory)
		FlushImages(CleanMemory)
		FlushSounds(CleanMemory)
		FlushCameras(CleanMemory)
		FlushEntities(CleanMemory)
		FlushMeshes(CleanMemory)
		FlushMaterials(CleanMemory)
		FlushTextures(CleanMemory)
	EndProcedure
EndModule
