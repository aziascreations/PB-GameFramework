# PureBasic Game Engine Test

This is just a test

## Features

* Customizable launcher (Unity style)
* GUI system (Unfinished)
* Launch arguments parsing (Unfinished)
* Logging
* Resource Management
* Screens (aka: scenes)

## Building

### For release
To build and package the game you can run the included scripts in this order:<br>
&nbsp;&nbsp;1. [_clean.cmd](_clean.cmd)<br>
&nbsp;&nbsp;2. [_build.cmd](_build.cmd)<br>
&nbsp;&nbsp;3. [_package.cmd](_package.cmd)

This will build the x86 and x64 versions of the game, copy the content of the "Data/" and "Licenses/" folders, remove the trash from them and package everything accordingly.

### For development
If you simply want to run the game to test your code, you can either compile [game.pb](game.pb) or simply open the [game.pbp](game.pbp) file and use the project.<br>
Just keep in mind that you will have to copy the appropriate DLL from the "Libraries/" folder in the root folder for this to work.

## Known Bugs

Some objects/entities can disapear if you move the game window to a different screen.<br>
I have no idea on why this happens...

The Game can hang a tiny bit and crash when shutting it down.<br>
It is probably related to the main loop, but I'm not sure why it happens yet, probably a race condition.

The x86 version of the game look "stuttery"...

## Licenses

### Engine
The custom engine and examples are covered under the *Unlicense* license.<br>
You can check it here: [LICENSE](LICENSE)

### PureBasic Libraries
Some of the internal libraries of PureBasic have special licenses, you can find their licenses in the [Licenses](Licenses/) folder.<br>
The license files are taken from the [fantaisie-software/purebasic-repository-template](https://github.com/fantaisie-software/purebasic-repository-template) repository.

### Remarks
To avoid any issues with the fact you may have to include some license files in your final product, the build script copies the whole "Licenses" folder in the "Build/" folder and adds the one for the engine under the following name: "Custom PB Engine.txt".
