    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    la sp, boot_stack_top

    # set stvec = _traps
    la t0, _traps
    csrw stvec, t0

    # set sie[STIE] = 1
    li t0, 32
    csrs sie, t0

    # set first time interrupt
    rdtime t0
    li t1, 10000000

    add a2, t0, t1

    li a0, 0
    li a1, 0
    li a3, 0
    li a4, 0
    li a5, 0
    li a6, 0
    li a7, 0

    call sbi_ecall

    # set sstatus[SIE] = 1
    csrs sstatus, 2


    call start_kernel

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096

    .globl boot_stack_top
boot_stack_top:
