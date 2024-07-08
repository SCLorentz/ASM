ARCH=arm64

# Assemble the source file
as -arch $ARCH -o ./ARM64/src/main.o ./ARM64/src/main.s

# Link the object file into the executable
ld -o ./.build/main-arm64 ./ARM64/src/main.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch $ARCH

echo "Assembly and linking completed!"