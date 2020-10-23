# PureBasic 2D/3D Game Framework Test
A basic 2D/3D game framework for PureBasic.

## Features
The framework features at first a very simple set of features:
<!--These features come embedded in the *core* part of the framework.-->
* Easily configurable build scripts
* Logging (Primitive)
* Screens (aka: scenes)

And if you want you can toggle the following features by editing the [build script config file](build-config.cmd):
* GUI system (Primitive)
* Launch arguments parsing (Unfinished)
* Live asset manipulator (Unfinished)
* Resource Management
* Snappy compression/decompression support (Windows only <sub><sup>easily portable to Linux if you compile the .so files, I think...</sup></sub>)
* Unity style launcher (Unfinished)
* XInput controller support (Windows only)

## Documentation
All of the documentation for the different components of the framework can be found in the *"[Documentation/](Documentation/readme.md)"* folder.<br>
A summary of all the pages will also be present in there.

## Building

### For release
To clean, build and package the game and launcher, you can run the included scripts.<br>
And if you want to configure these scripts, you can modify the *"[build-config.cmd](build-config.cmd)"* file and modify the lines that are relevant to your needs.

#### Scripts

<b>$> [build-clean.cmd](build-clean.cmd)</b><br>
Removes the *"Build/"* and *"Packages/"* folders and some trash.

<b>$> [build-compile.cmd](build-compile.cmd)</b><br>
This script builds the x86 and x64 versions of the game and launcher, copies the content of the *"[Data/](Data/)"* and *"[Licenses/](Licenses/)"* folders inside the *"Build/"* folder and removes the trash from them.

<b>$> [build-package.cmd](build-package.cmd)</b><br>
Packages the game in archives that are then put in the *"Packages/"* folder.

<b>$> [build-make-pbp.cmd](build-make-pbp.cmd)</b><br>
Removes any PureBasic project file and creates one with all the constants that are relevant and present in the config script.

### Modules

#### XInput
You can enable XInput support by compiling the game and framework by setting the `#FRAMEWORK_MODULE_XINPUT` constant in the compiler or by making sure the build script has the variable `%MODULE_FRAMEWORK_XINPUT%` set to `1`.

By doing so, you will have access to the `XInput` module and it's fonctions, and the XInput library will be loaded when you call `Framework::Init()`.
And since this module is the only controller module present in the framework for now, if you activate it, the framework will take care of calling the controller-related procedures of your screens with the help of the `ControllerManager` module.

More info about the XInput module can be found in the [relevant documentation](Documentation/XInput.md).

### For development
If you simply want to run the game to test your code, you can either compile *"[Game.pb](Game.pb)"* or simply open the *"[Game.pbp](Game.pbp)"* file and use the project.<br>
Just keep in mind that you will have to copy the appropriate DLL from the *"[Libraries/](Libraries/)"* folder in the root folder for this to work.<br><br>
And if you want to run the launcher, you can either compile *"[Launcher.pb](Launcher.pb)"* or simply open the *"[Game.pbp](Game.pbp)"* project file and select the launcher build.

## Known Bugs
* Some objects/entities can disapear if you move the game window to a different screen.<br>
I have no idea on why this happens...
* The Game can hang a tiny bit and crash when shutting it down.<br>
It is probably related to the main loop, but I'm not sure why it happens yet, probably a race condition.
* The x86 version of the game look "stuttery"...

## Licenses

### Framework
The custom framework and examples are covered under the *Unlicense* license.<br>
You can check it here: *"[LICENSE](LICENSE)"*

Does not apply to the trash folders for "safety", just in case I ever publish them.

### PureBasic Libraries
Some of the internal libraries of PureBasic have special licenses, you can find their licenses in the *"[Licenses/](Licenses/)"* folder.<br>
The license files are taken from the *"[fantaisie-software/purebasic-repository-template](https://github.com/fantaisie-software/purebasic-repository-template)"* repository.

### Google's Snappy


### Remarks
To avoid any issues with the fact you may have to include some license files in your final product, the build script copies the whole *"[Licenses/](Licenses/)"* folder in the *"Build/Commons/"* folder and adds the one for the framework under the following name: *"Custom PB Framework.txt"*.
