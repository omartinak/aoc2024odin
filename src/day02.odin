package aoc2024

import "core:fmt"
import "core:strings"
import "core:strconv"

get_diff :: proc(t0, t1: string) -> int {
    i0 := strconv.atoi(t0)
    i1 := strconv.atoi(t1)
    return i1 - i0
}

get_dir :: proc(num: int) -> int {
    return num > 0 ? 1 : -1
}

is_report_safe :: proc(tokens: []string) -> int {
    diff := get_diff(tokens[0], tokens[1])
    if abs(diff) < 1 || abs(diff) > 3 do return 1

    dir := get_dir(diff)
    prev_token := tokens[1]

    for token, i in tokens[2:] {
        diff = get_diff(prev_token, token)
        if abs(diff) < 1 || abs(diff) > 3 || get_dir(diff) != dir do return i+2

        prev_token = token
    }
    return -1
}

is_report_safe2 :: proc(tokens: []string) -> bool {
    dir: int
    prev_token := tokens[0]

    for token in tokens[1:] {
        diff := get_diff(prev_token, token)
        if abs(diff) < 1 || abs(diff) > 3 do return false

        if dir == 0 do dir = get_dir(diff)
        else if dir != get_dir(diff) do return false

        prev_token = token
    }
    return true
}

is_report_safe3 :: proc(tokens: []string) -> bool {
    dir: int
    prev_token := tokens[0]
    tolerated := false

    for token in tokens[1:] {
        unsafe := false

        diff := get_diff(prev_token, token)
        if abs(diff) < 1 || abs(diff) > 3 do unsafe = true

        if dir == 0 do dir = get_dir(diff)
        else if dir != get_dir(diff) do unsafe = true

        if unsafe {
            if tolerated do return false
            else do tolerated = true
        }
        prev_token = token
    }
    return true
}

day02a :: proc() {
//    lines := read_input("data/day02_test.txt")
    lines := read_input("data/day02.txt")

    sum: int
    for line in lines {
        tokens := strings.split(line, " ")
        if is_report_safe2(tokens) do sum += 1
    }

    //    fmt.println(sum == 2 ? "Pass" : "Fail", sum)
    fmt.println(sum == 371 ? "Pass" : "Fail", sum)
}

day02b :: proc() {
//    lines := read_input("data/day02_test.txt")
    lines := read_input("data/day02.txt")

    sum: int
    for line in lines {
        tokens := strings.split(line, " ")
        if is_report_safe3(tokens) do sum += 1
    }

//    fmt.println(sum == 4 ? "Pass" : "Fail", sum)
    fmt.println(sum == 426 ? "Pass" : "Fail", sum)
}
