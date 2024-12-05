package aoc2024

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

Parse :: enum {RULES, PAGES}
Rule :: struct {
    left, right: int
}
Pages :: [dynamic]int

day05a :: proc() {
//    filename := "data/day05_test.txt"
    filename := "data/day05.txt"

    lines := read_input(filename)
    rules: [dynamic]Rule
    pages: [dynamic]Pages

    parse := Parse.RULES
    for line in lines {
        if line == "" do parse = .PAGES
        else if parse == .RULES {
            tokens := strings.split(line, "|")
            rule := Rule{
                left = strconv.atoi(tokens[0]),
                right = strconv.atoi(tokens[1]),
            }
            append(&rules, rule)
        } else if parse == .PAGES {
            tokens := strings.split(line, ",")
            append(&pages, make(Pages))
            for token in tokens do append(&pages[len(pages)-1], strconv.atoi(token))
        }
    }

//    fmt.println(rules)
//    fmt.println(pages)

    sum := 0
    for page_line in pages {
        valid := true
        for rule in rules {
            il := -1
            ir := -1
            for page, i in page_line {
                if page == rule.left do il = i
                if page == rule.right do ir = i
            }
            if il >= 0 && ir >= 0 && il > ir do valid = false // break
        }
        if valid do sum += page_line[len(page_line)/2]
    }

//    fmt.println(sum == 143 ? "Pass" : "Fail", sum)
    fmt.println(sum == 6384 ? "Pass" : "Fail", sum)
}

g_rules: []Rule // TODO
day05b :: proc() {
//    filename := "data/day05_test.txt"
    filename := "data/day05.txt"

    lines := read_input(filename)
    rules: [dynamic]Rule
    pages: [dynamic]Pages

    parse := Parse.RULES
    for line in lines {
        if line == "" do parse = .PAGES
        else if parse == .RULES {
            tokens := strings.split(line, "|")
            rule := Rule{
                left = strconv.atoi(tokens[0]),
                right = strconv.atoi(tokens[1]),
            }
            append(&rules, rule)
        } else if parse == .PAGES {
            tokens := strings.split(line, ",")
            append(&pages, make(Pages))
            for token in tokens do append(&pages[len(pages)-1], strconv.atoi(token))
        }
    }
    g_rules = rules[:]

    //    fmt.println(rules)
    //    fmt.println(pages)

    sum := 0
    for &page_line in pages {
        valid := true
        for rule in rules {
            il := -1
            ir := -1
            for page, i in page_line {
                if page == rule.left do il = i
                if page == rule.right do ir = i
            }
            if il >= 0 && ir >= 0 && il > ir do valid = false // break
        }
        if !valid {
            slice.sort_by(page_line[:], proc(a, b: int) -> bool {
                for rule in g_rules {
                    if rule.left == b && rule.right == a do return false
                }
                return true
            })
            sum += page_line[len(page_line)/2]
        }
    }

//    fmt.println(sum == 123 ? "Pass" : "Fail", sum)
    fmt.println(sum == 5353 ? "Pass" : "Fail", sum)
}
