package main

import "core:strings"
import "core:os"
import "core:fmt"
import "core:strconv"

Turn_direction :: enum {LEFT, RIGHT}

Dial_rotation :: struct {
    direction: Turn_direction,
    amount: uint
}

parse_input :: proc(file_path: string) -> [dynamic]Dial_rotation {
    data, ok := os.read_entire_file(file_path)
    
    if !ok {
        panic("Can't read file")
    }
    
    iterator := string(data)
    result: [dynamic]Dial_rotation
    for line in strings.split_lines_iterator(&iterator) {
        direction, _ := strings.substring(line, 0, 1)
        number, _ := strings.substring_from(line, 1)
        parsed_number, _ := strconv.parse_uint(number)
        
        append(&result, Dial_rotation {
            direction = direction == "L" ? Turn_direction.LEFT : Turn_direction.RIGHT, 
            amount = parsed_number
        })
    }
    
    return result
}

sub :: proc(dial: uint, sub: uint) -> uint {    
    if dial < sub {
        return 100 - (sub - dial)
    } else {
        return dial - sub
    }
}

add :: proc(dial: uint, add: uint) -> uint {
    add := add
    
    if add + dial >= 100 {
        return dial - (100 - add)
    } else {
        return dial + add
    }
}

rotate_dial :: proc(current_dial_value: ^uint, rotation: Dial_rotation) {
    // Normalize to a range of 0 - 100
    rotation_normalized := rotation.amount % 100
    
    switch rotation.direction {
        case .LEFT: {
            current_dial_value^ = sub(current_dial_value^, rotation_normalized)
        }
        
        case .RIGHT: {
            current_dial_value^ = add(current_dial_value^, rotation_normalized)
        }
    }
}

main :: proc() {
    dial := parse_input("./input.txt")
    
    current_dial_value: uint = 50
    zero_counter := 0
    
    for item in dial {
        rotate_dial(&current_dial_value, item)
        
        if current_dial_value == 0 {zero_counter += 1}
    }
    
    fmt.println(zero_counter)
}