package main

import "core:bytes"
import "core:fmt"
import "core:math/rand"
import "core:mem"
import "core:os"
import "core:time"


board_height :: 30 + 2
board_width :: 50 + 2
live_cells :: 15

board: [board_height][board_width]bool


init_board :: proc() {
	for i in 1 ..< board_height - 1 {
		for j in 1 ..= live_cells {
			board[i][j] = true
		}
	}
}

draw_board :: proc() {
	// DEBUG
	// for i in 0 ..< board_height {
	// 	for j in 0 ..< board_width {
	// 		fmt.print(cast(int)board[i][j])
	// 	}
	// 	fmt.println()
	// }

	for i in 1 ..< board_height - 1 {
		for j in 1 ..< board_width - 1 {
			fmt.print(cast(int)board[i][j])
		}
		fmt.println()
	}
}

clear_board :: proc() {
	fmt.print("\033[;H\033[2J")
}

shuffle_board :: proc() {
	for i in 1 ..< board_height - 1 {
		rand.shuffle(board[i][1:board_width - 1])
	}
}

sleep :: proc() {
	time.accurate_sleep(100 * time.Millisecond)
}

next_generation :: proc() {
	neighbors: [board_height][board_width]u8

	for i in 1 ..< board_height - 1 {
		for j in 1 ..< board_width - 1 {
			// top-left: board[i - 1][j - 1]
			// top-middle: board[i - 1][j]
			// top-right: board[i - 1][j + 1]
			// left: board[i][j - 1]
			// right: board[i][j + 1]
			// bottom-left: board[i + 1][j - 1]
			// bottom-middle: board[i + 1][j]
			// bottom-right: board[i + 1][j + 1]
			neighbors[i][j] =
				cast(u8)board[i - 1][j - 1] +
				cast(u8)board[i - 1][j] +
				cast(u8)board[i - 1][j + 1] +
				cast(u8)board[i][j - 1] +
				cast(u8)board[i][j + 1] +
				cast(u8)board[i + 1][j - 1] +
				cast(u8)board[i + 1][j] +
				cast(u8)board[i + 1][j + 1]
		}
	}

	for i in 1 ..< board_height - 1 {
		for j in 1 ..< board_width - 1 {
			switch neighbors[i][j] {
			case 2:
			// Do nothing
			case 3:
				board[i][j] = true
			case:
				board[i][j] = false
			}
		}
	}

}

main :: proc() {

	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	init_board()
	shuffle_board()

	for {
		draw_board()
		sleep()
		next_generation()
		clear_board()
	}
}
