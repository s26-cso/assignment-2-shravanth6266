.section .rodata
printing_format: .string "%lld "
newline: .string "%lld\n"

.global main

main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp) # argc
    sd s1, 40(sp) # Pointer to argv
    sd s2, 32(sp) # Loop counter
    sd s3, 24(sp) # Base Address of array
    sd s4, 16(sp) # Base Address of stack
    sd s5, 8(sp) # Address of top
    sd s6, 0(sp) # Base Address of result array

    mv s0, a0
    mv s1, a1
    li s2, 1

    addi a0, a0, -1
    slli a0, a0, 3
    call malloc

    mv s3, a0

parsing:
    bge s2, s0, parsing_done # Exit if i >= argc - 1
    slli t0, s2, 3
    add t1, s1, t0

    ld a0, 0(t1)
    call atoi

    # Store into array
    addi t0, s2, -1
    slli t0, t0, 3
    add t1, s3, t0
    sd a0, 0(t1)

    addi s2, s2, 1
    j parsing

parsing_done:
    # Allocating space for stack
    mv a0, s0
    addi a0, a0, -1
    slli a0, a0, 3
    call malloc
    mv s4, a0
    mv s5, a0

    # Allocating space for result
    mv a0, s0
    addi a0, a0, -1
    slli a0, a0, 3
    call malloc
    mv s6, a0

    mv s2, s0
    addi s2, s2, -2

loop1:
    blt s2, x0, print # Exit loop when i < 0

loop2:
    beq s4, s5, break # Break if stack is empty
    ld t0, -8(s5)
    slli t1, t0, 3
    add t1, t1, s3
    ld t0, 0(t1)

    slli t1, s2, 3
    add t1, t1, s3
    ld t2, 0(t1)

    bgt t0, t2, break # Break if arr[top_index] > arr[i]
    addi s5, s5, -8

    j loop2

break:
    beq s4, s5, empty_stack
    # If stack is not empty, result[i] = top_index
    ld t0, -8(s5)
    slli t1, s2, 3
    add t1, t1, s6
    sd t0, 0(t1)

    j push

empty_stack:
    # If stack is empty, result[i] = -1
    slli t0, s2, 3
    add t1, t0, s6
    li t2, -1
    sd t2, 0(t1)

push:
    # Push i onto the stack
    sd s2, 0(s5)
    addi s5, s5, 8

    addi s2, s2, -1

    j loop1

print:
    li s2, 0
    addi s0, s0, -2

printloop:
    bge s2, s0, exitprintloop

    slli t0, s2, 3
    add t1, s6, t0
    ld a1, 0(t1)

    lla a0, printing_format
    call printf

    addi s2, s2, 1
    j printloop

exitprintloop:
    slli t0, s2, 3
    add t1, s6, t0
    ld a1, 0(t1)

    lla a0, newline
    call printf

exit:
    li a0, 0
    ld s6, 0(sp)
    ld s5, 8(sp)
    ld s4, 16(sp)
    ld s3, 24(sp)
    ld s2, 32(sp)
    ld s1, 40(sp)
    ld s0, 48(sp)
    ld ra, 56(sp)
    addi sp, sp, 64

    ret
