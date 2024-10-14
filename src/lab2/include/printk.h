#ifndef __PRINTK_H__
#define __PRINTK_H__

#include "stddef.h"

#define bool _Bool
#define true 1
#define false 0
#define RED "\033[31m"
#define GREEN "\033[32m"
#define YELLOW "\033[33m"
#define BLUE "\033[34m"
#define PURPLE "\033[35m"
#define DEEPGREEN "\033[36m"
#define CLEAR "\033[0m"

#define Log(format, ...) \
    printk("\33[1;35m[%s,%d,%s] " format "\33[0m\n", \
        __FILE__, __LINE__, __func__, ## __VA_ARGS__)

int printk(const char *, ...);

#endif