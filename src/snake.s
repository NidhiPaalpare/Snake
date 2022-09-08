########################################################################
# COMP1521 21T2 -- Assignment 1 -- Snake!
# <https://www.cse.unsw.edu.au/~cs1521/21T2/assignments/ass1/index.html>
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# For instructions, see: https://www.cse.unsw.edu.au/~cs1521/21T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Nidhi Paalpare (z5257492)
# on 14-07-2021
#
# Version 1.0 (2021-06-24): Team COMP1521 <cs1521@cse.unsw.edu.au>
#

# Requires:
# - [no external symbols]
#
# Provides:
# - Global variables:
.globl	symbols
.globl	grid
.globl	snake_body_row
.globl	snake_body_col
.globl	snake_body_len
.globl	snake_growth
.globl	snake_tail

# - Utility global variables:
.globl	last_direction
.globl	rand_seed
.globl  input_direction__buf

# - Functions for you to implement
.globl	main
.globl	init_snake
.globl	update_apple
.globl	move_snake_in_grid
.globl	move_snake_in_array

# - Utility functions provided for you
.globl	set_snake
.globl  set_snake_grid
.globl	set_snake_array
.globl  print_grid
.globl	input_direction
.globl	get_d_row
.globl	get_d_col
.globl	seed_rng
.globl  rand_value


########################################################################
# Constant definitions.

N_COLS          = 15
N_ROWS          = 15
MAX_SNAKE_LEN   = N_COLS * N_ROWS

EMPTY           = 0
SNAKE_HEAD      = 1
SNAKE_BODY      = 2
APPLE           = 3

NORTH       = 0
EAST        = 1
SOUTH       = 2
WEST        = 3


########################################################################
# .DATA
        .data

        # const char symbols[4] = {'.', '#', 'o', '@'};
symbols:
        .byte	'.', '#', 'o', '@'

        .align 2
        # int8_t grid[N_ROWS][N_COLS] = { EMPTY };
grid:
        .space	N_ROWS * N_COLS

        .align 2
        # int8_t snake_body_row[MAX_SNAKE_LEN] = { EMPTY };
snake_body_row:
        .space	MAX_SNAKE_LEN

        .align 2
        # int8_t snake_body_col[MAX_SNAKE_LEN] = { EMPTY };
snake_body_col:
        .space	MAX_SNAKE_LEN

        # int snake_body_len = 0;
snake_body_len:
        .word	0

        # int snake_growth = 0;
snake_growth:
        .word	0

        # int snake_tail = 0;
snake_tail:
        .word	0

        # Game over prompt, for your convenience...
main__game_over:
        .asciiz	"Game over! Your score was "


        ########################################################################
        #
        # Your journey begins here, intrepid adventurer!
        #
        # Implement the following 6 functions, and check these boxes as you
        # finish implementing each function
        #
        #  - [x] main
        #  - [x] init_snake
        #  - [x] update_apple
        #  - [x] update_snake
        #  - [x] move_snake_in_grid
        #  - [x] move_snake_in_array
        #



########################################################################
# .TEXT <main>
.text
main:

        # Args:     void
        # Returns:
        #   - $v0: int
        #
        # Frame:    $ra
        # Uses:	    $v0, $a0, $t0, $t1, $t2
        # Clobbers: $a0, $t0, $t1
        #
        # Locals:
        #   - 'int direction' in $a0
        #
        # Structure:
        #   main
        #   -> [prologue]
        #   -> body
        #   -> main_do
        #   -> main_next
        #   -> [epilogue]

        # Code:
main__prologue:
        # set up stack frame
        addiu	$sp, $sp, -4
        sw	$ra,  ($sp)

main__body:
        # TODO ... complete this function.

        jal  init_snake                         # init_snake();

        jal  update_apple                       # update_apple();

main_do:
        # do {

        jal  print_grid                         # print_grid();

        jal  input_direction                    # direction = input_direction();                          

        move  $a0, $v0
        jal update_snake                        # update_snake(direction)
    
        beq   $v0, 1, main_do                   # back to do loop

        j  main_next
