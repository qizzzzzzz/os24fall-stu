
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_skernel>:
    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    la sp, boot_stack_top
    80200000:	00003117          	auipc	sp,0x3
    80200004:	01013103          	ld	sp,16(sp) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>

    # set stvec = _traps
    la t0, _traps
    80200008:	00003297          	auipc	t0,0x3
    8020000c:	0102b283          	ld	t0,16(t0) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    csrw stvec, t0
    80200010:	10529073          	csrw	stvec,t0

    # set sie[STIE] = 1
    li t0, 32
    80200014:	02000293          	li	t0,32
    csrs sie, t0
    80200018:	1042a073          	csrs	sie,t0

    # set first time interrupt
    rdtime t0
    8020001c:	c01022f3          	rdtime	t0
    li t1, 10000000
    80200020:	00989337          	lui	t1,0x989
    80200024:	6803031b          	addiw	t1,t1,1664 # 989680 <_skernel-0x7f876980>

    add a2, t0, t1
    80200028:	00628633          	add	a2,t0,t1

    li a0, 0
    8020002c:	00000513          	li	a0,0
    li a1, 0
    80200030:	00000593          	li	a1,0
    li a3, 0
    80200034:	00000693          	li	a3,0
    li a4, 0
    80200038:	00000713          	li	a4,0
    li a5, 0
    8020003c:	00000793          	li	a5,0
    li a6, 0
    80200040:	00000813          	li	a6,0
    li a7, 0
    80200044:	00000893          	li	a7,0

    call sbi_ecall
    80200048:	1a4000ef          	jal	ra,802001ec <sbi_ecall>

    # set sstatus[SIE] = 1
    csrs sstatus, 2
    8020004c:	10016073          	csrsi	sstatus,2


    call start_kernel
    80200050:	4bc000ef          	jal	ra,8020050c <start_kernel>

0000000080200054 <_traps>:
    .section .text.entry
    .align 2
    .globl _traps
_traps:
    # 1. save 32 registers and sepc to stack
    addi sp, sp, -264 # 8*33
    80200054:	ef810113          	addi	sp,sp,-264

    sd x0, 0(sp)
    80200058:	00013023          	sd	zero,0(sp)
    sd x1, 8(sp)
    8020005c:	00113423          	sd	ra,8(sp)
    sd x2, 16(sp)
    80200060:	00213823          	sd	sp,16(sp)
    sd x3, 24(sp)
    80200064:	00313c23          	sd	gp,24(sp)
    sd x4, 32(sp)
    80200068:	02413023          	sd	tp,32(sp)
    sd x5, 40(sp)
    8020006c:	02513423          	sd	t0,40(sp)
    sd x6, 48(sp)
    80200070:	02613823          	sd	t1,48(sp)
    sd x7, 56(sp)
    80200074:	02713c23          	sd	t2,56(sp)
    sd x8, 64(sp)
    80200078:	04813023          	sd	s0,64(sp)
    sd x9, 72(sp)
    8020007c:	04913423          	sd	s1,72(sp)
    sd x10, 80(sp)
    80200080:	04a13823          	sd	a0,80(sp)
    sd x11, 88(sp)
    80200084:	04b13c23          	sd	a1,88(sp)
    sd x12, 96(sp)
    80200088:	06c13023          	sd	a2,96(sp)
    sd x13, 104(sp)
    8020008c:	06d13423          	sd	a3,104(sp)
    sd x14, 112(sp)
    80200090:	06e13823          	sd	a4,112(sp)
    sd x15, 120(sp)
    80200094:	06f13c23          	sd	a5,120(sp)
    sd x16, 128(sp)
    80200098:	09013023          	sd	a6,128(sp)
    sd x17, 136(sp)
    8020009c:	09113423          	sd	a7,136(sp)
    sd x18, 144(sp)
    802000a0:	09213823          	sd	s2,144(sp)
    sd x19, 152(sp)
    802000a4:	09313c23          	sd	s3,152(sp)
    sd x20, 160(sp)
    802000a8:	0b413023          	sd	s4,160(sp)
    sd x21, 168(sp)
    802000ac:	0b513423          	sd	s5,168(sp)
    sd x22, 176(sp)
    802000b0:	0b613823          	sd	s6,176(sp)
    sd x23, 184(sp)
    802000b4:	0b713c23          	sd	s7,184(sp)
    sd x24, 192(sp)
    802000b8:	0d813023          	sd	s8,192(sp)
    sd x25, 200(sp)
    802000bc:	0d913423          	sd	s9,200(sp)
    sd x26, 208(sp)
    802000c0:	0da13823          	sd	s10,208(sp)
    sd x27, 216(sp)
    802000c4:	0db13c23          	sd	s11,216(sp)
    sd x28, 224(sp)
    802000c8:	0fc13023          	sd	t3,224(sp)
    sd x29, 232(sp)
    802000cc:	0fd13423          	sd	t4,232(sp)
    sd x30, 240(sp)
    802000d0:	0fe13823          	sd	t5,240(sp)
    sd x31, 248(sp)
    802000d4:	0ff13c23          	sd	t6,248(sp)

    csrr t0, sepc
    802000d8:	141022f3          	csrr	t0,sepc
    sd t0, 256(sp)
    802000dc:	10513023          	sd	t0,256(sp)

    # 2. call trap_handler
    csrr a0, scause
    802000e0:	14202573          	csrr	a0,scause
    csrr a1, sepc
    802000e4:	141025f3          	csrr	a1,sepc
    call trap_handler
    802000e8:	390000ef          	jal	ra,80200478 <trap_handler>

    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld x0, 0(sp)
    802000ec:	00013003          	ld	zero,0(sp)
    ld x1, 8(sp)
    802000f0:	00813083          	ld	ra,8(sp)
    ld x2, 16(sp)
    802000f4:	01013103          	ld	sp,16(sp)
    ld x3, 24(sp)
    802000f8:	01813183          	ld	gp,24(sp)
    ld x4, 32(sp)
    802000fc:	02013203          	ld	tp,32(sp)
    ld x5, 40(sp)
    80200100:	02813283          	ld	t0,40(sp)
    ld x6, 48(sp)
    80200104:	03013303          	ld	t1,48(sp)
    ld x7, 56(sp)
    80200108:	03813383          	ld	t2,56(sp)
    ld x8, 64(sp)
    8020010c:	04013403          	ld	s0,64(sp)
    ld x9, 72(sp)
    80200110:	04813483          	ld	s1,72(sp)
    ld x10, 80(sp)
    80200114:	05013503          	ld	a0,80(sp)
    ld x11, 88(sp)
    80200118:	05813583          	ld	a1,88(sp)
    ld x12, 96(sp)
    8020011c:	06013603          	ld	a2,96(sp)
    ld x13, 104(sp)
    80200120:	06813683          	ld	a3,104(sp)
    ld x14, 112(sp)
    80200124:	07013703          	ld	a4,112(sp)
    ld x15, 120(sp)
    80200128:	07813783          	ld	a5,120(sp)
    ld x16, 128(sp)
    8020012c:	08013803          	ld	a6,128(sp)
    ld x17, 136(sp)
    80200130:	08813883          	ld	a7,136(sp)
    ld x18, 144(sp)
    80200134:	09013903          	ld	s2,144(sp)
    ld x19, 152(sp)
    80200138:	09813983          	ld	s3,152(sp)
    ld x20, 160(sp)
    8020013c:	0a013a03          	ld	s4,160(sp)
    ld x21, 168(sp)
    80200140:	0a813a83          	ld	s5,168(sp)
    ld x22, 176(sp)
    80200144:	0b013b03          	ld	s6,176(sp)
    ld x23, 184(sp)
    80200148:	0b813b83          	ld	s7,184(sp)
    ld x24, 192(sp)
    8020014c:	0c013c03          	ld	s8,192(sp)
    ld x25, 200(sp)
    80200150:	0c813c83          	ld	s9,200(sp)
    ld x26, 208(sp)
    80200154:	0d013d03          	ld	s10,208(sp)
    ld x27, 216(sp)
    80200158:	0d813d83          	ld	s11,216(sp)
    ld x28, 224(sp)
    8020015c:	0e013e03          	ld	t3,224(sp)
    ld x29, 232(sp)
    80200160:	0e813e83          	ld	t4,232(sp)
    ld x30, 240(sp)
    80200164:	0f013f03          	ld	t5,240(sp)
    ld x31, 248(sp)
    80200168:	0f813f83          	ld	t6,248(sp)

    ld t0, 256(sp)
    8020016c:	10013283          	ld	t0,256(sp)
    csrw sepc, t0
    80200170:	14129073          	csrw	sepc,t0

    addi sp, sp, 264
    80200174:	10810113          	addi	sp,sp,264

    # 4. return from trap
    80200178:	10200073          	sret

000000008020017c <get_cycles>:
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
    8020017c:	fe010113          	addi	sp,sp,-32
    80200180:	00813c23          	sd	s0,24(sp)
    80200184:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t res;
    __asm__ volatile (
    80200188:	c01027f3          	rdtime	a5
    8020018c:	fef43423          	sd	a5,-24(s0)
        "rdtime %0\n"
        :"=r"(res)
        :
        :
    );
    return res;
    80200190:	fe843783          	ld	a5,-24(s0)
}
    80200194:	00078513          	mv	a0,a5
    80200198:	01813403          	ld	s0,24(sp)
    8020019c:	02010113          	addi	sp,sp,32
    802001a0:	00008067          	ret

00000000802001a4 <clock_set_next_event>:

