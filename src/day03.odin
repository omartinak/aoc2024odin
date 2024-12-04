package aoc2024

import "core:fmt"
import "core:os"
import "core:strconv"

Token :: enum {
    UNKNOWN,
    MUL_START,
    OP,
    SEP,
    MUL_END,
    DO,
    DONT,
    NIL,
}

ParseState :: enum {
    UNKNOWN,
    MUL_START,
    OP1,
    SEP,
    OP2,
    DO,
    DONT,
    MUL_END,
}

i := 0
get_token :: proc(data: []u8) -> (Token, string) {
//    @static
//    i: int = 0

    start := i
    for i < len(data) {
        c := data[i]

        switch c {
        case 'm':
            mul_start := true
            // TODO: we can skip the first char
            mul := "mul("
            j := 0
            for j < len(mul) {
                if i+j >= len(data) || data[i+j] != mul[j] {
                    mul_start = false
                    break
                }
                j += 1
            }
            i += j
            if mul_start do return .MUL_START, string(data[start:i])
            else         do return .UNKNOWN, string(data[start:i])

        case '0'..='9':
            j := 0
            for j < 3 {
                if i+j >= len(data) || data[i+j] < '0' || data[i+j] > '9' {
                    break
                }
                j += 1
            }
            i += j
            return .OP, string(data[start:i])

        case ',':
            i += 1
            return .SEP, string(data[start:i])

        case ')':
            i += 1
            return .MUL_END, string(data[start:i])

        case 'd':
            dd := true
            // TODO: we can skip the first char
            do_str := "do()"
            j := 0
            for j < len(do_str) {
                if i+j >= len(data) || data[i+j] != do_str[j] {
                    dd = false
                    break
                }
                j += 1
            }
            if dd {
                i += j
                return .DO, string(data[start:i])
            } else if j == 2 {
                dd = true
                dont_str := "don't()"
                j = 0
                for j < len(dont_str) {
                    if i+j >= len(data) || data[i+j] != dont_str[j] {
                        dd = false
                        break
                    }
                    j += 1
                }
                if dd {
                    i += j
                    return .DONT, string(data[start:i])
                }
            }

            i += j
            return .UNKNOWN, string(data[start:i])

        case:
            j := 0
            for j < len(data)-i {
                if data[i+j] == 'm' || data[i+j] == 'd' || (data[i+j] >= '0' && data[i+j] <= '9') || data[i+j] == ',' || data[i+j] == ')' {
                    break
                }
                j += 1
            }
            i += j
            return .UNKNOWN, string(data[start:i])
        }
    }
    return .NIL, ""
}

day03a :: proc() {
    filename := "data/day03_test.txt"
//    filename := "data/day03.txt"

    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.eprintfln("Error: could not read input file: %s", filename)
        return
    }

    i = 0

    state := ParseState.UNKNOWN
    token, token_str := get_token(data)
    op1, op2: int
    sum := 0
    for token != .NIL {
        fmt.println(token, token_str)
        switch state {
        case .UNKNOWN:
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
        case .MUL_START:
            if token == .OP {
                state = .OP1
                op1 = strconv.atoi(token_str)
            } else do state = .UNKNOWN
        case .OP1:
            if token == .SEP do state = .SEP
            else             do state = .UNKNOWN
        case .SEP:
            if token == .OP {
                state = .OP2
                op2 = strconv.atoi(token_str)
            } else do state = .UNKNOWN
        case .OP2:
            if token == .MUL_END do state = .MUL_END
            else                 do state = .UNKNOWN
        case .DO:
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
            else                   do state = .UNKNOWN
        case .DONT:
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
            else                   do state = .UNKNOWN
        case .MUL_END:
            // TODO: we should go to proper state in every state instead of .UNKNOWN?
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
            else                   do state = .UNKNOWN

            sum += op1 * op2
            fmt.printfln("  %d * %d = %d", op1, op2, op1 * op2)
        }
        token, token_str = get_token(data)
    }

    fmt.println(sum == 161 ? "Pass" : "Fail", sum)
//    fmt.println(sum == 170778545 ? "Pass" : "Fail", sum)
}

day03b :: proc() {
//    filename := "data/day03_test_b.txt"
    filename := "data/day03.txt"

    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.eprintfln("Error: could not read input file: %s", filename)
        return
    }

    i = 0

    state := ParseState.UNKNOWN
    token, token_str := get_token(data)
    op1, op2: int
    sum := 0
    enabled := true
    for token != .NIL {
        fmt.println(token, token_str)
        switch state {
        case .UNKNOWN:
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
        case .MUL_START:
            if token == .OP {
                state = .OP1
                op1 = strconv.atoi(token_str)
            } else do state = .UNKNOWN
        case .OP1:
            if token == .SEP do state = .SEP
            else             do state = .UNKNOWN
        case .SEP:
            if token == .OP {
                state = .OP2
                op2 = strconv.atoi(token_str)
            } else do state = .UNKNOWN
        case .OP2:
            if token == .MUL_END do state = .MUL_END
            else                 do state = .UNKNOWN
        case .DO:
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
            else                   do state = .UNKNOWN

            enabled = true
        case .DONT:
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
            else                   do state = .UNKNOWN

            enabled = false
        case .MUL_END:
        // TODO: we should go to proper state in every state instead of .UNKNOWN?
            if token == .MUL_START do state = .MUL_START
            else if token == .DO   do state = .DO
            else if token == .DONT do state = .DONT
            else                   do state = .UNKNOWN

            if enabled do sum += op1 * op2
            fmt.printfln("  %d * %d = %d - %v", op1, op2, op1 * op2, enabled)
        }
        token, token_str = get_token(data)
    }

//    fmt.println(sum == 48 ? "Pass" : "Fail", sum)
    fmt.println(sum == 82868252 ? "Pass" : "Fail", sum)
}