main_next:

        lw   $t0, snake_body_len                # int score = snake_body_len / 3
        li   $t1, 3
        div  $t2, $t0, $t1

        la   $a0, main__game_over               # print string
        li   $v0, 4
        syscall

        move   $a0, $t2                         # print score
        li     $v0, 1
        syscall

        li     $a0, '\n'                        # print escape char
        li     $v0, 11
        syscall

main__epilogue:
        # tear down stack frame
        lw	$ra,  ($sp)
        addiu 	$sp, $sp, 4

        li	$v0, 0
        jr	$ra			        # return 0;



########################################################################
# .TEXT <init_snake>
.text
init_snake:

        # Args:     void
        # Returns:  void
        #
        # Frame:    $ra
        # Uses:     $a1, $a2, $a3
        # Clobbers: $a1, $a2, $a3
        #
        # Locals:
        #   - void
        #
        # Structure:
        #   init_snake
        #   -> [prologue]
        #   -> body
        #   -> [epilogue]

        # Code:
init_snake__prologue:
        # set up stack frame
        addiu	$sp, $sp, -4
        sw	$ra, ($sp)

init_snake__body:
        # TODO ... complete this function.
        li   $a0, 7                             # initilaise 1st arg
        li   $a1, 7                             # initialise 2nd arg
        li   $a2, SNAKE_HEAD                    # initialise 3rd arg
        jal  set_snake                          # call function

        li   $a0, 7                             # initilaise 1st arg
        li   $a1, 6                             # initialise 2nd arg                     
        li   $a2, SNAKE_BODY                    # initialise 3rd arg
        jal  set_snake                          # call function

        li   $a0, 7                             # initilaise 1st arg
        li   $a1, 5                             # initialise 2nd arg                     
        li   $a2, SNAKE_BODY                    # initialise 3rd arg
        jal  set_snake                          # call function

        li   $a0, 7                             # initilaise 1st arg
        li   $a1, 4                             # initialise 2nd arg                     
        li   $a2, SNAKE_BODY                    # initialise 3rd arg
        jal  set_snake                          # call function

init_snake__epilogue:
        # tear down stack frame
        lw	$ra, ($sp)
        addiu 	$sp, $sp, 4

        jr	$ra			        # return;



########################################################################
# .TEXT <update_apple>
.text
update_apple:

        # Args:     void
        # Returns:  void
        #
        # Frame:    $ra, $s0, $s1, $s2
        # Uses:     $v0, $a0, $s0, $s1, $s2, $t2, $t3, $t4
        # Clobbers: $t2, $t3, 
        #
        # Locals:
        #   - 'int apple_row' in $s0
        #   - 'int apple_col' in $s1
        #
        # Structure:
        #   update_apple
        #   -> [prologue]
        #   -> body
        #   -> do_update_apple
        #   -> next_apple
        #   -> [epilogue]

        # Code:
update_apple__prologue:
        # set up stack frame
        addiu	$sp, $sp, -16
        sw	$ra,  12($sp)
        sw      $s0,   8($sp)
        sw      $s1,   4($sp)
        sw      $s2,     ($sp)

update_apple__body:
        # TODO ... complete this function.

do_update_apple:

        li   $a0, N_ROWS                        # initialise arg
        jal  rand_value                         # call function    

        move $s0, $v0                           # apple_row = rand_value(N_ROWS)

        li   $a0, N_COLS                        # initialise arg
        jal  rand_value                         # call function

        move $s1, $v0                           # apple_col = rand_value(N_RCOLS)

        li   $t2, N_COLS		        # grid[apple_row][apple_cow]
        mul  $t2, $t2, $s0
        add  $t2, $t2, $s1 
        lb   $s2, grid($t2)

        beq  $s2, EMPTY, next_apple             # while (grid[apple_row][apple_col] != EMPTY)             

        j    do_update_apple                    # loop again

next_apple:

        li   $t3, N_COLS			# grid[apple_row][apple_cow]
        mul  $t3, $t3, $s0
        add  $t3, $t3, $s1 
        li   $t4, APPLE                         # $t4 = APPLE;
        sb   $t4, grid($t3)                     # grid[apple_row][apple_cow] = APPLE

update_apple__epilogue:
        # tear down stack frame
        lw      $s2,   ($sp)
        lw      $s1,   4($sp)
        lw      $s0,  8($sp)
        lw	$ra,  12($sp)
        addiu 	$sp, $sp, 16

        jr	$ra			        # return;



########################################################################
# .TEXT <update_snake>
.text
update_snake:

        # Args:
        #   - $a0: int direction
        # Returns:
        #   - $v0: bool
        #
        # Frame:    $ra, $s0, $s1, $s2
        # Uses:     $v0, $s0, $s1, $s2, $s3, $s4, 
        #           $s5, $s6, $s7, $s8, $a0, $t0,
        #           $t1, $t2, $t3, $t5, $t6
        # Clobbers: $s0, $s1, $s2, $a0, $t0,
        #           $t1, $t2, $t3, $t5, $t6
        #
        # Locals:
        #   - 'int d_col' in $t0
        #   - 'int d_row' in $t1
        #   - 'int head_row' in $s1
        #   - 'int head_col' in $s2
        #   - 'int new_head_row' in $s3
        #   - 'int new_head_col' in $s4
        #   - 'bool apple' in $t2
        # Structure:
        #   update_snake
        #   -> [prologue]
        #   -> body
        #   -> check_apple
        #   -> true_apple
        #   -> update_calls
        #   -> false_return
        #   -> true_return
        #   -> [epilogue]

        # Code:
update_snake__prologue:
        # set up stack frame
        addiu	$sp, $sp, -16
        sw	$ra, 12($sp)
        sw      $s0, 8($sp)
        sw      $s1, 4($sp)
        sw      $s2,  ($sp)

update_snake__body:
        # TODO ... complete this function.

        move   $s0, $a0                         # $s0 = direction

        jal    get_d_row                        # call get_d_row function

        move   $t0, $v0                         # d_row = get_d_row(direction)

        move   $a0, $s0

        jal    get_d_col                        # call get_d_col function

        move   $t1, $v0                         # d_col = get_d_col(direction)

        li     $t2, 0
        lb     $s1, snake_body_row($t2)         # int head_row = snake_body_row[0]

        lb     $s2, snake_body_col($t2)         # int head_col = snake_body_col[0]                          

        li     $t5, N_COLS
        mul    $t5, $t5, $s1
        add    $t5, $t5, $s2
        li     $t6, SNAKE_BODY                  # grid[head_row][head_col] = SNAKE_BODY;
        sb     $t6, grid($t5)

        add    $s3, $s1, $t0                    # int new_head_row ($s3) = head_row + d_row;
        add    $s4, $s2, $t1                    # int new_head_col ($s4) = head_col + d_col;

        blt    $s3, 0, false_return             # if (new_head_row < 0)       return false;
        bge    $s3, N_ROWS, false_return        # if (new_head_row >= N_ROWS) return false;
        blt    $s4, 0, false_return             # if (new_head_col < 0)       return false;
        bge    $s4, N_COLS, false_return        # if (new_head_col >= N_COLS) return false;

check_apple:

        li     $t2, 0                           # apple = false
        li     $t1, N_COLS
        mul    $t1, $t1, $s3
        add    $t1, $t1, $s4
        lb     $s5, grid($t1)                   # $s5 = grid[new_head_row][new_head_col]

        beq    $s5, APPLE, true_apple           # if grid[new_head_row][new_head_col] = APPLE go to true_apple

        j       update_calls
true_apple:

        li     $t2, 1                           # apple = true

        j       update_calls
