# [Documentation](readme.md) - Logger
<b>Location:</b> *[Framework/Logger.pbi](../Framework/Logger.pbi)*

<b>Status:</b> *Core component*

<b>Dependencies:</b> *Core components*<br>
<b>Dependants:</b> *Everything*

<b>Module namespace:</b> `Logger`

<b>Requirements:</b><br>
&emsp;<b>OS:</b> Any OS, or Windows for the silent console.

## Description
The logger module allows you to easily log stuff using different togglable levels of importance.

## Code

### Procedures
`Info(Message$).b`<br>
&emsp;Logs an informational message.

`Warning(Message$).b`<br>
&emsp;Logs a warning message.

`Error(Message$).b`<br>
&emsp;Logs an error message.

`Devel(Message$).b`<br>
&emsp;Logs a debugging message.

`Trace(Message$).b`<br>
&emsp;Logs a tracing message.

`EnableConsole().b`<br>
&emsp;Starts the console and returns non-zero if it worked.

`EnableHiddenConsole().b`<br>
&emsp;<b>Windows</b><br>
&emsp;&emsp;Starts writing message to `STD_OUTPUT_HANDLE`.<br>
&emsp;<b>Others</b><br>
&emsp;&emsp;Calls `EnableConsole()` for compaptibility reason.

`EnableTrace()`<br>
&emsp;Stop ignoring trace level messages.

### Custom constants

`#Separator$`<br>
&emsp; ???
