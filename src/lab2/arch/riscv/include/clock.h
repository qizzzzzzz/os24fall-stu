#ifndef CLOCK_H
#define CLOCK_H

#include "stdint.h"

// 定义时钟频率常量
extern uint64_t TIMECLOCK;

// 函数声明
uint64_t get_cycles(void);
void clock_set_next_event(void);

#endif // CLOCK_H
