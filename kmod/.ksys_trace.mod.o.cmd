savedcmd_ksys_trace.mod.o := gcc -Wp,-MMD,./.ksys_trace.mod.o.d -nostdinc -I/home/kt5965/linux-build/arch/x86/include -I/home/kt5965/linux-build/arch/x86/include/generated -I/home/kt5965/linux-build/include -I/home/kt5965/linux-build/include -I/home/kt5965/linux-build/arch/x86/include/uapi -I/home/kt5965/linux-build/arch/x86/include/generated/uapi -I/home/kt5965/linux-build/include/uapi -I/home/kt5965/linux-build/include/generated/uapi -include /home/kt5965/linux-build/include/linux/compiler-version.h -include /home/kt5965/linux-build/include/linux/kconfig.h -include /home/kt5965/linux-build/include/linux/compiler_types.h -D__KERNEL__ -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fcf-protection=none -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -march=x86-64 -mtune=generic -mno-red-zone -mcmodel=kernel -mstack-protector-guard-reg=gs -mstack-protector-guard-symbol=__ref_stack_chk_guard -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register -mindirect-branch-cs-prefix -mfunction-return=thunk-extern -fno-jump-tables -mharden-sls=all -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fstack-protector-strong -fno-omit-frame-pointer -fno-optimize-sibling-calls -ftrivial-auto-var-init=zero -fno-stack-clash-protection -fzero-call-used-regs=used-gpr -pg -mrecord-mcount -mfentry -DCC_USING_FENTRY -falign-functions=16 -fstrict-flex-arrays=3 -fno-strict-overflow -fno-stack-check -fconserve-stack -fno-builtin-wcslen -Wall -Wextra -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wmissing-declarations -Wmissing-prototypes -Wframe-larger-than=1024 -Wno-main -Wno-dangling-pointer -Wvla-larger-than=1 -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-stringop-overflow -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wunused -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-truncation -Wno-override-init -Wno-missing-field-initializers -Wno-type-limits -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare -Wno-unused-parameter -g -gdwarf-5  -fsanitize=bounds-strict -fsanitize=shift -fsanitize=bool -fsanitize=enum    -DMODULE  -DKBUILD_BASENAME='"ksys_trace.mod"' -DKBUILD_MODNAME='"ksys_trace"' -D__KBUILD_MODNAME=kmod_ksys_trace -c -o ksys_trace.mod.o ksys_trace.mod.c   ; /home/kt5965/linux-build/tools/objtool/objtool --hacks=jump_label --hacks=noinstr --hacks=skylake --retpoline --rethunk --sls --stackval --static-call --uaccess --prefix=16   --module ksys_trace.mod.o

source_ksys_trace.mod.o := ksys_trace.mod.c

