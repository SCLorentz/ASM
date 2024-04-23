%macro sys_write 2
    mov rax, 1                  ; syscall for sys_write
    mov rdi, 1                  ; file descriptor 1: stdout
    mov rsi, %1                 ; pointer to the message
    mov rdx, %2                 ; length of the message
    syscall                     ; system call
%endmacro

; função sys_read para input
%macro sys_read 1
    mov rax, 0                  ; syscall for sys_read
    mov rdi, 0                  ; file descriptor 0: stdin
    mov rsi, %1                 ; pointer to the input buffer
    mov rdx, 255                ; maximum length to read
    syscall
    ; Remover o caractere de quebra de linha do final da string no buffer
    mov rdi, %1                 ; Ponteiro para o buffer
    call remove_newline 
%endmacro

%macro modfy 3
    mov rsi, %1                 ; Ponteiro para a string original
    add rsi, 0                  ; Avança para o ponto de inserção

    ; Deslocar os caracteres subsequentes para a direita
    mov rcx, %2                 ; Número de caracteres a serem deslocados
    mov rdi, rsi                ; Ponteiro para o próximo caractere
    rep movsb                   ; Desloca os caracteres

    ; Adicionar o novo caractere
    mov byte [rsi], %3          ; Adiciona o novo caractere no ponto de inserção
%endmacro

%macro is_negative 2
    ; Corrigir a necessidade de se usar um id
    mov rax, %1                 ; valor a ser comparado
    cmp rax, 0                  ; Comparar com 0 e verificar se num é negativo
    js _true_%2                 ; se num for negativo
    jmp _false_%2               ; Se não
    _true_%2:
        sys_write true, 5
        syscall
    _false_%2:
        sys_write false, 6
        syscall
%endmacro

%macro stringfy 3
    mov eax, [%1]               ; Carrega o número em eax
    lea edi, [%2]               ; Carrega o endereço da variável string_num em edi
    add edi, 10                 ; Aponta para o final da string

    convert_loop_%3:
        mov edx, 0              ; Limpa edx para a divisão
        mov ecx, 10             ; Define o divisor como 10
        div ecx                 ; Divide eax por 10, resultado em eax, resto em edx
        add dl, '0'             ; Converte o dígito em ASCII
        dec edi                 ; Move o ponteiro para a esquerda na string
        mov [edi], dl           ; Armazena o dígito na string
        test eax, eax           ; Verifica se ainda há dígitos
        jnz convert_loop_%3     ; Se sim, continua o loop
%endmacro

section .data
    ; string
    newline db 0x0A
    hello db "Hello World!", 0x0A
    true db "true", 0x0A        ; definindo true para futuros 'IFs'
    false db "false", 0x0A      ; definindo false para futuros 'IFs'
    num dd 5                    ; Define a variável minha_variavel como um valor inteiro de 32 bits com o valor 1
    buffer times 255 db 0

    ; stringfy
    num2 dd 10                  ; Número a ser transformado em string
    string_num db 10 DUP(0)

section .text
    global _start

_start:
    ; números
    mov eax, [num2]             ; Salvar o valor de num2 em eax
    add eax, [num]              ; eax + num
    mov [num2], eax             ; mudar o valor de num2 para o resultado da soma

    stringfy num2, string_num, 1; transformar em string
    sys_write string_num, 10    ; imprimir a string númerica
    sys_write newline, 1        ; pular uma linha

    ; is_negative ?
    is_negative 10, 1           ; 1° valor - número a ser verificado / 2° valor - ID da verificação
    is_negative -10, 2
    
    ; função sys_write
    sys_write hello, 13

    ; modificar caractere da string e imprimi-la
    modfy hello, 13, '>'
    sys_write hello, 14

    ; função sys_read
    sys_read buffer
    ; is_negative buffer, 3 <-- converter string em int
    sys_write buffer, 255

    ; Exit the program
    mov rax, 60                 ; syscall for sys_exit
    xor rdi, rdi                ; exit code 0
    ; int3
    syscall

remove_newline:
    xor rcx, rcx                ; Limpar rcx para contar
search_loop:
    mov al, byte [rdi + rcx]    ; Carregar o próximo byte da string
    cmp al, 0x0A                ; Verificar se é o caractere de quebra de linha
    je replace_newline          ; Se for, substituir por 0x00
    inc rcx                     ; Incrementar o contador
    cmp al, 0                   ; Verificar se chegou ao final da string
    jne search_loop             ; Se não, continuar a busca
    ret
replace_newline:
    mov byte [rdi + rcx], 0     ; Substituir o caractere de quebra de linha por 0x00
    ret