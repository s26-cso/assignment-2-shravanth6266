.section .rodata
file_name:
    .string "input.txt"
mode:
    .string "r"
ispalindrome:
    .string "Yes\n"
isnotpalindrome:
    .string "No\n"

.global main
.section .text

main:
    lla a0, file_name
    lla a1, mode

    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp) # File Pointer
    sd s1, 24(sp) # Left Pointer
    sd s2, 16(sp) # Right Pointer
    sd s3, 8(sp) # Char at Left
    sd s4, 0(sp) # Char at Right

    call fopen

    mv s0, a0
    mv s1, x0

    li a1, 0
    li a2, 2
    call fseek # fseek(FILE* stream, int OFFSET, int SEEK_SET)

    mv a0, s0
    call ftell # Gives last byte in the file
    mv s2, a0
    addi s2, s2, -1


check:
    bge s1, s2, palindrome
    mv a0, s0
    mv a1, s1
    li a2, 0
    call fseek # Move cursor in File to Left
    mv a0, s0
    call fgetc # Get char at Left
    mv s3, a0 

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek # Move cursor in File to Right
    mv a0, s0
    call fgetc # Get char at Right
    mv s4, a0

    bne s3, s4, notpalindrome
    addi s1, s1, 1
    addi s2, s2, -1
    j check

palindrome:
    lla a0, ispalindrome
    call printf

    j exit

notpalindrome:
    lla a0, isnotpalindrome
    call printf

    j exit

exit:
    mv a0, s0
    call fclose

    ld s4, 0(sp)
    ld s3, 8(sp)
    ld s2, 16(sp)
    ld s1, 24(sp)
    ld s0, 32(sp)
    ld ra, 40(sp)
    addi sp, sp, 48

    ret
