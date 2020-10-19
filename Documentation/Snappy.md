# [Documentation](readme.md) - Snappy
<b>Location:</b> *[Framework/Snappy/Snappy.pbi](/Framework/Snappy/Snappy.pbi)*<br>
<b>Status:</b> *Optional component*<br>

<b>Dependencies:</b> *None*<br>
<b>Dependants:</b> *None*

<b>Compile flags:</b><br>
&emsp;`#FRAMEWORK_MODULE_SNAPPY = <#False|#True>`<br>
&emsp;`%FRAMEWORK_MODULE_SNAPPY% = <0|1>`</b>

<b>Module namespace:</b> `Snappy`

<b>Requirements:</b><br>
&emsp;<b>OS:</b> Windows.

## Description
The snappy *component* gives you access to all the functions contained in the Snappy library.

The component is included in the *[Framework](Framework.md)* and is immediatly usable.

## Code

### Constants

`#SNAPPY_OK`<br>
&emsp;Returned when the functions worked correctly.

`#SNAPPY_INVALID_INPUT`<br>
&emsp;Returned when the functions were given an invalid input.

`#SNAPPY_BUFFER_TOO_SMALL`<br>
&emsp;Returned when a given buffer is too small.


### Functions

`snappy_compress.b(*input, input_length.i, *compressed, *compressed_length)`<br>
&emsp;Compresses the `*input` buffer of `input_length.i` length,<br>
&emsp;&nbsp;&nbsp;and puts it into the `*compressed` buffer of `compressed_length.i` length.<br>
&emsp;Returns one of the constants seen above.

`snappy_uncompress.b(*compressed, compressed_length.i, *uncompressed, uncompressed_length.i)`<br>
&emsp;Uncompresses the `*compressed` buffer of `compressed_length.i` length,<br>
&emsp;&nbsp;&nbsp;and puts it into the `*uncompressed` buffer of `uncompressed_length.i` length.<br>
&emsp;Returns one of the constants seen above.

`snappy_max_compressed_length.i(source_length.i)`<br>
&emsp;

`snappy_uncompressed_length.b(*compressed, compressed_length.i, *result)`<br>
&emsp;

`snappy_validate_compressed_buffer.b(*compressed, compressed_length.i)`<br>
&emsp;

## License

[TODO]
