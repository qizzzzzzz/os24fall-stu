
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_skernel>:
    .extern mm_init
    .extern task_init
    .section .text.init
    .globl _start
_start:
    la sp, boot_stack_top
    80200000:	00003117          	auipc	sp,0x3
    80200004:	02013103          	ld	sp,32(sp) # 80203020 <_GLOBAL_OFFSET_TABLE_+0x18>

    call mm_init
    80200008:	3c8000ef          	jal	ra,802003d0 <mm_init>

    call task_init
    8020000c:	408000ef          	jal	ra,80200414 <task_init>

    # set stvec = _traps
    la t0, _traps
    80200010:	00003297          	auipc	t0,0x3
    80200014:	0202b283          	ld	t0,32(t0) # 80203030 <_GLOBAL_OFFSET_TABLE_+0x28>
    csrw stvec, t0
    80200018:	10529073          	csrw	stvec,t0

    # set sie[STIE] = 1
    li t0, 32
    8020001c:	02000293          	li	t0,32
    csrs sie, t0
    80200020:	1042a073          	csrs	sie,t0

    # set first time interrupt
    rdtime t0
    80200024:	c01022f3          	rdtime	t0
    li t1, 30000000
    80200028:	01c9c337          	lui	t1,0x1c9c
    8020002c:	3803031b          	addiw	t1,t1,896 # 1c9c380 <_skernel-0x7e563c80>

    add a2, t0, t1
    80200030:	00628633          	add	a2,t0,t1

    li a0, 0
    80200034:	00000513          	li	a0,0
    li a1, 0
    80200038:	00000593          	li	a1,0
    li a3, 0
    8020003c:	00000693          	li	a3,0
    li a4, 0
    80200040:	00000713          	li	a4,0
    li a5, 0
    80200044:	00000793          	li	a5,0
    li a6, 0
    80200048:	00000813          	li	a6,0
    li a7, 0
    8020004c:	00000893          	li	a7,0

    call sbi_ecall
    80200050:	2fd000ef          	jal	ra,80200b4c <sbi_ecall>

    # set sstatus[SIE] = 1
    csrs sstatus, 2
    80200054:	10016073          	csrsi	sstatus,2

    call start_kernel
    80200058:	60d000ef          	jal	ra,80200e64 <start_kernel>

000000008020005c <_traps>:
    .section .text.entry
    .align 2
    .globl _traps
_traps:
    # 1. save 32 registers and sepc to stack
    addi sp, sp, -264 # 8*33
    8020005c:	ef810113          	addi	sp,sp,-264

    sd x0, 0(sp)
    80200060:	00013023          	sd	zero,0(sp)
    sd x1, 8(sp)
    80200064:	00113423          	sd	ra,8(sp)
    sd x2, 16(sp)
    80200068:	00213823          	sd	sp,16(sp)
    sd x3, 24(sp)
    8020006c:	00313c23          	sd	gp,24(sp)
    sd x4, 32(sp)
    80200070:	02413023          	sd	tp,32(sp)
    sd x5, 40(sp)
    80200074:	02513423          	sd	t0,40(sp)
    sd x6, 48(sp)
    80200078:	02613823          	sd	t1,48(sp)
    sd x7, 56(sp)
    8020007c:	02713c23          	sd	t2,56(sp)
    sd x8, 64(sp)
    80200080:	04813023          	sd	s0,64(sp)
    sd x9, 72(sp)
    80200084:	04913423          	sd	s1,72(sp)
    sd x10, 80(sp)
    80200088:	04a13823          	sd	a0,80(sp)
    sd x11, 88(sp)
    8020008c:	04b13c23          	sd	a1,88(sp)
    sd x12, 96(sp)
    80200090:	06c13023          	sd	a2,96(sp)
    sd x13, 104(sp)
    80200094:	06d13423          	sd	a3,104(sp)
    sd x14, 112(sp)
    80200098:	06e13823          	sd	a4,112(sp)
    sd x15, 120(sp)
    8020009c:	06f13c23          	sd	a5,120(sp)
    sd x16, 128(sp)
    802000a0:	09013023          	sd	a6,128(sp)
    sd x17, 136(sp)
    802000a4:	09113423          	sd	a7,136(sp)
    sd x18, 144(sp)
    802000a8:	09213823          	sd	s2,144(sp)
    sd x19, 152(sp)
    802000ac:	09313c23          	sd	s3,152(sp)
    sd x20, 160(sp)
    802000b0:	0b413023          	sd	s4,160(sp)
    sd x21, 168(sp)
    802000b4:	0b513423          	sd	s5,168(sp)
    sd x22, 176(sp)
    802000b8:	0b613823          	sd	s6,176(sp)
    sd x23, 184(sp)
    802000bc:	0b713c23          	sd	s7,184(sp)
    sd x24, 192(sp)
    802000c0:	0d813023          	sd	s8,192(sp)
    sd x25, 200(sp)
    802000c4:	0d913423          	sd	s9,200(sp)
    sd x26, 208(sp)
    802000c8:	0da13823          	sd	s10,208(sp)
    sd x27, 216(sp)
    802000cc:	0db13c23          	sd	s11,216(sp)
    sd x28, 224(sp)
    802000d0:	0fc13023          	sd	t3,224(sp)
    sd x29, 232(sp)
    802000d4:	0fd13423          	sd	t4,232(sp)
    sd x30, 240(sp)
    802000d8:	0fe13823          	sd	t5,240(sp)
    sd x31, 248(sp)
    802000dc:	0ff13c23          	sd	t6,248(sp)

    csrr t0, sepc
    802000e0:	141022f3          	csrr	t0,sepc
    sd t0, 256(sp)
    802000e4:	10513023          	sd	t0,256(sp)

    # 2. call trap_handler
    csrr a0, scause
    802000e8:	14202573          	csrr	a0,scause
    csrr a1, sepc
    802000ec:	141025f3          	csrr	a1,sepc
    call trap_handler
    802000f0:	4e9000ef          	jal	ra,80200dd8 <trap_handler>

    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld x0, 0(sp)
    802000f4:	00013003          	ld	zero,0(sp)
    ld x1, 8(sp)
    802000f8:	00813083          	ld	ra,8(sp)
    ld x2, 16(sp)
    802000fc:	01013103          	ld	sp,16(sp)
    ld x3, 24(sp)
    80200100:	01813183          	ld	gp,24(sp)
    ld x4, 32(sp)
    80200104:	02013203          	ld	tp,32(sp)
    ld x5, 40(sp)
    80200108:	02813283          	ld	t0,40(sp)
    ld x6, 48(sp)
    8020010c:	03013303          	ld	t1,48(sp)
    ld x7, 56(sp)
    80200110:	03813383          	ld	t2,56(sp)
    ld x8, 64(sp)
    80200114:	04013403          	ld	s0,64(sp)
    ld x9, 72(sp)
    80200118:	04813483          	ld	s1,72(sp)
    ld x10, 80(sp)
    8020011c:	05013503          	ld	a0,80(sp)
    ld x11, 88(sp)
    80200120:	05813583          	ld	a1,88(sp)
    ld x12, 96(sp)
    80200124:	06013603          	ld	a2,96(sp)
    ld x13, 104(sp)
    80200128:	06813683          	ld	a3,104(sp)
    ld x14, 112(sp)
    8020012c:	07013703          	ld	a4,112(sp)
    ld x15, 120(sp)
    80200130:	07813783          	ld	a5,120(sp)
    ld x16, 128(sp)
    80200134:	08013803          	ld	a6,128(sp)
    ld x17, 136(sp)
    80200138:	08813883          	ld	a7,136(sp)
    ld x18, 144(sp)
    8020013c:	09013903          	ld	s2,144(sp)
    ld x19, 152(sp)
    80200140:	09813983          	ld	s3,152(sp)
    ld x20, 160(sp)
    80200144:	0a013a03          	ld	s4,160(sp)
    ld x21, 168(sp)
    80200148:	0a813a83          	ld	s5,168(sp)
    ld x22, 176(sp)
    8020014c:	0b013b03          	ld	s6,176(sp)
    ld x23, 184(sp)
    80200150:	0b813b83          	ld	s7,184(sp)
    ld x24, 192(sp)
    80200154:	0c013c03          	ld	s8,192(sp)
    ld x25, 200(sp)
    80200158:	0c813c83          	ld	s9,200(sp)
    ld x26, 208(sp)
    8020015c:	0d013d03          	ld	s10,208(sp)
    ld x27, 216(sp)
    80200160:	0d813d83          	ld	s11,216(sp)
    ld x28, 224(sp)
    80200164:	0e013e03          	ld	t3,224(sp)
    ld x29, 232(sp)
    80200168:	0e813e83          	ld	t4,232(sp)
    ld x30, 240(sp)
    8020016c:	0f013f03          	ld	t5,240(sp)
    ld x31, 248(sp)
    80200170:	0f813f83          	ld	t6,248(sp)

    ld t0, 256(sp)
    80200174:	10013283          	ld	t0,256(sp)
    csrw sepc, t0
    80200178:	14129073          	csrw	sepc,t0

    addi sp, sp, 264
    8020017c:	10810113          	addi	sp,sp,264

    # 4. return from trap
    sret
    80200180:	10200073          	sret

0000000080200184 <__dummy>:

    .extern dummy
    .globl __dummy
__dummy:
    # 在 __dummy 中将 sepc 设置为 dummy() 的地址，并使用 sret 从 S 模式中返回
    la t0, dummy
    80200184:	00003297          	auipc	t0,0x3
    80200188:	ea42b283          	ld	t0,-348(t0) # 80203028 <_GLOBAL_OFFSET_TABLE_+0x20>
    csrw sepc, t0
    8020018c:	14129073          	csrw	sepc,t0
    sret
    80200190:	10200073          	sret

0000000080200194 <__switch_to>:
    # a1: next
    # 保存当前线程的 ra，sp，s0~s11 到当前线程的 thread_struct 中
    # thread_struct 前有4个8位的数据，所以偏移量起始为32

    # save state to prev process
    sd ra, 32(a0)
    80200194:	02153023          	sd	ra,32(a0)
    sd sp, 40(a0)
    80200198:	02253423          	sd	sp,40(a0)
    sd s0, 48(a0)
    8020019c:	02853823          	sd	s0,48(a0)
    sd s1, 56(a0)
    802001a0:	02953c23          	sd	s1,56(a0)
    sd s2, 64(a0)
    802001a4:	05253023          	sd	s2,64(a0)
    sd s3, 72(a0)
    802001a8:	05353423          	sd	s3,72(a0)
    sd s4, 80(a0)
    802001ac:	05453823          	sd	s4,80(a0)
    sd s5, 88(a0)
    802001b0:	05553c23          	sd	s5,88(a0)
    sd s6, 96(a0)
    802001b4:	07653023          	sd	s6,96(a0)
    sd s7, 104(a0)
    802001b8:	07753423          	sd	s7,104(a0)
    sd s8, 112(a0)
    802001bc:	07853823          	sd	s8,112(a0)
    sd s9, 120(a0)
    802001c0:	07953c23          	sd	s9,120(a0)
    sd s10, 128(a0)
    802001c4:	09a53023          	sd	s10,128(a0)
    sd s11, 136(a0)
    802001c8:	09b53423          	sd	s11,136(a0)

    # restore state from next process
    ld ra, 32(a1)
    802001cc:	0205b083          	ld	ra,32(a1)
    ld sp, 40(a1)
    802001d0:	0285b103          	ld	sp,40(a1)
    ld s0, 48(a1)
    802001d4:	0305b403          	ld	s0,48(a1)
    ld s1, 56(a1)
    802001d8:	0385b483          	ld	s1,56(a1)
    ld s2, 64(a1)
    802001dc:	0405b903          	ld	s2,64(a1)
    ld s3, 72(a1)
    802001e0:	0485b983          	ld	s3,72(a1)
    ld s4, 80(a1)
    802001e4:	0505ba03          	ld	s4,80(a1)
    ld s5, 88(a1)
    802001e8:	0585ba83          	ld	s5,88(a1)
    ld s6, 96(a1)
    802001ec:	0605bb03          	ld	s6,96(a1)
    ld s7, 104(a1)
    802001f0:	0685bb83          	ld	s7,104(a1)
    ld s8, 112(a1)
    802001f4:	0705bc03          	ld	s8,112(a1)
    ld s9, 120(a1)
    802001f8:	0785bc83          	ld	s9,120(a1)
    ld s10, 128(a1)
    802001fc:	0805bd03          	ld	s10,128(a1)
    ld s11, 136(a1)
    80200200:	0885bd83          	ld	s11,136(a1)

    80200204:	00008067          	ret

0000000080200208 <get_cycles>:
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
    80200208:	fe010113          	addi	sp,sp,-32
    8020020c:	00813c23          	sd	s0,24(sp)
    80200210:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t res;
    __asm__ volatile (
    80200214:	c01027f3          	rdtime	a5
    80200218:	fef43423          	sd	a5,-24(s0)
        "rdtime %0\n"
        :"=r"(res)
        :
        :
    );
    return res;
    8020021c:	fe843783          	ld	a5,-24(s0)
}
    80200220:	00078513          	mv	a0,a5
    80200224:	01813403          	ld	s0,24(sp)
    80200228:	02010113          	addi	sp,sp,32
    8020022c:	00008067          	ret

0000000080200230 <clock_set_next_event>:

void clock_set_next_event() {
    80200230:	fe010113          	addi	sp,sp,-32
    80200234:	00113c23          	sd	ra,24(sp)
    80200238:	00813823          	sd	s0,16(sp)
    8020023c:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
    80200240:	fc9ff0ef          	jal	ra,80200208 <get_cycles>
    80200244:	00050713          	mv	a4,a0
    80200248:	00003797          	auipc	a5,0x3
    8020024c:	db878793          	addi	a5,a5,-584 # 80203000 <TIMECLOCK>
    80200250:	0007b783          	ld	a5,0(a5)
    80200254:	00f707b3          	add	a5,a4,a5
    80200258:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
    8020025c:	fe843503          	ld	a0,-24(s0)
    80200260:	2ed000ef          	jal	ra,80200d4c <sbi_set_timer>

    return;
    80200264:	00000013          	nop
    80200268:	01813083          	ld	ra,24(sp)
    8020026c:	01013403          	ld	s0,16(sp)
    80200270:	02010113          	addi	sp,sp,32
    80200274:	00008067          	ret

0000000080200278 <kalloc>:

struct {
    struct run *freelist;
} kmem;

void *kalloc() {
    80200278:	fe010113          	addi	sp,sp,-32
    8020027c:	00113c23          	sd	ra,24(sp)
    80200280:	00813823          	sd	s0,16(sp)
    80200284:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
    80200288:	00005797          	auipc	a5,0x5
    8020028c:	d7878793          	addi	a5,a5,-648 # 80205000 <kmem>
    80200290:	0007b783          	ld	a5,0(a5)
    80200294:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
    80200298:	fe843783          	ld	a5,-24(s0)
    8020029c:	0007b703          	ld	a4,0(a5)
    802002a0:	00005797          	auipc	a5,0x5
    802002a4:	d6078793          	addi	a5,a5,-672 # 80205000 <kmem>
    802002a8:	00e7b023          	sd	a4,0(a5)
    
    memset((void *)r, 0x0, PGSIZE);
    802002ac:	00001637          	lui	a2,0x1
    802002b0:	00000593          	li	a1,0
    802002b4:	fe843503          	ld	a0,-24(s0)
    802002b8:	459010ef          	jal	ra,80201f10 <memset>
    return (void *)r;
    802002bc:	fe843783          	ld	a5,-24(s0)
}
    802002c0:	00078513          	mv	a0,a5
    802002c4:	01813083          	ld	ra,24(sp)
    802002c8:	01013403          	ld	s0,16(sp)
    802002cc:	02010113          	addi	sp,sp,32
    802002d0:	00008067          	ret

00000000802002d4 <kfree>:

void kfree(void *addr) {
    802002d4:	fd010113          	addi	sp,sp,-48
    802002d8:	02113423          	sd	ra,40(sp)
    802002dc:	02813023          	sd	s0,32(sp)
    802002e0:	03010413          	addi	s0,sp,48
    802002e4:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    *(uintptr_t *)&addr = (uintptr_t)addr & ~(PGSIZE - 1);
    802002e8:	fd843783          	ld	a5,-40(s0)
    802002ec:	00078693          	mv	a3,a5
    802002f0:	fd840793          	addi	a5,s0,-40
    802002f4:	fffff737          	lui	a4,0xfffff
    802002f8:	00e6f733          	and	a4,a3,a4
    802002fc:	00e7b023          	sd	a4,0(a5)

    memset(addr, 0x0, (uint64_t)PGSIZE);
    80200300:	fd843783          	ld	a5,-40(s0)
    80200304:	00001637          	lui	a2,0x1
    80200308:	00000593          	li	a1,0
    8020030c:	00078513          	mv	a0,a5
    80200310:	401010ef          	jal	ra,80201f10 <memset>

    r = (struct run *)addr;
    80200314:	fd843783          	ld	a5,-40(s0)
    80200318:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
    8020031c:	00005797          	auipc	a5,0x5
    80200320:	ce478793          	addi	a5,a5,-796 # 80205000 <kmem>
    80200324:	0007b703          	ld	a4,0(a5)
    80200328:	fe843783          	ld	a5,-24(s0)
    8020032c:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
    80200330:	00005797          	auipc	a5,0x5
    80200334:	cd078793          	addi	a5,a5,-816 # 80205000 <kmem>
    80200338:	fe843703          	ld	a4,-24(s0)
    8020033c:	00e7b023          	sd	a4,0(a5)

    return;
    80200340:	00000013          	nop
}
    80200344:	02813083          	ld	ra,40(sp)
    80200348:	02013403          	ld	s0,32(sp)
    8020034c:	03010113          	addi	sp,sp,48
    80200350:	00008067          	ret

0000000080200354 <kfreerange>:

void kfreerange(char *start, char *end) {
    80200354:	fd010113          	addi	sp,sp,-48
    80200358:	02113423          	sd	ra,40(sp)
    8020035c:	02813023          	sd	s0,32(sp)
    80200360:	03010413          	addi	s0,sp,48
    80200364:	fca43c23          	sd	a0,-40(s0)
    80200368:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
    8020036c:	fd843703          	ld	a4,-40(s0)
    80200370:	000017b7          	lui	a5,0x1
    80200374:	fff78793          	addi	a5,a5,-1 # fff <_skernel-0x801ff001>
    80200378:	00f70733          	add	a4,a4,a5
    8020037c:	fffff7b7          	lui	a5,0xfffff
    80200380:	00f777b3          	and	a5,a4,a5
    80200384:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    80200388:	01c0006f          	j	802003a4 <kfreerange+0x50>
        kfree((void *)addr);
    8020038c:	fe843503          	ld	a0,-24(s0)
    80200390:	f45ff0ef          	jal	ra,802002d4 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    80200394:	fe843703          	ld	a4,-24(s0)
    80200398:	000017b7          	lui	a5,0x1
    8020039c:	00f707b3          	add	a5,a4,a5
    802003a0:	fef43423          	sd	a5,-24(s0)
    802003a4:	fe843703          	ld	a4,-24(s0)
    802003a8:	000017b7          	lui	a5,0x1
    802003ac:	00f70733          	add	a4,a4,a5
    802003b0:	fd043783          	ld	a5,-48(s0)
    802003b4:	fce7fce3          	bgeu	a5,a4,8020038c <kfreerange+0x38>
    }
}
    802003b8:	00000013          	nop
    802003bc:	00000013          	nop
    802003c0:	02813083          	ld	ra,40(sp)
    802003c4:	02013403          	ld	s0,32(sp)
    802003c8:	03010113          	addi	sp,sp,48
    802003cc:	00008067          	ret

