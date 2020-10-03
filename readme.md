# PureBasic Game Engine Test

This is just a test


## Features

* Customizable launcher (Unity style)
* GUI system
* Launch arguments parsing
* Logging
* Resource Management
* Screens (aka: scenes)


## Building
You can either open the main file named "Game.pb" and compile it.<br>
Or you can run the "_build.cmd" script file to compile it in a separate folder.


## Licenses

### Engine
The whole engine and examples are covered under the *Unlicense* license.<br>
You can check it here: [LICENSE](LICENSE)

### PureBasic Libraries
Some of the internal libraries of PureBasic have special licenses, you can find the license of the used ones here:

#### Ogre engine
This is the 3D engine that is used troughout this engine.
It is licensed under the *GNU v2* license, and it can be found in "[Licenses/OGRE Engine.txt](Licenses/OGRE%20Engine.txt)".

#### PCRE
This is the regex library used in the "[Engine/Arguments.pbi](Engine/Arguments.pbi)" include.<br>
It is licensed under the *BSD* license, and it can be found in "[Licenses/PRCE.txt](Licenses/PRCE.txt)".

### Remarks
To avoid any issues with the fact you may have to include some license files in your final product, the build script copies the whole "Licenses" folder in the "Build/" folder and adds the one for the engine under the following name: "Custom PB Engine.txt".