deps_ksys_trace.mod.o := \
    $(wildcard include/config/MODULE_UNLOAD) \
  /home/kt5965/linux-build/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/kt5965/linux-build/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/kt5965/linux-build/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/CC_HAS_SANE_FUNCTION_ALIGNMENT) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/LD_DEAD_CODE_DATA_ELIMINATION) \
    $(wildcard include/config/LTO_CLANG) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_COUNTED_BY) \
    $(wildcard include/config/CC_HAS_MULTIDIMENSIONAL_NONSTRING) \
    $(wildcard include/config/UBSAN_INTEGER_WRAP) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/kt5965/linux-build/include/linux/compiler_attributes.h \
  /home/kt5965/linux-build/include/linux/compiler-gcc.h \
    $(wildcard include/config/MITIGATION_RETPOLINE) \
    $(wildcard include/config/ARCH_USE_BUILTIN_BSWAP) \
    $(wildcard include/config/SHADOW_CALL_STACK) \
    $(wildcard include/config/KCOV) \
    $(wildcard include/config/CC_HAS_TYPEOF_UNQUAL) \
  /home/kt5965/linux-build/include/linux/module.h \
    $(wildcard include/config/MODULES) \
    $(wildcard include/config/SYSFS) \
    $(wildcard include/config/MODULES_TREE_LOOKUP) \
    $(wildcard include/config/LIVEPATCH) \
    $(wildcard include/config/STACKTRACE_BUILD_ID) \
    $(wildcard include/config/ARCH_USES_CFI_TRAPS) \
    $(wildcard include/config/MODULE_SIG) \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/KALLSYMS) \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/TRACEPOINTS) \
    $(wildcard include/config/TREE_SRCU) \
    $(wildcard include/config/BPF_EVENTS) \
    $(wildcard include/config/DEBUG_INFO_BTF_MODULES) \
    $(wildcard include/config/JUMP_LABEL) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/EVENT_TRACING) \
    $(wildcard include/config/FTRACE_MCOUNT_RECORD) \
    $(wildcard include/config/KPROBES) \
    $(wildcard include/config/HAVE_STATIC_CALL_INLINE) \
    $(wildcard include/config/KUNIT) \
    $(wildcard include/config/PRINTK_INDEX) \
    $(wildcard include/config/MITIGATION_ITS) \
    $(wildcard include/config/CONSTRUCTORS) \
    $(wildcard include/config/FUNCTION_ERROR_INJECTION) \
    $(wildcard include/config/DYNAMIC_DEBUG_CORE) \
  /home/kt5965/linux-build/include/linux/list.h \
    $(wildcard include/config/LIST_HARDENED) \
    $(wildcard include/config/DEBUG_LIST) \
  /home/kt5965/linux-build/include/linux/container_of.h \
  /home/kt5965/linux-build/include/linux/build_bug.h \
  /home/kt5965/linux-build/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
    $(wildcard include/config/CFI_CLANG) \
    $(wildcard include/config/64BIT) \
  /home/kt5965/linux-build/arch/x86/include/generated/asm/rwonce.h \
  /home/kt5965/linux-build/include/asm-generic/rwonce.h \
  /home/kt5965/linux-build/include/linux/kasan-checks.h \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KASAN_SW_TAGS) \
  /home/kt5965/linux-build/include/linux/types.h \
    $(wildcard include/config/HAVE_UID16) \
    $(wildcard include/config/UID16) \
    $(wildcard include/config/ARCH_DMA_ADDR_T_64BIT) \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
    $(wildcard include/config/ARCH_32BIT_USTAT_F_TINODE) \
  /home/kt5965/linux-build/include/uapi/linux/types.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/types.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/types.h \
  /home/kt5965/linux-build/include/asm-generic/int-ll64.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/int-ll64.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/bitsperlong.h \
  /home/kt5965/linux-build/include/asm-generic/bitsperlong.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/bitsperlong.h \
  /home/kt5965/linux-build/include/uapi/linux/posix_types.h \
  /home/kt5965/linux-build/include/linux/stddef.h \
  /home/kt5965/linux-build/include/uapi/linux/stddef.h \
  /home/kt5965/linux-build/arch/x86/include/asm/posix_types.h \
    $(wildcard include/config/X86_32) \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/posix_types_64.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/posix_types.h \
  /home/kt5965/linux-build/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /home/kt5965/linux-build/include/linux/poison.h \
    $(wildcard include/config/ILLEGAL_POINTER_VALUE) \
  /home/kt5965/linux-build/include/linux/const.h \
  /home/kt5965/linux-build/include/vdso/const.h \
  /home/kt5965/linux-build/include/uapi/linux/const.h \
  /home/kt5965/linux-build/arch/x86/include/asm/barrier.h \
  /home/kt5965/linux-build/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/CALL_THUNKS) \
    $(wildcard include/config/MITIGATION_RETHUNK) \
  /home/kt5965/linux-build/include/linux/stringify.h \
  /home/kt5965/linux-build/include/linux/objtool.h \
    $(wildcard include/config/FRAME_POINTER) \
    $(wildcard include/config/NOINSTR_VALIDATION) \
    $(wildcard include/config/MITIGATION_UNRET_ENTRY) \
    $(wildcard include/config/MITIGATION_SRSO) \
  /home/kt5965/linux-build/include/linux/objtool_types.h \
  /home/kt5965/linux-build/arch/x86/include/asm/asm.h \
  /home/kt5965/linux-build/arch/x86/include/asm/extable_fixup_types.h \
  /home/kt5965/linux-build/arch/x86/include/asm/bug.h \
    $(wildcard include/config/DEBUG_BUGVERBOSE) \
  /home/kt5965/linux-build/include/linux/instrumentation.h \
  /home/kt5965/linux-build/include/asm-generic/bug.h \
    $(wildcard include/config/BUG) \
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
  /home/kt5965/linux-build/include/linux/once_lite.h \
  /home/kt5965/linux-build/include/linux/panic.h \
    $(wildcard include/config/PANIC_TIMEOUT) \
  /home/kt5965/linux-build/include/linux/printk.h \
    $(wildcard include/config/MESSAGE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_QUIET) \
    $(wildcard include/config/EARLY_PRINTK) \
    $(wildcard include/config/PRINTK) \
    $(wildcard include/config/DYNAMIC_DEBUG) \
  /home/kt5965/linux-build/include/linux/stdarg.h \
  /home/kt5965/linux-build/include/linux/init.h \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
  /home/kt5965/linux-build/include/linux/kern_levels.h \
  /home/kt5965/linux-build/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/kt5965/linux-build/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
    $(wildcard include/config/GENDWARFKSYMS) \
  /home/kt5965/linux-build/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/CALL_PADDING) \
    $(wildcard include/config/MITIGATION_SLS) \
    $(wildcard include/config/FUNCTION_PADDING_BYTES) \
    $(wildcard include/config/UML) \
  /home/kt5965/linux-build/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
    $(wildcard include/config/FINEIBT_BHI) \
  /home/kt5965/linux-build/include/linux/ratelimit_types.h \
  /home/kt5965/linux-build/include/linux/bits.h \
  /home/kt5965/linux-build/include/vdso/bits.h \
  /home/kt5965/linux-build/include/uapi/linux/bits.h \
  /home/kt5965/linux-build/include/linux/overflow.h \
  /home/kt5965/linux-build/include/linux/limits.h \
  /home/kt5965/linux-build/include/uapi/linux/limits.h \
  /home/kt5965/linux-build/include/vdso/limits.h \
  /home/kt5965/linux-build/include/uapi/linux/param.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/param.h \
  /home/kt5965/linux-build/include/asm-generic/param.h \
    $(wildcard include/config/HZ) \
  /home/kt5965/linux-build/include/uapi/asm-generic/param.h \
  /home/kt5965/linux-build/include/linux/spinlock_types_raw.h \
    $(wildcard include/config/DEBUG_SPINLOCK) \
    $(wildcard include/config/DEBUG_LOCK_ALLOC) \
  /home/kt5965/linux-build/arch/x86/include/asm/spinlock_types.h \
  /home/kt5965/linux-build/include/asm-generic/qspinlock_types.h \
    $(wildcard include/config/NR_CPUS) \
  /home/kt5965/linux-build/include/asm-generic/qrwlock_types.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/byteorder.h \
  /home/kt5965/linux-build/include/linux/byteorder/little_endian.h \
  /home/kt5965/linux-build/include/uapi/linux/byteorder/little_endian.h \
  /home/kt5965/linux-build/include/linux/swab.h \
  /home/kt5965/linux-build/include/uapi/linux/swab.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/swab.h \
  /home/kt5965/linux-build/include/linux/byteorder/generic.h \
  /home/kt5965/linux-build/include/linux/lockdep_types.h \
    $(wildcard include/config/PROVE_RAW_LOCK_NESTING) \
    $(wildcard include/config/LOCKDEP) \
    $(wildcard include/config/LOCK_STAT) \
  /home/kt5965/linux-build/include/linux/dynamic_debug.h \
  /home/kt5965/linux-build/include/linux/jump_label.h \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /home/kt5965/linux-build/include/linux/cleanup.h \
  /home/kt5965/linux-build/arch/x86/include/asm/jump_label.h \
    $(wildcard include/config/HAVE_JUMP_LABEL_HACK) \
  /home/kt5965/linux-build/arch/x86/include/asm/nops.h \
  /home/kt5965/linux-build/include/asm-generic/barrier.h \
  /home/kt5965/linux-build/include/linux/stat.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/stat.h \
  /home/kt5965/linux-build/include/uapi/linux/stat.h \
  /home/kt5965/linux-build/include/linux/time.h \
    $(wildcard include/config/POSIX_TIMERS) \
  /home/kt5965/linux-build/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /home/kt5965/linux-build/include/uapi/linux/kernel.h \
  /home/kt5965/linux-build/include/uapi/linux/sysinfo.h \
  /home/kt5965/linux-build/include/vdso/cache.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  /home/kt5965/linux-build/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /home/kt5965/linux-build/include/linux/math.h \
  /home/kt5965/linux-build/arch/x86/include/asm/div64.h \
  /home/kt5965/linux-build/include/asm-generic/div64.h \
    $(wildcard include/config/CC_OPTIMIZE_FOR_PERFORMANCE) \
  /home/kt5965/linux-build/include/vdso/math64.h \
  /home/kt5965/linux-build/include/linux/time64.h \
  /home/kt5965/linux-build/include/vdso/time64.h \
  /home/kt5965/linux-build/include/uapi/linux/time.h \
  /home/kt5965/linux-build/include/uapi/linux/time_types.h \
  /home/kt5965/linux-build/include/linux/time32.h \
  /home/kt5965/linux-build/include/linux/timex.h \
  /home/kt5965/linux-build/include/uapi/linux/timex.h \
  /home/kt5965/linux-build/arch/x86/include/asm/timex.h \
    $(wildcard include/config/X86_TSC) \
  /home/kt5965/linux-build/arch/x86/include/asm/processor.h \
    $(wildcard include/config/X86_VMX_FEATURE_NAMES) \
    $(wildcard include/config/X86_IOPL_IOPERM) \
    $(wildcard include/config/VM86) \
    $(wildcard include/config/X86_USER_SHADOW_STACK) \
    $(wildcard include/config/X86_DEBUG_FPU) \
    $(wildcard include/config/USE_X86_SEG_SUPPORT) \
    $(wildcard include/config/PARAVIRT_XXL) \
    $(wildcard include/config/CPU_SUP_AMD) \
    $(wildcard include/config/XEN) \
  /home/kt5965/linux-build/arch/x86/include/asm/processor-flags.h \
    $(wildcard include/config/MITIGATION_PAGE_TABLE_ISOLATION) \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/processor-flags.h \
  /home/kt5965/linux-build/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /home/kt5965/linux-build/arch/x86/include/asm/mem_encrypt.h \
    $(wildcard include/config/X86_MEM_ENCRYPT) \
  /home/kt5965/linux-build/include/linux/cc_platform.h \
    $(wildcard include/config/ARCH_HAS_CC_PLATFORM) \
  /home/kt5965/linux-build/arch/x86/include/asm/math_emu.h \
  /home/kt5965/linux-build/arch/x86/include/asm/ptrace.h \
    $(wildcard include/config/PARAVIRT) \
    $(wildcard include/config/IA32_EMULATION) \
    $(wildcard include/config/X86_DEBUGCTLMSR) \
  /home/kt5965/linux-build/arch/x86/include/asm/segment.h \
    $(wildcard include/config/XEN_PV) \
  /home/kt5965/linux-build/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /home/kt5965/linux-build/include/vdso/page.h \
    $(wildcard include/config/PAGE_SHIFT) \
  /home/kt5965/linux-build/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/RANDOMIZE_BASE) \
  /home/kt5965/linux-build/arch/x86/include/asm/kaslr.h \
    $(wildcard include/config/RANDOMIZE_MEMORY) \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/ptrace.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/ptrace-abi.h \
  /home/kt5965/linux-build/arch/x86/include/asm/paravirt_types.h \
    $(wildcard include/config/ZERO_CALL_USED_REGS) \
    $(wildcard include/config/PARAVIRT_DEBUG) \
  /home/kt5965/linux-build/arch/x86/include/asm/desc_defs.h \
  /home/kt5965/linux-build/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/X86_INTEL_MEMORY_PROTECTION_KEYS) \
    $(wildcard include/config/X86_PAE) \
    $(wildcard include/config/MEM_SOFT_DIRTY) \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_WP) \
    $(wildcard include/config/PGTABLE_LEVELS) \
    $(wildcard include/config/PROC_FS) \
  /home/kt5965/linux-build/arch/x86/include/asm/pgtable_64_types.h \
    $(wildcard include/config/KMSAN) \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /home/kt5965/linux-build/arch/x86/include/asm/sparsemem.h \
    $(wildcard include/config/SPARSEMEM) \
  /home/kt5965/linux-build/arch/x86/include/asm/nospec-branch.h \
    $(wildcard include/config/CALL_THUNKS_DEBUG) \
    $(wildcard include/config/MITIGATION_CALL_DEPTH_TRACKING) \
    $(wildcard include/config/MITIGATION_IBPB_ENTRY) \
  /home/kt5965/linux-build/include/linux/static_key.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cpufeatures.h \
  /home/kt5965/linux-build/arch/x86/include/asm/msr-index.h \
  /home/kt5965/linux-build/arch/x86/include/asm/unwind_hints.h \
  /home/kt5965/linux-build/arch/x86/include/asm/orc_types.h \
  /home/kt5965/linux-build/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/CC_HAS_NAMED_AS) \
  /home/kt5965/linux-build/include/linux/args.h \
  /home/kt5965/linux-build/include/asm-generic/percpu.h \
    $(wildcard include/config/DEBUG_PREEMPT) \
    $(wildcard include/config/HAVE_SETUP_PER_CPU_AREA) \
  /home/kt5965/linux-build/include/linux/threads.h \
    $(wildcard include/config/BASE_SMALL) \
  /home/kt5965/linux-build/include/linux/percpu-defs.h \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
  /home/kt5965/linux-build/arch/x86/include/asm/asm-offsets.h \
  /home/kt5965/linux-build/include/generated/asm-offsets.h \
  /home/kt5965/linux-build/arch/x86/include/asm/GEN-for-each-reg.h \
  /home/kt5965/linux-build/arch/x86/include/asm/proto.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/ldt.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/sigcontext.h \
  /home/kt5965/linux-build/arch/x86/include/asm/current.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cpuid/api.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cpuid/types.h \
  /home/kt5965/linux-build/arch/x86/include/asm/string.h \
  /home/kt5965/linux-build/arch/x86/include/asm/string_64.h \
    $(wildcard include/config/ARCH_HAS_UACCESS_FLUSHCACHE) \
  /home/kt5965/linux-build/arch/x86/include/asm/paravirt.h \
    $(wildcard include/config/PARAVIRT_SPINLOCKS) \
    $(wildcard include/config/DEBUG_ENTRY) \
  /home/kt5965/linux-build/include/linux/bug.h \
    $(wildcard include/config/BUG_ON_DATA_CORRUPTION) \
  /home/kt5965/linux-build/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/HOTPLUG_CPU) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /home/kt5965/linux-build/include/linux/kernel.h \
    $(wildcard include/config/PREEMPT_VOLUNTARY_BUILD) \
    $(wildcard include/config/PREEMPT_DYNAMIC) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_CALL) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_KEY) \
    $(wildcard include/config/PREEMPT_) \
    $(wildcard include/config/DEBUG_ATOMIC_SLEEP) \
    $(wildcard include/config/MMU) \
    $(wildcard include/config/PROVE_LOCKING) \
  /home/kt5965/linux-build/include/linux/align.h \
  /home/kt5965/linux-build/include/vdso/align.h \
  /home/kt5965/linux-build/include/linux/array_size.h \
  /home/kt5965/linux-build/include/linux/bitops.h \
  /home/kt5965/linux-build/include/linux/typecheck.h \
  /home/kt5965/linux-build/include/asm-generic/bitops/generic-non-atomic.h \
  /home/kt5965/linux-build/arch/x86/include/asm/bitops.h \
    $(wildcard include/config/X86_CMOV) \
  /home/kt5965/linux-build/arch/x86/include/asm/rmwcc.h \
  /home/kt5965/linux-build/include/asm-generic/bitops/sched.h \
  /home/kt5965/linux-build/arch/x86/include/asm/arch_hweight.h \
  /home/kt5965/linux-build/include/asm-generic/bitops/const_hweight.h \
  /home/kt5965/linux-build/include/asm-generic/bitops/instrumented-atomic.h \
  /home/kt5965/linux-build/include/linux/instrumented.h \
  /home/kt5965/linux-build/include/linux/kmsan-checks.h \
  /home/kt5965/linux-build/include/asm-generic/bitops/instrumented-non-atomic.h \
    $(wildcard include/config/KCSAN_ASSUME_PLAIN_WRITES_ATOMIC) \
  /home/kt5965/linux-build/include/asm-generic/bitops/instrumented-lock.h \
  /home/kt5965/linux-build/include/asm-generic/bitops/le.h \
  /home/kt5965/linux-build/include/asm-generic/bitops/ext2-atomic-setbit.h \
  /home/kt5965/linux-build/include/linux/hex.h \
  /home/kt5965/linux-build/include/linux/kstrtox.h \
  /home/kt5965/linux-build/include/linux/log2.h \
    $(wildcard include/config/ARCH_HAS_ILOG2_U32) \
    $(wildcard include/config/ARCH_HAS_ILOG2_U64) \
  /home/kt5965/linux-build/include/linux/minmax.h \
  /home/kt5965/linux-build/include/linux/sprintf.h \
  /home/kt5965/linux-build/include/linux/static_call_types.h \
    $(wildcard include/config/HAVE_STATIC_CALL) \
  /home/kt5965/linux-build/include/linux/instruction_pointer.h \
  /home/kt5965/linux-build/include/linux/util_macros.h \
    $(wildcard include/config/FOO_SUSPEND) \
  /home/kt5965/linux-build/include/linux/wordpart.h \
  /home/kt5965/linux-build/include/linux/bitmap.h \
  /home/kt5965/linux-build/include/linux/errno.h \
  /home/kt5965/linux-build/include/uapi/linux/errno.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/errno.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/errno.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/errno-base.h \
  /home/kt5965/linux-build/include/linux/find.h \
  /home/kt5965/linux-build/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
    $(wildcard include/config/FORTIFY_SOURCE) \
  /home/kt5965/linux-build/include/linux/err.h \
  /home/kt5965/linux-build/include/uapi/linux/string.h \
  /home/kt5965/linux-build/include/linux/fortify-string.h \
    $(wildcard include/config/CC_HAS_KASAN_MEMINTRINSIC_PREFIX) \
    $(wildcard include/config/GENERIC_ENTRY) \
  /home/kt5965/linux-build/include/linux/bitfield.h \
  /home/kt5965/linux-build/include/linux/bitmap-str.h \
  /home/kt5965/linux-build/include/linux/cpumask_types.h \
  /home/kt5965/linux-build/include/linux/atomic.h \
  /home/kt5965/linux-build/arch/x86/include/asm/atomic.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cmpxchg.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cmpxchg_64.h \
  /home/kt5965/linux-build/arch/x86/include/asm/atomic64_64.h \
  /home/kt5965/linux-build/include/linux/atomic/atomic-arch-fallback.h \
    $(wildcard include/config/GENERIC_ATOMIC64) \
  /home/kt5965/linux-build/include/linux/atomic/atomic-long.h \
  /home/kt5965/linux-build/include/linux/atomic/atomic-instrumented.h \
  /home/kt5965/linux-build/include/linux/gfp_types.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
    $(wildcard include/config/SLAB_OBJ_EXT) \
  /home/kt5965/linux-build/include/linux/numa.h \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/HAVE_ARCH_NODE_DEV_GROUP) \
  /home/kt5965/linux-build/include/linux/nodemask.h \
    $(wildcard include/config/HIGHMEM) \
  /home/kt5965/linux-build/include/linux/nodemask_types.h \
    $(wildcard include/config/NODES_SHIFT) \
  /home/kt5965/linux-build/include/linux/random.h \
    $(wildcard include/config/VMGENID) \
  /home/kt5965/linux-build/include/uapi/linux/random.h \
  /home/kt5965/linux-build/include/uapi/linux/ioctl.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/ioctl.h \
  /home/kt5965/linux-build/include/asm-generic/ioctl.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/ioctl.h \
  /home/kt5965/linux-build/include/linux/irqnr.h \
  /home/kt5965/linux-build/include/uapi/linux/irqnr.h \
  /home/kt5965/linux-build/arch/x86/include/asm/frame.h \
  /home/kt5965/linux-build/arch/x86/include/asm/page.h \
  /home/kt5965/linux-build/arch/x86/include/asm/page_64.h \
    $(wildcard include/config/DEBUG_VIRTUAL) \
    $(wildcard include/config/X86_VSYSCALL_EMULATION) \
  /home/kt5965/linux-build/include/linux/range.h \
  /home/kt5965/linux-build/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
  /home/kt5965/linux-build/include/linux/pfn.h \
  /home/kt5965/linux-build/include/asm-generic/getorder.h \
  /home/kt5965/linux-build/arch/x86/include/asm/special_insns.h \
  /home/kt5965/linux-build/include/linux/irqflags.h \
    $(wildcard include/config/TRACE_IRQFLAGS) \
    $(wildcard include/config/PREEMPT_RT) \
    $(wildcard include/config/IRQSOFF_TRACER) \
    $(wildcard include/config/PREEMPT_TRACER) \
    $(wildcard include/config/DEBUG_IRQFLAGS) \
    $(wildcard include/config/TRACE_IRQFLAGS_SUPPORT) \
  /home/kt5965/linux-build/include/linux/irqflags_types.h \
  /home/kt5965/linux-build/arch/x86/include/asm/irqflags.h \
  /home/kt5965/linux-build/arch/x86/include/asm/fpu/types.h \
  /home/kt5965/linux-build/arch/x86/include/asm/vmxfeatures.h \
  /home/kt5965/linux-build/arch/x86/include/asm/vdso/processor.h \
  /home/kt5965/linux-build/arch/x86/include/asm/shstk.h \
  /home/kt5965/linux-build/include/linux/personality.h \
  /home/kt5965/linux-build/include/uapi/linux/personality.h \
  /home/kt5965/linux-build/arch/x86/include/asm/tsc.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cpufeature.h \
  /home/kt5965/linux-build/arch/x86/include/generated/asm/cpufeaturemasks.h \
  /home/kt5965/linux-build/arch/x86/include/asm/msr.h \
  /home/kt5965/linux-build/arch/x86/include/asm/cpumask.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/msr.h \
  /home/kt5965/linux-build/arch/x86/include/asm/shared/msr.h \
  /home/kt5965/linux-build/include/linux/percpu.h \
    $(wildcard include/config/RANDOM_KMALLOC_CACHES) \
    $(wildcard include/config/PAGE_SIZE_4KB) \
    $(wildcard include/config/NEED_PER_CPU_PAGE_FIRST_CHUNK) \
  /home/kt5965/linux-build/include/linux/alloc_tag.h \
    $(wildcard include/config/MEM_ALLOC_PROFILING_DEBUG) \
    $(wildcard include/config/MEM_ALLOC_PROFILING) \
    $(wildcard include/config/MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT) \
  /home/kt5965/linux-build/include/linux/codetag.h \
    $(wildcard include/config/CODE_TAGGING) \
  /home/kt5965/linux-build/include/linux/preempt.h \
    $(wildcard include/config/PREEMPT_COUNT) \
    $(wildcard include/config/TRACE_PREEMPT_TOGGLE) \
    $(wildcard include/config/PREEMPTION) \
    $(wildcard include/config/PREEMPT_NOTIFIERS) \
    $(wildcard include/config/PREEMPT_NONE) \
    $(wildcard include/config/PREEMPT_VOLUNTARY) \
    $(wildcard include/config/PREEMPT) \
    $(wildcard include/config/PREEMPT_LAZY) \
  /home/kt5965/linux-build/arch/x86/include/asm/preempt.h \
  /home/kt5965/linux-build/include/linux/smp.h \
    $(wildcard include/config/UP_LATE_INIT) \
    $(wildcard include/config/CSD_LOCK_WAIT_DEBUG) \
  /home/kt5965/linux-build/include/linux/smp_types.h \
  /home/kt5965/linux-build/include/linux/llist.h \
    $(wildcard include/config/ARCH_HAVE_NMI_SAFE_CMPXCHG) \
  /home/kt5965/linux-build/include/linux/thread_info.h \
    $(wildcard include/config/THREAD_INFO_IN_TASK) \
    $(wildcard include/config/ARCH_HAS_PREEMPT_LAZY) \
    $(wildcard include/config/HAVE_ARCH_WITHIN_STACK_FRAMES) \
    $(wildcard include/config/SH) \
  /home/kt5965/linux-build/include/linux/restart_block.h \
  /home/kt5965/linux-build/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/X86_FRED) \
    $(wildcard include/config/COMPAT) \
  /home/kt5965/linux-build/arch/x86/include/asm/smp.h \
    $(wildcard include/config/DEBUG_NMI_SELFTEST) \
  /home/kt5965/linux-build/include/linux/mmdebug.h \
    $(wildcard include/config/DEBUG_VM) \
    $(wildcard include/config/DEBUG_VM_IRQSOFF) \
    $(wildcard include/config/DEBUG_VM_PGFLAGS) \
  /home/kt5965/linux-build/include/linux/sched.h \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_NATIVE) \
    $(wildcard include/config/SCHED_INFO) \
    $(wildcard include/config/SCHEDSTATS) \
    $(wildcard include/config/NUMA_BALANCING) \
    $(wildcard include/config/SCHED_CORE) \
    $(wildcard include/config/FAIR_GROUP_SCHED) \
    $(wildcard include/config/RT_GROUP_SCHED) \
    $(wildcard include/config/RT_MUTEXES) \
    $(wildcard include/config/UCLAMP_TASK) \
    $(wildcard include/config/UCLAMP_BUCKETS_COUNT) \
    $(wildcard include/config/KMAP_LOCAL) \
    $(wildcard include/config/SCHED_CLASS_EXT) \
    $(wildcard include/config/CGROUP_SCHED) \
    $(wildcard include/config/BLK_DEV_IO_TRACE) \
    $(wildcard include/config/PREEMPT_RCU) \
    $(wildcard include/config/TASKS_RCU) \
    $(wildcard include/config/TASKS_TRACE_RCU) \
    $(wildcard include/config/MEMCG_V1) \
    $(wildcard include/config/LRU_GEN) \
    $(wildcard include/config/COMPAT_BRK) \
    $(wildcard include/config/CGROUPS) \
    $(wildcard include/config/BLK_CGROUP) \
    $(wildcard include/config/PSI) \
    $(wildcard include/config/PAGE_OWNER) \
    $(wildcard include/config/EVENTFD) \
    $(wildcard include/config/ARCH_HAS_CPU_PASID) \
    $(wildcard include/config/X86_BUS_LOCK_DETECT) \
    $(wildcard include/config/TASK_DELAY_ACCT) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/ARCH_HAS_SCALED_CPUTIME) \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_GEN) \
    $(wildcard include/config/NO_HZ_FULL) \
    $(wildcard include/config/POSIX_CPUTIMERS) \
    $(wildcard include/config/POSIX_CPU_TIMERS_TASK_WORK) \
    $(wildcard include/config/KEYS) \
    $(wildcard include/config/SYSVIPC) \
    $(wildcard include/config/DETECT_HUNG_TASK) \
    $(wildcard include/config/IO_URING) \
    $(wildcard include/config/AUDIT) \
    $(wildcard include/config/AUDITSYSCALL) \
    $(wildcard include/config/DEBUG_MUTEXES) \
    $(wildcard include/config/DETECT_HUNG_TASK_BLOCKER) \
    $(wildcard include/config/UBSAN) \
    $(wildcard include/config/UBSAN_TRAP) \
    $(wildcard include/config/COMPACTION) \
    $(wildcard include/config/TASK_XACCT) \
    $(wildcard include/config/CPUSETS) \
    $(wildcard include/config/X86_CPU_RESCTRL) \
    $(wildcard include/config/FUTEX) \
    $(wildcard include/config/PERF_EVENTS) \
    $(wildcard include/config/RSEQ) \
    $(wildcard include/config/DEBUG_RSEQ) \
    $(wildcard include/config/SCHED_MM_CID) \
    $(wildcard include/config/FAULT_INJECTION) \
    $(wildcard include/config/LATENCYTOP) \
    $(wildcard include/config/FUNCTION_GRAPH_TRACER) \
    $(wildcard include/config/MEMCG) \
    $(wildcard include/config/UPROBES) \
    $(wildcard include/config/BCACHE) \
    $(wildcard include/config/VMAP_STACK) \
    $(wildcard include/config/SECURITY) \
    $(wildcard include/config/BPF_SYSCALL) \
    $(wildcard include/config/GCC_PLUGIN_STACKLEAK) \
    $(wildcard include/config/X86_MCE) \
    $(wildcard include/config/KRETPROBES) \
    $(wildcard include/config/RETHOOK) \
    $(wildcard include/config/ARCH_HAS_PARANOID_L1D_FLUSH) \
    $(wildcard include/config/RV) \
    $(wildcard include/config/USER_EVENTS) \
  /home/kt5965/linux-build/include/uapi/linux/sched.h \
  /home/kt5965/linux-build/include/linux/pid_types.h \
  /home/kt5965/linux-build/include/linux/sem_types.h \
  /home/kt5965/linux-build/include/linux/shm.h \
  /home/kt5965/linux-build/arch/x86/include/asm/shmparam.h \
  /home/kt5965/linux-build/include/linux/kmsan_types.h \
  /home/kt5965/linux-build/include/linux/mutex_types.h \
    $(wildcard include/config/MUTEX_SPIN_ON_OWNER) \
  /home/kt5965/linux-build/include/linux/osq_lock.h \
  /home/kt5965/linux-build/include/linux/spinlock_types.h \
  /home/kt5965/linux-build/include/linux/rwlock_types.h \
  /home/kt5965/linux-build/include/linux/plist_types.h \
  /home/kt5965/linux-build/include/linux/hrtimer_types.h \
  /home/kt5965/linux-build/include/linux/timerqueue_types.h \
  /home/kt5965/linux-build/include/linux/rbtree_types.h \
  /home/kt5965/linux-build/include/linux/timer_types.h \
  /home/kt5965/linux-build/include/linux/seccomp_types.h \
    $(wildcard include/config/SECCOMP) \
  /home/kt5965/linux-build/include/linux/refcount_types.h \
  /home/kt5965/linux-build/include/linux/resource.h \
  /home/kt5965/linux-build/include/uapi/linux/resource.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/resource.h \
  /home/kt5965/linux-build/include/asm-generic/resource.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/resource.h \
  /home/kt5965/linux-build/include/linux/latencytop.h \
  /home/kt5965/linux-build/include/linux/sched/prio.h \
  /home/kt5965/linux-build/include/linux/sched/types.h \
  /home/kt5965/linux-build/include/linux/signal_types.h \
    $(wildcard include/config/OLD_SIGACTION) \
  /home/kt5965/linux-build/include/uapi/linux/signal.h \
  /home/kt5965/linux-build/arch/x86/include/asm/signal.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/signal.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/signal-defs.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/siginfo.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/siginfo.h \
  /home/kt5965/linux-build/include/linux/syscall_user_dispatch_types.h \
  /home/kt5965/linux-build/include/linux/mm_types_task.h \
    $(wildcard include/config/ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH) \
  /home/kt5965/linux-build/arch/x86/include/asm/tlbbatch.h \
  /home/kt5965/linux-build/include/linux/netdevice_xmit.h \
    $(wildcard include/config/NET_EGRESS) \
    $(wildcard include/config/NET_ACT_MIRRED) \
    $(wildcard include/config/NF_DUP_NETDEV) \
  /home/kt5965/linux-build/include/linux/task_io_accounting.h \
    $(wildcard include/config/TASK_IO_ACCOUNTING) \
  /home/kt5965/linux-build/include/linux/posix-timers_types.h \
  /home/kt5965/linux-build/include/uapi/linux/rseq.h \
  /home/kt5965/linux-build/include/linux/seqlock_types.h \
  /home/kt5965/linux-build/include/linux/kcsan.h \
  /home/kt5965/linux-build/include/linux/rv.h \
    $(wildcard include/config/RV_REACTORS) \
  /home/kt5965/linux-build/include/linux/uidgid_types.h \
  /home/kt5965/linux-build/include/linux/tracepoint-defs.h \
  /home/kt5965/linux-build/arch/x86/include/generated/asm/kmap_size.h \
  /home/kt5965/linux-build/include/asm-generic/kmap_size.h \
    $(wildcard include/config/DEBUG_KMAP_LOCAL) \
  /home/kt5965/linux-build/include/linux/sched/ext.h \
    $(wildcard include/config/EXT_GROUP_SCHED) \
  /home/kt5965/linux-build/include/linux/spinlock.h \
  /home/kt5965/linux-build/include/linux/bottom_half.h \
  /home/kt5965/linux-build/include/linux/lockdep.h \
    $(wildcard include/config/DEBUG_LOCKING_API_SELFTESTS) \
  /home/kt5965/linux-build/arch/x86/include/generated/asm/mmiowb.h \
  /home/kt5965/linux-build/include/asm-generic/mmiowb.h \
    $(wildcard include/config/MMIOWB) \
  /home/kt5965/linux-build/arch/x86/include/asm/spinlock.h \
  /home/kt5965/linux-build/arch/x86/include/asm/qspinlock.h \
  /home/kt5965/linux-build/include/asm-generic/qspinlock.h \
  /home/kt5965/linux-build/arch/x86/include/asm/qrwlock.h \
  /home/kt5965/linux-build/include/asm-generic/qrwlock.h \
  /home/kt5965/linux-build/include/linux/rwlock.h \
  /home/kt5965/linux-build/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/INLINE_SPIN_LOCK) \
    $(wildcard include/config/INLINE_SPIN_LOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK_BH) \
    $(wildcard include/config/UNINLINE_SPIN_UNLOCK) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/GENERIC_LOCKBREAK) \
  /home/kt5965/linux-build/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/INLINE_READ_LOCK) \
    $(wildcard include/config/INLINE_WRITE_LOCK) \
    $(wildcard include/config/INLINE_READ_LOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_LOCK_BH) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_READ_TRYLOCK) \
    $(wildcard include/config/INLINE_WRITE_TRYLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_BH) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQRESTORE) \
  /home/kt5965/linux-build/include/vdso/time32.h \
  /home/kt5965/linux-build/include/vdso/time.h \
  /home/kt5965/linux-build/include/linux/uidgid.h \
    $(wildcard include/config/MULTIUSER) \
    $(wildcard include/config/USER_NS) \
  /home/kt5965/linux-build/include/linux/highuid.h \
  /home/kt5965/linux-build/include/linux/buildid.h \
    $(wildcard include/config/VMCORE_INFO) \
  /home/kt5965/linux-build/include/linux/kmod.h \
  /home/kt5965/linux-build/include/linux/umh.h \
  /home/kt5965/linux-build/include/linux/gfp.h \
    $(wildcard include/config/ZONE_DMA) \
    $(wildcard include/config/ZONE_DMA32) \
    $(wildcard include/config/ZONE_DEVICE) \
    $(wildcard include/config/CONTIG_ALLOC) \
  /home/kt5965/linux-build/include/linux/mmzone.h \
    $(wildcard include/config/ARCH_FORCE_MAX_ORDER) \
    $(wildcard include/config/PAGE_BLOCK_ORDER) \
    $(wildcard include/config/CMA) \
    $(wildcard include/config/MEMORY_ISOLATION) \
    $(wildcard include/config/ZSMALLOC) \
    $(wildcard include/config/UNACCEPTED_MEMORY) \
    $(wildcard include/config/IOMMU_SUPPORT) \
    $(wildcard include/config/SWAP) \
    $(wildcard include/config/HUGETLB_PAGE) \
    $(wildcard include/config/TRANSPARENT_HUGEPAGE) \
    $(wildcard include/config/LRU_GEN_STATS) \
    $(wildcard include/config/LRU_GEN_WALKS_MMU) \
    $(wildcard include/config/MEMORY_FAILURE) \
    $(wildcard include/config/PAGE_EXTENSION) \
    $(wildcard include/config/DEFERRED_STRUCT_PAGE_INIT) \
    $(wildcard include/config/HAVE_MEMORYLESS_NODES) \
    $(wildcard include/config/SPARSEMEM_EXTREME) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP_PREINIT) \
    $(wildcard include/config/HAVE_ARCH_PFN_VALID) \
  /home/kt5965/linux-build/include/linux/list_nulls.h \
  /home/kt5965/linux-build/include/linux/wait.h \
  /home/kt5965/linux-build/include/linux/seqlock.h \
  /home/kt5965/linux-build/include/linux/mutex.h \
  /home/kt5965/linux-build/include/linux/debug_locks.h \
  /home/kt5965/linux-build/include/linux/pageblock-flags.h \
    $(wildcard include/config/HUGETLB_PAGE_SIZE_VARIABLE) \
  /home/kt5965/linux-build/include/linux/page-flags-layout.h \
  /home/kt5965/linux-build/include/generated/bounds.h \
  /home/kt5965/linux-build/include/linux/mm_types.h \
    $(wildcard include/config/HAVE_ALIGNED_STRUCT_PAGE) \
    $(wildcard include/config/HUGETLB_PMD_PAGE_TABLE_SHARING) \
    $(wildcard include/config/SLAB_FREELIST_HARDENED) \
    $(wildcard include/config/USERFAULTFD) \
    $(wildcard include/config/ANON_VMA_NAME) \
    $(wildcard include/config/PER_VMA_LOCK) \
    $(wildcard include/config/HAVE_ARCH_COMPAT_MMAP_BASES) \
    $(wildcard include/config/MEMBARRIER) \
    $(wildcard include/config/FUTEX_PRIVATE_HASH) \
    $(wildcard include/config/AIO) \
    $(wildcard include/config/MMU_NOTIFIER) \
    $(wildcard include/config/SPLIT_PMD_PTLOCKS) \
    $(wildcard include/config/IOMMU_MM_DATA) \
    $(wildcard include/config/KSM) \
    $(wildcard include/config/MM_ID) \
    $(wildcard include/config/CORE_DUMP_DEFAULT_ELF_HEADERS) \
  /home/kt5965/linux-build/include/linux/auxvec.h \
  /home/kt5965/linux-build/include/uapi/linux/auxvec.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/auxvec.h \
  /home/kt5965/linux-build/include/linux/kref.h \
  /home/kt5965/linux-build/include/linux/refcount.h \
  /home/kt5965/linux-build/include/linux/rbtree.h \
  /home/kt5965/linux-build/include/linux/rcupdate.h \
    $(wildcard include/config/TINY_RCU) \
    $(wildcard include/config/RCU_STRICT_GRACE_PERIOD) \
    $(wildcard include/config/RCU_LAZY) \
    $(wildcard include/config/RCU_STALL_COMMON) \
    $(wildcard include/config/KVM_XFER_TO_GUEST_WORK) \
    $(wildcard include/config/RCU_NOCB_CPU) \
    $(wildcard include/config/TASKS_RCU_GENERIC) \
    $(wildcard include/config/TASKS_RUDE_RCU) \
    $(wildcard include/config/TREE_RCU) \
    $(wildcard include/config/DEBUG_OBJECTS_RCU_HEAD) \
    $(wildcard include/config/PROVE_RCU) \
    $(wildcard include/config/ARCH_WEAK_RELEASE_ACQUIRE) \
  /home/kt5965/linux-build/include/linux/context_tracking_irq.h \
    $(wildcard include/config/CONTEXT_TRACKING_IDLE) \
  /home/kt5965/linux-build/include/linux/rcutree.h \
  /home/kt5965/linux-build/include/linux/maple_tree.h \
    $(wildcard include/config/MAPLE_RCU_DISABLED) \
    $(wildcard include/config/DEBUG_MAPLE_TREE) \
  /home/kt5965/linux-build/include/linux/rwsem.h \
    $(wildcard include/config/RWSEM_SPIN_ON_OWNER) \
    $(wildcard include/config/DEBUG_RWSEMS) \
  /home/kt5965/linux-build/include/linux/completion.h \
  /home/kt5965/linux-build/include/linux/swait.h \
  /home/kt5965/linux-build/include/linux/uprobes.h \
  /home/kt5965/linux-build/include/linux/timer.h \
    $(wildcard include/config/DEBUG_OBJECTS_TIMERS) \
  /home/kt5965/linux-build/include/linux/ktime.h \
  /home/kt5965/linux-build/include/linux/jiffies.h \
  /home/kt5965/linux-build/include/vdso/jiffies.h \
  /home/kt5965/linux-build/include/generated/timeconst.h \
  /home/kt5965/linux-build/include/vdso/ktime.h \
  /home/kt5965/linux-build/include/linux/timekeeping.h \
    $(wildcard include/config/GENERIC_CMOS_UPDATE) \
  /home/kt5965/linux-build/include/linux/clocksource_ids.h \
  /home/kt5965/linux-build/include/linux/debugobjects.h \
    $(wildcard include/config/DEBUG_OBJECTS) \
    $(wildcard include/config/DEBUG_OBJECTS_FREE) \
  /home/kt5965/linux-build/arch/x86/include/asm/uprobes.h \
  /home/kt5965/linux-build/include/linux/notifier.h \
  /home/kt5965/linux-build/include/linux/srcu.h \
    $(wildcard include/config/TINY_SRCU) \
    $(wildcard include/config/NEED_SRCU_NMI_SAFE) \
  /home/kt5965/linux-build/include/linux/workqueue.h \
    $(wildcard include/config/DEBUG_OBJECTS_WORK) \
    $(wildcard include/config/FREEZER) \
    $(wildcard include/config/WQ_WATCHDOG) \
  /home/kt5965/linux-build/include/linux/workqueue_types.h \
  /home/kt5965/linux-build/include/linux/rcu_segcblist.h \
  /home/kt5965/linux-build/include/linux/srcutree.h \
  /home/kt5965/linux-build/include/linux/rcu_node_tree.h \
    $(wildcard include/config/RCU_FANOUT) \
    $(wildcard include/config/RCU_FANOUT_LEAF) \
  /home/kt5965/linux-build/include/linux/percpu_counter.h \
  /home/kt5965/linux-build/arch/x86/include/asm/mmu.h \
    $(wildcard include/config/MODIFY_LDT_SYSCALL) \
    $(wildcard include/config/ADDRESS_MASKING) \
    $(wildcard include/config/BROADCAST_TLB_FLUSH) \
  /home/kt5965/linux-build/include/linux/page-flags.h \
    $(wildcard include/config/PAGE_IDLE_FLAG) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_2) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_3) \
    $(wildcard include/config/HUGETLB_PAGE_OPTIMIZE_VMEMMAP) \
  /home/kt5965/linux-build/include/linux/local_lock.h \
  /home/kt5965/linux-build/include/linux/local_lock_internal.h \
  /home/kt5965/linux-build/include/linux/zswap.h \
    $(wildcard include/config/ZSWAP) \
  /home/kt5965/linux-build/include/linux/memory_hotplug.h \
    $(wildcard include/config/ARCH_HAS_ADD_PAGES) \
    $(wildcard include/config/MEMORY_HOTREMOVE) \
  /home/kt5965/linux-build/arch/x86/include/generated/asm/mmzone.h \
  /home/kt5965/linux-build/include/asm-generic/mmzone.h \
  /home/kt5965/linux-build/include/linux/topology.h \
    $(wildcard include/config/USE_PERCPU_NUMA_NODE_ID) \
    $(wildcard include/config/SCHED_SMT) \
    $(wildcard include/config/GENERIC_ARCH_TOPOLOGY) \
  /home/kt5965/linux-build/include/linux/arch_topology.h \
  /home/kt5965/linux-build/arch/x86/include/asm/topology.h \
    $(wildcard include/config/X86_LOCAL_APIC) \
    $(wildcard include/config/SCHED_MC_PRIO) \
  /home/kt5965/linux-build/arch/x86/include/asm/mpspec.h \
    $(wildcard include/config/EISA) \
    $(wildcard include/config/X86_MPPARSE) \
  /home/kt5965/linux-build/arch/x86/include/asm/mpspec_def.h \
  /home/kt5965/linux-build/arch/x86/include/asm/x86_init.h \
  /home/kt5965/linux-build/arch/x86/include/asm/apicdef.h \
  /home/kt5965/linux-build/include/asm-generic/topology.h \
  /home/kt5965/linux-build/include/linux/cpu_smt.h \
    $(wildcard include/config/HOTPLUG_SMT) \
  /home/kt5965/linux-build/include/linux/sysctl.h \
    $(wildcard include/config/SYSCTL) \
  /home/kt5965/linux-build/include/uapi/linux/sysctl.h \
  /home/kt5965/linux-build/include/linux/elf.h \
    $(wildcard include/config/ARCH_HAVE_EXTRA_ELF_NOTES) \
    $(wildcard include/config/ARCH_USE_GNU_PROPERTY) \
    $(wildcard include/config/ARCH_HAVE_ELF_PROT) \
  /home/kt5965/linux-build/arch/x86/include/asm/elf.h \
    $(wildcard include/config/X86_X32_ABI) \
  /home/kt5965/linux-build/arch/x86/include/asm/ia32.h \
  /home/kt5965/linux-build/include/linux/compat.h \
    $(wildcard include/config/ARCH_HAS_SYSCALL_WRAPPER) \
    $(wildcard include/config/COMPAT_OLD_SIGACTION) \
    $(wildcard include/config/HARDENED_USERCOPY) \
    $(wildcard include/config/ODD_RT_SIGACTION) \
  /home/kt5965/linux-build/include/linux/sem.h \
  /home/kt5965/linux-build/include/uapi/linux/sem.h \
  /home/kt5965/linux-build/include/linux/ipc.h \
  /home/kt5965/linux-build/include/linux/rhashtable-types.h \
  /home/kt5965/linux-build/include/uapi/linux/ipc.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/ipcbuf.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/ipcbuf.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/sembuf.h \
  /home/kt5965/linux-build/include/linux/socket.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/socket.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/socket.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/sockios.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/sockios.h \
  /home/kt5965/linux-build/include/uapi/linux/sockios.h \
  /home/kt5965/linux-build/include/linux/uio.h \
    $(wildcard include/config/ARCH_HAS_COPY_MC) \
  /home/kt5965/linux-build/include/linux/ucopysize.h \
    $(wildcard include/config/HARDENED_USERCOPY_DEFAULT_ON) \
  /home/kt5965/linux-build/include/uapi/linux/uio.h \
  /home/kt5965/linux-build/include/uapi/linux/socket.h \
  /home/kt5965/linux-build/include/uapi/linux/if.h \
  /home/kt5965/linux-build/include/uapi/linux/libc-compat.h \
  /home/kt5965/linux-build/include/uapi/linux/hdlc/ioctl.h \
  /home/kt5965/linux-build/include/linux/fs.h \
    $(wildcard include/config/FANOTIFY_ACCESS_PERMISSIONS) \
    $(wildcard include/config/READ_ONLY_THP_FOR_FS) \
    $(wildcard include/config/FS_POSIX_ACL) \
    $(wildcard include/config/CGROUP_WRITEBACK) \
    $(wildcard include/config/IMA) \
    $(wildcard include/config/FILE_LOCKING) \
    $(wildcard include/config/FSNOTIFY) \
    $(wildcard include/config/FS_ENCRYPTION) \
    $(wildcard include/config/FS_VERITY) \
    $(wildcard include/config/EPOLL) \
    $(wildcard include/config/UNICODE) \
    $(wildcard include/config/QUOTA) \
    $(wildcard include/config/FS_DAX) \
    $(wildcard include/config/BLOCK) \
  /home/kt5965/linux-build/include/linux/vfsdebug.h \
    $(wildcard include/config/DEBUG_VFS) \
  /home/kt5965/linux-build/include/linux/wait_bit.h \
  /home/kt5965/linux-build/include/linux/kdev_t.h \
  /home/kt5965/linux-build/include/uapi/linux/kdev_t.h \
  /home/kt5965/linux-build/include/linux/dcache.h \
  /home/kt5965/linux-build/include/linux/rculist.h \
    $(wildcard include/config/PROVE_RCU_LIST) \
  /home/kt5965/linux-build/include/linux/rculist_bl.h \
  /home/kt5965/linux-build/include/linux/list_bl.h \
  /home/kt5965/linux-build/include/linux/bit_spinlock.h \
  /home/kt5965/linux-build/include/linux/lockref.h \
    $(wildcard include/config/ARCH_USE_CMPXCHG_LOCKREF) \
  /home/kt5965/linux-build/include/linux/stringhash.h \
    $(wildcard include/config/DCACHE_WORD_ACCESS) \
  /home/kt5965/linux-build/include/linux/hash.h \
    $(wildcard include/config/HAVE_ARCH_HASH) \
  /home/kt5965/linux-build/include/linux/path.h \
  /home/kt5965/linux-build/include/linux/list_lru.h \
  /home/kt5965/linux-build/include/linux/shrinker.h \
    $(wildcard include/config/SHRINKER_DEBUG) \
  /home/kt5965/linux-build/include/linux/xarray.h \
    $(wildcard include/config/XARRAY_MULTI) \
  /home/kt5965/linux-build/include/linux/sched/mm.h \
    $(wildcard include/config/MMU_LAZY_TLB_REFCOUNT) \
    $(wildcard include/config/ARCH_HAS_MEMBARRIER_CALLBACKS) \
    $(wildcard include/config/ARCH_HAS_SYNC_CORE_BEFORE_USERMODE) \
  /home/kt5965/linux-build/include/linux/sync_core.h \
    $(wildcard include/config/ARCH_HAS_PREPARE_SYNC_CORE_CMD) \
  /home/kt5965/linux-build/arch/x86/include/asm/sync_core.h \
  /home/kt5965/linux-build/include/linux/sched/coredump.h \
  /home/kt5965/linux-build/include/linux/radix-tree.h \
  /home/kt5965/linux-build/include/linux/pid.h \
  /home/kt5965/linux-build/include/linux/capability.h \
  /home/kt5965/linux-build/include/uapi/linux/capability.h \
  /home/kt5965/linux-build/include/linux/semaphore.h \
  /home/kt5965/linux-build/include/linux/fcntl.h \
    $(wildcard include/config/ARCH_32BIT_OFF_T) \
  /home/kt5965/linux-build/include/uapi/linux/fcntl.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/fcntl.h \
  /home/kt5965/linux-build/include/uapi/asm-generic/fcntl.h \
  /home/kt5965/linux-build/include/uapi/linux/openat2.h \
  /home/kt5965/linux-build/include/linux/migrate_mode.h \
  /home/kt5965/linux-build/include/linux/percpu-rwsem.h \
  /home/kt5965/linux-build/include/linux/rcuwait.h \
  /home/kt5965/linux-build/include/linux/sched/signal.h \
    $(wildcard include/config/SCHED_AUTOGROUP) \
    $(wildcard include/config/BSD_PROCESS_ACCT) \
    $(wildcard include/config/TASKSTATS) \
    $(wildcard include/config/STACK_GROWSUP) \
  /home/kt5965/linux-build/include/linux/signal.h \
    $(wildcard include/config/DYNAMIC_SIGFRAME) \
  /home/kt5965/linux-build/include/linux/sched/jobctl.h \
  /home/kt5965/linux-build/include/linux/sched/task.h \
    $(wildcard include/config/HAVE_EXIT_THREAD) \
    $(wildcard include/config/ARCH_WANTS_DYNAMIC_TASK_STRUCT) \
    $(wildcard include/config/HAVE_ARCH_THREAD_STRUCT_WHITELIST) \
  /home/kt5965/linux-build/include/linux/uaccess.h \
    $(wildcard include/config/ARCH_HAS_SUBPAGE_FAULTS) \
  /home/kt5965/linux-build/include/linux/fault-inject-usercopy.h \
    $(wildcard include/config/FAULT_INJECTION_USERCOPY) \
  /home/kt5965/linux-build/include/linux/nospec.h \
  /home/kt5965/linux-build/arch/x86/include/asm/uaccess.h \
    $(wildcard include/config/CC_HAS_ASM_GOTO_OUTPUT) \
    $(wildcard include/config/CC_HAS_ASM_GOTO_TIED_OUTPUT) \
    $(wildcard include/config/X86_INTEL_USERCOPY) \
  /home/kt5965/linux-build/include/linux/mmap_lock.h \
  /home/kt5965/linux-build/arch/x86/include/asm/smap.h \
  /home/kt5965/linux-build/arch/x86/include/asm/extable.h \
    $(wildcard include/config/BPF_JIT) \
  /home/kt5965/linux-build/arch/x86/include/asm/tlbflush.h \
  /home/kt5965/linux-build/include/linux/mmu_notifier.h \
  /home/kt5965/linux-build/include/linux/interval_tree.h \
  /home/kt5965/linux-build/arch/x86/include/asm/invpcid.h \
  /home/kt5965/linux-build/arch/x86/include/asm/pti.h \
  /home/kt5965/linux-build/arch/x86/include/asm/pgtable.h \
    $(wildcard include/config/DEBUG_WX) \
    $(wildcard include/config/HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) \
    $(wildcard include/config/ARCH_HAS_PTE_DEVMAP) \
    $(wildcard include/config/ARCH_SUPPORTS_PMD_PFNMAP) \
    $(wildcard include/config/ARCH_SUPPORTS_PUD_PFNMAP) \
    $(wildcard include/config/HAVE_ARCH_SOFT_DIRTY) \
    $(wildcard include/config/ARCH_ENABLE_THP_MIGRATION) \
    $(wildcard include/config/PAGE_TABLE_CHECK) \
    $(wildcard include/config/X86_SGX) \
  /home/kt5965/linux-build/arch/x86/include/asm/pkru.h \
  /home/kt5965/linux-build/arch/x86/include/asm/fpu/api.h \
    $(wildcard include/config/MATH_EMULATION) \
  /home/kt5965/linux-build/arch/x86/include/asm/coco.h \
  /home/kt5965/linux-build/include/asm-generic/pgtable_uffd.h \
  /home/kt5965/linux-build/include/linux/page_table_check.h \
  /home/kt5965/linux-build/arch/x86/include/asm/pgtable_64.h \
  /home/kt5965/linux-build/arch/x86/include/asm/fixmap.h \
    $(wildcard include/config/PROVIDE_OHCI1394_DMA_INIT) \
    $(wildcard include/config/X86_IO_APIC) \
    $(wildcard include/config/PCI_MMCONFIG) \
    $(wildcard include/config/ACPI_APEI_GHES) \
    $(wildcard include/config/INTEL_TXT) \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/vsyscall.h \
  /home/kt5965/linux-build/include/asm-generic/fixmap.h \
  /home/kt5965/linux-build/arch/x86/include/asm/pgtable-invert.h \
  /home/kt5965/linux-build/arch/x86/include/asm/uaccess_64.h \
  /home/kt5965/linux-build/arch/x86/include/asm/runtime-const.h \
  /home/kt5965/linux-build/include/asm-generic/access_ok.h \
    $(wildcard include/config/ALTERNATE_USER_ADDRESS_SPACE) \
  /home/kt5965/linux-build/include/linux/cred.h \
  /home/kt5965/linux-build/include/linux/key.h \
    $(wildcard include/config/KEY_NOTIFICATIONS) \
    $(wildcard include/config/NET) \
  /home/kt5965/linux-build/include/linux/assoc_array.h \
    $(wildcard include/config/ASSOCIATIVE_ARRAY) \
  /home/kt5965/linux-build/include/linux/sched/user.h \
    $(wildcard include/config/VFIO_PCI_ZDEV_KVM) \
    $(wildcard include/config/IOMMUFD) \
    $(wildcard include/config/WATCH_QUEUE) \
  /home/kt5965/linux-build/include/linux/ratelimit.h \
  /home/kt5965/linux-build/include/linux/posix-timers.h \
  /home/kt5965/linux-build/include/linux/alarmtimer.h \
    $(wildcard include/config/RTC_CLASS) \
  /home/kt5965/linux-build/include/linux/hrtimer.h \
    $(wildcard include/config/HIGH_RES_TIMERS) \
    $(wildcard include/config/TIME_LOW_RES) \
    $(wildcard include/config/TIMERFD) \
  /home/kt5965/linux-build/include/linux/hrtimer_defs.h \
  /home/kt5965/linux-build/include/linux/timerqueue.h \
  /home/kt5965/linux-build/include/linux/rcuref.h \
  /home/kt5965/linux-build/include/linux/rcu_sync.h \
  /home/kt5965/linux-build/include/linux/delayed_call.h \
  /home/kt5965/linux-build/include/linux/uuid.h \
  /home/kt5965/linux-build/include/linux/errseq.h \
  /home/kt5965/linux-build/include/linux/ioprio.h \
  /home/kt5965/linux-build/include/linux/sched/rt.h \
  /home/kt5965/linux-build/include/linux/iocontext.h \
    $(wildcard include/config/BLK_ICQ) \
  /home/kt5965/linux-build/include/uapi/linux/ioprio.h \
  /home/kt5965/linux-build/include/linux/fs_types.h \
  /home/kt5965/linux-build/include/linux/mount.h \
  /home/kt5965/linux-build/include/linux/mnt_idmapping.h \
  /home/kt5965/linux-build/include/linux/slab.h \
    $(wildcard include/config/FAILSLAB) \
    $(wildcard include/config/KFENCE) \
    $(wildcard include/config/SLUB_TINY) \
    $(wildcard include/config/SLUB_DEBUG) \
    $(wildcard include/config/SLAB_BUCKETS) \
    $(wildcard include/config/KVFREE_RCU_BATCHED) \
  /home/kt5965/linux-build/include/linux/percpu-refcount.h \
  /home/kt5965/linux-build/include/linux/kasan.h \
    $(wildcard include/config/KASAN_STACK) \
    $(wildcard include/config/KASAN_VMALLOC) \
  /home/kt5965/linux-build/include/linux/kasan-enabled.h \
  /home/kt5965/linux-build/include/linux/kasan-tags.h \
  /home/kt5965/linux-build/include/linux/rw_hint.h \
  /home/kt5965/linux-build/include/linux/file_ref.h \
  /home/kt5965/linux-build/include/linux/unicode.h \
  /home/kt5965/linux-build/include/uapi/linux/fs.h \
  /home/kt5965/linux-build/include/linux/quota.h \
    $(wildcard include/config/QUOTA_NETLINK_INTERFACE) \
  /home/kt5965/linux-build/include/uapi/linux/dqblk_xfs.h \
  /home/kt5965/linux-build/include/linux/dqblk_v1.h \
  /home/kt5965/linux-build/include/linux/dqblk_v2.h \
  /home/kt5965/linux-build/include/linux/dqblk_qtree.h \
  /home/kt5965/linux-build/include/linux/projid.h \
  /home/kt5965/linux-build/include/uapi/linux/quota.h \
  /home/kt5965/linux-build/include/uapi/linux/aio_abi.h \
  /home/kt5965/linux-build/include/uapi/linux/unistd.h \
  /home/kt5965/linux-build/arch/x86/include/asm/unistd.h \
  /home/kt5965/linux-build/arch/x86/include/uapi/asm/unistd.h \
  /home/kt5965/linux-build/arch/x86/include/generated/uapi/asm/unistd_64.h \
  /home/kt5965/linux-build/arch/x86/include/generated/asm/unistd_64_x32.h \
  /home/kt5965/linux-build/arch/x86/include/generated/asm/unistd_32_ia32.h \
  /home/kt5965/linux-build/arch/x86/include/asm/compat.h \
  /home/kt5965/linux-build/include/linux/sched/task_stack.h \
    $(wildcard include/config/DEBUG_STACK_USAGE) \
  /home/kt5965/linux-build/include/uapi/linux/magic.h \
  /home/kt5965/linux-build/arch/x86/include/asm/user32.h \
  /home/kt5965/linux-build/include/asm-generic/compat.h \
    $(wildcard include/config/COMPAT_FOR_U64_ALIGNMENT) \
  /home/kt5965/linux-build/arch/x86/include/asm/syscall_wrapper.h \
  /home/kt5965/linux-build/arch/x86/include/asm/user.h \
  /home/kt5965/linux-build/arch/x86/include/asm/user_64.h \
  /home/kt5965/linux-build/arch/x86/include/asm/fsgsbase.h \
  /home/kt5965/linux-build/arch/x86/include/asm/vdso.h \
  /home/kt5965/linux-build/include/uapi/linux/elf.h \
  /home/kt5965/linux-build/include/uapi/linux/elf-em.h \
  /home/kt5965/linux-build/include/linux/kobject.h \
    $(wildcard include/config/UEVENT_HELPER) \
    $(wildcard include/config/DEBUG_KOBJECT_RELEASE) \
  /home/kt5965/linux-build/include/linux/sysfs.h \
  /home/kt5965/linux-build/include/linux/kernfs.h \
    $(wildcard include/config/KERNFS) \
  /home/kt5965/linux-build/include/linux/idr.h \
  /home/kt5965/linux-build/include/linux/kobject_ns.h \
  /home/kt5965/linux-build/include/linux/moduleparam.h \
    $(wildcard include/config/ALPHA) \
    $(wildcard include/config/PPC64) \
  /home/kt5965/linux-build/include/linux/rbtree_latch.h \
  /home/kt5965/linux-build/include/linux/error-injection.h \
  /home/kt5965/linux-build/include/asm-generic/error-injection.h \
  /home/kt5965/linux-build/arch/x86/include/asm/module.h \
    $(wildcard include/config/UNWINDER_ORC) \
  /home/kt5965/linux-build/include/asm-generic/module.h \
    $(wildcard include/config/HAVE_MOD_ARCH_SPECIFIC) \
  /home/kt5965/linux-build/include/linux/export-internal.h \
    $(wildcard include/config/PARISC) \

ksys_trace.mod.o: $(deps_ksys_trace.mod.o)

$(deps_ksys_trace.mod.o):

ksys_trace.mod.o: $(wildcard /home/kt5965/linux-build/tools/objtool/objtool)