void clock_set_next_event() {
    802001a4:	fe010113          	addi	sp,sp,-32
    802001a8:	00113c23          	sd	ra,24(sp)
    802001ac:	00813823          	sd	s0,16(sp)
    802001b0:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
    802001b4:	fc9ff0ef          	jal	ra,8020017c <get_cycles>
    802001b8:	00050713          	mv	a4,a0
    802001bc:	00003797          	auipc	a5,0x3
    802001c0:	e4478793          	addi	a5,a5,-444 # 80203000 <TIMECLOCK>
    802001c4:	0007b783          	ld	a5,0(a5)
    802001c8:	00f707b3          	add	a5,a4,a5
    802001cc:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
    802001d0:	fe843503          	ld	a0,-24(s0)
    802001d4:	218000ef          	jal	ra,802003ec <sbi_set_timer>

    return;
    802001d8:	00000013          	nop
    802001dc:	01813083          	ld	ra,24(sp)
    802001e0:	01013403          	ld	s0,16(sp)
    802001e4:	02010113          	addi	sp,sp,32
    802001e8:	00008067          	ret

00000000802001ec <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    802001ec:	f8010113          	addi	sp,sp,-128
    802001f0:	06813c23          	sd	s0,120(sp)
    802001f4:	06913823          	sd	s1,112(sp)
    802001f8:	07213423          	sd	s2,104(sp)
    802001fc:	07313023          	sd	s3,96(sp)
    80200200:	08010413          	addi	s0,sp,128
    80200204:	faa43c23          	sd	a0,-72(s0)
    80200208:	fab43823          	sd	a1,-80(s0)
    8020020c:	fac43423          	sd	a2,-88(s0)
    80200210:	fad43023          	sd	a3,-96(s0)
    80200214:	f8e43c23          	sd	a4,-104(s0)
    80200218:	f8f43823          	sd	a5,-112(s0)
    8020021c:	f9043423          	sd	a6,-120(s0)
    80200220:	f9143023          	sd	a7,-128(s0)
    struct sbiret res;
    __asm__ volatile (
    80200224:	fb843e03          	ld	t3,-72(s0)
    80200228:	fb043e83          	ld	t4,-80(s0)
    8020022c:	fa843f03          	ld	t5,-88(s0)
    80200230:	fa043f83          	ld	t6,-96(s0)
    80200234:	f9843283          	ld	t0,-104(s0)
    80200238:	f9043483          	ld	s1,-112(s0)
    8020023c:	f8843903          	ld	s2,-120(s0)
    80200240:	f8043983          	ld	s3,-128(s0)
    80200244:	000e0893          	mv	a7,t3
    80200248:	000e8813          	mv	a6,t4
    8020024c:	000f0513          	mv	a0,t5
    80200250:	000f8593          	mv	a1,t6
    80200254:	00028613          	mv	a2,t0
    80200258:	00048693          	mv	a3,s1
    8020025c:	00090713          	mv	a4,s2
    80200260:	00098793          	mv	a5,s3
    80200264:	00000073          	ecall
    80200268:	00050e93          	mv	t4,a0
    8020026c:	00058e13          	mv	t3,a1
    80200270:	fdd43023          	sd	t4,-64(s0)
    80200274:	fdc43423          	sd	t3,-56(s0)
            "mv %1, a1\n"
            : "=r"(res.error), "=r"(res.value)
            : "r"(eid), "r"(fid), "r"(arg0), "r"(arg1), "r"(arg2), "r"(arg3), "r"(arg4), "r"(arg5)
            : "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );
    return res;
    80200278:	fc043783          	ld	a5,-64(s0)
    8020027c:	fcf43823          	sd	a5,-48(s0)
    80200280:	fc843783          	ld	a5,-56(s0)
    80200284:	fcf43c23          	sd	a5,-40(s0)
    80200288:	fd043703          	ld	a4,-48(s0)
    8020028c:	fd843783          	ld	a5,-40(s0)
    80200290:	00070313          	mv	t1,a4
    80200294:	00078393          	mv	t2,a5
    80200298:	00030713          	mv	a4,t1
    8020029c:	00038793          	mv	a5,t2

}
    802002a0:	00070513          	mv	a0,a4
    802002a4:	00078593          	mv	a1,a5
    802002a8:	07813403          	ld	s0,120(sp)
    802002ac:	07013483          	ld	s1,112(sp)
    802002b0:	06813903          	ld	s2,104(sp)
    802002b4:	06013983          	ld	s3,96(sp)
    802002b8:	08010113          	addi	sp,sp,128
    802002bc:	00008067          	ret

00000000802002c0 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    802002c0:	fc010113          	addi	sp,sp,-64
    802002c4:	02113c23          	sd	ra,56(sp)
    802002c8:	02813823          	sd	s0,48(sp)
    802002cc:	03213423          	sd	s2,40(sp)
    802002d0:	03313023          	sd	s3,32(sp)
    802002d4:	04010413          	addi	s0,sp,64
    802002d8:	00050793          	mv	a5,a0
    802002dc:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434e, 2, byte, 0, 0, 0, 0, 0);
    802002e0:	fcf44603          	lbu	a2,-49(s0)
    802002e4:	00000893          	li	a7,0
    802002e8:	00000813          	li	a6,0
    802002ec:	00000793          	li	a5,0
    802002f0:	00000713          	li	a4,0
    802002f4:	00000693          	li	a3,0
    802002f8:	00200593          	li	a1,2
    802002fc:	44424537          	lui	a0,0x44424
    80200300:	34e50513          	addi	a0,a0,846 # 4442434e <_skernel-0x3bddbcb2>
    80200304:	ee9ff0ef          	jal	ra,802001ec <sbi_ecall>
    80200308:	00050713          	mv	a4,a0
    8020030c:	00058793          	mv	a5,a1
    80200310:	fce43823          	sd	a4,-48(s0)
    80200314:	fcf43c23          	sd	a5,-40(s0)
    80200318:	fd043703          	ld	a4,-48(s0)
    8020031c:	fd843783          	ld	a5,-40(s0)
    80200320:	00070913          	mv	s2,a4
    80200324:	00078993          	mv	s3,a5
    80200328:	00090713          	mv	a4,s2
    8020032c:	00098793          	mv	a5,s3
}
    80200330:	00070513          	mv	a0,a4
    80200334:	00078593          	mv	a1,a5
    80200338:	03813083          	ld	ra,56(sp)
    8020033c:	03013403          	ld	s0,48(sp)
    80200340:	02813903          	ld	s2,40(sp)
    80200344:	02013983          	ld	s3,32(sp)
    80200348:	04010113          	addi	sp,sp,64
    8020034c:	00008067          	ret

0000000080200350 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    80200350:	fc010113          	addi	sp,sp,-64
    80200354:	02113c23          	sd	ra,56(sp)
    80200358:	02813823          	sd	s0,48(sp)
    8020035c:	03213423          	sd	s2,40(sp)
    80200360:	03313023          	sd	s3,32(sp)
    80200364:	04010413          	addi	s0,sp,64
    80200368:	00050793          	mv	a5,a0
    8020036c:	00058713          	mv	a4,a1
    80200370:	fcf42623          	sw	a5,-52(s0)
    80200374:	00070793          	mv	a5,a4
    80200378:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0, reset_type, reset_reason, 0, 0, 0, 0);
    8020037c:	fcc46603          	lwu	a2,-52(s0)
    80200380:	fc846683          	lwu	a3,-56(s0)
    80200384:	00000893          	li	a7,0
    80200388:	00000813          	li	a6,0
    8020038c:	00000793          	li	a5,0
    80200390:	00000713          	li	a4,0
    80200394:	00000593          	li	a1,0
    80200398:	53525537          	lui	a0,0x53525
    8020039c:	35450513          	addi	a0,a0,852 # 53525354 <_skernel-0x2ccdacac>
    802003a0:	e4dff0ef          	jal	ra,802001ec <sbi_ecall>
    802003a4:	00050713          	mv	a4,a0
    802003a8:	00058793          	mv	a5,a1
    802003ac:	fce43823          	sd	a4,-48(s0)
    802003b0:	fcf43c23          	sd	a5,-40(s0)
    802003b4:	fd043703          	ld	a4,-48(s0)
    802003b8:	fd843783          	ld	a5,-40(s0)
    802003bc:	00070913          	mv	s2,a4
    802003c0:	00078993          	mv	s3,a5
    802003c4:	00090713          	mv	a4,s2
    802003c8:	00098793          	mv	a5,s3
}
    802003cc:	00070513          	mv	a0,a4
    802003d0:	00078593          	mv	a1,a5
    802003d4:	03813083          	ld	ra,56(sp)
    802003d8:	03013403          	ld	s0,48(sp)
    802003dc:	02813903          	ld	s2,40(sp)
    802003e0:	02013983          	ld	s3,32(sp)
    802003e4:	04010113          	addi	sp,sp,64
    802003e8:	00008067          	ret

00000000802003ec <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value) {
    802003ec:	fc010113          	addi	sp,sp,-64
    802003f0:	02113c23          	sd	ra,56(sp)
    802003f4:	02813823          	sd	s0,48(sp)
    802003f8:	03213423          	sd	s2,40(sp)
    802003fc:	03313023          	sd	s3,32(sp)
    80200400:	04010413          	addi	s0,sp,64
    80200404:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494d45, 0, stime_value, 0, 0, 0, 0, 0);
    80200408:	00000893          	li	a7,0
    8020040c:	00000813          	li	a6,0
    80200410:	00000793          	li	a5,0
    80200414:	00000713          	li	a4,0
    80200418:	00000693          	li	a3,0
    8020041c:	fc843603          	ld	a2,-56(s0)
    80200420:	00000593          	li	a1,0
    80200424:	54495537          	lui	a0,0x54495
    80200428:	d4550513          	addi	a0,a0,-699 # 54494d45 <_skernel-0x2bd6b2bb>
    8020042c:	dc1ff0ef          	jal	ra,802001ec <sbi_ecall>
    80200430:	00050713          	mv	a4,a0
    80200434:	00058793          	mv	a5,a1
    80200438:	fce43823          	sd	a4,-48(s0)
    8020043c:	fcf43c23          	sd	a5,-40(s0)
    80200440:	fd043703          	ld	a4,-48(s0)
    80200444:	fd843783          	ld	a5,-40(s0)
    80200448:	00070913          	mv	s2,a4
    8020044c:	00078993          	mv	s3,a5
    80200450:	00090713          	mv	a4,s2
    80200454:	00098793          	mv	a5,s3
    80200458:	00070513          	mv	a0,a4
    8020045c:	00078593          	mv	a1,a5
    80200460:	03813083          	ld	ra,56(sp)
    80200464:	03013403          	ld	s0,48(sp)
    80200468:	02813903          	ld	s2,40(sp)
    8020046c:	02013983          	ld	s3,32(sp)
    80200470:	04010113          	addi	sp,sp,64
    80200474:	00008067          	ret

0000000080200478 <trap_handler>:
#include "stdint.h"
#include "printk.h"
#include "clock.h"

