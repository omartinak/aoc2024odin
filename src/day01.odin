package aoc2024

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

day01a :: proc() {
//    read_input2("data/day01_test.txt", proc(line: string) {
//        fmt.println(line)
//    })
//    lines := read_input("data/day01_test.txt")
    lines := read_input("data/day01.txt")
    left, right: [dynamic]int

    for line in lines {
        tokens := strings.split(line, " ")
        append(&left, strconv.atoi(tokens[0]))
        append(&right, strconv.atoi(tokens[3]))
    }

    slice.sort(left[:])
    slice.sort(right[:])

    dist: int
    for _, i in left {
        dist += abs(right[i] - left[i])
    }

//    fmt.println(dist == 11 ? "Pass" : "Fail", dist)
    fmt.println(dist == 2430334 ? "Pass" : "Fail", dist)
}

day01b :: proc() {
    lines := read_input("data/day01.txt")
    left, right: [dynamic]int

    for line in lines {
        tokens := strings.split(line, " ")
        append(&left, strconv.atoi(tokens[0]))
        append(&right, strconv.atoi(tokens[3]))
    }

    // TODO: sort may speed it up?
//    slice.sort(left[:])
//    slice.sort(right[:])

    // TODO: buckets
    similarity: int
    for l in left {
        occ: int
        for r in right {
            if l == r do occ += 1
        }
        similarity += l * occ
    }

//    fmt.println(similarity == 31 ? "Pass" : "Fail", similarity)
    fmt.println(similarity == 28786472 ? "Pass" : "Fail", similarity)
}
