define hook-quit
    kill
end

target remote localhost:1234
set architecture arm
symbol-file tools/system
layout asm
layout split
list
b __divsi3
b breakpoint