void trap_handler(uint64_t scause, uint64_t sepc) {
    80200478:	fd010113          	addi	sp,sp,-48
    8020047c:	02113423          	sd	ra,40(sp)
    80200480:	02813023          	sd	s0,32(sp)
    80200484:	03010413          	addi	s0,sp,48
    80200488:	fca43c23          	sd	a0,-40(s0)
    8020048c:	fcb43823          	sd	a1,-48(s0)
    // interrupt：最高位
    uint64_t interrupt = (scause >> 63) & 1;
    80200490:	fd843783          	ld	a5,-40(s0)
    80200494:	03f7d793          	srli	a5,a5,0x3f
    80200498:	fef43423          	sd	a5,-24(s0)

    // exception_code：剩余位
    uint64_t exception_code = scause & 0x7FFFFFFFFFFFFFFF;
    8020049c:	fd843703          	ld	a4,-40(s0)
    802004a0:	fff00793          	li	a5,-1
    802004a4:	0017d793          	srli	a5,a5,0x1
    802004a8:	00f777b3          	and	a5,a4,a5
    802004ac:	fef43023          	sd	a5,-32(s0)

    // 最高位为0：interrupt；最高位为1：exception
    // Supervisor timer interrupt剩余位值为5

    if(interrupt == 1) {
    802004b0:	fe843703          	ld	a4,-24(s0)
    802004b4:	00100793          	li	a5,1
    802004b8:	02f71a63          	bne	a4,a5,802004ec <trap_handler+0x74>
        if(exception_code == 5) {
    802004bc:	fe043703          	ld	a4,-32(s0)
    802004c0:	00500793          	li	a5,5
    802004c4:	00f71c63          	bne	a4,a5,802004dc <trap_handler+0x64>
            printk("[S] Supervisor Mode Timer Interrupt\n");
    802004c8:	00002517          	auipc	a0,0x2
    802004cc:	b3850513          	addi	a0,a0,-1224 # 80202000 <_srodata>
    802004d0:	054010ef          	jal	ra,80201524 <printk>
            clock_set_next_event();
    802004d4:	cd1ff0ef          	jal	ra,802001a4 <clock_set_next_event>
            printk("Other Interrupt\n");
        }
    }else {
        printk("Exception\n");
    }
    802004d8:	0200006f          	j	802004f8 <trap_handler+0x80>
            printk("Other Interrupt\n");
    802004dc:	00002517          	auipc	a0,0x2
    802004e0:	b4c50513          	addi	a0,a0,-1204 # 80202028 <_srodata+0x28>
    802004e4:	040010ef          	jal	ra,80201524 <printk>
    802004e8:	0100006f          	j	802004f8 <trap_handler+0x80>
        printk("Exception\n");
    802004ec:	00002517          	auipc	a0,0x2
    802004f0:	b5450513          	addi	a0,a0,-1196 # 80202040 <_srodata+0x40>
    802004f4:	030010ef          	jal	ra,80201524 <printk>
    802004f8:	00000013          	nop
    802004fc:	02813083          	ld	ra,40(sp)
    80200500:	02013403          	ld	s0,32(sp)
    80200504:	03010113          	addi	sp,sp,48
    80200508:	00008067          	ret

000000008020050c <start_kernel>:
#include "printk.h"

extern void test();

int start_kernel() {
    8020050c:	ff010113          	addi	sp,sp,-16
    80200510:	00113423          	sd	ra,8(sp)
    80200514:	00813023          	sd	s0,0(sp)
    80200518:	01010413          	addi	s0,sp,16
    printk("2024");
    8020051c:	00002517          	auipc	a0,0x2
    80200520:	b3450513          	addi	a0,a0,-1228 # 80202050 <_srodata+0x50>
    80200524:	000010ef          	jal	ra,80201524 <printk>
    printk(" ZJU Operating System\n");
    80200528:	00002517          	auipc	a0,0x2
    8020052c:	b3050513          	addi	a0,a0,-1232 # 80202058 <_srodata+0x58>
    80200530:	7f5000ef          	jal	ra,80201524 <printk>

    test();
    80200534:	0bc000ef          	jal	ra,802005f0 <test>
    return 0;
    80200538:	00000793          	li	a5,0
}
    8020053c:	00078513          	mv	a0,a5
    80200540:	00813083          	ld	ra,8(sp)
    80200544:	00013403          	ld	s0,0(sp)
    80200548:	01010113          	addi	sp,sp,16
    8020054c:	00008067          	ret

0000000080200550 <print_binary>:
#include "sbi.h"
#include "defs.h"
#include "printk.h"

void print_binary(uint64_t value) {
    80200550:	fd010113          	addi	sp,sp,-48
    80200554:	02113423          	sd	ra,40(sp)
    80200558:	02813023          	sd	s0,32(sp)
    8020055c:	03010413          	addi	s0,sp,48
    80200560:	fca43c23          	sd	a0,-40(s0)
    for (int i = 63; i >= 0; i--) {
    80200564:	03f00793          	li	a5,63
    80200568:	fef42623          	sw	a5,-20(s0)
    8020056c:	0580006f          	j	802005c4 <print_binary+0x74>
        printk("%d",(value & (1ULL << i)) ? 1 : 0);
    80200570:	fec42783          	lw	a5,-20(s0)
    80200574:	00078713          	mv	a4,a5
    80200578:	fd843783          	ld	a5,-40(s0)
    8020057c:	00e7d7b3          	srl	a5,a5,a4
    80200580:	0007879b          	sext.w	a5,a5
    80200584:	0017f793          	andi	a5,a5,1
    80200588:	0007879b          	sext.w	a5,a5
    8020058c:	00078593          	mv	a1,a5
    80200590:	00002517          	auipc	a0,0x2
    80200594:	ae050513          	addi	a0,a0,-1312 # 80202070 <_srodata+0x70>
    80200598:	78d000ef          	jal	ra,80201524 <printk>
        // 每 8 位加一个空格，便于阅读
        if (i % 8 == 0) {
    8020059c:	fec42783          	lw	a5,-20(s0)
    802005a0:	0077f793          	andi	a5,a5,7
    802005a4:	0007879b          	sext.w	a5,a5
    802005a8:	00079863          	bnez	a5,802005b8 <print_binary+0x68>
            printk(" ");
    802005ac:	00002517          	auipc	a0,0x2
    802005b0:	acc50513          	addi	a0,a0,-1332 # 80202078 <_srodata+0x78>
    802005b4:	771000ef          	jal	ra,80201524 <printk>
    for (int i = 63; i >= 0; i--) {
    802005b8:	fec42783          	lw	a5,-20(s0)
    802005bc:	fff7879b          	addiw	a5,a5,-1
    802005c0:	fef42623          	sw	a5,-20(s0)
    802005c4:	fec42783          	lw	a5,-20(s0)
    802005c8:	0007879b          	sext.w	a5,a5
    802005cc:	fa07d2e3          	bgez	a5,80200570 <print_binary+0x20>
        }
    }
    printk("\n");
    802005d0:	00002517          	auipc	a0,0x2
    802005d4:	ab050513          	addi	a0,a0,-1360 # 80202080 <_srodata+0x80>
    802005d8:	74d000ef          	jal	ra,80201524 <printk>
}
    802005dc:	00000013          	nop
    802005e0:	02813083          	ld	ra,40(sp)
    802005e4:	02013403          	ld	s0,32(sp)
    802005e8:	03010113          	addi	sp,sp,48
    802005ec:	00008067          	ret

00000000802005f0 <test>:

void test() {
    802005f0:	fc010113          	addi	sp,sp,-64
    802005f4:	02113c23          	sd	ra,56(sp)
    802005f8:	02813823          	sd	s0,48(sp)
    802005fc:	04010413          	addi	s0,sp,64
    int i = 0;
    80200600:	fe042623          	sw	zero,-20(s0)
    uint64_t sscratch_value = csr_read(sscratch);
    80200604:	140027f3          	csrr	a5,sscratch
    80200608:	fef43023          	sd	a5,-32(s0)
    8020060c:	fe043783          	ld	a5,-32(s0)
    80200610:	fcf43c23          	sd	a5,-40(s0)
    printk("Before:%d\n",sscratch_value);
    80200614:	fd843583          	ld	a1,-40(s0)
    80200618:	00002517          	auipc	a0,0x2
    8020061c:	a7050513          	addi	a0,a0,-1424 # 80202088 <_srodata+0x88>
    80200620:	705000ef          	jal	ra,80201524 <printk>
    csr_write(sscratch, 1);
    80200624:	00100793          	li	a5,1
    80200628:	fcf43823          	sd	a5,-48(s0)
    8020062c:	fd043783          	ld	a5,-48(s0)
    80200630:	14079073          	csrw	sscratch,a5
    sscratch_value = csr_read(sscratch);
    80200634:	140027f3          	csrr	a5,sscratch
    80200638:	fcf43423          	sd	a5,-56(s0)
    8020063c:	fc843783          	ld	a5,-56(s0)
    80200640:	fcf43c23          	sd	a5,-40(s0)
    printk("After:%d\n",sscratch_value);
    80200644:	fd843583          	ld	a1,-40(s0)
    80200648:	00002517          	auipc	a0,0x2
    8020064c:	a5050513          	addi	a0,a0,-1456 # 80202098 <_srodata+0x98>
    80200650:	6d5000ef          	jal	ra,80201524 <printk>

    while (1) {
        if ((++i) % 300000000 == 0) {
    80200654:	fec42783          	lw	a5,-20(s0)
    80200658:	0017879b          	addiw	a5,a5,1
    8020065c:	fef42623          	sw	a5,-20(s0)
    80200660:	fec42783          	lw	a5,-20(s0)
    80200664:	00078713          	mv	a4,a5
    80200668:	11e1a7b7          	lui	a5,0x11e1a
    8020066c:	3007879b          	addiw	a5,a5,768 # 11e1a300 <_skernel-0x6e3e5d00>
    80200670:	02f767bb          	remw	a5,a4,a5
    80200674:	0007879b          	sext.w	a5,a5
    80200678:	fc079ee3          	bnez	a5,80200654 <test+0x64>
            printk("kernel is running!\n");
    8020067c:	00002517          	auipc	a0,0x2
    80200680:	a2c50513          	addi	a0,a0,-1492 # 802020a8 <_srodata+0xa8>
    80200684:	6a1000ef          	jal	ra,80201524 <printk>
            // uint64_t sstatus_value = csr_read(sstatus);
            // print_binary(sstatus_value);
            i = 0;
    80200688:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 300000000 == 0) {
    8020068c:	fc9ff06f          	j	80200654 <test+0x64>

0000000080200690 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
    80200690:	fe010113          	addi	sp,sp,-32
    80200694:	00113c23          	sd	ra,24(sp)
    80200698:	00813823          	sd	s0,16(sp)
    8020069c:	02010413          	addi	s0,sp,32
    802006a0:	00050793          	mv	a5,a0
    802006a4:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
    802006a8:	fec42783          	lw	a5,-20(s0)
    802006ac:	0ff7f793          	zext.b	a5,a5
    802006b0:	00078513          	mv	a0,a5
    802006b4:	c0dff0ef          	jal	ra,802002c0 <sbi_debug_console_write_byte>
    return (char)c;
    802006b8:	fec42783          	lw	a5,-20(s0)
    802006bc:	0ff7f793          	zext.b	a5,a5
    802006c0:	0007879b          	sext.w	a5,a5
}
    802006c4:	00078513          	mv	a0,a5
    802006c8:	01813083          	ld	ra,24(sp)
    802006cc:	01013403          	ld	s0,16(sp)
    802006d0:	02010113          	addi	sp,sp,32
    802006d4:	00008067          	ret

00000000802006d8 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
    802006d8:	fe010113          	addi	sp,sp,-32
    802006dc:	00813c23          	sd	s0,24(sp)
    802006e0:	02010413          	addi	s0,sp,32
    802006e4:	00050793          	mv	a5,a0
    802006e8:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
    802006ec:	fec42783          	lw	a5,-20(s0)
    802006f0:	0007871b          	sext.w	a4,a5
    802006f4:	02000793          	li	a5,32
    802006f8:	02f70263          	beq	a4,a5,8020071c <isspace+0x44>
    802006fc:	fec42783          	lw	a5,-20(s0)
    80200700:	0007871b          	sext.w	a4,a5
    80200704:	00800793          	li	a5,8
    80200708:	00e7de63          	bge	a5,a4,80200724 <isspace+0x4c>
    8020070c:	fec42783          	lw	a5,-20(s0)
    80200710:	0007871b          	sext.w	a4,a5
    80200714:	00d00793          	li	a5,13
    80200718:	00e7c663          	blt	a5,a4,80200724 <isspace+0x4c>
    8020071c:	00100793          	li	a5,1
    80200720:	0080006f          	j	80200728 <isspace+0x50>
    80200724:	00000793          	li	a5,0
}
    80200728:	00078513          	mv	a0,a5
    8020072c:	01813403          	ld	s0,24(sp)
    80200730:	02010113          	addi	sp,sp,32
    80200734:	00008067          	ret

0000000080200738 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
    80200738:	fb010113          	addi	sp,sp,-80
    8020073c:	04113423          	sd	ra,72(sp)
    80200740:	04813023          	sd	s0,64(sp)
    80200744:	05010413          	addi	s0,sp,80
    80200748:	fca43423          	sd	a0,-56(s0)
    8020074c:	fcb43023          	sd	a1,-64(s0)
    80200750:	00060793          	mv	a5,a2
    80200754:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
    80200758:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
    8020075c:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
    80200760:	fc843783          	ld	a5,-56(s0)
    80200764:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
    80200768:	0100006f          	j	80200778 <strtol+0x40>
        p++;
    8020076c:	fd843783          	ld	a5,-40(s0)
    80200770:	00178793          	addi	a5,a5,1
    80200774:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
    80200778:	fd843783          	ld	a5,-40(s0)
    8020077c:	0007c783          	lbu	a5,0(a5)
    80200780:	0007879b          	sext.w	a5,a5
    80200784:	00078513          	mv	a0,a5
    80200788:	f51ff0ef          	jal	ra,802006d8 <isspace>
    8020078c:	00050793          	mv	a5,a0
    80200790:	fc079ee3          	bnez	a5,8020076c <strtol+0x34>
    }

    if (*p == '-') {
    80200794:	fd843783          	ld	a5,-40(s0)
    80200798:	0007c783          	lbu	a5,0(a5)
    8020079c:	00078713          	mv	a4,a5
    802007a0:	02d00793          	li	a5,45
    802007a4:	00f71e63          	bne	a4,a5,802007c0 <strtol+0x88>
        neg = true;
    802007a8:	00100793          	li	a5,1
    802007ac:	fef403a3          	sb	a5,-25(s0)
        p++;
    802007b0:	fd843783          	ld	a5,-40(s0)
    802007b4:	00178793          	addi	a5,a5,1
    802007b8:	fcf43c23          	sd	a5,-40(s0)
    802007bc:	0240006f          	j	802007e0 <strtol+0xa8>
    } else if (*p == '+') {
    802007c0:	fd843783          	ld	a5,-40(s0)
    802007c4:	0007c783          	lbu	a5,0(a5)
    802007c8:	00078713          	mv	a4,a5
    802007cc:	02b00793          	li	a5,43
    802007d0:	00f71863          	bne	a4,a5,802007e0 <strtol+0xa8>
        p++;
    802007d4:	fd843783          	ld	a5,-40(s0)
    802007d8:	00178793          	addi	a5,a5,1
    802007dc:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
    802007e0:	fbc42783          	lw	a5,-68(s0)
    802007e4:	0007879b          	sext.w	a5,a5
    802007e8:	06079c63          	bnez	a5,80200860 <strtol+0x128>
        if (*p == '0') {
    802007ec:	fd843783          	ld	a5,-40(s0)
    802007f0:	0007c783          	lbu	a5,0(a5)
    802007f4:	00078713          	mv	a4,a5
    802007f8:	03000793          	li	a5,48
    802007fc:	04f71e63          	bne	a4,a5,80200858 <strtol+0x120>
            p++;
    80200800:	fd843783          	ld	a5,-40(s0)
    80200804:	00178793          	addi	a5,a5,1
    80200808:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
    8020080c:	fd843783          	ld	a5,-40(s0)
    80200810:	0007c783          	lbu	a5,0(a5)
    80200814:	00078713          	mv	a4,a5
    80200818:	07800793          	li	a5,120
    8020081c:	00f70c63          	beq	a4,a5,80200834 <strtol+0xfc>
    80200820:	fd843783          	ld	a5,-40(s0)
    80200824:	0007c783          	lbu	a5,0(a5)
    80200828:	00078713          	mv	a4,a5
    8020082c:	05800793          	li	a5,88
    80200830:	00f71e63          	bne	a4,a5,8020084c <strtol+0x114>
                base = 16;
    80200834:	01000793          	li	a5,16
    80200838:	faf42e23          	sw	a5,-68(s0)
                p++;
    8020083c:	fd843783          	ld	a5,-40(s0)
    80200840:	00178793          	addi	a5,a5,1
    80200844:	fcf43c23          	sd	a5,-40(s0)
    80200848:	0180006f          	j	80200860 <strtol+0x128>
            } else {
                base = 8;
    8020084c:	00800793          	li	a5,8
    80200850:	faf42e23          	sw	a5,-68(s0)
    80200854:	00c0006f          	j	80200860 <strtol+0x128>
            }
        } else {
            base = 10;
    80200858:	00a00793          	li	a5,10
    8020085c:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
    80200860:	fd843783          	ld	a5,-40(s0)
    80200864:	0007c783          	lbu	a5,0(a5)
    80200868:	00078713          	mv	a4,a5
    8020086c:	02f00793          	li	a5,47
    80200870:	02e7f863          	bgeu	a5,a4,802008a0 <strtol+0x168>
    80200874:	fd843783          	ld	a5,-40(s0)
    80200878:	0007c783          	lbu	a5,0(a5)
    8020087c:	00078713          	mv	a4,a5
    80200880:	03900793          	li	a5,57
    80200884:	00e7ee63          	bltu	a5,a4,802008a0 <strtol+0x168>
            digit = *p - '0';
    80200888:	fd843783          	ld	a5,-40(s0)
    8020088c:	0007c783          	lbu	a5,0(a5)
    80200890:	0007879b          	sext.w	a5,a5
    80200894:	fd07879b          	addiw	a5,a5,-48
    80200898:	fcf42a23          	sw	a5,-44(s0)
    8020089c:	0800006f          	j	8020091c <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
    802008a0:	fd843783          	ld	a5,-40(s0)
    802008a4:	0007c783          	lbu	a5,0(a5)
    802008a8:	00078713          	mv	a4,a5
    802008ac:	06000793          	li	a5,96
    802008b0:	02e7f863          	bgeu	a5,a4,802008e0 <strtol+0x1a8>
    802008b4:	fd843783          	ld	a5,-40(s0)
    802008b8:	0007c783          	lbu	a5,0(a5)
    802008bc:	00078713          	mv	a4,a5
    802008c0:	07a00793          	li	a5,122
    802008c4:	00e7ee63          	bltu	a5,a4,802008e0 <strtol+0x1a8>
            digit = *p - ('a' - 10);
    802008c8:	fd843783          	ld	a5,-40(s0)
    802008cc:	0007c783          	lbu	a5,0(a5)
    802008d0:	0007879b          	sext.w	a5,a5
    802008d4:	fa97879b          	addiw	a5,a5,-87
    802008d8:	fcf42a23          	sw	a5,-44(s0)
    802008dc:	0400006f          	j	8020091c <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
    802008e0:	fd843783          	ld	a5,-40(s0)
    802008e4:	0007c783          	lbu	a5,0(a5)
    802008e8:	00078713          	mv	a4,a5
    802008ec:	04000793          	li	a5,64
    802008f0:	06e7f863          	bgeu	a5,a4,80200960 <strtol+0x228>
    802008f4:	fd843783          	ld	a5,-40(s0)
    802008f8:	0007c783          	lbu	a5,0(a5)
    802008fc:	00078713          	mv	a4,a5
    80200900:	05a00793          	li	a5,90
    80200904:	04e7ee63          	bltu	a5,a4,80200960 <strtol+0x228>
            digit = *p - ('A' - 10);
    80200908:	fd843783          	ld	a5,-40(s0)
    8020090c:	0007c783          	lbu	a5,0(a5)
    80200910:	0007879b          	sext.w	a5,a5
    80200914:	fc97879b          	addiw	a5,a5,-55
    80200918:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
    8020091c:	fd442783          	lw	a5,-44(s0)
    80200920:	00078713          	mv	a4,a5
    80200924:	fbc42783          	lw	a5,-68(s0)
    80200928:	0007071b          	sext.w	a4,a4
    8020092c:	0007879b          	sext.w	a5,a5
    80200930:	02f75663          	bge	a4,a5,8020095c <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
    80200934:	fbc42703          	lw	a4,-68(s0)
    80200938:	fe843783          	ld	a5,-24(s0)
    8020093c:	02f70733          	mul	a4,a4,a5
    80200940:	fd442783          	lw	a5,-44(s0)
    80200944:	00f707b3          	add	a5,a4,a5
    80200948:	fef43423          	sd	a5,-24(s0)
        p++;
    8020094c:	fd843783          	ld	a5,-40(s0)
    80200950:	00178793          	addi	a5,a5,1
    80200954:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
    80200958:	f09ff06f          	j	80200860 <strtol+0x128>
            break;
    8020095c:	00000013          	nop
    }

    if (endptr) {
    80200960:	fc043783          	ld	a5,-64(s0)
    80200964:	00078863          	beqz	a5,80200974 <strtol+0x23c>
        *endptr = (char *)p;
    80200968:	fc043783          	ld	a5,-64(s0)
    8020096c:	fd843703          	ld	a4,-40(s0)
    80200970:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
    80200974:	fe744783          	lbu	a5,-25(s0)
    80200978:	0ff7f793          	zext.b	a5,a5
    8020097c:	00078863          	beqz	a5,8020098c <strtol+0x254>
    80200980:	fe843783          	ld	a5,-24(s0)
    80200984:	40f007b3          	neg	a5,a5
    80200988:	0080006f          	j	80200990 <strtol+0x258>
    8020098c:	fe843783          	ld	a5,-24(s0)
}
    80200990:	00078513          	mv	a0,a5
    80200994:	04813083          	ld	ra,72(sp)
    80200998:	04013403          	ld	s0,64(sp)
    8020099c:	05010113          	addi	sp,sp,80
    802009a0:	00008067          	ret

00000000802009a4 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
    802009a4:	fd010113          	addi	sp,sp,-48
    802009a8:	02113423          	sd	ra,40(sp)
    802009ac:	02813023          	sd	s0,32(sp)
    802009b0:	03010413          	addi	s0,sp,48
    802009b4:	fca43c23          	sd	a0,-40(s0)
    802009b8:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
    802009bc:	fd043783          	ld	a5,-48(s0)
    802009c0:	00079863          	bnez	a5,802009d0 <puts_wo_nl+0x2c>
        s = "(null)";
    802009c4:	00001797          	auipc	a5,0x1
    802009c8:	6fc78793          	addi	a5,a5,1788 # 802020c0 <_srodata+0xc0>
    802009cc:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
    802009d0:	fd043783          	ld	a5,-48(s0)
    802009d4:	fef43423          	sd	a5,-24(s0)
    while (*p) {
    802009d8:	0240006f          	j	802009fc <puts_wo_nl+0x58>
        putch(*p++);
    802009dc:	fe843783          	ld	a5,-24(s0)
    802009e0:	00178713          	addi	a4,a5,1
    802009e4:	fee43423          	sd	a4,-24(s0)
    802009e8:	0007c783          	lbu	a5,0(a5)
    802009ec:	0007871b          	sext.w	a4,a5
    802009f0:	fd843783          	ld	a5,-40(s0)
    802009f4:	00070513          	mv	a0,a4
    802009f8:	000780e7          	jalr	a5
    while (*p) {
    802009fc:	fe843783          	ld	a5,-24(s0)
    80200a00:	0007c783          	lbu	a5,0(a5)
    80200a04:	fc079ce3          	bnez	a5,802009dc <puts_wo_nl+0x38>
    }
    return p - s;
    80200a08:	fe843703          	ld	a4,-24(s0)
    80200a0c:	fd043783          	ld	a5,-48(s0)
    80200a10:	40f707b3          	sub	a5,a4,a5
    80200a14:	0007879b          	sext.w	a5,a5
}
    80200a18:	00078513          	mv	a0,a5
    80200a1c:	02813083          	ld	ra,40(sp)
    80200a20:	02013403          	ld	s0,32(sp)
    80200a24:	03010113          	addi	sp,sp,48
    80200a28:	00008067          	ret

0000000080200a2c <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
    80200a2c:	f9010113          	addi	sp,sp,-112
    80200a30:	06113423          	sd	ra,104(sp)
    80200a34:	06813023          	sd	s0,96(sp)
    80200a38:	07010413          	addi	s0,sp,112
    80200a3c:	faa43423          	sd	a0,-88(s0)
    80200a40:	fab43023          	sd	a1,-96(s0)
    80200a44:	00060793          	mv	a5,a2
    80200a48:	f8d43823          	sd	a3,-112(s0)
    80200a4c:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
    80200a50:	f9f44783          	lbu	a5,-97(s0)
    80200a54:	0ff7f793          	zext.b	a5,a5
    80200a58:	02078663          	beqz	a5,80200a84 <print_dec_int+0x58>
    80200a5c:	fa043703          	ld	a4,-96(s0)
    80200a60:	fff00793          	li	a5,-1
    80200a64:	03f79793          	slli	a5,a5,0x3f
    80200a68:	00f71e63          	bne	a4,a5,80200a84 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
    80200a6c:	00001597          	auipc	a1,0x1
    80200a70:	65c58593          	addi	a1,a1,1628 # 802020c8 <_srodata+0xc8>
    80200a74:	fa843503          	ld	a0,-88(s0)
    80200a78:	f2dff0ef          	jal	ra,802009a4 <puts_wo_nl>
    80200a7c:	00050793          	mv	a5,a0
    80200a80:	2a00006f          	j	80200d20 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
    80200a84:	f9043783          	ld	a5,-112(s0)
    80200a88:	00c7a783          	lw	a5,12(a5)
    80200a8c:	00079a63          	bnez	a5,80200aa0 <print_dec_int+0x74>
    80200a90:	fa043783          	ld	a5,-96(s0)
    80200a94:	00079663          	bnez	a5,80200aa0 <print_dec_int+0x74>
        return 0;
    80200a98:	00000793          	li	a5,0
    80200a9c:	2840006f          	j	80200d20 <print_dec_int+0x2f4>
    }

    bool neg = false;
    80200aa0:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
    80200aa4:	f9f44783          	lbu	a5,-97(s0)
    80200aa8:	0ff7f793          	zext.b	a5,a5
    80200aac:	02078063          	beqz	a5,80200acc <print_dec_int+0xa0>
    80200ab0:	fa043783          	ld	a5,-96(s0)
    80200ab4:	0007dc63          	bgez	a5,80200acc <print_dec_int+0xa0>
        neg = true;
    80200ab8:	00100793          	li	a5,1
    80200abc:	fef407a3          	sb	a5,-17(s0)
        num = -num;
    80200ac0:	fa043783          	ld	a5,-96(s0)
    80200ac4:	40f007b3          	neg	a5,a5
    80200ac8:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
    80200acc:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
    80200ad0:	f9f44783          	lbu	a5,-97(s0)
    80200ad4:	0ff7f793          	zext.b	a5,a5
    80200ad8:	02078863          	beqz	a5,80200b08 <print_dec_int+0xdc>
    80200adc:	fef44783          	lbu	a5,-17(s0)
    80200ae0:	0ff7f793          	zext.b	a5,a5
    80200ae4:	00079e63          	bnez	a5,80200b00 <print_dec_int+0xd4>
    80200ae8:	f9043783          	ld	a5,-112(s0)
    80200aec:	0057c783          	lbu	a5,5(a5)
    80200af0:	00079863          	bnez	a5,80200b00 <print_dec_int+0xd4>
    80200af4:	f9043783          	ld	a5,-112(s0)
    80200af8:	0047c783          	lbu	a5,4(a5)
    80200afc:	00078663          	beqz	a5,80200b08 <print_dec_int+0xdc>
    80200b00:	00100793          	li	a5,1
    80200b04:	0080006f          	j	80200b0c <print_dec_int+0xe0>
    80200b08:	00000793          	li	a5,0
    80200b0c:	fcf40ba3          	sb	a5,-41(s0)
    80200b10:	fd744783          	lbu	a5,-41(s0)
    80200b14:	0017f793          	andi	a5,a5,1
    80200b18:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
    80200b1c:	fa043703          	ld	a4,-96(s0)
    80200b20:	00a00793          	li	a5,10
    80200b24:	02f777b3          	remu	a5,a4,a5
    80200b28:	0ff7f713          	zext.b	a4,a5
    80200b2c:	fe842783          	lw	a5,-24(s0)
    80200b30:	0017869b          	addiw	a3,a5,1
    80200b34:	fed42423          	sw	a3,-24(s0)
    80200b38:	0307071b          	addiw	a4,a4,48
    80200b3c:	0ff77713          	zext.b	a4,a4
    80200b40:	ff078793          	addi	a5,a5,-16
    80200b44:	008787b3          	add	a5,a5,s0
    80200b48:	fce78423          	sb	a4,-56(a5)
        num /= 10;
    80200b4c:	fa043703          	ld	a4,-96(s0)
    80200b50:	00a00793          	li	a5,10
    80200b54:	02f757b3          	divu	a5,a4,a5
    80200b58:	faf43023          	sd	a5,-96(s0)
    } while (num);
    80200b5c:	fa043783          	ld	a5,-96(s0)
    80200b60:	fa079ee3          	bnez	a5,80200b1c <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
    80200b64:	f9043783          	ld	a5,-112(s0)
    80200b68:	00c7a783          	lw	a5,12(a5)
    80200b6c:	00078713          	mv	a4,a5
    80200b70:	fff00793          	li	a5,-1
    80200b74:	02f71063          	bne	a4,a5,80200b94 <print_dec_int+0x168>
    80200b78:	f9043783          	ld	a5,-112(s0)
    80200b7c:	0037c783          	lbu	a5,3(a5)
    80200b80:	00078a63          	beqz	a5,80200b94 <print_dec_int+0x168>
        flags->prec = flags->width;
    80200b84:	f9043783          	ld	a5,-112(s0)
    80200b88:	0087a703          	lw	a4,8(a5)
    80200b8c:	f9043783          	ld	a5,-112(s0)
    80200b90:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
    80200b94:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80200b98:	f9043783          	ld	a5,-112(s0)
    80200b9c:	0087a703          	lw	a4,8(a5)
    80200ba0:	fe842783          	lw	a5,-24(s0)
    80200ba4:	fcf42823          	sw	a5,-48(s0)
    80200ba8:	f9043783          	ld	a5,-112(s0)
    80200bac:	00c7a783          	lw	a5,12(a5)
    80200bb0:	fcf42623          	sw	a5,-52(s0)
    80200bb4:	fd042783          	lw	a5,-48(s0)
    80200bb8:	00078593          	mv	a1,a5
    80200bbc:	fcc42783          	lw	a5,-52(s0)
    80200bc0:	00078613          	mv	a2,a5
    80200bc4:	0006069b          	sext.w	a3,a2
    80200bc8:	0005879b          	sext.w	a5,a1
    80200bcc:	00f6d463          	bge	a3,a5,80200bd4 <print_dec_int+0x1a8>
    80200bd0:	00058613          	mv	a2,a1
    80200bd4:	0006079b          	sext.w	a5,a2
    80200bd8:	40f707bb          	subw	a5,a4,a5
    80200bdc:	0007871b          	sext.w	a4,a5
    80200be0:	fd744783          	lbu	a5,-41(s0)
    80200be4:	0007879b          	sext.w	a5,a5
    80200be8:	40f707bb          	subw	a5,a4,a5
    80200bec:	fef42023          	sw	a5,-32(s0)
    80200bf0:	0280006f          	j	80200c18 <print_dec_int+0x1ec>
        putch(' ');
    80200bf4:	fa843783          	ld	a5,-88(s0)
    80200bf8:	02000513          	li	a0,32
    80200bfc:	000780e7          	jalr	a5
        ++written;
    80200c00:	fe442783          	lw	a5,-28(s0)
    80200c04:	0017879b          	addiw	a5,a5,1
    80200c08:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80200c0c:	fe042783          	lw	a5,-32(s0)
    80200c10:	fff7879b          	addiw	a5,a5,-1
    80200c14:	fef42023          	sw	a5,-32(s0)
    80200c18:	fe042783          	lw	a5,-32(s0)
    80200c1c:	0007879b          	sext.w	a5,a5
    80200c20:	fcf04ae3          	bgtz	a5,80200bf4 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
    80200c24:	fd744783          	lbu	a5,-41(s0)
    80200c28:	0ff7f793          	zext.b	a5,a5
    80200c2c:	04078463          	beqz	a5,80200c74 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
    80200c30:	fef44783          	lbu	a5,-17(s0)
    80200c34:	0ff7f793          	zext.b	a5,a5
    80200c38:	00078663          	beqz	a5,80200c44 <print_dec_int+0x218>
    80200c3c:	02d00793          	li	a5,45
    80200c40:	01c0006f          	j	80200c5c <print_dec_int+0x230>
    80200c44:	f9043783          	ld	a5,-112(s0)
    80200c48:	0057c783          	lbu	a5,5(a5)
    80200c4c:	00078663          	beqz	a5,80200c58 <print_dec_int+0x22c>
    80200c50:	02b00793          	li	a5,43
    80200c54:	0080006f          	j	80200c5c <print_dec_int+0x230>
    80200c58:	02000793          	li	a5,32
    80200c5c:	fa843703          	ld	a4,-88(s0)
    80200c60:	00078513          	mv	a0,a5
    80200c64:	000700e7          	jalr	a4
        ++written;
    80200c68:	fe442783          	lw	a5,-28(s0)
    80200c6c:	0017879b          	addiw	a5,a5,1
    80200c70:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80200c74:	fe842783          	lw	a5,-24(s0)
    80200c78:	fcf42e23          	sw	a5,-36(s0)
    80200c7c:	0280006f          	j	80200ca4 <print_dec_int+0x278>
        putch('0');
    80200c80:	fa843783          	ld	a5,-88(s0)
    80200c84:	03000513          	li	a0,48
    80200c88:	000780e7          	jalr	a5
        ++written;
    80200c8c:	fe442783          	lw	a5,-28(s0)
    80200c90:	0017879b          	addiw	a5,a5,1
    80200c94:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80200c98:	fdc42783          	lw	a5,-36(s0)
    80200c9c:	0017879b          	addiw	a5,a5,1
    80200ca0:	fcf42e23          	sw	a5,-36(s0)
    80200ca4:	f9043783          	ld	a5,-112(s0)
    80200ca8:	00c7a703          	lw	a4,12(a5)
    80200cac:	fd744783          	lbu	a5,-41(s0)
    80200cb0:	0007879b          	sext.w	a5,a5
    80200cb4:	40f707bb          	subw	a5,a4,a5
    80200cb8:	0007871b          	sext.w	a4,a5
    80200cbc:	fdc42783          	lw	a5,-36(s0)
    80200cc0:	0007879b          	sext.w	a5,a5
    80200cc4:	fae7cee3          	blt	a5,a4,80200c80 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
    80200cc8:	fe842783          	lw	a5,-24(s0)
    80200ccc:	fff7879b          	addiw	a5,a5,-1
    80200cd0:	fcf42c23          	sw	a5,-40(s0)
    80200cd4:	03c0006f          	j	80200d10 <print_dec_int+0x2e4>
        putch(buf[i]);
    80200cd8:	fd842783          	lw	a5,-40(s0)
    80200cdc:	ff078793          	addi	a5,a5,-16
    80200ce0:	008787b3          	add	a5,a5,s0
    80200ce4:	fc87c783          	lbu	a5,-56(a5)
    80200ce8:	0007871b          	sext.w	a4,a5
    80200cec:	fa843783          	ld	a5,-88(s0)
    80200cf0:	00070513          	mv	a0,a4
    80200cf4:	000780e7          	jalr	a5
        ++written;
    80200cf8:	fe442783          	lw	a5,-28(s0)
    80200cfc:	0017879b          	addiw	a5,a5,1
    80200d00:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
    80200d04:	fd842783          	lw	a5,-40(s0)
    80200d08:	fff7879b          	addiw	a5,a5,-1
    80200d0c:	fcf42c23          	sw	a5,-40(s0)
    80200d10:	fd842783          	lw	a5,-40(s0)
    80200d14:	0007879b          	sext.w	a5,a5
    80200d18:	fc07d0e3          	bgez	a5,80200cd8 <print_dec_int+0x2ac>
    }

    return written;
    80200d1c:	fe442783          	lw	a5,-28(s0)
}
    80200d20:	00078513          	mv	a0,a5
    80200d24:	06813083          	ld	ra,104(sp)
    80200d28:	06013403          	ld	s0,96(sp)
    80200d2c:	07010113          	addi	sp,sp,112
    80200d30:	00008067          	ret

