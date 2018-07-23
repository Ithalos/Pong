#!/bin/bash
# An extremely primitive Pong build script for Windows x86 and x64.

eval $"zip -9 -r Pong.love . -x *.git/* /Builds/* build.sh"

eval $"cp Pong.love Builds/love-win32"
eval $"cp Pong.love Builds/love-win64"

rm Pong.love

eval $"cd Builds/love-win32"
eval $"cat love.exe Pong.love > Pong.exe"
eval $"zip -9 -r Pong_x86 Pong.exe *.dll license.txt"
eval $"mv Pong_x86.zip ../Windows/x86/"

rm Pong.love
rm Pong.exe
cd ../..

eval $"cd Builds/love-win64"
eval $"cat love.exe Pong.love > Pong.exe"
eval $"zip -9 -r Pong_x64 Pong.exe *.dll license.txt"
eval $"mv Pong_x64.zip ../Windows/x64/"

rm Pong.love
rm Pong.exe

