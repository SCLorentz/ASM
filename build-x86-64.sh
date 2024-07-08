# testar no linux dps para ver se está funcionando
#nasm -f elf64 -o ./x86-64/src/func.o ./x86-64/src/func.asm
#ld -o ./.build/func ./x86-64/src/func.o

ARCH=x86_64

# Assemble the source file
as -arch $ARCH -o ./x86-64/src/func.o ./x86-64/src/func.asm

# Link the object file into the executable
ld -o ./.build/main-x86-64 ./x86-64/src/func.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch $ARCH

echo "Assembly and linking completed!"

echo "\nrunning script:"

./.build/main-x86-64