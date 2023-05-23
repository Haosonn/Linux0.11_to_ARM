
# 环境配置
``` 
//下载交叉编译库
sudo apt install gcc-arm-linux-gnueabihf
//下载QEMU
sudo apt install qemu-system-arm
//下载gdb
sudo apt install gdb-multiarch
```

# 调试
1. 在terminal中先make qemu启动qemu
2. 再开一个terminal, 输入`gdb-multiarch -x init.gdb`