00000000802003d0 <mm_init>:

void mm_init(void) {
    802003d0:	ff010113          	addi	sp,sp,-16
    802003d4:	00113423          	sd	ra,8(sp)
    802003d8:	00813023          	sd	s0,0(sp)
    802003dc:	01010413          	addi	s0,sp,16
    kfreerange(_ekernel, (char *)PHY_END);
    802003e0:	01100793          	li	a5,17
    802003e4:	01b79593          	slli	a1,a5,0x1b
    802003e8:	00003517          	auipc	a0,0x3
    802003ec:	c2853503          	ld	a0,-984(a0) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>
    802003f0:	f65ff0ef          	jal	ra,80200354 <kfreerange>
    printk("...mm_init done!\n");
    802003f4:	00002517          	auipc	a0,0x2
    802003f8:	c0c50513          	addi	a0,a0,-1012 # 80202000 <_srodata>
    802003fc:	1f5010ef          	jal	ra,80201df0 <printk>
}
    80200400:	00000013          	nop
    80200404:	00813083          	ld	ra,8(sp)
    80200408:	00013403          	ld	s0,0(sp)
    8020040c:	01010113          	addi	sp,sp,16
    80200410:	00008067          	ret

0000000080200414 <task_init>:

struct task_struct *idle;          // idle process
struct task_struct *current;       // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS];// 线程数组，所有的线程都保存在此

void task_init() {
    80200414:	fe010113          	addi	sp,sp,-32
    80200418:	00113c23          	sd	ra,24(sp)
    8020041c:	00813823          	sd	s0,16(sp)
    80200420:	02010413          	addi	s0,sp,32
    srand(2024);
    80200424:	7e800513          	li	a0,2024
    80200428:	249010ef          	jal	ra,80201e70 <srand>
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    idle = (struct task_struct*) kalloc();
    8020042c:	e4dff0ef          	jal	ra,80200278 <kalloc>
    80200430:	00050713          	mv	a4,a0
    80200434:	00005797          	auipc	a5,0x5
    80200438:	bd478793          	addi	a5,a5,-1068 # 80205008 <idle>
    8020043c:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
    80200440:	00005797          	auipc	a5,0x5
    80200444:	bc878793          	addi	a5,a5,-1080 # 80205008 <idle>
    80200448:	0007b783          	ld	a5,0(a5)
    8020044c:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
    80200450:	00005797          	auipc	a5,0x5
    80200454:	bb878793          	addi	a5,a5,-1096 # 80205008 <idle>
    80200458:	0007b783          	ld	a5,0(a5)
    8020045c:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
    80200460:	00005797          	auipc	a5,0x5
    80200464:	ba878793          	addi	a5,a5,-1112 # 80205008 <idle>
    80200468:	0007b783          	ld	a5,0(a5)
    8020046c:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
    80200470:	00005797          	auipc	a5,0x5
    80200474:	b9878793          	addi	a5,a5,-1128 # 80205008 <idle>
    80200478:	0007b783          	ld	a5,0(a5)
    8020047c:	0007bc23          	sd	zero,24(a5)
    current = idle;
    80200480:	00005797          	auipc	a5,0x5
    80200484:	b8878793          	addi	a5,a5,-1144 # 80205008 <idle>
    80200488:	0007b703          	ld	a4,0(a5)
    8020048c:	00005797          	auipc	a5,0x5
    80200490:	b8478793          	addi	a5,a5,-1148 # 80205010 <current>
    80200494:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
    80200498:	00005797          	auipc	a5,0x5
    8020049c:	b7078793          	addi	a5,a5,-1168 # 80205008 <idle>
    802004a0:	0007b703          	ld	a4,0(a5)
    802004a4:	00005797          	auipc	a5,0x5
    802004a8:	b7478793          	addi	a5,a5,-1164 # 80205018 <task>
    802004ac:	00e7b023          	sd	a4,0(a5)
    printk("\nINIT [PID = %d PRIORITY = %d COUNTER = %d]\n", idle->pid, idle->priority, idle->counter);
    802004b0:	00005797          	auipc	a5,0x5
    802004b4:	b5878793          	addi	a5,a5,-1192 # 80205008 <idle>
    802004b8:	0007b783          	ld	a5,0(a5)
    802004bc:	0187b703          	ld	a4,24(a5)
    802004c0:	00005797          	auipc	a5,0x5
    802004c4:	b4878793          	addi	a5,a5,-1208 # 80205008 <idle>
    802004c8:	0007b783          	ld	a5,0(a5)
    802004cc:	0107b603          	ld	a2,16(a5)
    802004d0:	00005797          	auipc	a5,0x5
    802004d4:	b3878793          	addi	a5,a5,-1224 # 80205008 <idle>
    802004d8:	0007b783          	ld	a5,0(a5)
    802004dc:	0087b783          	ld	a5,8(a5)
    802004e0:	00078693          	mv	a3,a5
    802004e4:	00070593          	mv	a1,a4
    802004e8:	00002517          	auipc	a0,0x2
    802004ec:	b3050513          	addi	a0,a0,-1232 # 80202018 <_srodata+0x18>
    802004f0:	101010ef          	jal	ra,80201df0 <printk>
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    for (uint64_t i = 1; i < NR_TASKS; i++) {
    802004f4:	00100793          	li	a5,1
    802004f8:	fef43423          	sd	a5,-24(s0)
    802004fc:	1900006f          	j	8020068c <task_init+0x278>
        task[i] = (struct task_struct *) kalloc();
    80200500:	d79ff0ef          	jal	ra,80200278 <kalloc>
    80200504:	00050693          	mv	a3,a0
    80200508:	00005717          	auipc	a4,0x5
    8020050c:	b1070713          	addi	a4,a4,-1264 # 80205018 <task>
    80200510:	fe843783          	ld	a5,-24(s0)
    80200514:	00379793          	slli	a5,a5,0x3
    80200518:	00f707b3          	add	a5,a4,a5
    8020051c:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
    80200520:	00005717          	auipc	a4,0x5
    80200524:	af870713          	addi	a4,a4,-1288 # 80205018 <task>
    80200528:	fe843783          	ld	a5,-24(s0)
    8020052c:	00379793          	slli	a5,a5,0x3
    80200530:	00f707b3          	add	a5,a4,a5
    80200534:	0007b783          	ld	a5,0(a5)
    80200538:	0007b023          	sd	zero,0(a5)
        task[i]->counter = 0;
    8020053c:	00005717          	auipc	a4,0x5
    80200540:	adc70713          	addi	a4,a4,-1316 # 80205018 <task>
    80200544:	fe843783          	ld	a5,-24(s0)
    80200548:	00379793          	slli	a5,a5,0x3
    8020054c:	00f707b3          	add	a5,a4,a5
    80200550:	0007b783          	ld	a5,0(a5)
    80200554:	0007b423          	sd	zero,8(a5)
        task[i]->pid = i;
    80200558:	00005717          	auipc	a4,0x5
    8020055c:	ac070713          	addi	a4,a4,-1344 # 80205018 <task>
    80200560:	fe843783          	ld	a5,-24(s0)
    80200564:	00379793          	slli	a5,a5,0x3
    80200568:	00f707b3          	add	a5,a4,a5
    8020056c:	0007b783          	ld	a5,0(a5)
    80200570:	fe843703          	ld	a4,-24(s0)
    80200574:	00e7bc23          	sd	a4,24(a5)
        task[i]->priority = rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;// 随机数在[PRIORITY_MIN, PRIORITY_MAX] 之间
    80200578:	13d010ef          	jal	ra,80201eb4 <rand>
    8020057c:	00050793          	mv	a5,a0
    80200580:	00078713          	mv	a4,a5
    80200584:	00a00793          	li	a5,10
    80200588:	02f767bb          	remw	a5,a4,a5
    8020058c:	0007879b          	sext.w	a5,a5
    80200590:	0017879b          	addiw	a5,a5,1
    80200594:	0007869b          	sext.w	a3,a5
    80200598:	00005717          	auipc	a4,0x5
    8020059c:	a8070713          	addi	a4,a4,-1408 # 80205018 <task>
    802005a0:	fe843783          	ld	a5,-24(s0)
    802005a4:	00379793          	slli	a5,a5,0x3
    802005a8:	00f707b3          	add	a5,a4,a5
    802005ac:	0007b783          	ld	a5,0(a5)
    802005b0:	00068713          	mv	a4,a3
    802005b4:	00e7b823          	sd	a4,16(a5)
        task[i]->thread.ra = (uint64_t) (uintptr_t) __dummy;                          // (uint64_t)(uintptr_t)双重转换确保安全
    802005b8:	00005717          	auipc	a4,0x5
    802005bc:	a6070713          	addi	a4,a4,-1440 # 80205018 <task>
    802005c0:	fe843783          	ld	a5,-24(s0)
    802005c4:	00379793          	slli	a5,a5,0x3
    802005c8:	00f707b3          	add	a5,a4,a5
    802005cc:	0007b783          	ld	a5,0(a5)
    802005d0:	00003717          	auipc	a4,0x3
    802005d4:	a4873703          	ld	a4,-1464(a4) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    802005d8:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t) (uintptr_t) task[i] + PGSIZE;                 // 比task[i]本身指针高PGSIZE位
    802005dc:	00005717          	auipc	a4,0x5
    802005e0:	a3c70713          	addi	a4,a4,-1476 # 80205018 <task>
    802005e4:	fe843783          	ld	a5,-24(s0)
    802005e8:	00379793          	slli	a5,a5,0x3
    802005ec:	00f707b3          	add	a5,a4,a5
    802005f0:	0007b783          	ld	a5,0(a5)
    802005f4:	00078693          	mv	a3,a5
    802005f8:	00005717          	auipc	a4,0x5
    802005fc:	a2070713          	addi	a4,a4,-1504 # 80205018 <task>
    80200600:	fe843783          	ld	a5,-24(s0)
    80200604:	00379793          	slli	a5,a5,0x3
    80200608:	00f707b3          	add	a5,a4,a5
    8020060c:	0007b783          	ld	a5,0(a5)
    80200610:	00001737          	lui	a4,0x1
    80200614:	00e68733          	add	a4,a3,a4
    80200618:	02e7b423          	sd	a4,40(a5)
        printk("INIT [PID = %d PRIORITY = %d COUNTER = %d]\n", task[i]->pid, task[i]->priority, task[i]->counter);
    8020061c:	00005717          	auipc	a4,0x5
    80200620:	9fc70713          	addi	a4,a4,-1540 # 80205018 <task>
    80200624:	fe843783          	ld	a5,-24(s0)
    80200628:	00379793          	slli	a5,a5,0x3
    8020062c:	00f707b3          	add	a5,a4,a5
    80200630:	0007b783          	ld	a5,0(a5)
    80200634:	0187b583          	ld	a1,24(a5)
    80200638:	00005717          	auipc	a4,0x5
    8020063c:	9e070713          	addi	a4,a4,-1568 # 80205018 <task>
    80200640:	fe843783          	ld	a5,-24(s0)
    80200644:	00379793          	slli	a5,a5,0x3
    80200648:	00f707b3          	add	a5,a4,a5
    8020064c:	0007b783          	ld	a5,0(a5)
    80200650:	0107b603          	ld	a2,16(a5)
    80200654:	00005717          	auipc	a4,0x5
    80200658:	9c470713          	addi	a4,a4,-1596 # 80205018 <task>
    8020065c:	fe843783          	ld	a5,-24(s0)
    80200660:	00379793          	slli	a5,a5,0x3
    80200664:	00f707b3          	add	a5,a4,a5
    80200668:	0007b783          	ld	a5,0(a5)
    8020066c:	0087b783          	ld	a5,8(a5)
    80200670:	00078693          	mv	a3,a5
    80200674:	00002517          	auipc	a0,0x2
    80200678:	9d450513          	addi	a0,a0,-1580 # 80202048 <_srodata+0x48>
    8020067c:	774010ef          	jal	ra,80201df0 <printk>
    for (uint64_t i = 1; i < NR_TASKS; i++) {
    80200680:	fe843783          	ld	a5,-24(s0)
    80200684:	00178793          	addi	a5,a5,1
    80200688:	fef43423          	sd	a5,-24(s0)
    8020068c:	fe843703          	ld	a4,-24(s0)
    80200690:	01f00793          	li	a5,31
    80200694:	e6e7f6e3          	bgeu	a5,a4,80200500 <task_init+0xec>
    }
    printk("...task_init done!\n");
    80200698:	00002517          	auipc	a0,0x2
    8020069c:	9e050513          	addi	a0,a0,-1568 # 80202078 <_srodata+0x78>
    802006a0:	750010ef          	jal	ra,80201df0 <printk>
}
    802006a4:	00000013          	nop
    802006a8:	01813083          	ld	ra,24(sp)
    802006ac:	01013403          	ld	s0,16(sp)
    802006b0:	02010113          	addi	sp,sp,32
    802006b4:	00008067          	ret

00000000802006b8 <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    802006b8:	fd010113          	addi	sp,sp,-48
    802006bc:	02113423          	sd	ra,40(sp)
    802006c0:	02813023          	sd	s0,32(sp)
    802006c4:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
    802006c8:	3b9ad7b7          	lui	a5,0x3b9ad
    802006cc:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_skernel-0x448535f9>
    802006d0:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
    802006d4:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
    802006d8:	fff00793          	li	a5,-1
    802006dc:	fef42223          	sw	a5,-28(s0)
    printk(GREEN"[PID = %d] start dummy.\n" CLEAR, current->pid);
    802006e0:	00005797          	auipc	a5,0x5
    802006e4:	93078793          	addi	a5,a5,-1744 # 80205010 <current>
    802006e8:	0007b783          	ld	a5,0(a5)
    802006ec:	0187b783          	ld	a5,24(a5)
    802006f0:	00078593          	mv	a1,a5
    802006f4:	00002517          	auipc	a0,0x2
    802006f8:	99c50513          	addi	a0,a0,-1636 # 80202090 <_srodata+0x90>
    802006fc:	6f4010ef          	jal	ra,80201df0 <printk>
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    80200700:	fe442783          	lw	a5,-28(s0)
    80200704:	0007871b          	sext.w	a4,a5
    80200708:	fff00793          	li	a5,-1
    8020070c:	00f70e63          	beq	a4,a5,80200728 <dummy+0x70>
    80200710:	00005797          	auipc	a5,0x5
    80200714:	90078793          	addi	a5,a5,-1792 # 80205010 <current>
    80200718:	0007b783          	ld	a5,0(a5)
    8020071c:	0087b703          	ld	a4,8(a5)
    80200720:	fe442783          	lw	a5,-28(s0)
    80200724:	fcf70ee3          	beq	a4,a5,80200700 <dummy+0x48>
    80200728:	00005797          	auipc	a5,0x5
    8020072c:	8e878793          	addi	a5,a5,-1816 # 80205010 <current>
    80200730:	0007b783          	ld	a5,0(a5)
    80200734:	0087b783          	ld	a5,8(a5)
    80200738:	fc0784e3          	beqz	a5,80200700 <dummy+0x48>
            if (current->counter == 1) {
    8020073c:	00005797          	auipc	a5,0x5
    80200740:	8d478793          	addi	a5,a5,-1836 # 80205010 <current>
    80200744:	0007b783          	ld	a5,0(a5)
    80200748:	0087b703          	ld	a4,8(a5)
    8020074c:	00100793          	li	a5,1
    80200750:	00f71e63          	bne	a4,a5,8020076c <dummy+0xb4>
                --(current->counter);// forced the counter to be zero if this thread is going to be scheduled
    80200754:	00005797          	auipc	a5,0x5
    80200758:	8bc78793          	addi	a5,a5,-1860 # 80205010 <current>
    8020075c:	0007b783          	ld	a5,0(a5)
    80200760:	0087b703          	ld	a4,8(a5)
    80200764:	fff70713          	addi	a4,a4,-1
    80200768:	00e7b423          	sd	a4,8(a5)
            }// in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
    8020076c:	00005797          	auipc	a5,0x5
    80200770:	8a478793          	addi	a5,a5,-1884 # 80205010 <current>
    80200774:	0007b783          	ld	a5,0(a5)
    80200778:	0087b783          	ld	a5,8(a5)
    8020077c:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
    80200780:	fe843783          	ld	a5,-24(s0)
    80200784:	00178713          	addi	a4,a5,1
    80200788:	fd843783          	ld	a5,-40(s0)
    8020078c:	02f777b3          	remu	a5,a4,a5
    80200790:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
    80200794:	00005797          	auipc	a5,0x5
    80200798:	87c78793          	addi	a5,a5,-1924 # 80205010 <current>
    8020079c:	0007b783          	ld	a5,0(a5)
    802007a0:	0187b783          	ld	a5,24(a5)
    802007a4:	fe843603          	ld	a2,-24(s0)
    802007a8:	00078593          	mv	a1,a5
    802007ac:	00002517          	auipc	a0,0x2
    802007b0:	90c50513          	addi	a0,a0,-1780 # 802020b8 <_srodata+0xb8>
    802007b4:	63c010ef          	jal	ra,80201df0 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    802007b8:	f49ff06f          	j	80200700 <dummy+0x48>

00000000802007bc <switch_to>:
#endif
        }
    }
}

void switch_to(struct task_struct *next) {
    802007bc:	fd010113          	addi	sp,sp,-48
    802007c0:	02113423          	sd	ra,40(sp)
    802007c4:	02813023          	sd	s0,32(sp)
    802007c8:	03010413          	addi	s0,sp,48
    802007cc:	fca43c23          	sd	a0,-40(s0)
    static int num_call = 0;    // 记录 __switch_to 被调用的次数
    static int num_return = 0;  // 记录 __switch_to 返回的次数
    if(current != next){
    802007d0:	00005797          	auipc	a5,0x5
    802007d4:	84078793          	addi	a5,a5,-1984 # 80205010 <current>
    802007d8:	0007b783          	ld	a5,0(a5)
    802007dc:	fd843703          	ld	a4,-40(s0)
    802007e0:	0cf70a63          	beq	a4,a5,802008b4 <switch_to+0xf8>
        struct task_struct* prev = current;
    802007e4:	00005797          	auipc	a5,0x5
    802007e8:	82c78793          	addi	a5,a5,-2004 # 80205010 <current>
    802007ec:	0007b783          	ld	a5,0(a5)
    802007f0:	fef43423          	sd	a5,-24(s0)
        current = next; // 更新next必须在调用 __switch_to 前，因为该函数可能不会返回，而是跳转至 next 进程中 ra 储存地址
    802007f4:	00005797          	auipc	a5,0x5
    802007f8:	81c78793          	addi	a5,a5,-2020 # 80205010 <current>
    802007fc:	fd843703          	ld	a4,-40(s0)
    80200800:	00e7b023          	sd	a4,0(a5)
        printk(BLUE"\nswitch to [PID = %d PRIORITY = %d COUNTER = %d]\n" CLEAR, next->pid, next->priority, next->counter);
    80200804:	fd843783          	ld	a5,-40(s0)
    80200808:	0187b703          	ld	a4,24(a5)
    8020080c:	fd843783          	ld	a5,-40(s0)
    80200810:	0107b603          	ld	a2,16(a5)
    80200814:	fd843783          	ld	a5,-40(s0)
    80200818:	0087b783          	ld	a5,8(a5)
    8020081c:	00078693          	mv	a3,a5
    80200820:	00070593          	mv	a1,a4
    80200824:	00002517          	auipc	a0,0x2
    80200828:	8c450513          	addi	a0,a0,-1852 # 802020e8 <_srodata+0xe8>
    8020082c:	5c4010ef          	jal	ra,80201df0 <printk>

        num_call++;
    80200830:	00005797          	auipc	a5,0x5
    80200834:	8e878793          	addi	a5,a5,-1816 # 80205118 <num_call.1>
    80200838:	0007a783          	lw	a5,0(a5)
    8020083c:	0017879b          	addiw	a5,a5,1
    80200840:	0007871b          	sext.w	a4,a5
    80200844:	00005797          	auipc	a5,0x5
    80200848:	8d478793          	addi	a5,a5,-1836 # 80205118 <num_call.1>
    8020084c:	00e7a023          	sw	a4,0(a5)
        printk(RED" __switch_to has been called for the %d-th time\n" CLEAR, num_call);
    80200850:	00005797          	auipc	a5,0x5
    80200854:	8c878793          	addi	a5,a5,-1848 # 80205118 <num_call.1>
    80200858:	0007a783          	lw	a5,0(a5)
    8020085c:	00078593          	mv	a1,a5
    80200860:	00002517          	auipc	a0,0x2
    80200864:	8c850513          	addi	a0,a0,-1848 # 80202128 <_srodata+0x128>
    80200868:	588010ef          	jal	ra,80201df0 <printk>

        __switch_to(prev, next);
    8020086c:	fd843583          	ld	a1,-40(s0)
    80200870:	fe843503          	ld	a0,-24(s0)
    80200874:	921ff0ef          	jal	ra,80200194 <__switch_to>

        num_return++;
    80200878:	00005797          	auipc	a5,0x5
    8020087c:	8a478793          	addi	a5,a5,-1884 # 8020511c <num_return.0>
    80200880:	0007a783          	lw	a5,0(a5)
    80200884:	0017879b          	addiw	a5,a5,1
    80200888:	0007871b          	sext.w	a4,a5
    8020088c:	00005797          	auipc	a5,0x5
    80200890:	89078793          	addi	a5,a5,-1904 # 8020511c <num_return.0>
    80200894:	00e7a023          	sw	a4,0(a5)
        printk(RED" __switch_to has returned for the %d-th time\n" CLEAR, num_return);
    80200898:	00005797          	auipc	a5,0x5
    8020089c:	88478793          	addi	a5,a5,-1916 # 8020511c <num_return.0>
    802008a0:	0007a783          	lw	a5,0(a5)
    802008a4:	00078593          	mv	a1,a5
    802008a8:	00002517          	auipc	a0,0x2
    802008ac:	8c050513          	addi	a0,a0,-1856 # 80202168 <_srodata+0x168>
    802008b0:	540010ef          	jal	ra,80201df0 <printk>

        // printk(RED"return successfully\n" CLEAR);
        // 第一轮中，因为 ra 变成了 dummy 的地址，所以不会回到这个函数，所以不会输出 return successfully
        // 第二轮后，ra 为 __switch_to 地址，所以会回到该函数，正确输出
    }
}
    802008b4:	00000013          	nop
    802008b8:	02813083          	ld	ra,40(sp)
    802008bc:	02013403          	ld	s0,32(sp)
    802008c0:	03010113          	addi	sp,sp,48
    802008c4:	00008067          	ret

00000000802008c8 <do_timer>:

void do_timer() {
    802008c8:	ff010113          	addi	sp,sp,-16
    802008cc:	00113423          	sd	ra,8(sp)
    802008d0:	00813023          	sd	s0,0(sp)
    802008d4:	01010413          	addi	s0,sp,16
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    if (current == idle || current->counter == 0) {
    802008d8:	00004797          	auipc	a5,0x4
    802008dc:	73878793          	addi	a5,a5,1848 # 80205010 <current>
    802008e0:	0007b703          	ld	a4,0(a5)
    802008e4:	00004797          	auipc	a5,0x4
    802008e8:	72478793          	addi	a5,a5,1828 # 80205008 <idle>
    802008ec:	0007b783          	ld	a5,0(a5)
    802008f0:	00f70c63          	beq	a4,a5,80200908 <do_timer+0x40>
    802008f4:	00004797          	auipc	a5,0x4
    802008f8:	71c78793          	addi	a5,a5,1820 # 80205010 <current>
    802008fc:	0007b783          	ld	a5,0(a5)
    80200900:	0087b783          	ld	a5,8(a5)
    80200904:	00079663          	bnez	a5,80200910 <do_timer+0x48>
        schedule();
    80200908:	058000ef          	jal	ra,80200960 <schedule>
        current->counter -= 1;
        if (current->counter == 0) {
            schedule();
        }
    }
}
    8020090c:	0400006f          	j	8020094c <do_timer+0x84>
        current->counter -= 1;
    80200910:	00004797          	auipc	a5,0x4
    80200914:	70078793          	addi	a5,a5,1792 # 80205010 <current>
    80200918:	0007b783          	ld	a5,0(a5)
    8020091c:	0087b703          	ld	a4,8(a5)
    80200920:	00004797          	auipc	a5,0x4
    80200924:	6f078793          	addi	a5,a5,1776 # 80205010 <current>
    80200928:	0007b783          	ld	a5,0(a5)
    8020092c:	fff70713          	addi	a4,a4,-1
    80200930:	00e7b423          	sd	a4,8(a5)
        if (current->counter == 0) {
    80200934:	00004797          	auipc	a5,0x4
    80200938:	6dc78793          	addi	a5,a5,1756 # 80205010 <current>
    8020093c:	0007b783          	ld	a5,0(a5)
    80200940:	0087b783          	ld	a5,8(a5)
    80200944:	00079463          	bnez	a5,8020094c <do_timer+0x84>
            schedule();
    80200948:	018000ef          	jal	ra,80200960 <schedule>
}
    8020094c:	00000013          	nop
    80200950:	00813083          	ld	ra,8(sp)
    80200954:	00013403          	ld	s0,0(sp)
    80200958:	01010113          	addi	sp,sp,16
    8020095c:	00008067          	ret

0000000080200960 <schedule>:

void schedule() {
    80200960:	fd010113          	addi	sp,sp,-48
    80200964:	02113423          	sd	ra,40(sp)
    80200968:	02813023          	sd	s0,32(sp)
    8020096c:	03010413          	addi	s0,sp,48
    uint64_t next = 0;
    80200970:	fe043423          	sd	zero,-24(s0)
    // 调度时选择 counter 最大的线程运行
    for (uint64_t i = 1; i < NR_TASKS; i++) {
    80200974:	00100793          	li	a5,1
    80200978:	fef43023          	sd	a5,-32(s0)
    8020097c:	0540006f          	j	802009d0 <schedule+0x70>
        if (task[i]->counter > task[next]->counter) {
    80200980:	00004717          	auipc	a4,0x4
    80200984:	69870713          	addi	a4,a4,1688 # 80205018 <task>
    80200988:	fe043783          	ld	a5,-32(s0)
    8020098c:	00379793          	slli	a5,a5,0x3
    80200990:	00f707b3          	add	a5,a4,a5
    80200994:	0007b783          	ld	a5,0(a5)
    80200998:	0087b703          	ld	a4,8(a5)
    8020099c:	00004697          	auipc	a3,0x4
    802009a0:	67c68693          	addi	a3,a3,1660 # 80205018 <task>
    802009a4:	fe843783          	ld	a5,-24(s0)
    802009a8:	00379793          	slli	a5,a5,0x3
    802009ac:	00f687b3          	add	a5,a3,a5
    802009b0:	0007b783          	ld	a5,0(a5)
    802009b4:	0087b783          	ld	a5,8(a5)
    802009b8:	00e7f663          	bgeu	a5,a4,802009c4 <schedule+0x64>
            next = i;
    802009bc:	fe043783          	ld	a5,-32(s0)
    802009c0:	fef43423          	sd	a5,-24(s0)
    for (uint64_t i = 1; i < NR_TASKS; i++) {
    802009c4:	fe043783          	ld	a5,-32(s0)
    802009c8:	00178793          	addi	a5,a5,1
    802009cc:	fef43023          	sd	a5,-32(s0)
    802009d0:	fe043703          	ld	a4,-32(s0)
    802009d4:	01f00793          	li	a5,31
    802009d8:	fae7f4e3          	bgeu	a5,a4,80200980 <schedule+0x20>
        }
    }
    // 如果所有线程 counter 都为 0，则令所有线程 counter = priority
    if (task[next]->counter == 0) {
    802009dc:	00004717          	auipc	a4,0x4
    802009e0:	63c70713          	addi	a4,a4,1596 # 80205018 <task>
    802009e4:	fe843783          	ld	a5,-24(s0)
    802009e8:	00379793          	slli	a5,a5,0x3
    802009ec:	00f707b3          	add	a5,a4,a5
    802009f0:	0007b783          	ld	a5,0(a5)
    802009f4:	0087b783          	ld	a5,8(a5)
    802009f8:	12079063          	bnez	a5,80200b18 <schedule+0x1b8>
        for (uint64_t i = 1; i < NR_TASKS; i++) {
    802009fc:	00100793          	li	a5,1
    80200a00:	fcf43c23          	sd	a5,-40(s0)
    80200a04:	1080006f          	j	80200b0c <schedule+0x1ac>
            task[i]->counter = task[i]->priority;
    80200a08:	00004717          	auipc	a4,0x4
    80200a0c:	61070713          	addi	a4,a4,1552 # 80205018 <task>
    80200a10:	fd843783          	ld	a5,-40(s0)
    80200a14:	00379793          	slli	a5,a5,0x3
    80200a18:	00f707b3          	add	a5,a4,a5
    80200a1c:	0007b703          	ld	a4,0(a5)
    80200a20:	00004697          	auipc	a3,0x4
    80200a24:	5f868693          	addi	a3,a3,1528 # 80205018 <task>
    80200a28:	fd843783          	ld	a5,-40(s0)
    80200a2c:	00379793          	slli	a5,a5,0x3
    80200a30:	00f687b3          	add	a5,a3,a5
    80200a34:	0007b783          	ld	a5,0(a5)
    80200a38:	01073703          	ld	a4,16(a4)
    80200a3c:	00e7b423          	sd	a4,8(a5)
            if (task[i]->counter > task[next]->counter) {
    80200a40:	00004717          	auipc	a4,0x4
    80200a44:	5d870713          	addi	a4,a4,1496 # 80205018 <task>
    80200a48:	fd843783          	ld	a5,-40(s0)
    80200a4c:	00379793          	slli	a5,a5,0x3
    80200a50:	00f707b3          	add	a5,a4,a5
    80200a54:	0007b783          	ld	a5,0(a5)
    80200a58:	0087b703          	ld	a4,8(a5)
    80200a5c:	00004697          	auipc	a3,0x4
    80200a60:	5bc68693          	addi	a3,a3,1468 # 80205018 <task>
    80200a64:	fe843783          	ld	a5,-24(s0)
    80200a68:	00379793          	slli	a5,a5,0x3
    80200a6c:	00f687b3          	add	a5,a3,a5
    80200a70:	0007b783          	ld	a5,0(a5)
    80200a74:	0087b783          	ld	a5,8(a5)
    80200a78:	00e7f663          	bgeu	a5,a4,80200a84 <schedule+0x124>
                next = i;
    80200a7c:	fd843783          	ld	a5,-40(s0)
    80200a80:	fef43423          	sd	a5,-24(s0)
            }
            if(i == 1){
    80200a84:	fd843703          	ld	a4,-40(s0)
    80200a88:	00100793          	li	a5,1
    80200a8c:	00f71863          	bne	a4,a5,80200a9c <schedule+0x13c>
                printk("\n"); // 将SET打印内容分离便于观察
    80200a90:	00001517          	auipc	a0,0x1
    80200a94:	71050513          	addi	a0,a0,1808 # 802021a0 <_srodata+0x1a0>
    80200a98:	358010ef          	jal	ra,80201df0 <printk>
            }
            printk(YELLOW"SET [PID = %d PRIORITY = %d COUNTER = %d]\n" CLEAR, task[i]->pid, task[i]->priority, task[i]->counter);
    80200a9c:	00004717          	auipc	a4,0x4
    80200aa0:	57c70713          	addi	a4,a4,1404 # 80205018 <task>
    80200aa4:	fd843783          	ld	a5,-40(s0)
    80200aa8:	00379793          	slli	a5,a5,0x3
    80200aac:	00f707b3          	add	a5,a4,a5
    80200ab0:	0007b783          	ld	a5,0(a5)
    80200ab4:	0187b583          	ld	a1,24(a5)
    80200ab8:	00004717          	auipc	a4,0x4
    80200abc:	56070713          	addi	a4,a4,1376 # 80205018 <task>
    80200ac0:	fd843783          	ld	a5,-40(s0)
    80200ac4:	00379793          	slli	a5,a5,0x3
    80200ac8:	00f707b3          	add	a5,a4,a5
    80200acc:	0007b783          	ld	a5,0(a5)
    80200ad0:	0107b603          	ld	a2,16(a5)
    80200ad4:	00004717          	auipc	a4,0x4
    80200ad8:	54470713          	addi	a4,a4,1348 # 80205018 <task>
    80200adc:	fd843783          	ld	a5,-40(s0)
    80200ae0:	00379793          	slli	a5,a5,0x3
    80200ae4:	00f707b3          	add	a5,a4,a5
    80200ae8:	0007b783          	ld	a5,0(a5)
    80200aec:	0087b783          	ld	a5,8(a5)
    80200af0:	00078693          	mv	a3,a5
    80200af4:	00001517          	auipc	a0,0x1
    80200af8:	6b450513          	addi	a0,a0,1716 # 802021a8 <_srodata+0x1a8>
    80200afc:	2f4010ef          	jal	ra,80201df0 <printk>
        for (uint64_t i = 1; i < NR_TASKS; i++) {
    80200b00:	fd843783          	ld	a5,-40(s0)
    80200b04:	00178793          	addi	a5,a5,1
    80200b08:	fcf43c23          	sd	a5,-40(s0)
    80200b0c:	fd843703          	ld	a4,-40(s0)
    80200b10:	01f00793          	li	a5,31
    80200b14:	eee7fae3          	bgeu	a5,a4,80200a08 <schedule+0xa8>
        }
    }
    switch_to(task[next]);
    80200b18:	00004717          	auipc	a4,0x4
    80200b1c:	50070713          	addi	a4,a4,1280 # 80205018 <task>
    80200b20:	fe843783          	ld	a5,-24(s0)
    80200b24:	00379793          	slli	a5,a5,0x3
    80200b28:	00f707b3          	add	a5,a4,a5
    80200b2c:	0007b783          	ld	a5,0(a5)
    80200b30:	00078513          	mv	a0,a5
    80200b34:	c89ff0ef          	jal	ra,802007bc <switch_to>
    80200b38:	00000013          	nop
    80200b3c:	02813083          	ld	ra,40(sp)
    80200b40:	02013403          	ld	s0,32(sp)
    80200b44:	03010113          	addi	sp,sp,48
    80200b48:	00008067          	ret

0000000080200b4c <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    80200b4c:	f8010113          	addi	sp,sp,-128
    80200b50:	06813c23          	sd	s0,120(sp)
    80200b54:	06913823          	sd	s1,112(sp)
    80200b58:	07213423          	sd	s2,104(sp)
    80200b5c:	07313023          	sd	s3,96(sp)
    80200b60:	08010413          	addi	s0,sp,128
    80200b64:	faa43c23          	sd	a0,-72(s0)
    80200b68:	fab43823          	sd	a1,-80(s0)
    80200b6c:	fac43423          	sd	a2,-88(s0)
    80200b70:	fad43023          	sd	a3,-96(s0)
    80200b74:	f8e43c23          	sd	a4,-104(s0)
    80200b78:	f8f43823          	sd	a5,-112(s0)
    80200b7c:	f9043423          	sd	a6,-120(s0)
    80200b80:	f9143023          	sd	a7,-128(s0)
    struct sbiret res;
    __asm__ volatile (
    80200b84:	fb843e03          	ld	t3,-72(s0)
    80200b88:	fb043e83          	ld	t4,-80(s0)
    80200b8c:	fa843f03          	ld	t5,-88(s0)
    80200b90:	fa043f83          	ld	t6,-96(s0)
    80200b94:	f9843283          	ld	t0,-104(s0)
    80200b98:	f9043483          	ld	s1,-112(s0)
    80200b9c:	f8843903          	ld	s2,-120(s0)
    80200ba0:	f8043983          	ld	s3,-128(s0)
    80200ba4:	000e0893          	mv	a7,t3
    80200ba8:	000e8813          	mv	a6,t4
    80200bac:	000f0513          	mv	a0,t5
    80200bb0:	000f8593          	mv	a1,t6
    80200bb4:	00028613          	mv	a2,t0
    80200bb8:	00048693          	mv	a3,s1
    80200bbc:	00090713          	mv	a4,s2
    80200bc0:	00098793          	mv	a5,s3
    80200bc4:	00000073          	ecall
    80200bc8:	00050e93          	mv	t4,a0
    80200bcc:	00058e13          	mv	t3,a1
    80200bd0:	fdd43023          	sd	t4,-64(s0)
    80200bd4:	fdc43423          	sd	t3,-56(s0)
            "mv %1, a1\n"
            : "=r"(res.error), "=r"(res.value)
            : "r"(eid), "r"(fid), "r"(arg0), "r"(arg1), "r"(arg2), "r"(arg3), "r"(arg4), "r"(arg5)
            : "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return res;
    80200bd8:	fc043783          	ld	a5,-64(s0)
    80200bdc:	fcf43823          	sd	a5,-48(s0)
    80200be0:	fc843783          	ld	a5,-56(s0)
    80200be4:	fcf43c23          	sd	a5,-40(s0)
    80200be8:	fd043703          	ld	a4,-48(s0)
    80200bec:	fd843783          	ld	a5,-40(s0)
    80200bf0:	00070313          	mv	t1,a4
    80200bf4:	00078393          	mv	t2,a5
    80200bf8:	00030713          	mv	a4,t1
    80200bfc:	00038793          	mv	a5,t2

}
    80200c00:	00070513          	mv	a0,a4
    80200c04:	00078593          	mv	a1,a5
    80200c08:	07813403          	ld	s0,120(sp)
    80200c0c:	07013483          	ld	s1,112(sp)
    80200c10:	06813903          	ld	s2,104(sp)
    80200c14:	06013983          	ld	s3,96(sp)
    80200c18:	08010113          	addi	sp,sp,128
    80200c1c:	00008067          	ret

0000000080200c20 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    80200c20:	fc010113          	addi	sp,sp,-64
    80200c24:	02113c23          	sd	ra,56(sp)
    80200c28:	02813823          	sd	s0,48(sp)
    80200c2c:	03213423          	sd	s2,40(sp)
    80200c30:	03313023          	sd	s3,32(sp)
    80200c34:	04010413          	addi	s0,sp,64
    80200c38:	00050793          	mv	a5,a0
    80200c3c:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434e, 2, byte, 0, 0, 0, 0, 0);
    80200c40:	fcf44603          	lbu	a2,-49(s0)
    80200c44:	00000893          	li	a7,0
    80200c48:	00000813          	li	a6,0
    80200c4c:	00000793          	li	a5,0
    80200c50:	00000713          	li	a4,0
    80200c54:	00000693          	li	a3,0
    80200c58:	00200593          	li	a1,2
    80200c5c:	44424537          	lui	a0,0x44424
    80200c60:	34e50513          	addi	a0,a0,846 # 4442434e <_skernel-0x3bddbcb2>
    80200c64:	ee9ff0ef          	jal	ra,80200b4c <sbi_ecall>
    80200c68:	00050713          	mv	a4,a0
    80200c6c:	00058793          	mv	a5,a1
    80200c70:	fce43823          	sd	a4,-48(s0)
    80200c74:	fcf43c23          	sd	a5,-40(s0)
    80200c78:	fd043703          	ld	a4,-48(s0)
    80200c7c:	fd843783          	ld	a5,-40(s0)
    80200c80:	00070913          	mv	s2,a4
    80200c84:	00078993          	mv	s3,a5
    80200c88:	00090713          	mv	a4,s2
    80200c8c:	00098793          	mv	a5,s3
}
    80200c90:	00070513          	mv	a0,a4
    80200c94:	00078593          	mv	a1,a5
    80200c98:	03813083          	ld	ra,56(sp)
    80200c9c:	03013403          	ld	s0,48(sp)
    80200ca0:	02813903          	ld	s2,40(sp)
    80200ca4:	02013983          	ld	s3,32(sp)
    80200ca8:	04010113          	addi	sp,sp,64
    80200cac:	00008067          	ret

0000000080200cb0 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    80200cb0:	fc010113          	addi	sp,sp,-64
    80200cb4:	02113c23          	sd	ra,56(sp)
    80200cb8:	02813823          	sd	s0,48(sp)
    80200cbc:	03213423          	sd	s2,40(sp)
    80200cc0:	03313023          	sd	s3,32(sp)
    80200cc4:	04010413          	addi	s0,sp,64
    80200cc8:	00050793          	mv	a5,a0
    80200ccc:	00058713          	mv	a4,a1
    80200cd0:	fcf42623          	sw	a5,-52(s0)
    80200cd4:	00070793          	mv	a5,a4
    80200cd8:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0, reset_type, reset_reason, 0, 0, 0, 0);
    80200cdc:	fcc46603          	lwu	a2,-52(s0)
    80200ce0:	fc846683          	lwu	a3,-56(s0)
    80200ce4:	00000893          	li	a7,0
    80200ce8:	00000813          	li	a6,0
    80200cec:	00000793          	li	a5,0
    80200cf0:	00000713          	li	a4,0
    80200cf4:	00000593          	li	a1,0
    80200cf8:	53525537          	lui	a0,0x53525
    80200cfc:	35450513          	addi	a0,a0,852 # 53525354 <_skernel-0x2ccdacac>
    80200d00:	e4dff0ef          	jal	ra,80200b4c <sbi_ecall>
    80200d04:	00050713          	mv	a4,a0
    80200d08:	00058793          	mv	a5,a1
    80200d0c:	fce43823          	sd	a4,-48(s0)
    80200d10:	fcf43c23          	sd	a5,-40(s0)
    80200d14:	fd043703          	ld	a4,-48(s0)
    80200d18:	fd843783          	ld	a5,-40(s0)
    80200d1c:	00070913          	mv	s2,a4
    80200d20:	00078993          	mv	s3,a5
    80200d24:	00090713          	mv	a4,s2
    80200d28:	00098793          	mv	a5,s3
}
    80200d2c:	00070513          	mv	a0,a4
    80200d30:	00078593          	mv	a1,a5
    80200d34:	03813083          	ld	ra,56(sp)
    80200d38:	03013403          	ld	s0,48(sp)
    80200d3c:	02813903          	ld	s2,40(sp)
    80200d40:	02013983          	ld	s3,32(sp)
    80200d44:	04010113          	addi	sp,sp,64
    80200d48:	00008067          	ret

0000000080200d4c <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value) {
    80200d4c:	fc010113          	addi	sp,sp,-64
    80200d50:	02113c23          	sd	ra,56(sp)
    80200d54:	02813823          	sd	s0,48(sp)
    80200d58:	03213423          	sd	s2,40(sp)
    80200d5c:	03313023          	sd	s3,32(sp)
    80200d60:	04010413          	addi	s0,sp,64
    80200d64:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494d45, 0, stime_value, 0, 0, 0, 0, 0);
    80200d68:	00000893          	li	a7,0
    80200d6c:	00000813          	li	a6,0
    80200d70:	00000793          	li	a5,0
    80200d74:	00000713          	li	a4,0
    80200d78:	00000693          	li	a3,0
    80200d7c:	fc843603          	ld	a2,-56(s0)
    80200d80:	00000593          	li	a1,0
    80200d84:	54495537          	lui	a0,0x54495
    80200d88:	d4550513          	addi	a0,a0,-699 # 54494d45 <_skernel-0x2bd6b2bb>
    80200d8c:	dc1ff0ef          	jal	ra,80200b4c <sbi_ecall>
    80200d90:	00050713          	mv	a4,a0
    80200d94:	00058793          	mv	a5,a1
    80200d98:	fce43823          	sd	a4,-48(s0)
    80200d9c:	fcf43c23          	sd	a5,-40(s0)
    80200da0:	fd043703          	ld	a4,-48(s0)
    80200da4:	fd843783          	ld	a5,-40(s0)
    80200da8:	00070913          	mv	s2,a4
    80200dac:	00078993          	mv	s3,a5
    80200db0:	00090713          	mv	a4,s2
    80200db4:	00098793          	mv	a5,s3
    80200db8:	00070513          	mv	a0,a4
    80200dbc:	00078593          	mv	a1,a5
    80200dc0:	03813083          	ld	ra,56(sp)
    80200dc4:	03013403          	ld	s0,48(sp)
    80200dc8:	02813903          	ld	s2,40(sp)
    80200dcc:	02013983          	ld	s3,32(sp)
    80200dd0:	04010113          	addi	sp,sp,64
    80200dd4:	00008067          	ret

0000000080200dd8 <trap_handler>:
#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "proc.h"

void trap_handler(uint64_t scause, uint64_t sepc) {
    80200dd8:	fd010113          	addi	sp,sp,-48
    80200ddc:	02113423          	sd	ra,40(sp)
    80200de0:	02813023          	sd	s0,32(sp)
    80200de4:	03010413          	addi	s0,sp,48
    80200de8:	fca43c23          	sd	a0,-40(s0)
    80200dec:	fcb43823          	sd	a1,-48(s0)
    // interrupt：最高位
    uint64_t interrupt = (scause >> 63) & 1;
    80200df0:	fd843783          	ld	a5,-40(s0)
    80200df4:	03f7d793          	srli	a5,a5,0x3f
    80200df8:	fef43423          	sd	a5,-24(s0)

    // exception_code：剩余位
    uint64_t exception_code = scause & 0x7FFFFFFFFFFFFFFF;
    80200dfc:	fd843703          	ld	a4,-40(s0)
    80200e00:	fff00793          	li	a5,-1
    80200e04:	0017d793          	srli	a5,a5,0x1
    80200e08:	00f777b3          	and	a5,a4,a5
    80200e0c:	fef43023          	sd	a5,-32(s0)

    // 最高位为0：interrupt；最高位为1：exception
    // Supervisor timer interrupt剩余位值为5

    if(interrupt == 1) {
    80200e10:	fe843703          	ld	a4,-24(s0)
    80200e14:	00100793          	li	a5,1
    80200e18:	02f71663          	bne	a4,a5,80200e44 <trap_handler+0x6c>
        if(exception_code == 5) {
    80200e1c:	fe043703          	ld	a4,-32(s0)
    80200e20:	00500793          	li	a5,5
    80200e24:	00f71863          	bne	a4,a5,80200e34 <trap_handler+0x5c>
            // printk("[S] Supervisor Mode Timer Interrupt\n");
            clock_set_next_event();
    80200e28:	c08ff0ef          	jal	ra,80200230 <clock_set_next_event>
            do_timer();
    80200e2c:	a9dff0ef          	jal	ra,802008c8 <do_timer>
            printk("Other Interrupt\n");
        }
    }else {
        printk("Exception\n");
    }
    80200e30:	0200006f          	j	80200e50 <trap_handler+0x78>
            printk("Other Interrupt\n");
    80200e34:	00001517          	auipc	a0,0x1
    80200e38:	3ac50513          	addi	a0,a0,940 # 802021e0 <_srodata+0x1e0>
    80200e3c:	7b5000ef          	jal	ra,80201df0 <printk>
    80200e40:	0100006f          	j	80200e50 <trap_handler+0x78>
        printk("Exception\n");
    80200e44:	00001517          	auipc	a0,0x1
    80200e48:	3b450513          	addi	a0,a0,948 # 802021f8 <_srodata+0x1f8>
    80200e4c:	7a5000ef          	jal	ra,80201df0 <printk>
    80200e50:	00000013          	nop
    80200e54:	02813083          	ld	ra,40(sp)
    80200e58:	02013403          	ld	s0,32(sp)
    80200e5c:	03010113          	addi	sp,sp,48
    80200e60:	00008067          	ret

0000000080200e64 <start_kernel>:
#include "printk.h"

extern void test();

int start_kernel() {
    80200e64:	ff010113          	addi	sp,sp,-16
    80200e68:	00113423          	sd	ra,8(sp)
    80200e6c:	00813023          	sd	s0,0(sp)
    80200e70:	01010413          	addi	s0,sp,16
    printk("2024");
    80200e74:	00001517          	auipc	a0,0x1
    80200e78:	39450513          	addi	a0,a0,916 # 80202208 <_srodata+0x208>
    80200e7c:	775000ef          	jal	ra,80201df0 <printk>
    printk(" ZJU Operating System\n");
    80200e80:	00001517          	auipc	a0,0x1
    80200e84:	39050513          	addi	a0,a0,912 # 80202210 <_srodata+0x210>
    80200e88:	769000ef          	jal	ra,80201df0 <printk>

    test();
    80200e8c:	0bc000ef          	jal	ra,80200f48 <test>
    return 0;
    80200e90:	00000793          	li	a5,0
}
    80200e94:	00078513          	mv	a0,a5
    80200e98:	00813083          	ld	ra,8(sp)
    80200e9c:	00013403          	ld	s0,0(sp)
    80200ea0:	01010113          	addi	sp,sp,16
    80200ea4:	00008067          	ret

0000000080200ea8 <print_binary>:
#include "sbi.h"
#include "defs.h"
#include "printk.h"

void print_binary(uint64_t value) {
    80200ea8:	fd010113          	addi	sp,sp,-48
    80200eac:	02113423          	sd	ra,40(sp)
    80200eb0:	02813023          	sd	s0,32(sp)
    80200eb4:	03010413          	addi	s0,sp,48
    80200eb8:	fca43c23          	sd	a0,-40(s0)
    for (int i = 63; i >= 0; i--) {
    80200ebc:	03f00793          	li	a5,63
    80200ec0:	fef42623          	sw	a5,-20(s0)
    80200ec4:	0580006f          	j	80200f1c <print_binary+0x74>
        printk("%d",(value & (1ULL << i)) ? 1 : 0);
    80200ec8:	fec42783          	lw	a5,-20(s0)
    80200ecc:	00078713          	mv	a4,a5
    80200ed0:	fd843783          	ld	a5,-40(s0)
    80200ed4:	00e7d7b3          	srl	a5,a5,a4
    80200ed8:	0007879b          	sext.w	a5,a5
    80200edc:	0017f793          	andi	a5,a5,1
    80200ee0:	0007879b          	sext.w	a5,a5
    80200ee4:	00078593          	mv	a1,a5
    80200ee8:	00001517          	auipc	a0,0x1
    80200eec:	34050513          	addi	a0,a0,832 # 80202228 <_srodata+0x228>
    80200ef0:	701000ef          	jal	ra,80201df0 <printk>
        // 每 8 位加一个空格，便于阅读
        if (i % 8 == 0) {
    80200ef4:	fec42783          	lw	a5,-20(s0)
    80200ef8:	0077f793          	andi	a5,a5,7
    80200efc:	0007879b          	sext.w	a5,a5
    80200f00:	00079863          	bnez	a5,80200f10 <print_binary+0x68>
            printk(" ");
    80200f04:	00001517          	auipc	a0,0x1
    80200f08:	32c50513          	addi	a0,a0,812 # 80202230 <_srodata+0x230>
    80200f0c:	6e5000ef          	jal	ra,80201df0 <printk>
    for (int i = 63; i >= 0; i--) {
    80200f10:	fec42783          	lw	a5,-20(s0)
    80200f14:	fff7879b          	addiw	a5,a5,-1
    80200f18:	fef42623          	sw	a5,-20(s0)
    80200f1c:	fec42783          	lw	a5,-20(s0)
    80200f20:	0007879b          	sext.w	a5,a5
    80200f24:	fa07d2e3          	bgez	a5,80200ec8 <print_binary+0x20>
        }
    }
    printk("\n");
    80200f28:	00001517          	auipc	a0,0x1
    80200f2c:	31050513          	addi	a0,a0,784 # 80202238 <_srodata+0x238>
    80200f30:	6c1000ef          	jal	ra,80201df0 <printk>
}
    80200f34:	00000013          	nop
    80200f38:	02813083          	ld	ra,40(sp)
    80200f3c:	02013403          	ld	s0,32(sp)
    80200f40:	03010113          	addi	sp,sp,48
    80200f44:	00008067          	ret

0000000080200f48 <test>:

void test() {
    80200f48:	fe010113          	addi	sp,sp,-32
    80200f4c:	00813c23          	sd	s0,24(sp)
    80200f50:	02010413          	addi	s0,sp,32
    int i = 0;
    80200f54:	fe042623          	sw	zero,-20(s0)
    printk("Before:%d\n",sscratch_value);
    csr_write(sscratch, 1);
    sscratch_value = csr_read(sscratch);
    printk("After:%d\n",sscratch_value);*/

    while (1) {
    80200f58:	0000006f          	j	80200f58 <test+0x10>

0000000080200f5c <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
    80200f5c:	fe010113          	addi	sp,sp,-32
    80200f60:	00113c23          	sd	ra,24(sp)
    80200f64:	00813823          	sd	s0,16(sp)
    80200f68:	02010413          	addi	s0,sp,32
    80200f6c:	00050793          	mv	a5,a0
    80200f70:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
    80200f74:	fec42783          	lw	a5,-20(s0)
    80200f78:	0ff7f793          	zext.b	a5,a5
    80200f7c:	00078513          	mv	a0,a5
    80200f80:	ca1ff0ef          	jal	ra,80200c20 <sbi_debug_console_write_byte>
    return (char)c;
    80200f84:	fec42783          	lw	a5,-20(s0)
    80200f88:	0ff7f793          	zext.b	a5,a5
    80200f8c:	0007879b          	sext.w	a5,a5
}
    80200f90:	00078513          	mv	a0,a5
    80200f94:	01813083          	ld	ra,24(sp)
    80200f98:	01013403          	ld	s0,16(sp)
    80200f9c:	02010113          	addi	sp,sp,32
    80200fa0:	00008067          	ret

0000000080200fa4 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
    80200fa4:	fe010113          	addi	sp,sp,-32
    80200fa8:	00813c23          	sd	s0,24(sp)
    80200fac:	02010413          	addi	s0,sp,32
    80200fb0:	00050793          	mv	a5,a0
    80200fb4:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
    80200fb8:	fec42783          	lw	a5,-20(s0)
    80200fbc:	0007871b          	sext.w	a4,a5
    80200fc0:	02000793          	li	a5,32
    80200fc4:	02f70263          	beq	a4,a5,80200fe8 <isspace+0x44>
    80200fc8:	fec42783          	lw	a5,-20(s0)
    80200fcc:	0007871b          	sext.w	a4,a5
    80200fd0:	00800793          	li	a5,8
    80200fd4:	00e7de63          	bge	a5,a4,80200ff0 <isspace+0x4c>
    80200fd8:	fec42783          	lw	a5,-20(s0)
    80200fdc:	0007871b          	sext.w	a4,a5
    80200fe0:	00d00793          	li	a5,13
    80200fe4:	00e7c663          	blt	a5,a4,80200ff0 <isspace+0x4c>
    80200fe8:	00100793          	li	a5,1
    80200fec:	0080006f          	j	80200ff4 <isspace+0x50>
    80200ff0:	00000793          	li	a5,0
}
    80200ff4:	00078513          	mv	a0,a5
    80200ff8:	01813403          	ld	s0,24(sp)
    80200ffc:	02010113          	addi	sp,sp,32
    80201000:	00008067          	ret

0000000080201004 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
    80201004:	fb010113          	addi	sp,sp,-80
    80201008:	04113423          	sd	ra,72(sp)
    8020100c:	04813023          	sd	s0,64(sp)
    80201010:	05010413          	addi	s0,sp,80
    80201014:	fca43423          	sd	a0,-56(s0)
    80201018:	fcb43023          	sd	a1,-64(s0)
    8020101c:	00060793          	mv	a5,a2
    80201020:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
    80201024:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
    80201028:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
    8020102c:	fc843783          	ld	a5,-56(s0)
    80201030:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
    80201034:	0100006f          	j	80201044 <strtol+0x40>
        p++;
    80201038:	fd843783          	ld	a5,-40(s0)
    8020103c:	00178793          	addi	a5,a5,1
    80201040:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
    80201044:	fd843783          	ld	a5,-40(s0)
    80201048:	0007c783          	lbu	a5,0(a5)
    8020104c:	0007879b          	sext.w	a5,a5
    80201050:	00078513          	mv	a0,a5
    80201054:	f51ff0ef          	jal	ra,80200fa4 <isspace>
    80201058:	00050793          	mv	a5,a0
    8020105c:	fc079ee3          	bnez	a5,80201038 <strtol+0x34>
    }

    if (*p == '-') {
    80201060:	fd843783          	ld	a5,-40(s0)
    80201064:	0007c783          	lbu	a5,0(a5)
    80201068:	00078713          	mv	a4,a5
    8020106c:	02d00793          	li	a5,45
    80201070:	00f71e63          	bne	a4,a5,8020108c <strtol+0x88>
        neg = true;
    80201074:	00100793          	li	a5,1
    80201078:	fef403a3          	sb	a5,-25(s0)
        p++;
    8020107c:	fd843783          	ld	a5,-40(s0)
    80201080:	00178793          	addi	a5,a5,1
    80201084:	fcf43c23          	sd	a5,-40(s0)
    80201088:	0240006f          	j	802010ac <strtol+0xa8>
    } else if (*p == '+') {
    8020108c:	fd843783          	ld	a5,-40(s0)
    80201090:	0007c783          	lbu	a5,0(a5)
    80201094:	00078713          	mv	a4,a5
    80201098:	02b00793          	li	a5,43
    8020109c:	00f71863          	bne	a4,a5,802010ac <strtol+0xa8>
        p++;
    802010a0:	fd843783          	ld	a5,-40(s0)
    802010a4:	00178793          	addi	a5,a5,1
    802010a8:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
    802010ac:	fbc42783          	lw	a5,-68(s0)
    802010b0:	0007879b          	sext.w	a5,a5
    802010b4:	06079c63          	bnez	a5,8020112c <strtol+0x128>
        if (*p == '0') {
    802010b8:	fd843783          	ld	a5,-40(s0)
    802010bc:	0007c783          	lbu	a5,0(a5)
    802010c0:	00078713          	mv	a4,a5
    802010c4:	03000793          	li	a5,48
    802010c8:	04f71e63          	bne	a4,a5,80201124 <strtol+0x120>
            p++;
    802010cc:	fd843783          	ld	a5,-40(s0)
    802010d0:	00178793          	addi	a5,a5,1
    802010d4:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
    802010d8:	fd843783          	ld	a5,-40(s0)
    802010dc:	0007c783          	lbu	a5,0(a5)
    802010e0:	00078713          	mv	a4,a5
    802010e4:	07800793          	li	a5,120
    802010e8:	00f70c63          	beq	a4,a5,80201100 <strtol+0xfc>
    802010ec:	fd843783          	ld	a5,-40(s0)
    802010f0:	0007c783          	lbu	a5,0(a5)
    802010f4:	00078713          	mv	a4,a5
    802010f8:	05800793          	li	a5,88
    802010fc:	00f71e63          	bne	a4,a5,80201118 <strtol+0x114>
                base = 16;
    80201100:	01000793          	li	a5,16
    80201104:	faf42e23          	sw	a5,-68(s0)
                p++;
    80201108:	fd843783          	ld	a5,-40(s0)
    8020110c:	00178793          	addi	a5,a5,1
    80201110:	fcf43c23          	sd	a5,-40(s0)
    80201114:	0180006f          	j	8020112c <strtol+0x128>
            } else {
                base = 8;
    80201118:	00800793          	li	a5,8
    8020111c:	faf42e23          	sw	a5,-68(s0)
    80201120:	00c0006f          	j	8020112c <strtol+0x128>
            }
        } else {
            base = 10;
    80201124:	00a00793          	li	a5,10
    80201128:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
    8020112c:	fd843783          	ld	a5,-40(s0)
    80201130:	0007c783          	lbu	a5,0(a5)
    80201134:	00078713          	mv	a4,a5
    80201138:	02f00793          	li	a5,47
    8020113c:	02e7f863          	bgeu	a5,a4,8020116c <strtol+0x168>
    80201140:	fd843783          	ld	a5,-40(s0)
    80201144:	0007c783          	lbu	a5,0(a5)
    80201148:	00078713          	mv	a4,a5
    8020114c:	03900793          	li	a5,57
    80201150:	00e7ee63          	bltu	a5,a4,8020116c <strtol+0x168>
            digit = *p - '0';
    80201154:	fd843783          	ld	a5,-40(s0)
    80201158:	0007c783          	lbu	a5,0(a5)
    8020115c:	0007879b          	sext.w	a5,a5
    80201160:	fd07879b          	addiw	a5,a5,-48
    80201164:	fcf42a23          	sw	a5,-44(s0)
    80201168:	0800006f          	j	802011e8 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
    8020116c:	fd843783          	ld	a5,-40(s0)
    80201170:	0007c783          	lbu	a5,0(a5)
    80201174:	00078713          	mv	a4,a5
    80201178:	06000793          	li	a5,96
    8020117c:	02e7f863          	bgeu	a5,a4,802011ac <strtol+0x1a8>
    80201180:	fd843783          	ld	a5,-40(s0)
    80201184:	0007c783          	lbu	a5,0(a5)
    80201188:	00078713          	mv	a4,a5
    8020118c:	07a00793          	li	a5,122
    80201190:	00e7ee63          	bltu	a5,a4,802011ac <strtol+0x1a8>
            digit = *p - ('a' - 10);
    80201194:	fd843783          	ld	a5,-40(s0)
    80201198:	0007c783          	lbu	a5,0(a5)
    8020119c:	0007879b          	sext.w	a5,a5
    802011a0:	fa97879b          	addiw	a5,a5,-87
    802011a4:	fcf42a23          	sw	a5,-44(s0)
    802011a8:	0400006f          	j	802011e8 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
    802011ac:	fd843783          	ld	a5,-40(s0)
    802011b0:	0007c783          	lbu	a5,0(a5)
    802011b4:	00078713          	mv	a4,a5
    802011b8:	04000793          	li	a5,64
    802011bc:	06e7f863          	bgeu	a5,a4,8020122c <strtol+0x228>
    802011c0:	fd843783          	ld	a5,-40(s0)
    802011c4:	0007c783          	lbu	a5,0(a5)
    802011c8:	00078713          	mv	a4,a5
    802011cc:	05a00793          	li	a5,90
    802011d0:	04e7ee63          	bltu	a5,a4,8020122c <strtol+0x228>
            digit = *p - ('A' - 10);
    802011d4:	fd843783          	ld	a5,-40(s0)
    802011d8:	0007c783          	lbu	a5,0(a5)
    802011dc:	0007879b          	sext.w	a5,a5
    802011e0:	fc97879b          	addiw	a5,a5,-55
    802011e4:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
    802011e8:	fd442783          	lw	a5,-44(s0)
    802011ec:	00078713          	mv	a4,a5
    802011f0:	fbc42783          	lw	a5,-68(s0)
    802011f4:	0007071b          	sext.w	a4,a4
    802011f8:	0007879b          	sext.w	a5,a5
    802011fc:	02f75663          	bge	a4,a5,80201228 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
    80201200:	fbc42703          	lw	a4,-68(s0)
    80201204:	fe843783          	ld	a5,-24(s0)
    80201208:	02f70733          	mul	a4,a4,a5
    8020120c:	fd442783          	lw	a5,-44(s0)
    80201210:	00f707b3          	add	a5,a4,a5
    80201214:	fef43423          	sd	a5,-24(s0)
        p++;
    80201218:	fd843783          	ld	a5,-40(s0)
    8020121c:	00178793          	addi	a5,a5,1
    80201220:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
    80201224:	f09ff06f          	j	8020112c <strtol+0x128>
            break;
    80201228:	00000013          	nop
    }

    if (endptr) {
    8020122c:	fc043783          	ld	a5,-64(s0)
    80201230:	00078863          	beqz	a5,80201240 <strtol+0x23c>
        *endptr = (char *)p;
    80201234:	fc043783          	ld	a5,-64(s0)
    80201238:	fd843703          	ld	a4,-40(s0)
    8020123c:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
    80201240:	fe744783          	lbu	a5,-25(s0)
    80201244:	0ff7f793          	zext.b	a5,a5
    80201248:	00078863          	beqz	a5,80201258 <strtol+0x254>
    8020124c:	fe843783          	ld	a5,-24(s0)
    80201250:	40f007b3          	neg	a5,a5
    80201254:	0080006f          	j	8020125c <strtol+0x258>
    80201258:	fe843783          	ld	a5,-24(s0)
}
    8020125c:	00078513          	mv	a0,a5
    80201260:	04813083          	ld	ra,72(sp)
    80201264:	04013403          	ld	s0,64(sp)
    80201268:	05010113          	addi	sp,sp,80
    8020126c:	00008067          	ret

0000000080201270 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
    80201270:	fd010113          	addi	sp,sp,-48
    80201274:	02113423          	sd	ra,40(sp)
    80201278:	02813023          	sd	s0,32(sp)
    8020127c:	03010413          	addi	s0,sp,48
    80201280:	fca43c23          	sd	a0,-40(s0)
    80201284:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
    80201288:	fd043783          	ld	a5,-48(s0)
    8020128c:	00079863          	bnez	a5,8020129c <puts_wo_nl+0x2c>
        s = "(null)";
    80201290:	00001797          	auipc	a5,0x1
    80201294:	fb078793          	addi	a5,a5,-80 # 80202240 <_srodata+0x240>
    80201298:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
    8020129c:	fd043783          	ld	a5,-48(s0)
    802012a0:	fef43423          	sd	a5,-24(s0)
    while (*p) {
    802012a4:	0240006f          	j	802012c8 <puts_wo_nl+0x58>
        putch(*p++);
    802012a8:	fe843783          	ld	a5,-24(s0)
    802012ac:	00178713          	addi	a4,a5,1
    802012b0:	fee43423          	sd	a4,-24(s0)
    802012b4:	0007c783          	lbu	a5,0(a5)
    802012b8:	0007871b          	sext.w	a4,a5
    802012bc:	fd843783          	ld	a5,-40(s0)
    802012c0:	00070513          	mv	a0,a4
    802012c4:	000780e7          	jalr	a5
    while (*p) {
    802012c8:	fe843783          	ld	a5,-24(s0)
    802012cc:	0007c783          	lbu	a5,0(a5)
    802012d0:	fc079ce3          	bnez	a5,802012a8 <puts_wo_nl+0x38>
    }
    return p - s;
    802012d4:	fe843703          	ld	a4,-24(s0)
    802012d8:	fd043783          	ld	a5,-48(s0)
    802012dc:	40f707b3          	sub	a5,a4,a5
    802012e0:	0007879b          	sext.w	a5,a5
}
    802012e4:	00078513          	mv	a0,a5
    802012e8:	02813083          	ld	ra,40(sp)
    802012ec:	02013403          	ld	s0,32(sp)
    802012f0:	03010113          	addi	sp,sp,48
    802012f4:	00008067          	ret

00000000802012f8 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
    802012f8:	f9010113          	addi	sp,sp,-112
    802012fc:	06113423          	sd	ra,104(sp)
    80201300:	06813023          	sd	s0,96(sp)
    80201304:	07010413          	addi	s0,sp,112
    80201308:	faa43423          	sd	a0,-88(s0)
    8020130c:	fab43023          	sd	a1,-96(s0)
    80201310:	00060793          	mv	a5,a2
    80201314:	f8d43823          	sd	a3,-112(s0)
    80201318:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
    8020131c:	f9f44783          	lbu	a5,-97(s0)
    80201320:	0ff7f793          	zext.b	a5,a5
    80201324:	02078663          	beqz	a5,80201350 <print_dec_int+0x58>
    80201328:	fa043703          	ld	a4,-96(s0)
    8020132c:	fff00793          	li	a5,-1
    80201330:	03f79793          	slli	a5,a5,0x3f
    80201334:	00f71e63          	bne	a4,a5,80201350 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
    80201338:	00001597          	auipc	a1,0x1
    8020133c:	f1058593          	addi	a1,a1,-240 # 80202248 <_srodata+0x248>
    80201340:	fa843503          	ld	a0,-88(s0)
    80201344:	f2dff0ef          	jal	ra,80201270 <puts_wo_nl>
    80201348:	00050793          	mv	a5,a0
    8020134c:	2a00006f          	j	802015ec <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
    80201350:	f9043783          	ld	a5,-112(s0)
    80201354:	00c7a783          	lw	a5,12(a5)
    80201358:	00079a63          	bnez	a5,8020136c <print_dec_int+0x74>
    8020135c:	fa043783          	ld	a5,-96(s0)
    80201360:	00079663          	bnez	a5,8020136c <print_dec_int+0x74>
        return 0;
    80201364:	00000793          	li	a5,0
    80201368:	2840006f          	j	802015ec <print_dec_int+0x2f4>
    }

    bool neg = false;
    8020136c:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
    80201370:	f9f44783          	lbu	a5,-97(s0)
    80201374:	0ff7f793          	zext.b	a5,a5
    80201378:	02078063          	beqz	a5,80201398 <print_dec_int+0xa0>
    8020137c:	fa043783          	ld	a5,-96(s0)
    80201380:	0007dc63          	bgez	a5,80201398 <print_dec_int+0xa0>
        neg = true;
    80201384:	00100793          	li	a5,1
    80201388:	fef407a3          	sb	a5,-17(s0)
        num = -num;
    8020138c:	fa043783          	ld	a5,-96(s0)
    80201390:	40f007b3          	neg	a5,a5
    80201394:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
    80201398:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
    8020139c:	f9f44783          	lbu	a5,-97(s0)
    802013a0:	0ff7f793          	zext.b	a5,a5
    802013a4:	02078863          	beqz	a5,802013d4 <print_dec_int+0xdc>
    802013a8:	fef44783          	lbu	a5,-17(s0)
    802013ac:	0ff7f793          	zext.b	a5,a5
    802013b0:	00079e63          	bnez	a5,802013cc <print_dec_int+0xd4>
    802013b4:	f9043783          	ld	a5,-112(s0)
    802013b8:	0057c783          	lbu	a5,5(a5)
    802013bc:	00079863          	bnez	a5,802013cc <print_dec_int+0xd4>
    802013c0:	f9043783          	ld	a5,-112(s0)
    802013c4:	0047c783          	lbu	a5,4(a5)
    802013c8:	00078663          	beqz	a5,802013d4 <print_dec_int+0xdc>
    802013cc:	00100793          	li	a5,1
    802013d0:	0080006f          	j	802013d8 <print_dec_int+0xe0>
    802013d4:	00000793          	li	a5,0
    802013d8:	fcf40ba3          	sb	a5,-41(s0)
    802013dc:	fd744783          	lbu	a5,-41(s0)
    802013e0:	0017f793          	andi	a5,a5,1
    802013e4:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
    802013e8:	fa043703          	ld	a4,-96(s0)
    802013ec:	00a00793          	li	a5,10
    802013f0:	02f777b3          	remu	a5,a4,a5
    802013f4:	0ff7f713          	zext.b	a4,a5
    802013f8:	fe842783          	lw	a5,-24(s0)
    802013fc:	0017869b          	addiw	a3,a5,1
    80201400:	fed42423          	sw	a3,-24(s0)
    80201404:	0307071b          	addiw	a4,a4,48
    80201408:	0ff77713          	zext.b	a4,a4
    8020140c:	ff078793          	addi	a5,a5,-16
    80201410:	008787b3          	add	a5,a5,s0
    80201414:	fce78423          	sb	a4,-56(a5)
        num /= 10;
    80201418:	fa043703          	ld	a4,-96(s0)
    8020141c:	00a00793          	li	a5,10
    80201420:	02f757b3          	divu	a5,a4,a5
    80201424:	faf43023          	sd	a5,-96(s0)
    } while (num);
    80201428:	fa043783          	ld	a5,-96(s0)
    8020142c:	fa079ee3          	bnez	a5,802013e8 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
    80201430:	f9043783          	ld	a5,-112(s0)
    80201434:	00c7a783          	lw	a5,12(a5)
    80201438:	00078713          	mv	a4,a5
    8020143c:	fff00793          	li	a5,-1
    80201440:	02f71063          	bne	a4,a5,80201460 <print_dec_int+0x168>
    80201444:	f9043783          	ld	a5,-112(s0)
    80201448:	0037c783          	lbu	a5,3(a5)
    8020144c:	00078a63          	beqz	a5,80201460 <print_dec_int+0x168>
        flags->prec = flags->width;
    80201450:	f9043783          	ld	a5,-112(s0)
    80201454:	0087a703          	lw	a4,8(a5)
    80201458:	f9043783          	ld	a5,-112(s0)
    8020145c:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
    80201460:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80201464:	f9043783          	ld	a5,-112(s0)
    80201468:	0087a703          	lw	a4,8(a5)
    8020146c:	fe842783          	lw	a5,-24(s0)
    80201470:	fcf42823          	sw	a5,-48(s0)
    80201474:	f9043783          	ld	a5,-112(s0)
    80201478:	00c7a783          	lw	a5,12(a5)
    8020147c:	fcf42623          	sw	a5,-52(s0)
    80201480:	fd042783          	lw	a5,-48(s0)
    80201484:	00078593          	mv	a1,a5
    80201488:	fcc42783          	lw	a5,-52(s0)
    8020148c:	00078613          	mv	a2,a5
    80201490:	0006069b          	sext.w	a3,a2
    80201494:	0005879b          	sext.w	a5,a1
    80201498:	00f6d463          	bge	a3,a5,802014a0 <print_dec_int+0x1a8>
    8020149c:	00058613          	mv	a2,a1
    802014a0:	0006079b          	sext.w	a5,a2
    802014a4:	40f707bb          	subw	a5,a4,a5
    802014a8:	0007871b          	sext.w	a4,a5
    802014ac:	fd744783          	lbu	a5,-41(s0)
    802014b0:	0007879b          	sext.w	a5,a5
    802014b4:	40f707bb          	subw	a5,a4,a5
    802014b8:	fef42023          	sw	a5,-32(s0)
    802014bc:	0280006f          	j	802014e4 <print_dec_int+0x1ec>
        putch(' ');
    802014c0:	fa843783          	ld	a5,-88(s0)
    802014c4:	02000513          	li	a0,32
    802014c8:	000780e7          	jalr	a5
        ++written;
    802014cc:	fe442783          	lw	a5,-28(s0)
    802014d0:	0017879b          	addiw	a5,a5,1
    802014d4:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    802014d8:	fe042783          	lw	a5,-32(s0)
    802014dc:	fff7879b          	addiw	a5,a5,-1
    802014e0:	fef42023          	sw	a5,-32(s0)
    802014e4:	fe042783          	lw	a5,-32(s0)
    802014e8:	0007879b          	sext.w	a5,a5
    802014ec:	fcf04ae3          	bgtz	a5,802014c0 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
    802014f0:	fd744783          	lbu	a5,-41(s0)
    802014f4:	0ff7f793          	zext.b	a5,a5
    802014f8:	04078463          	beqz	a5,80201540 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
    802014fc:	fef44783          	lbu	a5,-17(s0)
    80201500:	0ff7f793          	zext.b	a5,a5
    80201504:	00078663          	beqz	a5,80201510 <print_dec_int+0x218>
    80201508:	02d00793          	li	a5,45
    8020150c:	01c0006f          	j	80201528 <print_dec_int+0x230>
    80201510:	f9043783          	ld	a5,-112(s0)
    80201514:	0057c783          	lbu	a5,5(a5)
    80201518:	00078663          	beqz	a5,80201524 <print_dec_int+0x22c>
    8020151c:	02b00793          	li	a5,43
    80201520:	0080006f          	j	80201528 <print_dec_int+0x230>
    80201524:	02000793          	li	a5,32
    80201528:	fa843703          	ld	a4,-88(s0)
    8020152c:	00078513          	mv	a0,a5
    80201530:	000700e7          	jalr	a4
        ++written;
    80201534:	fe442783          	lw	a5,-28(s0)
    80201538:	0017879b          	addiw	a5,a5,1
    8020153c:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80201540:	fe842783          	lw	a5,-24(s0)
    80201544:	fcf42e23          	sw	a5,-36(s0)
    80201548:	0280006f          	j	80201570 <print_dec_int+0x278>
        putch('0');
    8020154c:	fa843783          	ld	a5,-88(s0)
    80201550:	03000513          	li	a0,48
    80201554:	000780e7          	jalr	a5
        ++written;
    80201558:	fe442783          	lw	a5,-28(s0)
    8020155c:	0017879b          	addiw	a5,a5,1
    80201560:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80201564:	fdc42783          	lw	a5,-36(s0)
    80201568:	0017879b          	addiw	a5,a5,1
    8020156c:	fcf42e23          	sw	a5,-36(s0)
    80201570:	f9043783          	ld	a5,-112(s0)
    80201574:	00c7a703          	lw	a4,12(a5)
    80201578:	fd744783          	lbu	a5,-41(s0)
    8020157c:	0007879b          	sext.w	a5,a5
    80201580:	40f707bb          	subw	a5,a4,a5
    80201584:	0007871b          	sext.w	a4,a5
    80201588:	fdc42783          	lw	a5,-36(s0)
    8020158c:	0007879b          	sext.w	a5,a5
    80201590:	fae7cee3          	blt	a5,a4,8020154c <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
    80201594:	fe842783          	lw	a5,-24(s0)
    80201598:	fff7879b          	addiw	a5,a5,-1
    8020159c:	fcf42c23          	sw	a5,-40(s0)
    802015a0:	03c0006f          	j	802015dc <print_dec_int+0x2e4>
        putch(buf[i]);
    802015a4:	fd842783          	lw	a5,-40(s0)
    802015a8:	ff078793          	addi	a5,a5,-16
    802015ac:	008787b3          	add	a5,a5,s0
    802015b0:	fc87c783          	lbu	a5,-56(a5)
    802015b4:	0007871b          	sext.w	a4,a5
    802015b8:	fa843783          	ld	a5,-88(s0)
    802015bc:	00070513          	mv	a0,a4
    802015c0:	000780e7          	jalr	a5
        ++written;
    802015c4:	fe442783          	lw	a5,-28(s0)
    802015c8:	0017879b          	addiw	a5,a5,1
    802015cc:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
    802015d0:	fd842783          	lw	a5,-40(s0)
    802015d4:	fff7879b          	addiw	a5,a5,-1
    802015d8:	fcf42c23          	sw	a5,-40(s0)
    802015dc:	fd842783          	lw	a5,-40(s0)
    802015e0:	0007879b          	sext.w	a5,a5
    802015e4:	fc07d0e3          	bgez	a5,802015a4 <print_dec_int+0x2ac>
    }

    return written;
    802015e8:	fe442783          	lw	a5,-28(s0)
}
    802015ec:	00078513          	mv	a0,a5
    802015f0:	06813083          	ld	ra,104(sp)
    802015f4:	06013403          	ld	s0,96(sp)
    802015f8:	07010113          	addi	sp,sp,112
    802015fc:	00008067          	ret