0000000080200d34 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
    80200d34:	f4010113          	addi	sp,sp,-192
    80200d38:	0a113c23          	sd	ra,184(sp)
    80200d3c:	0a813823          	sd	s0,176(sp)
    80200d40:	0c010413          	addi	s0,sp,192
    80200d44:	f4a43c23          	sd	a0,-168(s0)
    80200d48:	f4b43823          	sd	a1,-176(s0)
    80200d4c:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
    80200d50:	f8043023          	sd	zero,-128(s0)
    80200d54:	f8043423          	sd	zero,-120(s0)

    int written = 0;
    80200d58:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
    80200d5c:	7a40006f          	j	80201500 <vprintfmt+0x7cc>
        if (flags.in_format) {
    80200d60:	f8044783          	lbu	a5,-128(s0)
    80200d64:	72078e63          	beqz	a5,802014a0 <vprintfmt+0x76c>
            if (*fmt == '#') {
    80200d68:	f5043783          	ld	a5,-176(s0)
    80200d6c:	0007c783          	lbu	a5,0(a5)
    80200d70:	00078713          	mv	a4,a5
    80200d74:	02300793          	li	a5,35
    80200d78:	00f71863          	bne	a4,a5,80200d88 <vprintfmt+0x54>
                flags.sharpflag = true;
    80200d7c:	00100793          	li	a5,1
    80200d80:	f8f40123          	sb	a5,-126(s0)
    80200d84:	7700006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
    80200d88:	f5043783          	ld	a5,-176(s0)
    80200d8c:	0007c783          	lbu	a5,0(a5)
    80200d90:	00078713          	mv	a4,a5
    80200d94:	03000793          	li	a5,48
    80200d98:	00f71863          	bne	a4,a5,80200da8 <vprintfmt+0x74>
                flags.zeroflag = true;
    80200d9c:	00100793          	li	a5,1
    80200da0:	f8f401a3          	sb	a5,-125(s0)
    80200da4:	7500006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
    80200da8:	f5043783          	ld	a5,-176(s0)
    80200dac:	0007c783          	lbu	a5,0(a5)
    80200db0:	00078713          	mv	a4,a5
    80200db4:	06c00793          	li	a5,108
    80200db8:	04f70063          	beq	a4,a5,80200df8 <vprintfmt+0xc4>
    80200dbc:	f5043783          	ld	a5,-176(s0)
    80200dc0:	0007c783          	lbu	a5,0(a5)
    80200dc4:	00078713          	mv	a4,a5
    80200dc8:	07a00793          	li	a5,122
    80200dcc:	02f70663          	beq	a4,a5,80200df8 <vprintfmt+0xc4>
    80200dd0:	f5043783          	ld	a5,-176(s0)
    80200dd4:	0007c783          	lbu	a5,0(a5)
    80200dd8:	00078713          	mv	a4,a5
    80200ddc:	07400793          	li	a5,116
    80200de0:	00f70c63          	beq	a4,a5,80200df8 <vprintfmt+0xc4>
    80200de4:	f5043783          	ld	a5,-176(s0)
    80200de8:	0007c783          	lbu	a5,0(a5)
    80200dec:	00078713          	mv	a4,a5
    80200df0:	06a00793          	li	a5,106
    80200df4:	00f71863          	bne	a4,a5,80200e04 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
    80200df8:	00100793          	li	a5,1
    80200dfc:	f8f400a3          	sb	a5,-127(s0)
    80200e00:	6f40006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
    80200e04:	f5043783          	ld	a5,-176(s0)
    80200e08:	0007c783          	lbu	a5,0(a5)
    80200e0c:	00078713          	mv	a4,a5
    80200e10:	02b00793          	li	a5,43
    80200e14:	00f71863          	bne	a4,a5,80200e24 <vprintfmt+0xf0>
                flags.sign = true;
    80200e18:	00100793          	li	a5,1
    80200e1c:	f8f402a3          	sb	a5,-123(s0)
    80200e20:	6d40006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
    80200e24:	f5043783          	ld	a5,-176(s0)
    80200e28:	0007c783          	lbu	a5,0(a5)
    80200e2c:	00078713          	mv	a4,a5
    80200e30:	02000793          	li	a5,32
    80200e34:	00f71863          	bne	a4,a5,80200e44 <vprintfmt+0x110>
                flags.spaceflag = true;
    80200e38:	00100793          	li	a5,1
    80200e3c:	f8f40223          	sb	a5,-124(s0)
    80200e40:	6b40006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
    80200e44:	f5043783          	ld	a5,-176(s0)
    80200e48:	0007c783          	lbu	a5,0(a5)
    80200e4c:	00078713          	mv	a4,a5
    80200e50:	02a00793          	li	a5,42
    80200e54:	00f71e63          	bne	a4,a5,80200e70 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
    80200e58:	f4843783          	ld	a5,-184(s0)
    80200e5c:	00878713          	addi	a4,a5,8
    80200e60:	f4e43423          	sd	a4,-184(s0)
    80200e64:	0007a783          	lw	a5,0(a5)
    80200e68:	f8f42423          	sw	a5,-120(s0)
    80200e6c:	6880006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
    80200e70:	f5043783          	ld	a5,-176(s0)
    80200e74:	0007c783          	lbu	a5,0(a5)
    80200e78:	00078713          	mv	a4,a5
    80200e7c:	03000793          	li	a5,48
    80200e80:	04e7f663          	bgeu	a5,a4,80200ecc <vprintfmt+0x198>
    80200e84:	f5043783          	ld	a5,-176(s0)
    80200e88:	0007c783          	lbu	a5,0(a5)
    80200e8c:	00078713          	mv	a4,a5
    80200e90:	03900793          	li	a5,57
    80200e94:	02e7ec63          	bltu	a5,a4,80200ecc <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
    80200e98:	f5043783          	ld	a5,-176(s0)
    80200e9c:	f5040713          	addi	a4,s0,-176
    80200ea0:	00a00613          	li	a2,10
    80200ea4:	00070593          	mv	a1,a4
    80200ea8:	00078513          	mv	a0,a5
    80200eac:	88dff0ef          	jal	ra,80200738 <strtol>
    80200eb0:	00050793          	mv	a5,a0
    80200eb4:	0007879b          	sext.w	a5,a5
    80200eb8:	f8f42423          	sw	a5,-120(s0)
                fmt--;
    80200ebc:	f5043783          	ld	a5,-176(s0)
    80200ec0:	fff78793          	addi	a5,a5,-1
    80200ec4:	f4f43823          	sd	a5,-176(s0)
    80200ec8:	62c0006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
    80200ecc:	f5043783          	ld	a5,-176(s0)
    80200ed0:	0007c783          	lbu	a5,0(a5)
    80200ed4:	00078713          	mv	a4,a5
    80200ed8:	02e00793          	li	a5,46
    80200edc:	06f71863          	bne	a4,a5,80200f4c <vprintfmt+0x218>
                fmt++;
    80200ee0:	f5043783          	ld	a5,-176(s0)
    80200ee4:	00178793          	addi	a5,a5,1
    80200ee8:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
    80200eec:	f5043783          	ld	a5,-176(s0)
    80200ef0:	0007c783          	lbu	a5,0(a5)
    80200ef4:	00078713          	mv	a4,a5
    80200ef8:	02a00793          	li	a5,42
    80200efc:	00f71e63          	bne	a4,a5,80200f18 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
    80200f00:	f4843783          	ld	a5,-184(s0)
    80200f04:	00878713          	addi	a4,a5,8
    80200f08:	f4e43423          	sd	a4,-184(s0)
    80200f0c:	0007a783          	lw	a5,0(a5)
    80200f10:	f8f42623          	sw	a5,-116(s0)
    80200f14:	5e00006f          	j	802014f4 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
    80200f18:	f5043783          	ld	a5,-176(s0)
    80200f1c:	f5040713          	addi	a4,s0,-176
    80200f20:	00a00613          	li	a2,10
    80200f24:	00070593          	mv	a1,a4
    80200f28:	00078513          	mv	a0,a5
    80200f2c:	80dff0ef          	jal	ra,80200738 <strtol>
    80200f30:	00050793          	mv	a5,a0
    80200f34:	0007879b          	sext.w	a5,a5
    80200f38:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
    80200f3c:	f5043783          	ld	a5,-176(s0)
    80200f40:	fff78793          	addi	a5,a5,-1
    80200f44:	f4f43823          	sd	a5,-176(s0)
    80200f48:	5ac0006f          	j	802014f4 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80200f4c:	f5043783          	ld	a5,-176(s0)
    80200f50:	0007c783          	lbu	a5,0(a5)
    80200f54:	00078713          	mv	a4,a5
    80200f58:	07800793          	li	a5,120
    80200f5c:	02f70663          	beq	a4,a5,80200f88 <vprintfmt+0x254>
    80200f60:	f5043783          	ld	a5,-176(s0)
    80200f64:	0007c783          	lbu	a5,0(a5)
    80200f68:	00078713          	mv	a4,a5
    80200f6c:	05800793          	li	a5,88
    80200f70:	00f70c63          	beq	a4,a5,80200f88 <vprintfmt+0x254>
    80200f74:	f5043783          	ld	a5,-176(s0)
    80200f78:	0007c783          	lbu	a5,0(a5)
    80200f7c:	00078713          	mv	a4,a5
    80200f80:	07000793          	li	a5,112
    80200f84:	30f71263          	bne	a4,a5,80201288 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
    80200f88:	f5043783          	ld	a5,-176(s0)
    80200f8c:	0007c783          	lbu	a5,0(a5)
    80200f90:	00078713          	mv	a4,a5
    80200f94:	07000793          	li	a5,112
    80200f98:	00f70663          	beq	a4,a5,80200fa4 <vprintfmt+0x270>
    80200f9c:	f8144783          	lbu	a5,-127(s0)
    80200fa0:	00078663          	beqz	a5,80200fac <vprintfmt+0x278>
    80200fa4:	00100793          	li	a5,1
    80200fa8:	0080006f          	j	80200fb0 <vprintfmt+0x27c>
    80200fac:	00000793          	li	a5,0
    80200fb0:	faf403a3          	sb	a5,-89(s0)
    80200fb4:	fa744783          	lbu	a5,-89(s0)
    80200fb8:	0017f793          	andi	a5,a5,1
    80200fbc:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
    80200fc0:	fa744783          	lbu	a5,-89(s0)
    80200fc4:	0ff7f793          	zext.b	a5,a5
    80200fc8:	00078c63          	beqz	a5,80200fe0 <vprintfmt+0x2ac>
    80200fcc:	f4843783          	ld	a5,-184(s0)
    80200fd0:	00878713          	addi	a4,a5,8
    80200fd4:	f4e43423          	sd	a4,-184(s0)
    80200fd8:	0007b783          	ld	a5,0(a5)
    80200fdc:	01c0006f          	j	80200ff8 <vprintfmt+0x2c4>
    80200fe0:	f4843783          	ld	a5,-184(s0)
    80200fe4:	00878713          	addi	a4,a5,8
    80200fe8:	f4e43423          	sd	a4,-184(s0)
    80200fec:	0007a783          	lw	a5,0(a5)
    80200ff0:	02079793          	slli	a5,a5,0x20
    80200ff4:	0207d793          	srli	a5,a5,0x20
    80200ff8:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
    80200ffc:	f8c42783          	lw	a5,-116(s0)
    80201000:	02079463          	bnez	a5,80201028 <vprintfmt+0x2f4>
    80201004:	fe043783          	ld	a5,-32(s0)
    80201008:	02079063          	bnez	a5,80201028 <vprintfmt+0x2f4>
    8020100c:	f5043783          	ld	a5,-176(s0)
    80201010:	0007c783          	lbu	a5,0(a5)
    80201014:	00078713          	mv	a4,a5
    80201018:	07000793          	li	a5,112
    8020101c:	00f70663          	beq	a4,a5,80201028 <vprintfmt+0x2f4>
                    flags.in_format = false;
    80201020:	f8040023          	sb	zero,-128(s0)
    80201024:	4d00006f          	j	802014f4 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
    80201028:	f5043783          	ld	a5,-176(s0)
    8020102c:	0007c783          	lbu	a5,0(a5)
    80201030:	00078713          	mv	a4,a5
    80201034:	07000793          	li	a5,112
    80201038:	00f70a63          	beq	a4,a5,8020104c <vprintfmt+0x318>
    8020103c:	f8244783          	lbu	a5,-126(s0)
    80201040:	00078a63          	beqz	a5,80201054 <vprintfmt+0x320>
    80201044:	fe043783          	ld	a5,-32(s0)
    80201048:	00078663          	beqz	a5,80201054 <vprintfmt+0x320>
    8020104c:	00100793          	li	a5,1
    80201050:	0080006f          	j	80201058 <vprintfmt+0x324>
    80201054:	00000793          	li	a5,0
    80201058:	faf40323          	sb	a5,-90(s0)
    8020105c:	fa644783          	lbu	a5,-90(s0)
    80201060:	0017f793          	andi	a5,a5,1
    80201064:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
    80201068:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
    8020106c:	f5043783          	ld	a5,-176(s0)
    80201070:	0007c783          	lbu	a5,0(a5)
    80201074:	00078713          	mv	a4,a5
    80201078:	05800793          	li	a5,88
    8020107c:	00f71863          	bne	a4,a5,8020108c <vprintfmt+0x358>
    80201080:	00001797          	auipc	a5,0x1
    80201084:	06078793          	addi	a5,a5,96 # 802020e0 <upperxdigits.1>
    80201088:	00c0006f          	j	80201094 <vprintfmt+0x360>
    8020108c:	00001797          	auipc	a5,0x1
    80201090:	06c78793          	addi	a5,a5,108 # 802020f8 <lowerxdigits.0>
    80201094:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
    80201098:	fe043783          	ld	a5,-32(s0)
    8020109c:	00f7f793          	andi	a5,a5,15
    802010a0:	f9843703          	ld	a4,-104(s0)
    802010a4:	00f70733          	add	a4,a4,a5
    802010a8:	fdc42783          	lw	a5,-36(s0)
    802010ac:	0017869b          	addiw	a3,a5,1
    802010b0:	fcd42e23          	sw	a3,-36(s0)
    802010b4:	00074703          	lbu	a4,0(a4)
    802010b8:	ff078793          	addi	a5,a5,-16
    802010bc:	008787b3          	add	a5,a5,s0
    802010c0:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
    802010c4:	fe043783          	ld	a5,-32(s0)
    802010c8:	0047d793          	srli	a5,a5,0x4
    802010cc:	fef43023          	sd	a5,-32(s0)
                } while (num);
    802010d0:	fe043783          	ld	a5,-32(s0)
    802010d4:	fc0792e3          	bnez	a5,80201098 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
    802010d8:	f8c42783          	lw	a5,-116(s0)
    802010dc:	00078713          	mv	a4,a5
    802010e0:	fff00793          	li	a5,-1
    802010e4:	02f71663          	bne	a4,a5,80201110 <vprintfmt+0x3dc>
    802010e8:	f8344783          	lbu	a5,-125(s0)
    802010ec:	02078263          	beqz	a5,80201110 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
    802010f0:	f8842703          	lw	a4,-120(s0)
    802010f4:	fa644783          	lbu	a5,-90(s0)
    802010f8:	0007879b          	sext.w	a5,a5
    802010fc:	0017979b          	slliw	a5,a5,0x1
    80201100:	0007879b          	sext.w	a5,a5
    80201104:	40f707bb          	subw	a5,a4,a5
    80201108:	0007879b          	sext.w	a5,a5
    8020110c:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201110:	f8842703          	lw	a4,-120(s0)
    80201114:	fa644783          	lbu	a5,-90(s0)
    80201118:	0007879b          	sext.w	a5,a5
    8020111c:	0017979b          	slliw	a5,a5,0x1
    80201120:	0007879b          	sext.w	a5,a5
    80201124:	40f707bb          	subw	a5,a4,a5
    80201128:	0007871b          	sext.w	a4,a5
    8020112c:	fdc42783          	lw	a5,-36(s0)
    80201130:	f8f42a23          	sw	a5,-108(s0)
    80201134:	f8c42783          	lw	a5,-116(s0)
    80201138:	f8f42823          	sw	a5,-112(s0)
    8020113c:	f9442783          	lw	a5,-108(s0)
    80201140:	00078593          	mv	a1,a5
    80201144:	f9042783          	lw	a5,-112(s0)
    80201148:	00078613          	mv	a2,a5
    8020114c:	0006069b          	sext.w	a3,a2
    80201150:	0005879b          	sext.w	a5,a1
    80201154:	00f6d463          	bge	a3,a5,8020115c <vprintfmt+0x428>
    80201158:	00058613          	mv	a2,a1
    8020115c:	0006079b          	sext.w	a5,a2
    80201160:	40f707bb          	subw	a5,a4,a5
    80201164:	fcf42c23          	sw	a5,-40(s0)
    80201168:	0280006f          	j	80201190 <vprintfmt+0x45c>
                    putch(' ');
    8020116c:	f5843783          	ld	a5,-168(s0)
    80201170:	02000513          	li	a0,32
    80201174:	000780e7          	jalr	a5
                    ++written;
    80201178:	fec42783          	lw	a5,-20(s0)
    8020117c:	0017879b          	addiw	a5,a5,1
    80201180:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201184:	fd842783          	lw	a5,-40(s0)
    80201188:	fff7879b          	addiw	a5,a5,-1
    8020118c:	fcf42c23          	sw	a5,-40(s0)
    80201190:	fd842783          	lw	a5,-40(s0)
    80201194:	0007879b          	sext.w	a5,a5
    80201198:	fcf04ae3          	bgtz	a5,8020116c <vprintfmt+0x438>
                }

                if (prefix) {
    8020119c:	fa644783          	lbu	a5,-90(s0)
    802011a0:	0ff7f793          	zext.b	a5,a5
    802011a4:	04078463          	beqz	a5,802011ec <vprintfmt+0x4b8>
                    putch('0');
    802011a8:	f5843783          	ld	a5,-168(s0)
    802011ac:	03000513          	li	a0,48
    802011b0:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
    802011b4:	f5043783          	ld	a5,-176(s0)
    802011b8:	0007c783          	lbu	a5,0(a5)
    802011bc:	00078713          	mv	a4,a5
    802011c0:	05800793          	li	a5,88
    802011c4:	00f71663          	bne	a4,a5,802011d0 <vprintfmt+0x49c>
    802011c8:	05800793          	li	a5,88
    802011cc:	0080006f          	j	802011d4 <vprintfmt+0x4a0>
    802011d0:	07800793          	li	a5,120
    802011d4:	f5843703          	ld	a4,-168(s0)
    802011d8:	00078513          	mv	a0,a5
    802011dc:	000700e7          	jalr	a4
                    written += 2;
    802011e0:	fec42783          	lw	a5,-20(s0)
    802011e4:	0027879b          	addiw	a5,a5,2
    802011e8:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
    802011ec:	fdc42783          	lw	a5,-36(s0)
    802011f0:	fcf42a23          	sw	a5,-44(s0)
    802011f4:	0280006f          	j	8020121c <vprintfmt+0x4e8>
                    putch('0');
    802011f8:	f5843783          	ld	a5,-168(s0)
    802011fc:	03000513          	li	a0,48
    80201200:	000780e7          	jalr	a5
                    ++written;
    80201204:	fec42783          	lw	a5,-20(s0)
    80201208:	0017879b          	addiw	a5,a5,1
    8020120c:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
    80201210:	fd442783          	lw	a5,-44(s0)
    80201214:	0017879b          	addiw	a5,a5,1
    80201218:	fcf42a23          	sw	a5,-44(s0)
    8020121c:	f8c42703          	lw	a4,-116(s0)
    80201220:	fd442783          	lw	a5,-44(s0)
    80201224:	0007879b          	sext.w	a5,a5
    80201228:	fce7c8e3          	blt	a5,a4,802011f8 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
    8020122c:	fdc42783          	lw	a5,-36(s0)
    80201230:	fff7879b          	addiw	a5,a5,-1
    80201234:	fcf42823          	sw	a5,-48(s0)
    80201238:	03c0006f          	j	80201274 <vprintfmt+0x540>
                    putch(buf[i]);
    8020123c:	fd042783          	lw	a5,-48(s0)
    80201240:	ff078793          	addi	a5,a5,-16
    80201244:	008787b3          	add	a5,a5,s0
    80201248:	f807c783          	lbu	a5,-128(a5)
    8020124c:	0007871b          	sext.w	a4,a5
    80201250:	f5843783          	ld	a5,-168(s0)
    80201254:	00070513          	mv	a0,a4
    80201258:	000780e7          	jalr	a5
                    ++written;
    8020125c:	fec42783          	lw	a5,-20(s0)
    80201260:	0017879b          	addiw	a5,a5,1
    80201264:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
    80201268:	fd042783          	lw	a5,-48(s0)
    8020126c:	fff7879b          	addiw	a5,a5,-1
    80201270:	fcf42823          	sw	a5,-48(s0)
    80201274:	fd042783          	lw	a5,-48(s0)
    80201278:	0007879b          	sext.w	a5,a5
    8020127c:	fc07d0e3          	bgez	a5,8020123c <vprintfmt+0x508>
                }

                flags.in_format = false;
    80201280:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80201284:	2700006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201288:	f5043783          	ld	a5,-176(s0)
    8020128c:	0007c783          	lbu	a5,0(a5)
    80201290:	00078713          	mv	a4,a5
    80201294:	06400793          	li	a5,100
    80201298:	02f70663          	beq	a4,a5,802012c4 <vprintfmt+0x590>
    8020129c:	f5043783          	ld	a5,-176(s0)
    802012a0:	0007c783          	lbu	a5,0(a5)
    802012a4:	00078713          	mv	a4,a5
    802012a8:	06900793          	li	a5,105
    802012ac:	00f70c63          	beq	a4,a5,802012c4 <vprintfmt+0x590>
    802012b0:	f5043783          	ld	a5,-176(s0)
    802012b4:	0007c783          	lbu	a5,0(a5)
    802012b8:	00078713          	mv	a4,a5
    802012bc:	07500793          	li	a5,117
    802012c0:	08f71063          	bne	a4,a5,80201340 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
    802012c4:	f8144783          	lbu	a5,-127(s0)
    802012c8:	00078c63          	beqz	a5,802012e0 <vprintfmt+0x5ac>
    802012cc:	f4843783          	ld	a5,-184(s0)
    802012d0:	00878713          	addi	a4,a5,8
    802012d4:	f4e43423          	sd	a4,-184(s0)
    802012d8:	0007b783          	ld	a5,0(a5)
    802012dc:	0140006f          	j	802012f0 <vprintfmt+0x5bc>
    802012e0:	f4843783          	ld	a5,-184(s0)
    802012e4:	00878713          	addi	a4,a5,8
    802012e8:	f4e43423          	sd	a4,-184(s0)
    802012ec:	0007a783          	lw	a5,0(a5)
    802012f0:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
    802012f4:	fa843583          	ld	a1,-88(s0)
    802012f8:	f5043783          	ld	a5,-176(s0)
    802012fc:	0007c783          	lbu	a5,0(a5)
    80201300:	0007871b          	sext.w	a4,a5
    80201304:	07500793          	li	a5,117
    80201308:	40f707b3          	sub	a5,a4,a5
    8020130c:	00f037b3          	snez	a5,a5
    80201310:	0ff7f793          	zext.b	a5,a5
    80201314:	f8040713          	addi	a4,s0,-128
    80201318:	00070693          	mv	a3,a4
    8020131c:	00078613          	mv	a2,a5
    80201320:	f5843503          	ld	a0,-168(s0)
    80201324:	f08ff0ef          	jal	ra,80200a2c <print_dec_int>
    80201328:	00050793          	mv	a5,a0
    8020132c:	fec42703          	lw	a4,-20(s0)
    80201330:	00f707bb          	addw	a5,a4,a5
    80201334:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201338:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    8020133c:	1b80006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
    80201340:	f5043783          	ld	a5,-176(s0)
    80201344:	0007c783          	lbu	a5,0(a5)
    80201348:	00078713          	mv	a4,a5
    8020134c:	06e00793          	li	a5,110
    80201350:	04f71c63          	bne	a4,a5,802013a8 <vprintfmt+0x674>
                if (flags.longflag) {
    80201354:	f8144783          	lbu	a5,-127(s0)
    80201358:	02078463          	beqz	a5,80201380 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
    8020135c:	f4843783          	ld	a5,-184(s0)
    80201360:	00878713          	addi	a4,a5,8
    80201364:	f4e43423          	sd	a4,-184(s0)
    80201368:	0007b783          	ld	a5,0(a5)
    8020136c:	faf43823          	sd	a5,-80(s0)
                    *n = written;
    80201370:	fec42703          	lw	a4,-20(s0)
    80201374:	fb043783          	ld	a5,-80(s0)
    80201378:	00e7b023          	sd	a4,0(a5)
    8020137c:	0240006f          	j	802013a0 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
    80201380:	f4843783          	ld	a5,-184(s0)
    80201384:	00878713          	addi	a4,a5,8
    80201388:	f4e43423          	sd	a4,-184(s0)
    8020138c:	0007b783          	ld	a5,0(a5)
    80201390:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
    80201394:	fb843783          	ld	a5,-72(s0)
    80201398:	fec42703          	lw	a4,-20(s0)
    8020139c:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
    802013a0:	f8040023          	sb	zero,-128(s0)
    802013a4:	1500006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
    802013a8:	f5043783          	ld	a5,-176(s0)
    802013ac:	0007c783          	lbu	a5,0(a5)
    802013b0:	00078713          	mv	a4,a5
    802013b4:	07300793          	li	a5,115
    802013b8:	02f71e63          	bne	a4,a5,802013f4 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
    802013bc:	f4843783          	ld	a5,-184(s0)
    802013c0:	00878713          	addi	a4,a5,8
    802013c4:	f4e43423          	sd	a4,-184(s0)
    802013c8:	0007b783          	ld	a5,0(a5)
    802013cc:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
    802013d0:	fc043583          	ld	a1,-64(s0)
    802013d4:	f5843503          	ld	a0,-168(s0)
    802013d8:	dccff0ef          	jal	ra,802009a4 <puts_wo_nl>
    802013dc:	00050793          	mv	a5,a0
    802013e0:	fec42703          	lw	a4,-20(s0)
    802013e4:	00f707bb          	addw	a5,a4,a5
    802013e8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    802013ec:	f8040023          	sb	zero,-128(s0)
    802013f0:	1040006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
    802013f4:	f5043783          	ld	a5,-176(s0)
    802013f8:	0007c783          	lbu	a5,0(a5)
    802013fc:	00078713          	mv	a4,a5
    80201400:	06300793          	li	a5,99
    80201404:	02f71e63          	bne	a4,a5,80201440 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
    80201408:	f4843783          	ld	a5,-184(s0)
    8020140c:	00878713          	addi	a4,a5,8
    80201410:	f4e43423          	sd	a4,-184(s0)
    80201414:	0007a783          	lw	a5,0(a5)
    80201418:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
    8020141c:	fcc42703          	lw	a4,-52(s0)
    80201420:	f5843783          	ld	a5,-168(s0)
    80201424:	00070513          	mv	a0,a4
    80201428:	000780e7          	jalr	a5
                ++written;
    8020142c:	fec42783          	lw	a5,-20(s0)
    80201430:	0017879b          	addiw	a5,a5,1
    80201434:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201438:	f8040023          	sb	zero,-128(s0)
    8020143c:	0b80006f          	j	802014f4 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
    80201440:	f5043783          	ld	a5,-176(s0)
    80201444:	0007c783          	lbu	a5,0(a5)
    80201448:	00078713          	mv	a4,a5
    8020144c:	02500793          	li	a5,37
    80201450:	02f71263          	bne	a4,a5,80201474 <vprintfmt+0x740>
                putch('%');
    80201454:	f5843783          	ld	a5,-168(s0)
    80201458:	02500513          	li	a0,37
    8020145c:	000780e7          	jalr	a5
                ++written;
    80201460:	fec42783          	lw	a5,-20(s0)
    80201464:	0017879b          	addiw	a5,a5,1
    80201468:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    8020146c:	f8040023          	sb	zero,-128(s0)
    80201470:	0840006f          	j	802014f4 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
    80201474:	f5043783          	ld	a5,-176(s0)
    80201478:	0007c783          	lbu	a5,0(a5)
    8020147c:	0007871b          	sext.w	a4,a5
    80201480:	f5843783          	ld	a5,-168(s0)
    80201484:	00070513          	mv	a0,a4
    80201488:	000780e7          	jalr	a5
                ++written;
    8020148c:	fec42783          	lw	a5,-20(s0)
    80201490:	0017879b          	addiw	a5,a5,1
    80201494:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201498:	f8040023          	sb	zero,-128(s0)
    8020149c:	0580006f          	j	802014f4 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
    802014a0:	f5043783          	ld	a5,-176(s0)
    802014a4:	0007c783          	lbu	a5,0(a5)
    802014a8:	00078713          	mv	a4,a5
    802014ac:	02500793          	li	a5,37
    802014b0:	02f71063          	bne	a4,a5,802014d0 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
    802014b4:	f8043023          	sd	zero,-128(s0)
    802014b8:	f8043423          	sd	zero,-120(s0)
    802014bc:	00100793          	li	a5,1
    802014c0:	f8f40023          	sb	a5,-128(s0)
    802014c4:	fff00793          	li	a5,-1
    802014c8:	f8f42623          	sw	a5,-116(s0)
    802014cc:	0280006f          	j	802014f4 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
    802014d0:	f5043783          	ld	a5,-176(s0)
    802014d4:	0007c783          	lbu	a5,0(a5)
    802014d8:	0007871b          	sext.w	a4,a5
    802014dc:	f5843783          	ld	a5,-168(s0)
    802014e0:	00070513          	mv	a0,a4
    802014e4:	000780e7          	jalr	a5
            ++written;
    802014e8:	fec42783          	lw	a5,-20(s0)
    802014ec:	0017879b          	addiw	a5,a5,1
    802014f0:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
    802014f4:	f5043783          	ld	a5,-176(s0)
    802014f8:	00178793          	addi	a5,a5,1
    802014fc:	f4f43823          	sd	a5,-176(s0)
    80201500:	f5043783          	ld	a5,-176(s0)
    80201504:	0007c783          	lbu	a5,0(a5)
    80201508:	84079ce3          	bnez	a5,80200d60 <vprintfmt+0x2c>
        }
    }

    return written;
    8020150c:	fec42783          	lw	a5,-20(s0)
}
    80201510:	00078513          	mv	a0,a5
    80201514:	0b813083          	ld	ra,184(sp)
    80201518:	0b013403          	ld	s0,176(sp)
    8020151c:	0c010113          	addi	sp,sp,192
    80201520:	00008067          	ret

