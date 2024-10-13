ASM_SRC		= $(sort $(wildcard *.S))
C_SRC       = $(sort $(wildcard *.c))
OBJ		    = $(patsubst %.S,%.o,$(ASM_SRC)) $(patsubst %.c,%.o,$(C_SRC))
# DEP      = $(patsubst %.c,%.d,$(C_SRC))  # 生成依赖文件列表

# CFLAGS = -I../include -I../../../include ${OTHER_CFLAGS} -MMD -MP

all:$(OBJ)

%.o:%.S
	${GCC}  ${CFLAG} -c $<

%.o:%.c
	${GCC}  ${CFLAG} -c $<

clean:
	$(shell rm *.o 2>/dev/null)
