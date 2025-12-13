#!/usr/bin/env bash

riscv-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -ffreestanding -O2 start.s main.c -T linker.ld -o prog.elf
riscv-elf-objcopy -O binary prog.elf prog.bin
python process.py
