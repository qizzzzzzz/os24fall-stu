#include "sbi.h"
#include "defs.h"
#include "printk.h"

void print_binary(uint64_t value) {
    for (int i = 63; i >= 0; i--) {
        printk("%d",(value & (1ULL << i)) ? 1 : 0);
        // 每 8 位加一个空格，便于阅读
        if (i % 8 == 0) {
            printk(" ");
        }
    }
    printk("\n");
}

void test() {
    int i = 0;
    uint64_t sscratch_value = csr_read(sscratch);
    printk("Before:%d\n",sscratch_value);
    csr_write(sscratch, 1);
    sscratch_value = csr_read(sscratch);
    printk("After:%d\n",sscratch_value);

    while (1) {
        if ((++i) % 300000000 == 0) {
            printk("kernel is running!\n");
            // uint64_t sstatus_value = csr_read(sstatus);
            // print_binary(sstatus_value);
            i = 0;
        }
    }
}