0000000080201600 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
    80201600:	f4010113          	addi	sp,sp,-192
    80201604:	0a113c23          	sd	ra,184(sp)
    80201608:	0a813823          	sd	s0,176(sp)
    8020160c:	0c010413          	addi	s0,sp,192
    80201610:	f4a43c23          	sd	a0,-168(s0)
    80201614:	f4b43823          	sd	a1,-176(s0)
    80201618:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
    8020161c:	f8043023          	sd	zero,-128(s0)
    80201620:	f8043423          	sd	zero,-120(s0)

    int written = 0;
    80201624:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
    80201628:	7a40006f          	j	80201dcc <vprintfmt+0x7cc>
        if (flags.in_format) {
    8020162c:	f8044783          	lbu	a5,-128(s0)
    80201630:	72078e63          	beqz	a5,80201d6c <vprintfmt+0x76c>
            if (*fmt == '#') {
    80201634:	f5043783          	ld	a5,-176(s0)
    80201638:	0007c783          	lbu	a5,0(a5)
    8020163c:	00078713          	mv	a4,a5
    80201640:	02300793          	li	a5,35
    80201644:	00f71863          	bne	a4,a5,80201654 <vprintfmt+0x54>
                flags.sharpflag = true;
    80201648:	00100793          	li	a5,1
    8020164c:	f8f40123          	sb	a5,-126(s0)
    80201650:	7700006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
    80201654:	f5043783          	ld	a5,-176(s0)
    80201658:	0007c783          	lbu	a5,0(a5)
    8020165c:	00078713          	mv	a4,a5
    80201660:	03000793          	li	a5,48
    80201664:	00f71863          	bne	a4,a5,80201674 <vprintfmt+0x74>
                flags.zeroflag = true;
    80201668:	00100793          	li	a5,1
    8020166c:	f8f401a3          	sb	a5,-125(s0)
    80201670:	7500006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
    80201674:	f5043783          	ld	a5,-176(s0)
    80201678:	0007c783          	lbu	a5,0(a5)
    8020167c:	00078713          	mv	a4,a5
    80201680:	06c00793          	li	a5,108
    80201684:	04f70063          	beq	a4,a5,802016c4 <vprintfmt+0xc4>
    80201688:	f5043783          	ld	a5,-176(s0)
    8020168c:	0007c783          	lbu	a5,0(a5)
    80201690:	00078713          	mv	a4,a5
    80201694:	07a00793          	li	a5,122
    80201698:	02f70663          	beq	a4,a5,802016c4 <vprintfmt+0xc4>
    8020169c:	f5043783          	ld	a5,-176(s0)
    802016a0:	0007c783          	lbu	a5,0(a5)
    802016a4:	00078713          	mv	a4,a5
    802016a8:	07400793          	li	a5,116
    802016ac:	00f70c63          	beq	a4,a5,802016c4 <vprintfmt+0xc4>
    802016b0:	f5043783          	ld	a5,-176(s0)
    802016b4:	0007c783          	lbu	a5,0(a5)
    802016b8:	00078713          	mv	a4,a5
    802016bc:	06a00793          	li	a5,106
    802016c0:	00f71863          	bne	a4,a5,802016d0 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
    802016c4:	00100793          	li	a5,1
    802016c8:	f8f400a3          	sb	a5,-127(s0)
    802016cc:	6f40006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
    802016d0:	f5043783          	ld	a5,-176(s0)
    802016d4:	0007c783          	lbu	a5,0(a5)
    802016d8:	00078713          	mv	a4,a5
    802016dc:	02b00793          	li	a5,43
    802016e0:	00f71863          	bne	a4,a5,802016f0 <vprintfmt+0xf0>
                flags.sign = true;
    802016e4:	00100793          	li	a5,1
    802016e8:	f8f402a3          	sb	a5,-123(s0)
    802016ec:	6d40006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
    802016f0:	f5043783          	ld	a5,-176(s0)
    802016f4:	0007c783          	lbu	a5,0(a5)
    802016f8:	00078713          	mv	a4,a5
    802016fc:	02000793          	li	a5,32
    80201700:	00f71863          	bne	a4,a5,80201710 <vprintfmt+0x110>
                flags.spaceflag = true;
    80201704:	00100793          	li	a5,1
    80201708:	f8f40223          	sb	a5,-124(s0)
    8020170c:	6b40006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
    80201710:	f5043783          	ld	a5,-176(s0)
    80201714:	0007c783          	lbu	a5,0(a5)
    80201718:	00078713          	mv	a4,a5
    8020171c:	02a00793          	li	a5,42
    80201720:	00f71e63          	bne	a4,a5,8020173c <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
    80201724:	f4843783          	ld	a5,-184(s0)
    80201728:	00878713          	addi	a4,a5,8
    8020172c:	f4e43423          	sd	a4,-184(s0)
    80201730:	0007a783          	lw	a5,0(a5)
    80201734:	f8f42423          	sw	a5,-120(s0)
    80201738:	6880006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
    8020173c:	f5043783          	ld	a5,-176(s0)
    80201740:	0007c783          	lbu	a5,0(a5)
    80201744:	00078713          	mv	a4,a5
    80201748:	03000793          	li	a5,48
    8020174c:	04e7f663          	bgeu	a5,a4,80201798 <vprintfmt+0x198>
    80201750:	f5043783          	ld	a5,-176(s0)
    80201754:	0007c783          	lbu	a5,0(a5)
    80201758:	00078713          	mv	a4,a5
    8020175c:	03900793          	li	a5,57
    80201760:	02e7ec63          	bltu	a5,a4,80201798 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
    80201764:	f5043783          	ld	a5,-176(s0)
    80201768:	f5040713          	addi	a4,s0,-176
    8020176c:	00a00613          	li	a2,10
    80201770:	00070593          	mv	a1,a4
    80201774:	00078513          	mv	a0,a5
    80201778:	88dff0ef          	jal	ra,80201004 <strtol>
    8020177c:	00050793          	mv	a5,a0
    80201780:	0007879b          	sext.w	a5,a5
    80201784:	f8f42423          	sw	a5,-120(s0)
                fmt--;
    80201788:	f5043783          	ld	a5,-176(s0)
    8020178c:	fff78793          	addi	a5,a5,-1
    80201790:	f4f43823          	sd	a5,-176(s0)
    80201794:	62c0006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
    80201798:	f5043783          	ld	a5,-176(s0)
    8020179c:	0007c783          	lbu	a5,0(a5)
    802017a0:	00078713          	mv	a4,a5
    802017a4:	02e00793          	li	a5,46
    802017a8:	06f71863          	bne	a4,a5,80201818 <vprintfmt+0x218>
                fmt++;
    802017ac:	f5043783          	ld	a5,-176(s0)
    802017b0:	00178793          	addi	a5,a5,1
    802017b4:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
    802017b8:	f5043783          	ld	a5,-176(s0)
    802017bc:	0007c783          	lbu	a5,0(a5)
    802017c0:	00078713          	mv	a4,a5
    802017c4:	02a00793          	li	a5,42
    802017c8:	00f71e63          	bne	a4,a5,802017e4 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
    802017cc:	f4843783          	ld	a5,-184(s0)
    802017d0:	00878713          	addi	a4,a5,8
    802017d4:	f4e43423          	sd	a4,-184(s0)
    802017d8:	0007a783          	lw	a5,0(a5)
    802017dc:	f8f42623          	sw	a5,-116(s0)
    802017e0:	5e00006f          	j	80201dc0 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
    802017e4:	f5043783          	ld	a5,-176(s0)
    802017e8:	f5040713          	addi	a4,s0,-176
    802017ec:	00a00613          	li	a2,10
    802017f0:	00070593          	mv	a1,a4
    802017f4:	00078513          	mv	a0,a5
    802017f8:	80dff0ef          	jal	ra,80201004 <strtol>
    802017fc:	00050793          	mv	a5,a0
    80201800:	0007879b          	sext.w	a5,a5
    80201804:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
    80201808:	f5043783          	ld	a5,-176(s0)
    8020180c:	fff78793          	addi	a5,a5,-1
    80201810:	f4f43823          	sd	a5,-176(s0)
    80201814:	5ac0006f          	j	80201dc0 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80201818:	f5043783          	ld	a5,-176(s0)
    8020181c:	0007c783          	lbu	a5,0(a5)
    80201820:	00078713          	mv	a4,a5
    80201824:	07800793          	li	a5,120
    80201828:	02f70663          	beq	a4,a5,80201854 <vprintfmt+0x254>
    8020182c:	f5043783          	ld	a5,-176(s0)
    80201830:	0007c783          	lbu	a5,0(a5)
    80201834:	00078713          	mv	a4,a5
    80201838:	05800793          	li	a5,88
    8020183c:	00f70c63          	beq	a4,a5,80201854 <vprintfmt+0x254>
    80201840:	f5043783          	ld	a5,-176(s0)
    80201844:	0007c783          	lbu	a5,0(a5)
    80201848:	00078713          	mv	a4,a5
    8020184c:	07000793          	li	a5,112
    80201850:	30f71263          	bne	a4,a5,80201b54 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
    80201854:	f5043783          	ld	a5,-176(s0)
    80201858:	0007c783          	lbu	a5,0(a5)
    8020185c:	00078713          	mv	a4,a5
    80201860:	07000793          	li	a5,112
    80201864:	00f70663          	beq	a4,a5,80201870 <vprintfmt+0x270>
    80201868:	f8144783          	lbu	a5,-127(s0)
    8020186c:	00078663          	beqz	a5,80201878 <vprintfmt+0x278>
    80201870:	00100793          	li	a5,1
    80201874:	0080006f          	j	8020187c <vprintfmt+0x27c>
    80201878:	00000793          	li	a5,0
    8020187c:	faf403a3          	sb	a5,-89(s0)
    80201880:	fa744783          	lbu	a5,-89(s0)
    80201884:	0017f793          	andi	a5,a5,1
    80201888:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
    8020188c:	fa744783          	lbu	a5,-89(s0)
    80201890:	0ff7f793          	zext.b	a5,a5
    80201894:	00078c63          	beqz	a5,802018ac <vprintfmt+0x2ac>
    80201898:	f4843783          	ld	a5,-184(s0)
    8020189c:	00878713          	addi	a4,a5,8
    802018a0:	f4e43423          	sd	a4,-184(s0)
    802018a4:	0007b783          	ld	a5,0(a5)
    802018a8:	01c0006f          	j	802018c4 <vprintfmt+0x2c4>
    802018ac:	f4843783          	ld	a5,-184(s0)
    802018b0:	00878713          	addi	a4,a5,8
    802018b4:	f4e43423          	sd	a4,-184(s0)
    802018b8:	0007a783          	lw	a5,0(a5)
    802018bc:	02079793          	slli	a5,a5,0x20
    802018c0:	0207d793          	srli	a5,a5,0x20
    802018c4:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
    802018c8:	f8c42783          	lw	a5,-116(s0)
    802018cc:	02079463          	bnez	a5,802018f4 <vprintfmt+0x2f4>
    802018d0:	fe043783          	ld	a5,-32(s0)
    802018d4:	02079063          	bnez	a5,802018f4 <vprintfmt+0x2f4>
    802018d8:	f5043783          	ld	a5,-176(s0)
    802018dc:	0007c783          	lbu	a5,0(a5)
    802018e0:	00078713          	mv	a4,a5
    802018e4:	07000793          	li	a5,112
    802018e8:	00f70663          	beq	a4,a5,802018f4 <vprintfmt+0x2f4>
                    flags.in_format = false;
    802018ec:	f8040023          	sb	zero,-128(s0)
    802018f0:	4d00006f          	j	80201dc0 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
    802018f4:	f5043783          	ld	a5,-176(s0)
    802018f8:	0007c783          	lbu	a5,0(a5)
    802018fc:	00078713          	mv	a4,a5
    80201900:	07000793          	li	a5,112
    80201904:	00f70a63          	beq	a4,a5,80201918 <vprintfmt+0x318>
    80201908:	f8244783          	lbu	a5,-126(s0)
    8020190c:	00078a63          	beqz	a5,80201920 <vprintfmt+0x320>
    80201910:	fe043783          	ld	a5,-32(s0)
    80201914:	00078663          	beqz	a5,80201920 <vprintfmt+0x320>
    80201918:	00100793          	li	a5,1
    8020191c:	0080006f          	j	80201924 <vprintfmt+0x324>
    80201920:	00000793          	li	a5,0
    80201924:	faf40323          	sb	a5,-90(s0)
    80201928:	fa644783          	lbu	a5,-90(s0)
    8020192c:	0017f793          	andi	a5,a5,1
    80201930:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
    80201934:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
    80201938:	f5043783          	ld	a5,-176(s0)
    8020193c:	0007c783          	lbu	a5,0(a5)
    80201940:	00078713          	mv	a4,a5
    80201944:	05800793          	li	a5,88
    80201948:	00f71863          	bne	a4,a5,80201958 <vprintfmt+0x358>
    8020194c:	00001797          	auipc	a5,0x1
    80201950:	91478793          	addi	a5,a5,-1772 # 80202260 <upperxdigits.1>
    80201954:	00c0006f          	j	80201960 <vprintfmt+0x360>
    80201958:	00001797          	auipc	a5,0x1
    8020195c:	92078793          	addi	a5,a5,-1760 # 80202278 <lowerxdigits.0>
    80201960:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
    80201964:	fe043783          	ld	a5,-32(s0)
    80201968:	00f7f793          	andi	a5,a5,15
    8020196c:	f9843703          	ld	a4,-104(s0)
    80201970:	00f70733          	add	a4,a4,a5
    80201974:	fdc42783          	lw	a5,-36(s0)
    80201978:	0017869b          	addiw	a3,a5,1
    8020197c:	fcd42e23          	sw	a3,-36(s0)
    80201980:	00074703          	lbu	a4,0(a4)
    80201984:	ff078793          	addi	a5,a5,-16
    80201988:	008787b3          	add	a5,a5,s0
    8020198c:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
    80201990:	fe043783          	ld	a5,-32(s0)
    80201994:	0047d793          	srli	a5,a5,0x4
    80201998:	fef43023          	sd	a5,-32(s0)
                } while (num);
    8020199c:	fe043783          	ld	a5,-32(s0)
    802019a0:	fc0792e3          	bnez	a5,80201964 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
    802019a4:	f8c42783          	lw	a5,-116(s0)
    802019a8:	00078713          	mv	a4,a5
    802019ac:	fff00793          	li	a5,-1
    802019b0:	02f71663          	bne	a4,a5,802019dc <vprintfmt+0x3dc>
    802019b4:	f8344783          	lbu	a5,-125(s0)
    802019b8:	02078263          	beqz	a5,802019dc <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
    802019bc:	f8842703          	lw	a4,-120(s0)
    802019c0:	fa644783          	lbu	a5,-90(s0)
    802019c4:	0007879b          	sext.w	a5,a5
    802019c8:	0017979b          	slliw	a5,a5,0x1
    802019cc:	0007879b          	sext.w	a5,a5
    802019d0:	40f707bb          	subw	a5,a4,a5
    802019d4:	0007879b          	sext.w	a5,a5
    802019d8:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    802019dc:	f8842703          	lw	a4,-120(s0)
    802019e0:	fa644783          	lbu	a5,-90(s0)
    802019e4:	0007879b          	sext.w	a5,a5
    802019e8:	0017979b          	slliw	a5,a5,0x1
    802019ec:	0007879b          	sext.w	a5,a5
    802019f0:	40f707bb          	subw	a5,a4,a5
    802019f4:	0007871b          	sext.w	a4,a5
    802019f8:	fdc42783          	lw	a5,-36(s0)
    802019fc:	f8f42a23          	sw	a5,-108(s0)
    80201a00:	f8c42783          	lw	a5,-116(s0)
    80201a04:	f8f42823          	sw	a5,-112(s0)
    80201a08:	f9442783          	lw	a5,-108(s0)
    80201a0c:	00078593          	mv	a1,a5
    80201a10:	f9042783          	lw	a5,-112(s0)
    80201a14:	00078613          	mv	a2,a5
    80201a18:	0006069b          	sext.w	a3,a2
    80201a1c:	0005879b          	sext.w	a5,a1
    80201a20:	00f6d463          	bge	a3,a5,80201a28 <vprintfmt+0x428>
    80201a24:	00058613          	mv	a2,a1
    80201a28:	0006079b          	sext.w	a5,a2
    80201a2c:	40f707bb          	subw	a5,a4,a5
    80201a30:	fcf42c23          	sw	a5,-40(s0)
    80201a34:	0280006f          	j	80201a5c <vprintfmt+0x45c>
                    putch(' ');
    80201a38:	f5843783          	ld	a5,-168(s0)
    80201a3c:	02000513          	li	a0,32
    80201a40:	000780e7          	jalr	a5
                    ++written;
    80201a44:	fec42783          	lw	a5,-20(s0)
    80201a48:	0017879b          	addiw	a5,a5,1
    80201a4c:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201a50:	fd842783          	lw	a5,-40(s0)
    80201a54:	fff7879b          	addiw	a5,a5,-1
    80201a58:	fcf42c23          	sw	a5,-40(s0)
    80201a5c:	fd842783          	lw	a5,-40(s0)
    80201a60:	0007879b          	sext.w	a5,a5
    80201a64:	fcf04ae3          	bgtz	a5,80201a38 <vprintfmt+0x438>
                }

                if (prefix) {
    80201a68:	fa644783          	lbu	a5,-90(s0)
    80201a6c:	0ff7f793          	zext.b	a5,a5
    80201a70:	04078463          	beqz	a5,80201ab8 <vprintfmt+0x4b8>
                    putch('0');
    80201a74:	f5843783          	ld	a5,-168(s0)
    80201a78:	03000513          	li	a0,48
    80201a7c:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
    80201a80:	f5043783          	ld	a5,-176(s0)
    80201a84:	0007c783          	lbu	a5,0(a5)
    80201a88:	00078713          	mv	a4,a5
    80201a8c:	05800793          	li	a5,88
    80201a90:	00f71663          	bne	a4,a5,80201a9c <vprintfmt+0x49c>
    80201a94:	05800793          	li	a5,88
    80201a98:	0080006f          	j	80201aa0 <vprintfmt+0x4a0>
    80201a9c:	07800793          	li	a5,120
    80201aa0:	f5843703          	ld	a4,-168(s0)
    80201aa4:	00078513          	mv	a0,a5
    80201aa8:	000700e7          	jalr	a4
                    written += 2;
    80201aac:	fec42783          	lw	a5,-20(s0)
    80201ab0:	0027879b          	addiw	a5,a5,2
    80201ab4:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
    80201ab8:	fdc42783          	lw	a5,-36(s0)
    80201abc:	fcf42a23          	sw	a5,-44(s0)
    80201ac0:	0280006f          	j	80201ae8 <vprintfmt+0x4e8>
                    putch('0');
    80201ac4:	f5843783          	ld	a5,-168(s0)
    80201ac8:	03000513          	li	a0,48
    80201acc:	000780e7          	jalr	a5
                    ++written;
    80201ad0:	fec42783          	lw	a5,-20(s0)
    80201ad4:	0017879b          	addiw	a5,a5,1
    80201ad8:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
    80201adc:	fd442783          	lw	a5,-44(s0)
    80201ae0:	0017879b          	addiw	a5,a5,1
    80201ae4:	fcf42a23          	sw	a5,-44(s0)
    80201ae8:	f8c42703          	lw	a4,-116(s0)
    80201aec:	fd442783          	lw	a5,-44(s0)
    80201af0:	0007879b          	sext.w	a5,a5
    80201af4:	fce7c8e3          	blt	a5,a4,80201ac4 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
    80201af8:	fdc42783          	lw	a5,-36(s0)
    80201afc:	fff7879b          	addiw	a5,a5,-1
    80201b00:	fcf42823          	sw	a5,-48(s0)
    80201b04:	03c0006f          	j	80201b40 <vprintfmt+0x540>
                    putch(buf[i]);
    80201b08:	fd042783          	lw	a5,-48(s0)
    80201b0c:	ff078793          	addi	a5,a5,-16
    80201b10:	008787b3          	add	a5,a5,s0
    80201b14:	f807c783          	lbu	a5,-128(a5)
    80201b18:	0007871b          	sext.w	a4,a5
    80201b1c:	f5843783          	ld	a5,-168(s0)
    80201b20:	00070513          	mv	a0,a4
    80201b24:	000780e7          	jalr	a5
                    ++written;
    80201b28:	fec42783          	lw	a5,-20(s0)
    80201b2c:	0017879b          	addiw	a5,a5,1
    80201b30:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
    80201b34:	fd042783          	lw	a5,-48(s0)
    80201b38:	fff7879b          	addiw	a5,a5,-1
    80201b3c:	fcf42823          	sw	a5,-48(s0)
    80201b40:	fd042783          	lw	a5,-48(s0)
    80201b44:	0007879b          	sext.w	a5,a5
    80201b48:	fc07d0e3          	bgez	a5,80201b08 <vprintfmt+0x508>
                }

                flags.in_format = false;
    80201b4c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80201b50:	2700006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201b54:	f5043783          	ld	a5,-176(s0)
    80201b58:	0007c783          	lbu	a5,0(a5)
    80201b5c:	00078713          	mv	a4,a5
    80201b60:	06400793          	li	a5,100
    80201b64:	02f70663          	beq	a4,a5,80201b90 <vprintfmt+0x590>
    80201b68:	f5043783          	ld	a5,-176(s0)
    80201b6c:	0007c783          	lbu	a5,0(a5)
    80201b70:	00078713          	mv	a4,a5
    80201b74:	06900793          	li	a5,105
    80201b78:	00f70c63          	beq	a4,a5,80201b90 <vprintfmt+0x590>
    80201b7c:	f5043783          	ld	a5,-176(s0)
    80201b80:	0007c783          	lbu	a5,0(a5)
    80201b84:	00078713          	mv	a4,a5
    80201b88:	07500793          	li	a5,117
    80201b8c:	08f71063          	bne	a4,a5,80201c0c <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
    80201b90:	f8144783          	lbu	a5,-127(s0)
    80201b94:	00078c63          	beqz	a5,80201bac <vprintfmt+0x5ac>
    80201b98:	f4843783          	ld	a5,-184(s0)
    80201b9c:	00878713          	addi	a4,a5,8
    80201ba0:	f4e43423          	sd	a4,-184(s0)
    80201ba4:	0007b783          	ld	a5,0(a5)
    80201ba8:	0140006f          	j	80201bbc <vprintfmt+0x5bc>
    80201bac:	f4843783          	ld	a5,-184(s0)
    80201bb0:	00878713          	addi	a4,a5,8
    80201bb4:	f4e43423          	sd	a4,-184(s0)
    80201bb8:	0007a783          	lw	a5,0(a5)
    80201bbc:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
    80201bc0:	fa843583          	ld	a1,-88(s0)
    80201bc4:	f5043783          	ld	a5,-176(s0)
    80201bc8:	0007c783          	lbu	a5,0(a5)
    80201bcc:	0007871b          	sext.w	a4,a5
    80201bd0:	07500793          	li	a5,117
    80201bd4:	40f707b3          	sub	a5,a4,a5
    80201bd8:	00f037b3          	snez	a5,a5
    80201bdc:	0ff7f793          	zext.b	a5,a5
    80201be0:	f8040713          	addi	a4,s0,-128
    80201be4:	00070693          	mv	a3,a4
    80201be8:	00078613          	mv	a2,a5
    80201bec:	f5843503          	ld	a0,-168(s0)
    80201bf0:	f08ff0ef          	jal	ra,802012f8 <print_dec_int>
    80201bf4:	00050793          	mv	a5,a0
    80201bf8:	fec42703          	lw	a4,-20(s0)
    80201bfc:	00f707bb          	addw	a5,a4,a5
    80201c00:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201c04:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201c08:	1b80006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
    80201c0c:	f5043783          	ld	a5,-176(s0)
    80201c10:	0007c783          	lbu	a5,0(a5)
    80201c14:	00078713          	mv	a4,a5
    80201c18:	06e00793          	li	a5,110
    80201c1c:	04f71c63          	bne	a4,a5,80201c74 <vprintfmt+0x674>
                if (flags.longflag) {
    80201c20:	f8144783          	lbu	a5,-127(s0)
    80201c24:	02078463          	beqz	a5,80201c4c <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
    80201c28:	f4843783          	ld	a5,-184(s0)
    80201c2c:	00878713          	addi	a4,a5,8
    80201c30:	f4e43423          	sd	a4,-184(s0)
    80201c34:	0007b783          	ld	a5,0(a5)
    80201c38:	faf43823          	sd	a5,-80(s0)
                    *n = written;
    80201c3c:	fec42703          	lw	a4,-20(s0)
    80201c40:	fb043783          	ld	a5,-80(s0)
    80201c44:	00e7b023          	sd	a4,0(a5)
    80201c48:	0240006f          	j	80201c6c <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
    80201c4c:	f4843783          	ld	a5,-184(s0)
    80201c50:	00878713          	addi	a4,a5,8
    80201c54:	f4e43423          	sd	a4,-184(s0)
    80201c58:	0007b783          	ld	a5,0(a5)
    80201c5c:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
    80201c60:	fb843783          	ld	a5,-72(s0)
    80201c64:	fec42703          	lw	a4,-20(s0)
    80201c68:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
    80201c6c:	f8040023          	sb	zero,-128(s0)
    80201c70:	1500006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
    80201c74:	f5043783          	ld	a5,-176(s0)
    80201c78:	0007c783          	lbu	a5,0(a5)
    80201c7c:	00078713          	mv	a4,a5
    80201c80:	07300793          	li	a5,115
    80201c84:	02f71e63          	bne	a4,a5,80201cc0 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
    80201c88:	f4843783          	ld	a5,-184(s0)
    80201c8c:	00878713          	addi	a4,a5,8
    80201c90:	f4e43423          	sd	a4,-184(s0)
    80201c94:	0007b783          	ld	a5,0(a5)
    80201c98:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
    80201c9c:	fc043583          	ld	a1,-64(s0)
    80201ca0:	f5843503          	ld	a0,-168(s0)
    80201ca4:	dccff0ef          	jal	ra,80201270 <puts_wo_nl>
    80201ca8:	00050793          	mv	a5,a0
    80201cac:	fec42703          	lw	a4,-20(s0)
    80201cb0:	00f707bb          	addw	a5,a4,a5
    80201cb4:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201cb8:	f8040023          	sb	zero,-128(s0)
    80201cbc:	1040006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
    80201cc0:	f5043783          	ld	a5,-176(s0)
    80201cc4:	0007c783          	lbu	a5,0(a5)
    80201cc8:	00078713          	mv	a4,a5
    80201ccc:	06300793          	li	a5,99
    80201cd0:	02f71e63          	bne	a4,a5,80201d0c <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
    80201cd4:	f4843783          	ld	a5,-184(s0)
    80201cd8:	00878713          	addi	a4,a5,8
    80201cdc:	f4e43423          	sd	a4,-184(s0)
    80201ce0:	0007a783          	lw	a5,0(a5)
    80201ce4:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
    80201ce8:	fcc42703          	lw	a4,-52(s0)
    80201cec:	f5843783          	ld	a5,-168(s0)
    80201cf0:	00070513          	mv	a0,a4
    80201cf4:	000780e7          	jalr	a5
                ++written;
    80201cf8:	fec42783          	lw	a5,-20(s0)
    80201cfc:	0017879b          	addiw	a5,a5,1
    80201d00:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201d04:	f8040023          	sb	zero,-128(s0)
    80201d08:	0b80006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
    80201d0c:	f5043783          	ld	a5,-176(s0)
    80201d10:	0007c783          	lbu	a5,0(a5)
    80201d14:	00078713          	mv	a4,a5
    80201d18:	02500793          	li	a5,37
    80201d1c:	02f71263          	bne	a4,a5,80201d40 <vprintfmt+0x740>
                putch('%');
    80201d20:	f5843783          	ld	a5,-168(s0)
    80201d24:	02500513          	li	a0,37
    80201d28:	000780e7          	jalr	a5
                ++written;
    80201d2c:	fec42783          	lw	a5,-20(s0)
    80201d30:	0017879b          	addiw	a5,a5,1
    80201d34:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201d38:	f8040023          	sb	zero,-128(s0)
    80201d3c:	0840006f          	j	80201dc0 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
    80201d40:	f5043783          	ld	a5,-176(s0)
    80201d44:	0007c783          	lbu	a5,0(a5)
    80201d48:	0007871b          	sext.w	a4,a5
    80201d4c:	f5843783          	ld	a5,-168(s0)
    80201d50:	00070513          	mv	a0,a4
    80201d54:	000780e7          	jalr	a5
                ++written;
    80201d58:	fec42783          	lw	a5,-20(s0)
    80201d5c:	0017879b          	addiw	a5,a5,1
    80201d60:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201d64:	f8040023          	sb	zero,-128(s0)
    80201d68:	0580006f          	j	80201dc0 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
    80201d6c:	f5043783          	ld	a5,-176(s0)
    80201d70:	0007c783          	lbu	a5,0(a5)
    80201d74:	00078713          	mv	a4,a5
    80201d78:	02500793          	li	a5,37
    80201d7c:	02f71063          	bne	a4,a5,80201d9c <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
    80201d80:	f8043023          	sd	zero,-128(s0)
    80201d84:	f8043423          	sd	zero,-120(s0)
    80201d88:	00100793          	li	a5,1
    80201d8c:	f8f40023          	sb	a5,-128(s0)
    80201d90:	fff00793          	li	a5,-1
    80201d94:	f8f42623          	sw	a5,-116(s0)
    80201d98:	0280006f          	j	80201dc0 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
    80201d9c:	f5043783          	ld	a5,-176(s0)
    80201da0:	0007c783          	lbu	a5,0(a5)
    80201da4:	0007871b          	sext.w	a4,a5
    80201da8:	f5843783          	ld	a5,-168(s0)
    80201dac:	00070513          	mv	a0,a4
    80201db0:	000780e7          	jalr	a5
            ++written;
    80201db4:	fec42783          	lw	a5,-20(s0)
    80201db8:	0017879b          	addiw	a5,a5,1
    80201dbc:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
    80201dc0:	f5043783          	ld	a5,-176(s0)
    80201dc4:	00178793          	addi	a5,a5,1
    80201dc8:	f4f43823          	sd	a5,-176(s0)
    80201dcc:	f5043783          	ld	a5,-176(s0)
    80201dd0:	0007c783          	lbu	a5,0(a5)
    80201dd4:	84079ce3          	bnez	a5,8020162c <vprintfmt+0x2c>
        }
    }

    return written;
    80201dd8:	fec42783          	lw	a5,-20(s0)
}
    80201ddc:	00078513          	mv	a0,a5
    80201de0:	0b813083          	ld	ra,184(sp)
    80201de4:	0b013403          	ld	s0,176(sp)
    80201de8:	0c010113          	addi	sp,sp,192
    80201dec:	00008067          	ret