0000000080201524 <printk>:

int printk(const char* s, ...) {
    80201524:	f9010113          	addi	sp,sp,-112
    80201528:	02113423          	sd	ra,40(sp)
    8020152c:	02813023          	sd	s0,32(sp)
    80201530:	03010413          	addi	s0,sp,48
    80201534:	fca43c23          	sd	a0,-40(s0)
    80201538:	00b43423          	sd	a1,8(s0)
    8020153c:	00c43823          	sd	a2,16(s0)
    80201540:	00d43c23          	sd	a3,24(s0)
    80201544:	02e43023          	sd	a4,32(s0)
    80201548:	02f43423          	sd	a5,40(s0)
    8020154c:	03043823          	sd	a6,48(s0)
    80201550:	03143c23          	sd	a7,56(s0)
    int res = 0;
    80201554:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    80201558:	04040793          	addi	a5,s0,64
    8020155c:	fcf43823          	sd	a5,-48(s0)
    80201560:	fd043783          	ld	a5,-48(s0)
    80201564:	fc878793          	addi	a5,a5,-56
    80201568:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    8020156c:	fe043783          	ld	a5,-32(s0)
    80201570:	00078613          	mv	a2,a5
    80201574:	fd843583          	ld	a1,-40(s0)
    80201578:	fffff517          	auipc	a0,0xfffff
    8020157c:	11850513          	addi	a0,a0,280 # 80200690 <putc>
    80201580:	fb4ff0ef          	jal	ra,80200d34 <vprintfmt>
    80201584:	00050793          	mv	a5,a0
    80201588:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    8020158c:	fec42783          	lw	a5,-20(s0)
}
    80201590:	00078513          	mv	a0,a5
    80201594:	02813083          	ld	ra,40(sp)
    80201598:	02013403          	ld	s0,32(sp)
    8020159c:	07010113          	addi	sp,sp,112
    802015a0:	00008067          	ret
