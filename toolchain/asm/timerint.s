.section .text
.global _start

_start:
la t0, trap_handler
csrw mtvec, t0

# store 100 in MTIMECMP
li t0, 0x2004000
li t1, 100
sw t1, 0(t0)

# enable machine timer interrupt
li   t0, (1 << 7)
csrs mie, t0

# enable global machine interrupts
li   t0, (1 << 3)
csrs mstatus, t0

hang:
j hang

trap_handler:
li   t0, (1 << 7)
csrc mie, t0
mret