0000000080201df0 <printk>:

int printk(const char* s, ...) {
    80201df0:	f9010113          	addi	sp,sp,-112
    80201df4:	02113423          	sd	ra,40(sp)
    80201df8:	02813023          	sd	s0,32(sp)
    80201dfc:	03010413          	addi	s0,sp,48
    80201e00:	fca43c23          	sd	a0,-40(s0)
    80201e04:	00b43423          	sd	a1,8(s0)
    80201e08:	00c43823          	sd	a2,16(s0)
    80201e0c:	00d43c23          	sd	a3,24(s0)
    80201e10:	02e43023          	sd	a4,32(s0)
    80201e14:	02f43423          	sd	a5,40(s0)
    80201e18:	03043823          	sd	a6,48(s0)
    80201e1c:	03143c23          	sd	a7,56(s0)
    int res = 0;
    80201e20:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    80201e24:	04040793          	addi	a5,s0,64
    80201e28:	fcf43823          	sd	a5,-48(s0)
    80201e2c:	fd043783          	ld	a5,-48(s0)
    80201e30:	fc878793          	addi	a5,a5,-56
    80201e34:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    80201e38:	fe043783          	ld	a5,-32(s0)
    80201e3c:	00078613          	mv	a2,a5
    80201e40:	fd843583          	ld	a1,-40(s0)
    80201e44:	fffff517          	auipc	a0,0xfffff
    80201e48:	11850513          	addi	a0,a0,280 # 80200f5c <putc>
    80201e4c:	fb4ff0ef          	jal	ra,80201600 <vprintfmt>
    80201e50:	00050793          	mv	a5,a0
    80201e54:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    80201e58:	fec42783          	lw	a5,-20(s0)
}
    80201e5c:	00078513          	mv	a0,a5
    80201e60:	02813083          	ld	ra,40(sp)
    80201e64:	02013403          	ld	s0,32(sp)
    80201e68:	07010113          	addi	sp,sp,112
    80201e6c:	00008067          	ret

