.equ VAL, 0
.equ LEFT, 8
.equ RIGHT, 16
.equ SIZE, 24

.global make_node
.global insert
.global get
.global getAtMost

make_node:
    # a0 is val
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0
    # Storing val in s0 to prevent being overwritten by malloc

    li a0, SIZE
    call malloc

    sw s0, VAL(a0)
    sd x0, LEFT(a0)
    sd x0, RIGHT(a0)

    ld s0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    # a0 has pointer to Root, a1 has val
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    beq x0, s0, insert_basecase # Root == NULL

    lw t0, VAL(s0)

    bgt t0, s1, insert_lessthanroot # Branch if val < Root.val
    
    ld a0, RIGHT(s0) 
    mv a1, s1
    call insert

    sd a0, RIGHT(s0) # Passing on the new Node*

    j insert_end

insert_lessthanroot:
    ld a0, LEFT(s0)
    mv a1, s1
    call insert

    sd a0, LEFT(s0) # Passing on the new Node*

    j insert_end

insert_basecase:
    mv a0, s1
    call make_node

    j insert_exit

insert_end:
    mv a0, s0

insert_exit:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

get:
    # a0 has pointer to Root, a1 has val
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    beq s0, x0, get_notfound # Root == NULL

    lw t0, VAL(s0)
    beq t0, s1, get_found # Root.val == val

    bgt t0, s1, get_lessthanroot # Branch if Root.val > val
    
    ld a0, RIGHT(s0)
    mv a1, s1
    call get

    j get_exit

get_lessthanroot:
    ld a0, LEFT(s0)
    mv a1, s1
    call get

    j get_exit

get_found:
    mv a0, s0 # Returning pointer to the Node such that Node.val == val
    j get_exit

get_notfound:
    mv a0, x0 # Returning NULL

get_exit:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

getAtMost:
    # a0 has val, a1 has pointer to Root
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1, a1

    beq s1, x0, getAtMost_notfound # Root == NULL

    lw t0, VAL(s1)

    bgt t0, s0, getAtMost_lessthanroot # Branch if Root.val > val
    
    ld a1, RIGHT(s1)
    mv a0, s0
    call getAtMost

    li t1, -1
    bne a0, t1, getAtMost_exit # If recursive call returns a valid number then exit
    lw a0, VAL(s1) # Current Root is a possible answer

    j getAtMost_exit

getAtMost_lessthanroot:
    ld a1, LEFT(s1)
    mv a0, s0
    call getAtMost

    j getAtMost_exit

getAtMost_notfound:
    li a0, -1

getAtMost_exit:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret
