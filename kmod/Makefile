obj-m := ksys_trace.o

KDIR ?= /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
	objcopy --remove-section=.BTF ksys_trace.ko
	@echo ">> BTF section removed successfully!"

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean