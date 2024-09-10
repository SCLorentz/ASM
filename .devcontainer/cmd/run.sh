# It's not working on my computer, maybe because of the architecture of mine that is arm64 and not x86_64. 
# But I think that there are solutions

echo "O diretório atual é: $(pwd)"
echo "$(ls -a)"

nasm -f elf64 -o ./x86-64/src/func.o ./x86-64/src/func.asm
ld -o ./x86-64/src/func ./x86-64/src/func.o

./x86-64/src/func