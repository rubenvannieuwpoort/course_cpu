.section .text
.global _start

_start:
la t0, trap_handler
csrw mtvec, t0

# store 100000000 in MTIMECMP
li s0, 0x2004000
li s1, 100000000
# sw s1, 0(s2)

# enable machine timer interrupt
li   t0, (1 << 7)
csrs mie, t0

# enable global machine interrupts
li   t0, (1 << 3)
csrs mstatus, t0

hang:
j hang


trap_handler:

# negate s3
not s3, s3

.word 0x0009807f

lw t0, 0(s0)
lw t1, 4(s0)

# add 100M to low word
add t2, t0, s1

# compute carry (1 if new < original)
sltu t3, t2, t0

# add carry to high word
add t1, t1, t3

sw t2, 0(s0)  # store low word
sw t1, 4(s0)  # store high word

mret
