#!/bin/echo Warinng: this library should be sourced!

function concurrence::mutex_init()
{
    local mutex_fifo=$(mktemp -u "concurrence_mutex_XXXXXX" -p /tmp)
    mkfifo "${mutex_fifo}"
    exec 4<>"${mutex_fifo}";echo >&4
    echo "${mutex_fifo}"
}

function concurrence::mutex_lock()
{
    local mutex="$1"
    exec 4<>"${mutex}";read -u 4
}

mutex1=$(concurrence::mutex_init)
echo LOG1 "${mutex1}"
concurrence::mutex_lock "${mutex1}" # 为啥会卡住？？？
echo LOG2 "${mutex1}"
