savedcmd_ksys_trace.mod := printf '%s\n'   ksys_trace.o | awk '!x[$$0]++ { print("./"$$0) }' > ksys_trace.mod
