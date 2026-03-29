#!/bin/bash

# Simple test runner for SysPrak exercises

supports_color() {
    [ -t 1 ] && [ -n "${TERM:-}" ] && [ "${TERM}" != "dumb" ]
}

if supports_color; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    GREEN=''
    RED=''
    YELLOW=''
    BLUE=''
    NC=''
fi

failed=0
TOTAL_TASKS=0
TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0

test_task() {
    local task_dir=$1
    local task_name=$2
    local task_tests=0
    local task_passed=0
    local task_failed=0
    local task_skipped=0

    TOTAL_TASKS=$((TOTAL_TASKS + 1))

    printf "\n${BLUE}==== [%s] ====${NC}\n" "$task_name"

    if [ ! -d "$task_dir" ]; then
        echo -e "${RED}[ERROR]${NC} Task directory $task_dir not found!"
        TOTAL_FAILED=$((TOTAL_FAILED + 1))
        return 1
    fi
    
    cd "$task_dir"
    
    # Compile
    gcc -Wall -std=c99 -o main main.c
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR]${NC} Compilation failed for $task_name!"
        failed=1
        TOTAL_FAILED=$((TOTAL_FAILED + 1))
        cd ..
        return 1
    fi
    
    # Run tests if test files exist
    local task_test_dir="../tests/$task_name"
    if [ -d "$task_test_dir" ]; then
        for input_file in "$task_test_dir"/input_*; do
            [ -e "$input_file" ] || continue
            task_tests=$((task_tests + 1))
            TOTAL_TESTS=$((TOTAL_TESTS + 1))
            local test_num=$(echo $input_file | sed 's/.*input_//')
            local expected_file="$task_test_dir/expected_$test_num"

            if [ ! -e "$expected_file" ]; then
                echo -e "  [${YELLOW}SKIP${NC}] Test $test_num (missing expected_$test_num)"
                task_skipped=$((task_skipped + 1))
                TOTAL_SKIPPED=$((TOTAL_SKIPPED + 1))
                continue
            fi

            if [ "$task_name" == "command" ]; then
                args=$(cat "$input_file")
                ./main $args > "output_$test_num"
            else
                ./main < "$input_file" > "output_$test_num"
            fi
            
            if diff -u "$expected_file" "output_$test_num" > /dev/null; then
                echo -e "  [${GREEN}PASS${NC}] Test $test_num"
                task_passed=$((task_passed + 1))
                TOTAL_PASSED=$((TOTAL_PASSED + 1))
            else
                echo -e "  [${RED}FAIL${NC}] Test $test_num"
                echo "    --- diff (expected vs output) ---"
                diff -u "$expected_file" "output_$test_num"
                echo "    --- end diff ---"
                failed=1
                task_failed=$((task_failed + 1))
                TOTAL_FAILED=$((TOTAL_FAILED + 1))
            fi
            rm "output_$test_num"
        done
    else
        echo -e "  [${YELLOW}SKIP${NC}] No specific tests found for $task_name"
        task_skipped=$((task_skipped + 1))
        TOTAL_SKIPPED=$((TOTAL_SKIPPED + 1))
    fi

    if [ "$task_tests" -eq 0 ] && [ -d "$task_test_dir" ]; then
        echo -e "  [${YELLOW}SKIP${NC}] No input_* files found"
        task_skipped=$((task_skipped + 1))
        TOTAL_SKIPPED=$((TOTAL_SKIPPED + 1))
    fi

    echo "  Result: total=$task_tests passed=$task_passed failed=$task_failed skipped=$task_skipped"

    rm -f main
    cd ..
}

# Run tests for each task
echo -e "${BLUE}Starting SysPrak automated tests...${NC}"
test_task "linked_list" "linked_list"
test_task "struct" "struct"
test_task "command" "command"
test_task "prime" "prime"
test_task "readfile" "readfile"

echo
echo "========== Overall =========="
echo "Tasks:   $TOTAL_TASKS"
echo "Tests:   $TOTAL_TESTS"
echo "Passed:  $TOTAL_PASSED"
echo "Failed:  $TOTAL_FAILED"
echo "Skipped: $TOTAL_SKIPPED"

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}ALL AUTOMATED TESTS PASSED${NC}"
else
    echo -e "${RED}SOME TESTS FAILED${NC}"
    exit 1
fi
