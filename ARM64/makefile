HelloWorld: main.o
	ld -o HelloWorld main.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64 

HelloWorld.o: main.s
	as -arch arm64 -o main.o main.s
