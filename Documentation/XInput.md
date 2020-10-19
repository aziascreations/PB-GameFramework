# [Documentation](readme.md) - XInput
<b>Location:</b> *[Framework/Controllers/XInput.pbi](/Framework/Controllers/XInput.pbi)*<br>
<b>Status:</b> *Optional component*<br>

<b>Dependencies:</b> *None*<br>
<b>Dependants:</b> *[ControllerManager](ControllerManager.md)*

<b>Compile flag:</b><br>
&emsp;`#FRAMEWORK_MODULE_XINPUT = <#False|#True>`<br>
&emsp;`%FRAMEWORK_MODULE_XINPUT% = <0|1>`</b>

<b>Module namespace:</b> `XInput`

<b>Requirements:</b><br>
&emsp;<b>OS:</b> Windows, version required may vary depending on the chosen API version.

## Description
The XInput *component* gives you access to all of the standard XInput functions and structures, as well as a couple of helpers procedures that assists with loading specific versions on the XInput API.

When this *component*'s module is enabled, the *[Framework](Framework.md)* takes care of calling all the custom procedures to initialize, load and close the XInput library.<br>
And the *[Controller Manager](ControllerManager.md)*, which is also in the same module, takes care of notifying the screen something happens.

You should only use the standard/official XInput functions that are loaded and provided in this *component*.

## Code

### Custom procedures
`InitXInput(MaxVersion = #XINPUT_VERSION_LATEST, MinVersion = #XINPUT_VERSION_LATEST).i`<br>
&emsp;Returns the library ID if it was openned successfully, or zero otherwise.<br>
&emsp;The parameters are used to indicate which version of XInput you wish to use or fallback on.

`LoadXInputFunctions(XInputLibraryID).i`<br>
&emsp;Returns zero is the API functions were loaded correctly, or non-zero otherwise.<br>
&emsp;The returned value can be one of the [custom error constants](#errors).

`CloseXInputLibrary(XInputLibraryID)`<br>
&emsp;Closes the XInput library.

`+GetLoadedXInputVersionString().s`<br>
&emsp;Returns a version string of the currently loaded library.

`+GetLoadedXInputVersion().i`<br>
&emsp;Returns the version constant of the currently loaded library.

### Custom constants

#### Errors
`#XINPUT_ERROR_LIBRARY_NOT_LOADED`<br>
&emsp;Returned by `???` when ???.

`#XINPUT_ERROR_FAILURE_TO_LOAD_FROM_LIBRARY`<br>
&emsp;Returned by `???` when ???.

#### Versions
`#XINPUT_VERSION_1_0`<br>
&emsp; Refers to xinput9_1_0.dll (???)

`#XINPUT_VERSION_1_1`<br>
&emsp; Refers to xinput1_1.dll (DirectX SDK)

`#XINPUT_VERSION_1_2`<br>
&emsp; Refers to xinput1_2.dll (DirectX SDK)

`#XINPUT_VERSION_1_3`<br>
&emsp; Refers to xinput1_3.dll (DirectX SDK)

`#XINPUT_VERSION_1_4`<br>
&emsp; Refers to XInput1_4.dll (Windows 8+)

`#XINPUT_VERSION_LATEST`<br>
&emsp; Refers to `#XINPUT_VERSION_1_4`

### XInput API
Please refer to [Microsoft's documentation](https://docs.microsoft.com/en-us/windows/win32/api/xinput/) for the standard XInput API functions, structures and constants.

## Supported controllers

### Tested
* XBox One X Controller (Wired) - (??? to 1.4+)

### Untested
* XBox One X Controller (Bluetooth)
* Xbox 360 Controller (Wired)
* Xbox 360 Controller (Wired via adapter)
* Logitech F310 Gamepad
* Logitech F710 Gamepad
* Sony Dualshock 3
* Sony Dualshock 4 (Wired via DS4Windows)
* Steam XInput (The thing in Big Picture Mode)

### Not working
* Bootleg Sony Dualshock 4 (Wired via default drivers, don't know where they come from) (self-reports as legit)
* ???
