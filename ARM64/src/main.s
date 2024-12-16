//
// Assembler program to print "Hello World!" to stdout and read user input
// to stdin.
//
// X0-X2 - parameters to Unix system calls
// X16 - Mach System Call function number
//
// AI assistence was used to write this program

.equ SYS_WRITE, 1
.equ SYS_READ, 0
.equ NEWLN, 10

.global _start                  		// Provide program starting address to linker
.align 4                        		// Make sure everything is aligned properly

.macro write str
    mov     X0, SYS_WRITE              	// 1 = StdOut --> sys_write
    adr     X1, \str            		// Load address of the string
    ldr     X2, =(\str\()_end - \str) 	// Calculate length of the string
    mov     X16, #4             		// Unix write system call
    svc     #0x80               		// Call kernel to output the string
.endm

.macro read buffer, size
    mov     X0, SYS_READ              	// 0 = stdin --> sys_read
    adr     X1, \buffer         		// Load address of the buffer
    mov     X2, \size           		// Number of bytes to read
    mov     X16, #3             		// Unix read system call
    svc     #0x80               		// Call kernel to read input
.endm

_start:
    write prompt                		// Write the prompt to the user
    read buffer, 100 					// Read input from the user

    write NEWLN               			// Write a newline
    //write buffer          			// Write the input back to the user

    mov     X0, #0              		// Use 0 return code
    mov     X16, #1             		// System call number 1 terminates this program
    svc     #0x80               		// Call kernel to terminate the program

.align 4
prompt:
    .ascii  "Enter something: "
prompt_end:

.align 4
buffer:
	.space 100       					// Create a 100 byte buffer
buffer_end: