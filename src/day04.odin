package aoc2024

import "core:fmt"
import "core:os"

xmas := "XMAS"

check_xmas_r :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if i+ci >= width do return 0
        else if u8(c) != data[i + ci + width*j] do return 0
    }
    return 1
}

check_xmas_l :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if i-ci < 0 do return 0
        else if u8(c) != data[i - ci + width*j] do return 0
    }
    return 1
}

check_xmas_d :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if j+ci >= height do return 0
        else if u8(c) != data[i + width*(j+ci)] do return 0
    }
    return 1
}

check_xmas_u :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if j-ci < 0 do return 0
        else if u8(c) != data[i + width*(j-ci)] do return 0
    }
    return 1
}

check_xmas_ru :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if i+ci >= width || j-ci < 0 do return 0
        else if u8(c) != data[i + ci + width*(j-ci)] do return 0
    }
    return 1
}

check_xmas_lp :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if i-ci < 0 || j-ci < 0 do return 0
        else if u8(c) != data[i - ci + width*(j-ci)] do return 0
    }
    return 1
}

check_xmas_rd :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if i+ci >= width || j+ci >= height do return 0
        else if u8(c) != data[i + ci + width*(j+ci)] do return 0
    }
    return 1
}

check_xmas_ld :: proc(data: []u8, i, j: int, width, height: int) -> int {
    for c, ci in xmas {
        if i-ci < 0 || j+ci >= height do return 0
        else if u8(c) != data[i - ci + width*(j+ci)] do return 0
    }
    return 1
}

day04a :: proc() {
//    filename := "data/day04_test.txt"
    filename := "data/day04.txt"

    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.eprintfln("Error: could not read input file: %s", filename)
        return
    }
    width, height: int
    for c in data {
        if height == 0 && c >= 'A' && c <= 'Z' do width += 1
        if c == '\n' do height += 1
    }
    width += 2 // add \r\n

    sum: int
    for j in 0..<height {
        for i in 0..< width {
            sum += check_xmas_r(data, i, j, width, height)
            sum += check_xmas_l(data, i, j, width, height)
            sum += check_xmas_u(data, i, j, width, height)
            sum += check_xmas_d(data, i, j, width, height)
            sum += check_xmas_ru(data, i, j, width, height)
            sum += check_xmas_lp(data, i, j, width, height)
            sum += check_xmas_rd(data, i, j, width, height)
            sum += check_xmas_ld(data, i, j, width, height)
        }
    }

//    fmt.println(sum == 18 ? "Pass" : "Fail", sum)
    fmt.println(sum == 2547 ? "Pass" : "Fail", sum)
}

mas := "MAS"

check_mas :: proc(data: []u8, i, j: int, width, height: int) -> int {
    rd := true
    ld := true
    ru := true
    lu := true

    for ci in 0..<3 {
        if mas[ci] != data[i - 1 + ci + width * (j - 1 + ci)] do rd = false
        if mas[ci] != data[i + 1 - ci + width * (j - 1 + ci)] do ld = false
        if mas[ci] != data[i - 1 + ci + width * (j + 1 - ci)] do ru = false
        if mas[ci] != data[i + 1 - ci + width * (j + 1 - ci)] do lu = false
    }

    return (rd || lu) && (ru || ld) ? 1 : 0
}

day04b :: proc() {
//    filename := "data/day04_test.txt"
    filename := "data/day04.txt"

    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.eprintfln("Error: could not read input file: %s", filename)
        return
    }
    width, height: int
    for c in data {
        if height == 0 && c >= 'A' && c <= 'Z' do width += 1
        if c == '\n' do height += 1
    }
    width += 2 // add \r\n

    sum: int
    for j in 1..<height-1 {
        for i in 1..< width-1 {
            sum += check_mas(data, i, j, width, height)
        }
    }

//        fmt.println(sum == 9 ? "Pass" : "Fail", sum)
    fmt.println(sum == 1939 ? "Pass" : "Fail", sum)
}
