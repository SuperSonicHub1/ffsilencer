# FFsilencer

> Hack the silence out of your videos using Bash, FFmpeg and AWK!

## Usage
```
usage: ffsilencer IN OUT [THRESH] [DURATION]

Use FFmpeg to quickly remove the silent portions of any video.

positional arguments:
 IN          path to input file
 OUT         path to output file
optional arguments:
 THRESH      how loud the audio needs to be before it's cut out in dB (default: 50)
 DURATION    how long the silnece needs to be in order to be cut out (default: 1)
```

## Credits
Inspired by [carykh/jumpcutter](https://github.com/carykh/jumpcutter). We shouldn't need Python to do such a simple task!
Takes Bash code from ["Automatically trim silence from video with ffmpeg and python" by Donald Feury](https://blog.feurious.com/automatically-trim-silence-from-video-with-ffmpeg-and-python) and FFmpeg filter code from an answer to ["How can I remove multiple segments from a video using FFmpeg?" by shawnblais and Hashim Aziz](https://superuser.com/questions/681885/how-can-i-remove-multiple-segments-from-a-video-using-ffmpeg/1498811#1498811).

## License
```
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
```
