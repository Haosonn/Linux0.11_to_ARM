
# 环境配置
``` 
//下载交叉编译库
sudo apt install gcc-arm-linux-gnueabihf
//下载QEMU
sudo apt install qemu-system-arm
//下载gdb
sudo apt install gdb-multiarch
```

# 启动项解释

``` Makefile
	qemu-system-arm \
		-machine virt,gic-version=3 \
		-m 4G \
		-cpu cortex-a7 \
		-nographic \
		-device loader,file=Image,addr=0xC0008000,cpu-num=0 \
		-s -S \
		-serial mon:stdio 
```
- gic-version=3: cortex-a7架构理应用gic-version=2，但发现qemu对gic模拟好像一直出了啥问题（地址`0x8000000-0x8010000`），在`GIC_init()`获取`GICD_TYPER`时进入Data abort, `DFSR`代码为`0x8`，即Synchronous external abort, 怀疑是qemu的模拟出问题

- -s: 默认让QEMU监听localhost:1234 
- -S: 一开始停止cpu工作，方便调试
- -serial mon:stdio 把控制台作为uart输出


# 调试
1. 在terminal中先make qemu启动qemu
2. 再开一个terminal, 输入`gdb-multiarch -x init.gdb`
