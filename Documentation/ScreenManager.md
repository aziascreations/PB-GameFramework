# [Documentation](readme.md) - Screen Manager
<b>Location:</b> *[Framework/Screens.pbi](../Framework/Screens.pbi)*

<b>Status:</b> *Core component*

<b>Dependencies:</b> *Core components*<br>
<b>Dependants:</b> *[ControllerManager](ControllerManager.md)*, *Game Bootstrapper*, *Game Code*

## Screen Manager


## Screens
Screens are like scenes in other framework/engines that allow you to more easily manage your game code and define a specific set of procedures that will be called on very specific events.

Every screen [is tipically contained within a module...] has an id in the form of a string that is used to refer to it.

//Once the engine is initialized

Modules are typically used to keep the procedures names [...], but it's not mandatory.

### Procedures

`OnRegister()`<br>
&emsp;Called when the screen in registered in the screen manager.

`OnUnregister()`<br>
&emsp;Called when the screen in unregistered from the screen manager.

`OnInit()`<br>
&emsp;???

`OnStart()`<br>
&emsp;Called when entering in the screen the first time or after quitting it.

`OnEnter(IsFirstTime.b)`<br>
&emsp;Called when entering the screen the first time or after having left it temporarely.<br>
&emsp;If it is the first time `IsFirstTime.b` will equal `#True`, or `#False` otherwise.

`OnUpdate(TimeDelta.q)`<br>
&emsp;

`OnRender(TimeDelta.q)`<br>
&emsp;

`OnLeave()`<br>
&emsp;

`OnQuit()`<br>
&emsp;

`OnControllerButtonDown(UserIndex.l, ButtonPressed.w)`<br>
&emsp;

`OnControllerButtonUp(UserIndex.l, ButtonPressed.w)`<br>
&emsp;

`OnControllerAxisMoved(UserIndex.l, ButtonPressed.w, AxisX.f, AxisY.f)`<br>
&emsp;

### Example

```purebasic
DeclareModule MyScreen
	; Used as the screen's id when other parts of the game need to
	;  refer to it.
	#Id$ = "my-screen"
	
	; Used to register the screen in the screen manager.
	; Usually called at the end of the include/source file
	;  to avoid having to call it somewhere else.
	Declare.i Register()
EndDeclareModule

Module MyScreen
	EnableExplicit
	
	Procedure OnRegister()
		
	EndProcedure
	
	Procedure OnUnregister()
		
	EndProcedure
	
	Procedure OnInit()
		
	EndProcedure
	
	Procedure OnStart()
		
	EndProcedure
	
	Procedure OnEnter(IsFirstTime.b)
		
	EndProcedure
	
	Procedure OnUpdate(TimeDelta.q)
		; Called every frame.
		; "TimeDelta" is equal to the time that has passed since the
		;  last call to OnUpdate().
	EndProcedure
	
	Procedure OnRender(TimeDelta.q)
		; Called every frame.
		; "TimeDelta" is equal to the "TimeDelta" value that is passed
		;  to OnUpdate() and has the same meaning.
	EndProcedure
	
	Procedure OnLeave()
		; Called when temporarely leaving the screen for another one.
	EndProcedure
	
	Procedure OnQuit()
		; Called when leaving the screen for another one or when quitting the game.
	EndProcedure
	
	Procedure OnControllerButtonDown(???)
		;???
	EndProcedure
	
	Procedure OnControllerButtonUp(???)
		;???
	EndProcedure
	
	Procedure OnControllerAxisMoved(???)
		;???
	EndProcedure
	
	Procedure.i Register()
		Protected *Self = ScreenManager::CreateScreen("My screen", @OnRegister(),
		                                              @OnUnregister(), @OnInit(),
		                                              @OnStart(), @OnUpdate(),
		                                              @OnRender(), @OnLeave(),
		                                              @OnQuit(),
		                                              @OnControllerButtonDown(),
		                                              @OnControllerButtonUp(),
		                                              @OnControllerAxisMoved())
		
		If Not *Self
			Logger::Error("Failed to create my screen !")
			End 3
		EndIf
		
		If Not ScreenManager::RegisterScreen(*Self, #Id$, #True, #True)
			Logger::Error("Failed to register my screen !")
			End 4
		EndIf
	EndProcedure
EndModule

MyScreen::Register()
```
