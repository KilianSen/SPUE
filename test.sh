#!/bin/bash

# Simple test runner for SysPrak exercises

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

failed=0

test_task() {
    local task_dir=$1
    local task_name=$2
    
    echo "Testing $task_name..."
    
    if [ ! -d "$task_dir" ]; then
        echo -e "${RED}Task directory $task_dir not found!${NC}"
        return 1
    fi
    
    cd "$task_dir"
    
    # Compile
    gcc -Wall -o main main.c
    if [ $? -ne 0 ]; then
        echo -e "${RED}Compilation failed for $task_name!${NC}"
        failed=1
        cd ..
        return 1
    fi
    
    # Run tests if test files exist
    local task_test_dir="../tests/$task_name"
    if [ -d "$task_test_dir" ]; then
        for input_file in "$task_test_dir"/input_*; do
            [ -e "$input_file" ] || continue
            local test_num=$(echo $input_file | sed 's/.*input_//')
            local expected_file="$task_test_dir/expected_$test_num"
            
            if [ "$task_name" == "command" ]; then
                args=$(cat "$input_file")
                ./main $args > "output_$test_num"
            else
                ./main < "$input_file" > "output_$test_num"
            fi
            
            if diff -u "$expected_file" "output_$test_num" > /dev/null; then
                echo -e "  Test $test_num: ${GREEN}PASSED${NC}"
            else
                echo -e "  Test $test_num: ${RED}FAILED${NC}"
                diff -u "$expected_file" "output_$test_num"
                failed=1
            fi
            rm "output_$test_num"
        done
    else
        echo "  No specific tests found for $task_name, skipping automated run."
    fi
    
    rm -f main
    cd ..
}

# Run tests for each task
test_task "linked_list" "linked_list"
test_task "struct" "struct"
test_task "command" "command"
test_task "prime" "prime"
test_task "readfile" "readfile"

if [ $failed -eq 0 ]; then
    echo -e "\n${GREEN}ALL AUTOMATED TESTS PASSED${NC}"
else
    echo -e "\n${RED}SOME TESTS FAILED${NC}"
    exit 1
fi