0000000080201e70 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
    80201e70:	fe010113          	addi	sp,sp,-32
    80201e74:	00813c23          	sd	s0,24(sp)
    80201e78:	02010413          	addi	s0,sp,32
    80201e7c:	00050793          	mv	a5,a0
    80201e80:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
    80201e84:	fec42783          	lw	a5,-20(s0)
    80201e88:	fff7879b          	addiw	a5,a5,-1
    80201e8c:	0007879b          	sext.w	a5,a5
    80201e90:	02079713          	slli	a4,a5,0x20
    80201e94:	02075713          	srli	a4,a4,0x20
    80201e98:	00003797          	auipc	a5,0x3
    80201e9c:	28878793          	addi	a5,a5,648 # 80205120 <seed>
    80201ea0:	00e7b023          	sd	a4,0(a5)
}
    80201ea4:	00000013          	nop
    80201ea8:	01813403          	ld	s0,24(sp)
    80201eac:	02010113          	addi	sp,sp,32
    80201eb0:	00008067          	ret

0000000080201eb4 <rand>:

int rand(void) {
    80201eb4:	ff010113          	addi	sp,sp,-16
    80201eb8:	00813423          	sd	s0,8(sp)
    80201ebc:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
    80201ec0:	00003797          	auipc	a5,0x3
    80201ec4:	26078793          	addi	a5,a5,608 # 80205120 <seed>
    80201ec8:	0007b703          	ld	a4,0(a5)
    80201ecc:	00000797          	auipc	a5,0x0
    80201ed0:	3c478793          	addi	a5,a5,964 # 80202290 <lowerxdigits.0+0x18>
    80201ed4:	0007b783          	ld	a5,0(a5)
    80201ed8:	02f707b3          	mul	a5,a4,a5
    80201edc:	00178713          	addi	a4,a5,1
    80201ee0:	00003797          	auipc	a5,0x3
    80201ee4:	24078793          	addi	a5,a5,576 # 80205120 <seed>
    80201ee8:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
    80201eec:	00003797          	auipc	a5,0x3
    80201ef0:	23478793          	addi	a5,a5,564 # 80205120 <seed>
    80201ef4:	0007b783          	ld	a5,0(a5)
    80201ef8:	0217d793          	srli	a5,a5,0x21
    80201efc:	0007879b          	sext.w	a5,a5
}
    80201f00:	00078513          	mv	a0,a5
    80201f04:	00813403          	ld	s0,8(sp)
    80201f08:	01010113          	addi	sp,sp,16
    80201f0c:	00008067          	ret

0000000080201f10 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
    80201f10:	fc010113          	addi	sp,sp,-64
    80201f14:	02813c23          	sd	s0,56(sp)
    80201f18:	04010413          	addi	s0,sp,64
    80201f1c:	fca43c23          	sd	a0,-40(s0)
    80201f20:	00058793          	mv	a5,a1
    80201f24:	fcc43423          	sd	a2,-56(s0)
    80201f28:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
    80201f2c:	fd843783          	ld	a5,-40(s0)
    80201f30:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
    80201f34:	fe043423          	sd	zero,-24(s0)
    80201f38:	0280006f          	j	80201f60 <memset+0x50>
        s[i] = c;
    80201f3c:	fe043703          	ld	a4,-32(s0)
    80201f40:	fe843783          	ld	a5,-24(s0)
    80201f44:	00f707b3          	add	a5,a4,a5
    80201f48:	fd442703          	lw	a4,-44(s0)
    80201f4c:	0ff77713          	zext.b	a4,a4
    80201f50:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
    80201f54:	fe843783          	ld	a5,-24(s0)
    80201f58:	00178793          	addi	a5,a5,1
    80201f5c:	fef43423          	sd	a5,-24(s0)
    80201f60:	fe843703          	ld	a4,-24(s0)
    80201f64:	fc843783          	ld	a5,-56(s0)
    80201f68:	fcf76ae3          	bltu	a4,a5,80201f3c <memset+0x2c>
    }
    return dest;
    80201f6c:	fd843783          	ld	a5,-40(s0)
}
    80201f70:	00078513          	mv	a0,a5
    80201f74:	03813403          	ld	s0,56(sp)
    80201f78:	04010113          	addi	sp,sp,64
    80201f7c:	00008067          	ret
