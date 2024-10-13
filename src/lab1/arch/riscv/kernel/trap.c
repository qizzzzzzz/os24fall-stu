#include "stdint.h"
#include "printk.h"
#include "clock.h"

void trap_handler(uint64_t scause, uint64_t sepc) {
    // interrupt：最高位
    uint64_t interrupt = (scause >> 63) & 1;

    // exception_code：剩余位
    uint64_t exception_code = scause & 0x7FFFFFFFFFFFFFFF;

    // 最高位为0：interrupt；最高位为1：exception
    // Supervisor timer interrupt剩余位值为5

    if(interrupt == 1) {
        if(exception_code == 5) {
            printk("[S] Supervisor Mode Timer Interrupt\n");
            clock_set_next_event();
        }else {
            printk("Other Interrupt\n");
        }
    }else {
        printk("Exception\n");
    }
}