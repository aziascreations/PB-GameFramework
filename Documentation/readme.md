# Documentation
## Core
* [Framework](Framework.md)
* [Logger](Logger.md)
* [ScreenManager](ScreenManager.md)

## Optional Components <sub><sup>(Grouped per module)</sup></sub>
* [Arguments](Arguments.md)
* [Controller Manager](ControllerManager.md) & [XInput](XInput.md)
* [GUIs](GUIs.md)
* [Resource Manager](ResourceManager.md)
* [Snappy](Snappy.md)

## Helpers
### 2D Helpers
* ???

### 3D Helpers
* ???

## Special
* [Internal Data](InternalData.md)

<br>
<hr>
<br>

## General code structure

The whole framework is composed of 5 types of components that are defined by the way they interact with each other and with your code.

### Framework type

The first type is the <b><i>framework</i></b>.

It is defined by the fact that it can only call code inside *components* and by the fact that it handles everything [that inits the 3D / 2D engines].

### Component type

The second and most important type is the component.

Components can only call code from the framework, themselves and other components and they form the majority of the framework.

[some can be toggled]

### Helper type

Helpers are very basic and entirelly optionnal pieces of code that fullfill a simple and specific function.

They are contained inside *Modules* so that they are removed from the final executable if they are not used.

And they can only call code from the framework, components or themselves, but not other helpers.

If an helper needs to call code from another helper, the only being called should then be treated as a component. 

### Game Bootstrapper type

As the name implies, the game bootstrapper can only do things that are nescessary to start and maintain the game alive.

It can only interact with the framework when it wants, and only at specific times with some components and your game code when it switch to it. (Switching to the first screen)

### Game Code type

This is the code you will wrote, it can interact with everything except the game bootstrapper.