update_calls:

        lw     $s6, snake_tail                  # $s6 = snake_tail
        lw     $s7, snake_body_len              # $s7 = snake_body_len

        addi   $s7, $s7, -1                     # ($s6) snake_tail = snake_body_len - 1;
        sw     $s7, snake_tail

        move   $a0, $s3                         # move_snake_in_grid(new_head_row, new_head_col)
        move   $a1, $s4
        jal    move_snake_in_grid

        move   $t3, $v0
        bne    $t3, 1, false_return             # if (! move_snake_in_grid(new_head_row, new_head_col)) return false

        move   $a0, $s3
        move   $a1, $s4
        jal    move_snake_in_array              # move_snake_in_array(new_head_row, new_head_col);

        bne    $t2, 1, true_return              # if (! apple) --> go to return

        lw     $s8, snake_growth                # snake_growth += 3;
        addi   $s8, $s8, 3
        sw     $s8, snake_growth

        jal    update_apple                     # update_apple();

true_return:

        li      $v0, 1                          # to return true

        j update_snake__epilogue

false_return:

        li      $v0, 0                          # to return false

        j update_snake__epilogue
update_snake__epilogue:
        # tear down stack frame
        lw      $s2,  ($sp)
        lw      $s1, 4($sp)
        lw      $s0, 8($sp)
        lw	$ra, 12($sp)
        addiu 	$sp, $sp, 16

        jr	$ra			        # return;



########################################################################
# .TEXT <move_snake_in_grid>
.text
move_snake_in_grid:

        # Args:
        #   - $a0: new_head_row
        #   - $a1: new_head_col
        # Returns:
        #   - $v0: bool
        #
        # Frame:    $ra
        # Uses:     $t0, $t1,
        #           $t2, $t3, $t4, $t5, $t6
        #           $t7, $t8, $t9, $a0, $a1
        # Clobbers: $t0, $t1, $t2, $t3, $t4, 
        #           $t5, $t6, $t7, $t8, $t9
        #           
        # Locals:
        #   - 'int tail' in $t3
        #   - 'int tail_row' in $t4
        #   - 'int tail_col' in $t5
        #
        # Structure:
        #   move_snake_in_grid
        #   -> [prologue]
        #   -> body
        #   -> else_move
        #   -> updating_snake
        #   -> next_false_return
        #   -> next_true_return
        #   -> [epilogue]

        # Code:
move_snake_in_grid__prologue:
        # set up stack frame
        addiu	$sp, $sp, -4
        sw	$ra,  ($sp)

move_snake_in_grid__body:
        # TODO ... complete this function.		

        lw    $t0, snake_growth	                # locate word snake_growth and assign it to a register

        ble   $t0, 0, else_move		        # if snake_growth <= 0 go to else

        lw    $t1, snake_tail
        addiu $t1, $t1, 1			# snake_tail++;
        sw    $t1, snake_tail

        lw    $t2, snake_body_len
        addiu $t2, $t2, 1			# snake_body_len++;
        sw    $t2, snake_body_len
        
        addi $t0, $t0, -1			# snake_growth--;
        sw   $t0, snake_growth

        j   updating_snake
else_move:

        lw   $t3, snake_tail                    # int tail = snake_tail

        lb   $t4, snake_body_row($t3)           # int tail_row = snake_body_row[tail];

        lb   $t5, snake_body_col($t3)           # int tail_col = snake_body_col[tail];

        li   $t6, N_COLS
        mul  $t6, $t6, $t4
        add  $t6, $t6, $t5
        li   $t7, EMPTY                         # grid[tail_row][tail_col] = EMPTY;
        sb   $t7, grid($t6)

updating_snake:

        li   $t8, N_COLS
        mul  $t8, $t8, $a0
        add  $t8, $t8, $a1
        lb   $t9, grid($t8)                     # grid[new_head_row][new_head_col]

        beq  $t9, SNAKE_BODY, next_false_return    # if (grid[new_head_row][new_head_col] == SNAKE_BODY) return false

        li   $t0, N_COLS
        mul  $t0, $t0, $a0
        add  $t0, $t0, $a1
        li   $t1, SNAKE_HEAD
        sb   $t1, grid($t0)                     # grid[new_head_row][new_head_col] = SNAKE_HEAD;

        j    next_true_return                   # go to return true
        
next_false_return:


        li	$v0, 0                          # to return true

        j       move_snake_in_grid__epilogue

next_true_return:

        li      $v0, 1                          # to return false

        j       move_snake_in_grid__epilogue

move_snake_in_grid__epilogue:
        # tear down stack frame

        lw      $ra,  ($sp)
        addiu 	$sp, $sp, 4

        jr	$ra			        # return;



########################################################################
# .TEXT <move_snake_in_array>
.text
move_snake_in_array:

        # Arguments:
        #   - $a0: int new_head_row
        #   - $a1: int new_head_col
        # Returns:  void
        #
        # Frame:    $ra, $s0, $s1, $s2, $s3
        #           $s4, $s5
        # Uses:     $s0, $s1, $s2, $s3
        #           $s4, $s5, $a0, $a1
        #           $a2
        # Clobbers: ...
        # Locals:
        #   - 'int i' in $s2
        #
        # Structure:
        #   move_snake_in_array
        #   -> [prologue]
        #   -> body
        #   -> loop array
        #   -> call_set_array
        #   -> [epilogue]

        # Code:
move_snake_in_array__prologue:
        # set up stack frame
        addiu	$sp, $sp, -28
        sw      $ra, 24($sp)
        sw      $s0, 20($sp)
        sw	$s1,  16($sp)
        sw      $s2,  12($sp)
        sw      $s3,   8($sp)
        sw      $s4,   4($sp)
        sw      $s5,   ($sp)

move_snake_in_array__body:
        # TODO ... complete this function.

        
        move   $s0, $a0                         # new_head_row
        move   $s1, $a1                         # new_head_col
        lw     $s2, snake_tail                  # int i = snake_tail

loop_array:

        blt   $s2, 1, call_set_snake_array      # if i < 1 -> go to call_set_snake_array

        addi   $s3, $s2, -1                     # i - 1
        lb     $s4, snake_body_row($s3)         # snake_body_row[i - 1]
        move   $a0, $s4                         # arg1 = snake_body_row[i - 1]
        lb     $s5, snake_body_col($s3)         # snake_body_col[i - 1]
        move   $a1, $s5                         # arg2 = snake_body_col[i - 1]
        move   $a2, $s2                         # arg3 = i

        jal    set_snake_array                  # set_snake_array(snake_body_row[i - 1], snake_body_col[i - 1], i)

        addi   $s2, $s2, -1                     # i--

        j      loop_array                       # loop again

call_set_snake_array:

        move   $a0, $s0                         # move back new_head_row into arg1
        move   $a1, $s1                         # move back new_head_col into arg2 
        li     $a2, 0                           # arg3 = 0

        jal    set_snake_array                  # set_snake_array(new_head_row, new_head_col, 0)

move_snake_in_array__epilogue:
        # tear down stack frame
        lw      $s5,   ($sp)
        lw      $s4,  4($sp)
        lw      $s3,  8($sp)
        lw      $s2, 12($sp)
        lw	$s1, 16($sp)
        lw	$s0, 20($sp)
        lw	$ra, 24($sp)
        addiu 	$sp, $sp, 28

        jr	$ra			        # return;


########################################################################
####                                                                ####
####        STOP HERE ... YOU HAVE COMPLETED THE ASSIGNMENT!        ####
####                                                                ####
########################################################################

##
## The following is various utility functions provided for you.
##
## You don't need to modify any of the following.  But you may find it
## useful to read through --- you'll be calling some of these functions
## from your code.
##

        .data

last_direction:
        .word	EAST

rand_seed:
        .word	0

input_direction__invalid_direction:
        .asciiz	"invalid direction: "

input_direction__bonk:
        .asciiz	"bonk! cannot turn around 180 degrees\n"

        .align	2
input_direction__buf:
        .space	2



########################################################################
# .TEXT <set_snake>
.text
set_snake:

        # Args:
        #   - $a0: int row
        #   - $a1: int col
        #   - $a2: int body_piece
        # Returns:  void
        #
        # Frame:    $ra, $s0, $s1
        # Uses:     $a0, $a1, $a2, $t0, $s0, $s1
        # Clobbers: $t0
        #
        # Locals:
        #   - `int row` in $s0
        #   - `int col` in $s1
        #
        # Structure:
        #   set_snake
        #   -> [prologue]
        #   -> body
        #   -> [epilogue]

        # Code:
set_snake__prologue:
        # set up stack frame
        addiu	$sp, $sp, -12
        sw	$ra, 8($sp)
        sw	$s0, 4($sp)
        sw	$s1,  ($sp)

set_snake__body:
        move	$s0, $a0		# $s0 = row
        move	$s1, $a1		# $s1 = col

        jal	set_snake_grid		# set_snake_grid(row, col, body_piece);

        move	$a0, $s0
        move	$a1, $s1
        lw	$a2, snake_body_len
        jal	set_snake_array		# set_snake_array(row, col, snake_body_len);

        lw	$t0, snake_body_len
        addiu	$t0, $t0, 1
        sw	$t0, snake_body_len	# snake_body_len++;

set_snake__epilogue:
        # tear down stack frame
        lw	$s1,  ($sp)
        lw	$s0, 4($sp)
        lw	$ra, 8($sp)
        addiu 	$sp, $sp, 12

        jr	$ra			# return;



########################################################################
# .TEXT <set_snake_grid>
.text
set_snake_grid:

        # Args:
        #   - $a0: int row
        #   - $a1: int col
        #   - $a2: int body_piece
        # Returns:  void
        #
        # Frame:    None
        # Uses:     $a0, $a1, $a2, $t0
        # Clobbers: $t0
        #
        # Locals:   None
        #
        # Structure:
        #   set_snake
        #   -> body

        # Code:
        li	$t0, N_COLS
        mul	$t0, $t0, $a0		#  15 * row
        add	$t0, $t0, $a1		# (15 * row) + col
        sb	$a2, grid($t0)		# grid[row][col] = body_piece;

        jr	$ra			# return;



########################################################################
# .TEXT <set_snake_array>
.text
set_snake_array:

        # Args:
        #   - $a0: int row
        #   - $a1: int col
        #   - $a2: int nth_body_piece
        # Returns:  void
        #
        # Frame:    None
        # Uses:     $a0, $a1, $a2
        # Clobbers: None
        #
        # Locals:   None
        #
        # Structure:
        #   set_snake_array
        #   -> body

        # Code:
        sb	$a0, snake_body_row($a2)	# snake_body_row[nth_body_piece] = row;
        sb	$a1, snake_body_col($a2)	# snake_body_col[nth_body_piece] = col;

        jr	$ra				# return;



########################################################################
# .TEXT <print_grid>
.text
print_grid:

        # Args:     void
        # Returns:  void
        #
        # Frame:    None
        # Uses:     $v0, $a0, $t0, $t1, $t2
        # Clobbers: $v0, $a0, $t0, $t1, $t2
        #
        # Locals:
        #   - `int i` in $t0
        #   - `int j` in $t1
        #   - `char symbol` in $t2
        #
        # Structure:
        #   print_grid
        #   -> for_i_cond
        #     -> for_j_cond
        #     -> for_j_end
        #   -> for_i_end

        # Code:
        li	$v0, 11			# syscall 11: print_character
        li	$a0, '\n'
        syscall				# putchar('\n');

        li	$t0, 0			# int i = 0;

print_grid__for_i_cond:
        bge	$t0, N_ROWS, print_grid__for_i_end	# while (i < N_ROWS)

        li	$t1, 0			# int j = 0;

print_grid__for_j_cond:
        bge	$t1, N_COLS, print_grid__for_j_end	# while (j < N_COLS)

        li	$t2, N_COLS
        mul	$t2, $t2, $t0		#                             15 * i
        add	$t2, $t2, $t1		#                            (15 * i) + j
        lb	$t2, grid($t2)		#                       grid[(15 * i) + j]
        lb	$t2, symbols($t2)	# char symbol = symbols[grid[(15 * i) + j]]

        li	$v0, 11			# syscall 11: print_character
        move	$a0, $t2
        syscall				# putchar(symbol);

        addiu	$t1, $t1, 1		# j++;

        j	print_grid__for_j_cond

print_grid__for_j_end:

        li	$v0, 11			# syscall 11: print_character
        li	$a0, '\n'
        syscall				# putchar('\n');

        addiu	$t0, $t0, 1		# i++;

        j	print_grid__for_i_cond

print_grid__for_i_end:
        jr	$ra			# return;



########################################################################
# .TEXT <input_direction>
.text
input_direction:

        # Args:     void
        # Returns:
        #   - $v0: int
        #
        # Frame:    None
        # Uses:     $v0, $a0, $a1, $t0, $t1
        # Clobbers: $v0, $a0, $a1, $t0, $t1
        #
        # Locals:
        #   - `int direction` in $t0
        #
        # Structure:
        #   input_direction
        #   -> input_direction__do
        #     -> input_direction__switch
        #       -> input_direction__switch_w
        #       -> input_direction__switch_a
        #       -> input_direction__switch_s
        #       -> input_direction__switch_d
        #       -> input_direction__switch_newline
        #       -> input_direction__switch_null
        #       -> input_direction__switch_eot
        #       -> input_direction__switch_default
        #     -> input_direction__switch_post
        #     -> input_direction__bonk_branch
        #   -> input_direction__while

        # Code:
input_direction__do:
        li	$v0, 8			# syscall 8: read_string
        la	$a0, input_direction__buf
        li	$a1, 2
        syscall				# direction = getchar()

        lb	$t0, input_direction__buf

input_direction__switch:
        beq	$t0, 'w',  input_direction__switch_w	# case 'w':
        beq	$t0, 'a',  input_direction__switch_a	# case 'a':
        beq	$t0, 's',  input_direction__switch_s	# case 's':
        beq	$t0, 'd',  input_direction__switch_d	# case 'd':
        beq	$t0, '\n', input_direction__switch_newline	# case '\n':
        beq	$t0, 0,    input_direction__switch_null	# case '\0':
        beq	$t0, 4,    input_direction__switch_eot	# case '\004':
        j	input_direction__switch_default		# default:

input_direction__switch_w:
        li	$t0, NORTH			# direction = NORTH;
        j	input_direction__switch_post	# break;

input_direction__switch_a:
        li	$t0, WEST			# direction = WEST;
        j	input_direction__switch_post	# break;

input_direction__switch_s:
        li	$t0, SOUTH			# direction = SOUTH;
        j	input_direction__switch_post	# break;

input_direction__switch_d:
        li	$t0, EAST			# direction = EAST;
        j	input_direction__switch_post	# break;

input_direction__switch_newline:
        j	input_direction__do		# continue;

input_direction__switch_null:
input_direction__switch_eot:
        li	$v0, 17			# syscall 17: exit2
        li	$a0, 0
        syscall				# exit(0);

input_direction__switch_default:
        li	$v0, 4			# syscall 4: print_string
        la	$a0, input_direction__invalid_direction
        syscall				# printf("invalid direction: ");

        li	$v0, 11			# syscall 11: print_character
        move	$a0, $t0
        syscall				# printf("%c", direction);

        li	$v0, 11			# syscall 11: print_character
        li	$a0, '\n'
        syscall				# printf("\n");

        j	input_direction__do	# continue;

