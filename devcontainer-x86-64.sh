nasm -f elf64 -o /x86-64/src/func.o /x86-54/src/func.asm
ld -o /build/func /x86-64/src/func.o

./func