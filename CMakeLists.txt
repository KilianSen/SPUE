cmake_minimum_required(VERSION 4.2)
project(SysPrakUbung C)

set(CMAKE_C_STANDARD 99)

add_executable(SysPrakUbung main.c
        prime/main.c
        linked_list/main.c
        signals/main.c
        signals/main.c
        readfile/main.c
        sockets/main.c
        command/main.c
        struct/main.c)
