#!/bin/bash

POSITIONAL_ARGS=()


if (($# == 0)); then
  echo "usage: ./gdb4arm.sh source_code_file [-a func]
  -a func: advance gdb to function func (main is used by default)"
  exit 0
fi

# Parse command line arguments

ADVANCE="main"

while [[ $# -gt 0 ]]; do
  case $1 in
    -a|--advance)
      ADVANCE="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z "${POSITIONAL_ARGS[0]}" ]; then
  echo "usage: ./gdb4arm.sh source_code_file [-a func]
  -a func: advance code to function func 
  (default function is main)"
  exit 0
fi

# Use gdb-multiarch on Ubuntu, gdb on other distributions

GDB=gdb
if grep -q Ubuntu /etc/os-release; then
  GDB="gdb-multiarch"
fi

# Find an unused port
while
  PORT=$(shuf -n 1 -i 49152-65535)
  netstat -atun | grep -q "${PORT}"
do
  continue
done

SOURCE_FILE="${POSITIONAL_ARGS[0]}"

# Compile source file
arm-linux-gnueabi-gcc -static -g "${SOURCE_FILE}"

# Launch qemu
qemu-arm -L /usr/arm-linux-gnueabi -g "${PORT}" a.out &

# Attach gdb to qemu
${GDB} a.out -q -ex "target remote localhost:${PORT}" -ex "tui reg general" -ex "advance ${ADVANCE}"
