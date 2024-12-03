package aoc2024

import "core:fmt"
import "core:os"
import "core:strings"

read_input :: proc(filename: string) -> [dynamic]string {
    lines := make([dynamic]string) // TODO: what if we keep it zero initialized?

    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.eprintfln("Error: could not read input file: %s", filename)
        return lines
    }

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        append(&lines, line)
    }

    return lines
}

read_input2 :: proc(filename: string, process: proc(line: string)) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.eprintfln("Error: could not read input file: %s", filename)
        return
    }

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        process(line)
    }
}
