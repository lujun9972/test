#!/bin/echo Warinng: this library should be sourced!

mutex_fifo=/tmp/t.fifo
rm ${mutex_fifo}

function concurrence::mutex_init()
{
    mkfifo "${mutex_fifo}"
    exec 4<>"${mutex_fifo}";echo >&4
}

function concurrence::mutex_lock()
{
    (exec 4<>"${mutex_fifo}";read -u 4)
}


concurrence::mutex_init
echo LOG1
concurrence::mutex_lock  # 为啥会卡住？？？
echo LOG2
