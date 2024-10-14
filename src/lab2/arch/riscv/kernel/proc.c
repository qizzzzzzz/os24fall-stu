#include "proc.h"
#include "defs.h"
#include "mm.h"
#include "printk.h"
#include "stdlib.h"

extern void __dummy();
extern void __switch_to(struct task_struct *prev, struct task_struct *next);

struct task_struct *idle;          // idle process
struct task_struct *current;       // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS];// 线程数组，所有的线程都保存在此

void task_init() {
    srand(2024);

    // 1. 调用 kalloc() 为 idle 分配一个物理页
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    idle = (struct task_struct*) kalloc();
    idle->state = TASK_RUNNING;
    idle->counter = 0;
    idle->priority = 0;
    idle->pid = 0;
    current = idle;
    task[0] = idle;
    printk("\nINIT [PID = %d PRIORITY = %d COUNTER = %d]\n", idle->pid, idle->priority, idle->counter);

    // 1. 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    // 2. 其中每个线程的 state 为 TASK_RUNNING, 此外，counter 和 priority 进行如下赋值：
    //     - counter  = 0;
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    for (uint64_t i = 1; i < NR_TASKS; i++) {
        task[i] = (struct task_struct *) kalloc();
        task[i]->state = TASK_RUNNING;
        task[i]->counter = 0;
        task[i]->pid = i;
        task[i]->priority = rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;// 随机数在[PRIORITY_MIN, PRIORITY_MAX] 之间
        task[i]->thread.ra = (uint64_t) (uintptr_t) __dummy;                          // (uint64_t)(uintptr_t)双重转换确保安全
        task[i]->thread.sp = (uint64_t) (uintptr_t) task[i] + PGSIZE;                 // 比task[i]本身指针高PGSIZE位
        printk("INIT [PID = %d PRIORITY = %d COUNTER = %d]\n", task[i]->pid, task[i]->priority, task[i]->counter);
    }
    printk("...task_init done!\n");
}

#if TEST_SCHED
#define MAX_OUTPUT ((NR_TASKS - 1) * 10)
char tasks_output[MAX_OUTPUT];
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    uint64_t MOD = 1000000007;
    uint64_t auto_inc_local_var = 0;
    int last_counter = -1;
    printk(GREEN"[PID = %d] start dummy.\n" CLEAR, current->pid);
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
            if (current->counter == 1) {
                --(current->counter);// forced the counter to be zero if this thread is going to be scheduled
            }// in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
#if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
            if (tasks_output_index == MAX_OUTPUT) {
                for (int i = 0; i < MAX_OUTPUT; ++i) {
                    if (tasks_output[i] != expected_output[i]) {
                        printk("\033[31mTest failed!\033[0m\n");
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
            }
#endif
        }
    }
}

void switch_to(struct task_struct *next) {
    static int num_call = 0;    // 记录 __switch_to 被调用的次数
    static int num_return = 0;  // 记录 __switch_to 返回的次数
    if(current != next){
        struct task_struct* prev = current;
        current = next; // 更新next必须在调用 __switch_to 前，因为该函数可能不会返回，而是跳转至 next 进程中 ra 储存地址
        printk(BLUE"\nswitch to [PID = %d PRIORITY = %d COUNTER = %d]\n" CLEAR, next->pid, next->priority, next->counter);

        num_call++;
        printk(RED" __switch_to has been called for the %d-th time\n" CLEAR, num_call);

        __switch_to(prev, next);

        num_return++;
        printk(RED" __switch_to has returned for the %d-th time\n" CLEAR, num_return);

        // printk(RED"return successfully\n" CLEAR);
        // 第一轮中，因为 ra 变成了 dummy 的地址，所以不会回到这个函数，所以不会输出 return successfully
        // 第二轮后，ra 为 __switch_to 地址，所以会回到该函数，正确输出
    }
}

void do_timer() {
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    if (current == idle || current->counter == 0) {
        schedule();
    }
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
    else {
        current->counter -= 1;
        if (current->counter == 0) {
            schedule();
        }
    }
}

void schedule() {
    uint64_t next = 0;
    // 调度时选择 counter 最大的线程运行
    for (uint64_t i = 1; i < NR_TASKS; i++) {
        if (task[i]->counter > task[next]->counter) {
            next = i;
        }
    }
    // 如果所有线程 counter 都为 0，则令所有线程 counter = priority
    if (task[next]->counter == 0) {
        for (uint64_t i = 1; i < NR_TASKS; i++) {
            task[i]->counter = task[i]->priority;
            if (task[i]->counter > task[next]->counter) {
                next = i;
            }
            if(i == 1){
                printk("\n"); // 将SET打印内容分离便于观察
            }
            printk(YELLOW"SET [PID = %d PRIORITY = %d COUNTER = %d]\n" CLEAR, task[i]->pid, task[i]->priority, task[i]->counter);
        }
    }
    switch_to(task[next]);
}