input_direction__switch_post:
        blt	$t0, 0, input_direction__bonk_branch	# if (0 <= direction ...
        bgt	$t0, 3, input_direction__bonk_branch	# ... && direction <= 3 ...

        lw	$t1, last_direction	#     last_direction
        sub	$t1, $t1, $t0		#     last_direction - direction
        abs	$t1, $t1		# abs(last_direction - direction)
        beq	$t1, 2, input_direction__bonk_branch	# ... && abs(last_direction - direction) != 2)

        sw	$t0, last_direction	# last_direction = direction;

        move	$v0, $t0
        jr	$ra			# return direction;

input_direction__bonk_branch:
        li	$v0, 4			# syscall 4: print_string
        la	$a0, input_direction__bonk
        syscall				# printf("bonk! cannot turn around 180 degrees\n");

input_direction__while:
        j	input_direction__do	# while (true);



        ########################################################################
        # .TEXT <get_d_row>
.text
get_d_row:

        # Args:
        #   - $a0: int direction
        # Returns:
        #   - $v0: int
        #
        # Frame:    None
        # Uses:     $v0, $a0
        # Clobbers: $v0
        #
        # Locals:   None
        #
        # Structure:
        #   get_d_row
        #   -> get_d_row__south:
        #   -> get_d_row__north:
        #   -> get_d_row__else:

        # Code:
        beq	$a0, SOUTH, get_d_row__south	# if (direction == SOUTH)
        beq	$a0, NORTH, get_d_row__north	# else if (direction == NORTH)
        j	get_d_row__else			# else

get_d_row__south:
        li	$v0, 1
        jr	$ra				# return 1;

get_d_row__north:
        li	$v0, -1
        jr	$ra				# return -1;

get_d_row__else:
        li	$v0, 0
        jr	$ra				# return 0;



########################################################################
# .TEXT <get_d_col>
.text
get_d_col:

        # Args:
        #   - $a0: int direction
        # Returns:
        #   - $v0: int
        #
        # Frame:    None
        # Uses:     $v0, $a0
        # Clobbers: $v0
        #
        # Locals:   None
        #
        # Structure:
        #   get_d_col
        #   -> get_d_col__east:
        #   -> get_d_col__west:
        #   -> get_d_col__else:

        # Code:
        beq	$a0, EAST, get_d_col__east	# if (direction == EAST)
        beq	$a0, WEST, get_d_col__west	# else if (direction == WEST)
        j	get_d_col__else			# else

get_d_col__east:
        li	$v0, 1
        jr	$ra				# return 1;

get_d_col__west:
        li	$v0, -1
        jr	$ra				# return -1;

get_d_col__else:
        li	$v0, 0
        jr	$ra				# return 0;



########################################################################
# .TEXT <seed_rng>
.text
seed_rng:

        # Args:
        #   - $a0: unsigned int seed
        # Returns:  void
        #
        # Frame:    None
        # Uses:     $a0
        # Clobbers: None
        #
        # Locals:   None
        #
        # Structure:
        #   seed_rng
        #   -> body

        # Code:
        sw	$a0, rand_seed		# rand_seed = seed;

        jr	$ra			# return;



########################################################################
# .TEXT <rand_value>
.text
rand_value:

        # Args:
        #   - $a0: unsigned int n
        # Returns:
        #   - $v0: unsigned int
        #
        # Frame:    None
        # Uses:     $v0, $a0, $t0, $t1
        # Clobbers: $v0, $t0, $t1
        #
        # Locals:
        #   - `unsigned int rand_seed` cached in $t0
        #
        # Structure:
        #   rand_value
        #   -> body

        # Code:
        lw	$t0, rand_seed		#  rand_seed

        li	$t1, 1103515245
        mul	$t0, $t0, $t1		#  rand_seed * 1103515245

        addiu	$t0, $t0, 12345		#  rand_seed * 1103515245 + 12345

        li	$t1, 0x7FFFFFFF
        and	$t0, $t0, $t1		# (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF

        sw	$t0, rand_seed		# rand_seed = (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF;

        rem	$v0, $t0, $a0
        jr	$ra			# return rand_seed % n;

