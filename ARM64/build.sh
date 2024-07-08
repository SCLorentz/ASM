#!/bin/bash

ARCH=arm64

# Assemble the source file
as -arch $ARCH -o ./src/main.o ./h/main.s

# Link the object file into the executable
ld -o compiled ./src/main.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch $ARCH

echo "Assembly and linking completed!"