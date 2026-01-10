#include <linux/module.h>
#include <linux/export-internal.h>
#include <linux/compiler.h>

MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};



static const struct modversion_info ____versions[]
__used __section("__versions") = {
	{ 0x34db050b, "_raw_spin_lock_irqsave" },
	{ 0xd35cce70, "_raw_spin_unlock_irqrestore" },
	{ 0x6b10bee1, "_copy_to_user" },
	{ 0xf0fdf6cb, "__stack_chk_fail" },
	{ 0xe2c17b5d, "__SCT__might_resched" },
	{ 0xfe487975, "init_wait_entry" },
	{ 0x01000e51, "schedule" },
	{ 0x8c26d495, "prepare_to_wait_event" },
	{ 0x92540fbf, "finish_wait" },
	{ 0x6a5cc518, "__kmalloc_noprof" },
	{ 0x1c303cee, "validate_usercopy_range" },
	{ 0x88db9f48, "__check_object_size" },
	{ 0xb43f9365, "ktime_get" },
	{ 0x45097ebf, "const_current_task" },
	{ 0xa916b694, "strnlen" },
	{ 0x476b165a, "sized_strscpy" },
	{ 0x8522d6bc, "strncpy_from_user" },
	{ 0x5a921311, "strncmp" },
	{ 0xe2964344, "__wake_up" },
	{ 0x19dee613, "__fortify_panic" },
	{ 0xfb63aebf, "misc_deregister" },
	{ 0x65487097, "__x86_indirect_thunk_rax" },
	{ 0x4c03a563, "random_kmalloc_seed" },
	{ 0x6ff96825, "kmalloc_caches" },
	{ 0x73dfdff1, "__kmalloc_cache_noprof" },
	{ 0x12916334, "noop_llseek" },
	{ 0xadb47d94, "param_ops_charp" },
	{ 0x9f259962, "param_ops_int" },
	{ 0xbdfb6dbb, "__fentry__" },
	{ 0x5b8239ca, "__x86_return_thunk" },
	{ 0x3f66a26e, "register_kprobe" },
	{ 0x19010199, "misc_register" },
	{ 0x122c3a7e, "_printk" },
	{ 0xbb10e61d, "unregister_kprobe" },
	{ 0x037a0cba, "kfree" },
	{ 0xdc50aae2, "__ref_stack_chk_guard" },
	{ 0x4121abdf, "module_layout" },
};

MODULE_INFO(depends, "");


MODULE_INFO(srcversion, "A1DF2EDDDCE3F1138F7AFA0");
