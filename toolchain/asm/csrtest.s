    .section .text
    .globl _start

_start:
    /* Clear mscratch (swap with zero) */
    li      t0, 0
    csrrw   t1, mscratch, t0     /* t1 = old mstatus, mstatus = 0 */

    /* Set some bits using register variant */
    li      t0, 0x8             /* example: set MIE bit */
    csrrs   t2, mscratch, t0     /* set bits, t2 = old mstatus */

    /* Clear some bits using register variant */
    li      t0, 0x8
    csrrc   t3, mscratch, t0     /* clear MIE bit, t3 = old mstatus */

    /* Set bits using immediate variant */
    csrsi   mscratch, 0x8        /* set MIE bit */

    /* Clear bits using immediate variant */
    csrci   mscratch, 0x8        /* clear MIE bit */

    /* Read CSR using register variant (no side effects) */
    csrrs   t4, mscratch, x0     /* t4 = mstatus */

    /* Read CSR using immediate variant (no side effects) */
    csrrsi  t5, mscratch, 0      /* t5 = mstatus */

    /* Swap CSR and register again */
    li      t0, 0x1800          /* example: set MPP=11 */
    csrrw   t6, mscratch, t0     /* t6 = old mstatus */

hang:
    j       hang

