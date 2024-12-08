package aoc2024

import "core:fmt"
import rl "vendor:raylib"

Vec2i :: [2]i32

Tile :: enum u8 {
    Empty,
    Visited,
    Obstacle,
}

update_guard :: proc(guard_pos, guard_dir: ^Vec2i, level: []Tile, width, height: i32, count: ^int) -> bool {
    if level[guard_pos.x + guard_pos.y * width] != .Visited {
        count^ += 1
        level[guard_pos.x + guard_pos.y * width] = .Visited
    }

    new_pos := guard_pos^ + guard_dir^

    if new_pos.x < 0 || new_pos.x >= width || new_pos.y < 0 || new_pos.y >= height {
        return false
    }

    if level[new_pos.x + new_pos.y * width] != .Obstacle {
        guard_pos^ = new_pos
    } else {
        // We assume that there will be no obstacle when we turn
        guard_dir^ = guard_dir.yx
        guard_dir.x *= -1
        guard_pos^ += guard_dir^
    }

    return true
}

draw :: proc(guard_pos, guard_dir: Vec2i, level: []Tile, width, height: i32, count: int) {
    size :: 8

    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)

    for y in 0..<height {
        for x in 0..<width {
            c: cstring
            switch level[x+y*width] {
            case .Empty: c = "."
            case .Visited: c = "x"
            case .Obstacle: c = "#"
            }
            if guard_pos == {i32(x), i32(y)} {
                switch guard_dir {
                case { 0, -1}: c = "^"
                case { 0,  1}: c = "v"
                case {-1,  0}: c = "<"
                case { 1,  0}: c = ">"
                case: c = "*"
                }
            }
            rl.DrawText(c, i32(x * size), i32(y * size), size, rl.RAYWHITE)
        }
    }
    count_str := fmt.caprintf("count: %d", count)
    rl.DrawText(count_str, i32(width * size) + 10, 0, 20, rl.RAYWHITE)

    rl.EndDrawing()
}

day06a :: proc() {
//    filename := "data/day06_test.txt"
    filename := "data/day06.txt"

    lines := read_input(filename)
    width := len(lines[0])
    height := len(lines)
    level := make([dynamic]Tile, width * height)

    guard_pos: Vec2i
    guard_dir: Vec2i = {0, -1}
    for line, y in lines {
        for c, x in line {
            switch c {
            case '#':
                level[x+y*width] = .Obstacle
            case:
                level[x+y*width] = .Empty
                if c == '^' do guard_pos = {i32(x), i32(y)}
            }
        }
    }

    count := 0
    vis := true
    step := false

    if vis {
        rl.InitWindow(800, 600, "day06a")
        rl.SetWindowState({.WINDOW_RESIZABLE})

        for !rl.WindowShouldClose() {
            if !step || (rl.IsKeyPressed(.SPACE) || rl.IsKeyPressed(.ENTER)) {
                if !update_guard(&guard_pos, &guard_dir, level[:], i32(width), i32(height), &count) do break
            }
            draw(guard_pos, guard_dir, level[:], i32(width), i32(height), count)
        }

        rl.CloseWindow()
    } else {
        for update_guard(&guard_pos, &guard_dir, level[:], i32(width), i32(height), &count) {}
    }

//    fmt.println(count == 41 ? "Pass" : "Fail", count)
    fmt.println(count == 5305 ? "Pass" : "Fail", count)
}

day06b :: proc() {
}
