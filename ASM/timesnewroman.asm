section .data
    message db 'ASMTARD', 0   ; Null-terminated string to print

section .text
    global _start

_start:
    ; Write the message to stdout (file descriptor 1)
    mov     rax, 1          ; syscall number for sys_write
    mov     rdi, 1          ; file descriptor 1 (stdout)
    mov     rsi, message    ; pointer to the message
    mov     rdx, 7          ; number of bytes to write (excluding the null terminator)
    syscall

    ; Exit the program
    mov     rax, 60         ; syscall number for sys_exit
    xor     rdi, rdi        ; exit status 0
    syscall

