#!/bin/bash
# sh variables.sh a b c 1 2 3
# args and $* difference
args1=("$@")
args2=("$*")
echo "Name of the script("\$0"): $0"
echo "Total number of arguments("\$#"): $#"
echo "Values of all the arguments("\$@"): $@"
for n in $args2
  do
    echo -e "Name of the script("\$args[n]"):$n"
  done

index=1                       #将计数器设置为1
echo "listing args with \"\$@\":"    #在"$@"中遍历参数
for n in "$@"
do
  echo "arg: $index = $n"
  let index+=1
done

