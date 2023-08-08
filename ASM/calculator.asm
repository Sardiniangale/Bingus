section .data
    prompt:     db "Enter the first number: ", 0
    op_prompt:  db "Enter the operator (+, -, *, /): ", 0
    result_fmt: db "Result: %lld", 10, 0   ; Format specifier for printf (long long)

section .bss
    num1 resq 1
    num2 resq 1
    result resq 1

section .text
global _start

_start:
    ; Print the first prompt and read the first number
    mov rdi, 0        ; File descriptor 0 (stdin)
    mov rsi, prompt
    call print_string
    call read_integer
    mov [num1], rax   ; Store the first number in the variable num1

    ; Print the operator prompt and read the operator
    mov rsi, op_prompt
    call print_string
    call read_operator
    mov rbx, rax      ; Store the operator in the variable rbx

    ; Print the second prompt and read the second number
    mov rsi, prompt
    call print_string
    call read_integer
    mov [num2], rax   ; Store the second number in the variable num2

    ; Perform the operation based on the operator
    cmp rbx, '+'
    je add_numbers

    cmp rbx, '-'
    je subtract_numbers

    cmp rbx, '*'
    je multiply_numbers

    cmp rbx, '/'
    je divide_numbers

    ; Invalid operator, print an error message and exit
    mov rsi, invalid_op_error
    call print_string
    jmp exit_program

add_numbers:
    mov rax, [num1]
    add rax, [num2]
    mov [result], rax
    jmp print_result

subtract_numbers:
    mov rax, [num1]
    sub rax, [num2]
    mov [result], rax
    jmp print_result

multiply_numbers:
    mov rax, [num1]
    imul rax, [num2]
    mov [result], rax
    jmp print_result

divide_numbers:
    mov rax, [num1]
    cqo               ; Sign-extend rax into rdx:rax (for 64-bit division)
    idiv qword [num2] ; Divide rdx:rax by num2, quotient stored in rax
    mov [result], rax
    jmp print_result

print_result:
    ; Print the result
    mov rsi, result_fmt
    mov rdi, [result]
    call printf

exit_program:
    ; Exit the program
    mov rax, 60      ; syscall number for sys_exit
    xor edi, edi     ; exit status 0
    syscall

print_string:
    ; Function to print a null-terminated string
    ; Input:
    ;   rsi: pointer to the string to be printed
    mov rax, 0x1     ; syscall number for sys_write
    mov rdi, 0x1     ; file descriptor 1 (stdout)
    mov rdx, -1      ; print until null terminator
    syscall
    ret

read_integer:
    ; Function to read an integer from the standard input
    ; Output:
    ;   rax: the read integer
    lea rdi, [buffer]    ; pointer to the buffer for reading
    lea rsi, [fmt_int]   ; pointer to the format specifier
    call scanf
    ret

read_operator:
    ; Function to read a single character (operator) from the standard input
    ; Output:
    ;   al: the read character (operator)
    lea rdi, [buffer]    ; pointer to the buffer for reading
    lea rsi, [fmt_char]  ; pointer to the format specifier for a single character
    call scanf
    ret

scanf:
    ; Function to read input from the standard input using scanf
    ; Input:
    ;   rdi: pointer to the buffer for reading
    ;   rsi: pointer to the format specifier
    mov rax, 0x0         ; syscall number for sys_read
    syscall
    ret

section .data
    buffer resb 32       ; Buffer for reading input
    fmt_int db "%lld", 0 ; Format specifier for reading an integer (long long)
    fmt_char db "%c", 0  ; Format specifier for reading a single character
    invalid_op_error db "Error: Invalid operator.", 10, 0

