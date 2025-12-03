package main

import "core:strings"
import "core:os"
import "core:fmt"
import "core:strconv"

parse_input :: proc(file_path: string) -> string {
    data, ok := os.read_entire_file(file_path)
    
    if !ok {
        panic("Can't read file")
    }
    
    return string(data)
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

main :: proc() {
    parsed := parse_input("./input.txt")
    
    current_dial_value: uint = 50
    zero_counter := 0
    
    for line in strings.split_lines_iterator(&parsed) {
        direction, _ := strings.substring(line, 0, 1)
        
        number, _ := strings.substring_from(line, 1)
        parsed_number, _ := strconv.parse_uint(number)
        parsed_number = parsed_number % 100    // Normalize to a range of 0 - 100
        
        if direction == "L" {
            current_dial_value = sub(current_dial_value, parsed_number)
        } else {
            current_dial_value = add(current_dial_value, parsed_number)
        }
        
        if current_dial_value == 0 {zero_counter += 1}
    }
    
    fmt.println(zero_counter)
}