#!/usr/bin/env python

SIZE=4096
LINE=8
DEFAULTWORD = 'X"00000000"'

data=[]

inputdata = open('prog.bin','rb').read()
pad = (-len(inputdata)) % 4
inputdata += b'\x00' * pad
for i in range(0, len(inputdata), 4):
    w = inputdata[i:i+4]
    val = int.from_bytes(w, 'little')
    data.append(f'X"{val:08x}"')

oldsize = len(data)
for i in range(oldsize, SIZE):
    data.append(DEFAULTWORD)

i = 0
while i < SIZE:
    print(', '.join(data[i:i+LINE]) + ('' if i + LINE >= len(data) else ','))
    i += LINE
