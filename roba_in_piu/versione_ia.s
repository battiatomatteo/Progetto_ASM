.section .data
filename: .ascii "./src/test.txt"
fd: .int 0
buffer: .string ""
newline: .byte 10
lines: .int 0
indice: .int 0
max_i: .int 0
cambiamenti: .int 0

.section .bss
vettore: .space 140
vettore_int: .space 200
vettore_2: .space 200

.section .text
.global readfile

readfile:
    call open_file
    jmp read_loop

open_file:
    mov $5, %eax
    mov $filename, %ebx
    mov $0, %ecx
    int $0x80
    cmp $0, %eax
    jle exit
    mov %eax, fd
    ret

read_loop:
    mov $3, %eax
    mov fd, %ebx
    mov $buffer, %ecx
    mov $1, %edx
    int $0x80
    cmp $0, %eax
    jle close_file
    movb buffer, %al
    cmpb newline, %al
    jne add_to_vector
    incl lines
    jmp read_loop

add_to_vector:
    movl indice, %ebx
    movb %al, vettore(%ebx)
    incl %ebx
    movl %ebx, indice
    jmp read_loop

close_file:
    mov $6, %eax
    mov fd, %ebx
    int $0x80
    jmp char_to_int

char_to_int:
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx
    leal vettore, %esi
    leal vettore_int, %edi
    movl $0, indice
    jmp convert_char_to_int

convert_char_to_int:
    cmpl %ecx, max_i
    jl in_calcolo
    movb (%esi), %bl
    incl %esi
    cmpb $10, %bl
    je fine_campo
    cmpb $44, %bl
    je fine_campo
    cmpb $47, %bl
    jg check
    jmp convert_char_to_int

fine_campo:
    incl %ecx
    movl %eax, (%edi)
    addl $4, %edi
    xorl %eax, %eax
    jmp convert_char_to_int

check:
    cmpb $57, %bl
    jle valore
    ; gestire errore

valore:
    subl $48, %ebx
    movl $10, %edx
    mul %edx
    addl %ebx, %eax
    incl %ecx
    jmp convert_char_to_int

in_calcolo:
    ; calcolo logic here
    movl $4, %ecx

in_calcolo_loop:
    cmpl %ecx, max_i
    jge exit
    leal vettore_int(%ecx, %ecx, 4), %ebx
    movl (%ebx), %eax
    leal vettore_int(%ecx, %ecx, 4), %ebx
    movl (%ebx), %ebx
    cmp %eax, %ebx
    jl insert_min
    leal vettore_int(%ecx, %ecx, 4), %ebx
    movl (%ebx), %ebx
    cmp %eax, %ebx
    jge continue

insert_min:
    leal vettore_2, %edx
    addl %ecx, %edx
    movl %eax, (%edx)
    
continue:
    incl %