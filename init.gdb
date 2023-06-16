define hook-quit
    kill
end

target remote localhost:1234
set disassemble-next-line on
set architecture arm
symbol-file tools/system
layout asm
layout split
list
b sched_init
b breakpoint
