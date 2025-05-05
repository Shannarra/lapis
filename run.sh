#!/bin/bash

set -e

for arg in "$@"; do
  case $arg in
    -s| --silent)
      SURPRESS_MSG=1
      shift
    		;;
	esac
done

ruby lapis.rb $@

if [[ $SURPRESS_MSG -eq 1 ]]; then
		fasm lapis.asm lapis.o > /dev/null
else
		fasm lapis.asm lapis.o
fi
ld lapis.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o lapis

./lapis
