#!/bin/echo Warinng: this library should be sourced!

function concurrence::Mutex()
{
    local mutex_fifo=$(mktemp -u "concurrence_mutex_XXXXXX" -p /tmp)
    mkfifo "${mutex_fifo}"
    # (exec 4<>"${mutex_fifo}";echo >&4)
    exec 4<>"${mutex_fifo}";echo >&4
    eval $1="${mutex_fifo}"
}

function concurrence::mutex_lock()
{
    local mutex="$1"
    exec 4<>"${mutex}";read -u 4
}

function concurrence::mutex_unlock()
{
    local mutex="$1"
    exec 4<>"${mutex}";echo >&4 
}

function concurrence::mutex_destory()
{
    local mutex="$1"
    rm "${mutex}"
}

function concurrence::test()
{
    concurrence::Mutex mutex1
    # echo LOG1 "${mutex1}"
    # concurrence::mutex_lock "${mutex1}" # 为啥会卡住？？？
    # echo LOG2 "${mutex1}"
    (concurrence::mutex_lock ${mutex1};sleep 2 ;echo 1;concurrence::mutex_unlock ${mutex1}) &
    (concurrence::mutex_lock ${mutex1};echo 2;concurrence::mutex_unlock ${mutex1}) &
    wait
}

concurrence::test
