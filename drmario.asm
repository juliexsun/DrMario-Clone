################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Zhu Xin Sun, 1009839383
# Student 2: Yuchen Zhao, 1009999762
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       1
# - Unit height in pixels:      1
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
#################
# NOTES TO SELF
#################
# starting coord of bottle grid is (9, 25)
# bottle gird is 18x25


##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
WIDTH:
    .word 64
BLACK: 
	.word 0x000000
GREY:
    .word 0x808080
RED:     # 1
    .word 0xff0000
YELLOW:  # 2
    .word 0xffff00
BLUE:    # 3
    .word 0x0000ff
RED_VIRUS:    # 1
    .word 0xcf554c
YELLOW_VIRUS: # 2
    .word 0xccbb37
BLUE_VIRUS:   # 3
    .word 0x356594
##############################################################################
# Mutable Data
##############################################################################
# current capsule data
CAP_ORIENTATION: # 0 = horizontal, 1 = vertical
	.word 0
CAP1_X:
	.word 17
CAP1_Y:
	.word 24
CAP2_X:
	.word 18
CAP2_Y:
	.word 24
CAP1_COLOUR:
	.word 0xffffff
CAP2_COLOUR:
	.word 0xffffff
BOTTLE_GRID:
	.word 0:450  # 18 x 25
LINK:
    .word 0:450  
GRAVITY_COUNTER:
    .word 0
CASCADE_FLAG:
    .word 0

NUM_VIRUSES:
    .word 0
GRAVITY_SPEED:
    .word 0

SIDE1_CAP1_X:
    .word 29
SIDE1_CAP1_Y:
    .word 24
SIDE1_CAP2_X:
    .word 30
SIDE1_CAP2_Y:
    .word 24
SIDE1_CAP1_COLOUR:
    .word 0
SIDE1_CAP2_COLOUR:
    .word 0

SIDE2_CAP1_X:
    .word 29
SIDE2_CAP1_Y:
    .word 26
SIDE2_CAP2_X:
    .word 30
SIDE2_CAP2_Y:
    .word 26
SIDE2_CAP1_COLOUR:
    .word 0
SIDE2_CAP2_COLOUR:
    .word 0

SIDE3_CAP1_X:
    .word 29
SIDE3_CAP1_Y:
    .word 28
SIDE3_CAP2_X:
    .word 30
SIDE3_CAP2_Y:
    .word 28
SIDE3_CAP1_COLOUR:
    .word 0
SIDE3_CAP2_COLOUR:
    .word 0

SIDE4_CAP1_X:
    .word 29
SIDE4_CAP1_Y:
    .word 30
SIDE4_CAP2_X:
    .word 30
SIDE4_CAP2_Y:
    .word 30
SIDE4_CAP1_COLOUR:
    .word 0
SIDE4_CAP2_COLOUR:
    .word 0

GAME_OVER:
    .word 0, -1, -1, -1, 0, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, -1, -1, -1, -1,
          -1, 0, 0, 0, 0, 0, 0, -1, 0, -1, 0, 0, -1, -1, 0, -1, -1, 0, -1, 0, 0, 0,
          -1, 0, -1, -1, -1, 0, -1, -1, -1, -1, -1, 0, -1, 0, -1, 0, -1, 0, -1, -1, 0, 0,
          -1, 0, 0, -1, 0, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0,
          0, -1, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, -1, 0, -1, -1, -1, -1,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, # blank line
          0, 0, -1, -1, 0, 0, -1, 0, 0, 0, -1, 0, -1, -1, -1, -1, 0, -1, -1, -1, -1, 0,
          0, -1, 0, 0, -1, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, 0, -1, 0,
          0, -1, 0, 0, -1, 0, -1, 0, 0, 0, -1, 0, -1, -1, -1, 0, 0, -1, -1, -1, -1, 0,
          0, -1, 0, 0, -1, 0, 0, -1, 0, -1, 0, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0,
          0, 0, -1, -1, 0, 0, 0, 0, -1, 0, 0, 0, -1, -1, -1, -1, 0, -1, 0, 0, -1, 0
PAUSE:
    .word 0, -1, -1, -1, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, -1, 0, 0, -1, -1, -1, -1, 0, -1, -1, -1, -1,
          -1, 0, 0, -1, 0, 0, -1, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0,
          -1, -1, -1, -1, 0, -1, -1, -1, -1, -1, 0, -1, 0, 0, -1, 0, 0, -1, -1, -1, -1, 0, -1, -1, 0, 0,
          -1, 0, 0, 0, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0,
          -1, 0, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, -1, -1, 0, 0, 0, -1, -1, -1, -1, 0, -1, -1, -1, -1, 0,

EMH:
    .word -1, -1, -1, -1, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, -1, 0,
          -1, 0, 0, 0, 0, -1, -1, 0, -1, -1, 0, -1, 0, 0, 0, -1, 0,
          -1, -1, -1, 0, 0, -1, 0, -1, 0, -1, 0, -1, -1, -1, -1, -1, 0,
          -1, 0, 0, 0, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, -1, 0,
          -1, -1, -1, -1, 0, -1, 0, 0, 0, -1, 0, -1, 0, 0, 0, -1, 0,

# CAPYBARA:
#     .word -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1,
#           -1, -1, -1, 0, 0x7d4e0c, 0x7d4e0c, 0, 0, 0, 0, 0, 0, -1, -1,
#           -1, -1, -1, 0, 0x5c4033, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x5c4033, 0, 0,
#           -1, -1, -1, -1, 0, 0x5c4033, 0x7d4e0c, 0, 0, 0x7d4e0c, 0x5c4033, 0x5c4033, 0, 0,
#           -1, -1, 0, 0, 0, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0, 0,
#           -1, 0, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0, 0,
#           0, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0, 0,
#           0, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0, 0, 0, -1, 0
#           0, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0, -1, -1, -1, -1, -1,
#           0, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0, -1, -1, -1, -1, 0,
#           -1, 0, 0x7d4e0c, 0x7d4e0c, 0, 0, 0x5c4033, 0x7d4e0c, 0, -1, -1, -1, -1, 0,

CAPYBARA:
    .word 0, 0, 0, 0, 0x3d2401, 0x3d2401, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x3d2401, 0x3d2401, 0x3d2401, 0x3d2401, 0x3d2401, 0x3d2401, 0, 0,
          0, 0, 0, 0x3d2401, 0x5c4033, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x5c4033, 0x3d2401, 0,
          0, 0, 0, 0, 0x3d2401, 0x5c4033, 0x7d4e0c, 0, 0, 0x7d4e0c, 0x5c4033, 0x5c4033, 0x3d2401, 0,
          0, 0, 0x3d2401, 0x3d2401, 0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x3d2401, 0,
          0, 0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x3d2401, 0,
          0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x3d2401, 0,
          0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x3d2401, 0x3d2401, 0x3d2401, 0, 0
          0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x3d2401, 0, 0, 0, 0, 0,
          0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x5c4033, 0x5c4033, 0x7d4e0c, 0x7d4e0c, 0x7d4e0c, 0x3d2401, 0, 0, 0, 0, 0,
          0, 0x3d2401, 0x7d4e0c, 0x7d4e0c, 0x3d2401, 0x3d2401, 0x5c4033, 0x7d4e0c, 0x3d2401, 0, 0, 0, 0, 0,

VIRUS_YELLOW:
    .word 0xccbb37, 0, 0xccbb37, 0, 0xccbb37, 0, 0xccbb37, 0,
          0, 0xccbb37, 0xccbb37, 0xccbb37, 0xccbb37, 0xccbb37, 0, 0,
          0xccbb37, 0xccbb37, 0, 0xccbb37, 0, 0xccbb37, 0xccbb37, 0,
          0, 0xccbb37, 0xccbb37, 0xccbb37, 0xccbb37, 0xccbb37, 0, 0,
          0, 0, 0xccbb37, 0, 0xccbb37, 0, 0, 0,

VIRUS_BLUE:
    .word 0x356594, 0, 0x356594, 0, 0x356594, 0, 0x356594, 0,
          0, 0x356594, 0x356594, 0x356594, 0x356594, 0x356594, 0, 0,
          0x356594, 0x356594, 0, 0x356594, 0, 0x356594, 0x356594, 0,
          0, 0x356594, 0x356594, 0x356594, 0x356594, 0x356594, 0, 0,
          0, 0, 0x356594, 0, 0x356594, 0, 0, 0,

VIRUS_RED:
    .word 0xcf554c, 0, 0xcf554c, 0, 0xcf554c, 0, 0xcf554c, 0,
          0, 0xcf554c, 0xcf554c, 0xcf554c, 0xcf554c, 0xcf554c, 0, 0,
          0xcf554c, 0xcf554c, 0, 0xcf554c, 0, 0xcf554c, 0xcf554c, 0,
          0, 0xcf554c, 0xcf554c, 0xcf554c, 0xcf554c, 0xcf554c, 0, 0,
          0, 0, 0xcf554c, 0, 0xcf554c, 0, 0, 0,

##############################################################################
# Code
##############################################################################
	.text

	.globl main

    # Run the game.
.macro push(%reg)
	sub $sp, $sp, 4
	sw %reg, 0($sp)
.end_macro

.macro pop(%reg)
	lw %reg, 0($sp)         # Load the return address back into reg
    addi $sp, $sp, 4       # Restore the stack pointer
.end_macro

.macro get_pixel_address(%xreg, %yreg)
	lw $t0, ADDR_DSPL           # Load base address of display
	sll $t1, %yreg, 8           # vertical offset = y * 256
	add $t1, $t1, $t0           # add to base
	sll $t2, %xreg, 2           # horizontal offset = x * 4
	add $v0, $t1, $t2  
.end_macro


select_level:
    la $t0, EMH   # Load base address of emh drawing
    li $t1, 5         # Height (Y)
    li $t2, 16      # Width (X)
    jal draw_words
    lw $t0, ADDR_KBRD           # load keyboard address 
    lw $a0, 4($t0)              # load what key is pressed
    beq $a0, 101, easy 
    beq $a0, 109, medium
    beq $a0, 104, hard 
    beq $a0, 0x71, quit_game
    j select_level

easy:
    li $t0, 71
    li $t1, 4
    sw $t0, GRAVITY_SPEED
    sw $t1, NUM_VIRUSES

    li $t5, 30
    li $t6, 30
    jal clear_board
    j main
    
medium:
    li $t0, 51
    li $t1, 5
    sw $t0, GRAVITY_SPEED
    sw $t1, NUM_VIRUSES

    li $t5, 30
    li $t6, 30
    jal clear_board
    j main

hard:
    li $t0, 31
    li $t1, 6
    sw $t0, GRAVITY_SPEED
    sw $t1, NUM_VIRUSES

    li $t5, 30
    li $t6, 30
    jal clear_board
    j main

main:
    push($ra)
    # Intialize the game
	jal initialize_capsule
    jal initialize_upcoming_capsules
	jal draw_bottle
    jal draw_upcoming_capsules
    jal generate_viruses
    
    # push($t0)
    # push($t1)
    # push($t2)
    # push($t3)
    # push($t5)
    # push($t6)
    la $t0, CAPYBARA   # Load base address of capybara drawing
    li $t1, 11         # Height (Y)
    li $t2, 13      # Width (X)
    li $t5, 40
    li $t6, 40
    push($ra)
    jal draw_sprite
    pop($ra)
    # push($t6)
    # push($t5)
    # push($t3)
    # push($t2)
    # push($t1)
    # push($t0)

    la $t0, VIRUS_YELLOW   # Load base address of capybara drawing
    li $t1, 5         # Height (Y)
    li $t2, 7      # Width (X)
    li $t5, 40
    li $t6, 15
    jal draw_sprite

    la $t0, VIRUS_BLUE  # Load base address of capybara drawing
    li $t1, 5         # Height (Y)
    li $t2, 7      # Width (X)
    li $t5, 40
    li $t6, 22
    jal draw_sprite

    la $t0, VIRUS_RED  # Load base address of capybara drawing
    li $t1, 5         # Height (Y)
    li $t2, 7      # Width (X)
    li $t5, 40
    li $t6, 29
    jal draw_sprite
    

    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31  # capsule spawning sound
    li $a0, 100
    li $a1, 100
    li $a2, 99
    li $a3, 127
    syscall 
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)
    pop($ra)

game_loop:
	# repaint the screen
	jal draw_capsule
    jal draw_upcoming_capsules
	jal draw_bottle
	
    # 1a. Check if key has been pressed
    lw $t0, ADDR_KBRD
    lw $t8, 0($t0) # Load first word from keyboard
    beq $t8, 1, keyboard_input # If first word 1, key is pressed
	jal gravity
    
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
	li $v0, 32
	li $a0, 16
	syscall

    # 5. Go back to Step 1
    j game_loop


draw_capsule:
	push($ra)
    # draw pixel1
    lw $a0, CAP1_X
    lw $a1, CAP1_Y
    lw $a2, CAP1_COLOUR
    jal draw_pixel

    # draw pixel2
    lw $a0, CAP2_X
    lw $a1, CAP2_Y
    lw $a2, CAP2_COLOUR
    jal draw_pixel

	pop($ra)
    jr $ra

draw_upcoming_capsules:
    push($ra)
    
    # draw side capule1 pixel1
    lw $a0, SIDE1_CAP1_X
    lw $a1, SIDE1_CAP1_Y
    lw $a2, SIDE1_CAP1_COLOUR
    jal draw_pixel
    # draw side capule1 pixel2
    lw $a0, SIDE1_CAP2_X
    lw $a1, SIDE1_CAP2_Y
    lw $a2, SIDE1_CAP2_COLOUR
    jal draw_pixel

    # draw side capule2 pixel1
    lw $a0, SIDE2_CAP1_X
    lw $a1, SIDE2_CAP1_Y
    lw $a2, SIDE2_CAP1_COLOUR
    jal draw_pixel
    # draw side capule2 pixel2
    lw $a0, SIDE2_CAP2_X
    lw $a1, SIDE2_CAP2_Y
    lw $a2, SIDE2_CAP2_COLOUR
    jal draw_pixel

    # draw side capule3 pixel1
    lw $a0, SIDE3_CAP1_X
    lw $a1, SIDE3_CAP1_Y
    lw $a2, SIDE3_CAP1_COLOUR
    jal draw_pixel
    # draw side capule3 pixel2
    lw $a0, SIDE3_CAP2_X
    lw $a1, SIDE3_CAP2_Y
    lw $a2, SIDE3_CAP2_COLOUR
    jal draw_pixel

    # draw side capule4 pixel1
    lw $a0, SIDE4_CAP1_X
    lw $a1, SIDE4_CAP1_Y
    lw $a2, SIDE4_CAP1_COLOUR
    jal draw_pixel
    # draw side capule4 pixel2
    lw $a0, SIDE4_CAP2_X
    lw $a1, SIDE4_CAP2_Y
    lw $a2, SIDE4_CAP2_COLOUR
    jal draw_pixel

	pop($ra)
    jr $ra
    
draw_bottle:
	push($ra)
    lw $t4, GREY      # $t4 = grey

    # draw bottom of bottle
    addi $a0, $zero, 8
    addi $a1, $zero, 50
    add $a2, $zero, $t4   # colour in $t4
    addi $a3, $zero, 20
    jal draw_line_horizontal

    # draw left side of bottle
    addi $a0, $zero, 8
    addi $a1, $zero, 25
    add $a2, $zero, $t4   # colour = $t4
    addi $a3, $zero, 25
    jal draw_line_vertical

    # draw right side of bottle
    addi $a0, $zero, 27
    addi $a1, $zero, 25
    add $a2, $zero, $t4   # colour = $t4
    addi $a3, $zero, 25
    jal draw_line_vertical

    # draw top left of bottle
    addi $a0, $zero, 8
    addi $a1, $zero, 24
    add $a2, $zero, $t4   # colour = $t4
    addi $a3, $zero, 8
    jal draw_line_horizontal

    # draw top right of bottle
    addi $a0, $zero, 20
    addi $a1, $zero, 24
    add $a2, $zero, $t4   # colour = $t4
    addi $a3, $zero, 8
    jal draw_line_horizontal

    # draw left of bottle neck
    addi $a0, $zero, 16
    addi $a1, $zero, 20
    add $a2, $zero, $t4   # colour = $t4
    addi $a3, $zero, 5
    jal draw_line_vertical

    # draw right of bottle neck
    addi $a0, $zero, 19
    addi $a1, $zero, 20
    add $a2, $zero, $t4   # colour = $t4
    addi $a3, $zero, 5
    jal draw_line_vertical

	pop($ra)
	jr $ra

initialize_upcoming_capsules:
    # before game starts
    push($ra)

    # init side capsule 1
    jal random_colour
    sw $v0, SIDE1_CAP1_COLOUR
    jal random_colour
    sw $v0, SIDE1_CAP2_COLOUR

    # init side capsule 2
    jal random_colour
    sw $v0, SIDE2_CAP1_COLOUR
    jal random_colour
    sw $v0, SIDE2_CAP2_COLOUR

    # init side capsule 3
    jal random_colour
    sw $v0, SIDE3_CAP1_COLOUR
    jal random_colour
    sw $v0, SIDE3_CAP2_COLOUR

    # init side capsule 4
    jal random_colour
    sw $v0, SIDE4_CAP1_COLOUR
    jal random_colour
    sw $v0, SIDE4_CAP2_COLOUR
    
    pop($ra)
    jr $ra

shift_upcoming_capsules:
    push($ra)

    li $t0, 17
    sw $t0, CAP1_X
    li $t0, 24
    sw $t0, CAP1_Y
    li $t0, 18
    sw $t0, CAP2_X
    li $t0, 24
    sw $t0, CAP2_Y

    li $t4, 0
    sw $t4, CAP_ORIENTATION
    
    # shift first side capsule to bottle neck
    lw $t0, SIDE1_CAP1_COLOUR
    sw $t0, CAP1_COLOUR
    lw $t0, SIDE1_CAP2_COLOUR
    sw $t0, CAP2_COLOUR

    # shift 2nd side capsule to 1st
    lw $t0, SIDE2_CAP1_COLOUR
    sw $t0, SIDE1_CAP1_COLOUR
    lw $t0, SIDE2_CAP2_COLOUR
    sw $t0, SIDE1_CAP2_COLOUR

    # shift 3rd side capsule to 2nd
    lw $t0, SIDE3_CAP1_COLOUR
    sw $t0, SIDE2_CAP1_COLOUR
    lw $t0, SIDE3_CAP2_COLOUR
    sw $t0, SIDE2_CAP2_COLOUR

    # shift 4th side capsule to 3rd
    lw $t0, SIDE4_CAP1_COLOUR
    sw $t0, SIDE3_CAP1_COLOUR
    lw $t0, SIDE4_CAP2_COLOUR
    sw $t0, SIDE3_CAP2_COLOUR

    # initialize 4th one
    # random colour stored in $v0
    jal random_colour
    sw $v0, SIDE4_CAP1_COLOUR
    jal random_colour
    sw $v0, SIDE4_CAP2_COLOUR

    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31  # capsule spawning sound
    li $a0, 100
    li $a1, 100
    li $a2, 99
    li $a3, 127
    syscall 
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)

    pop($ra)
    jr $ra




check_game_over:
    push($ra)
    li $t9, 17        # check if initial position of capsule is coloured
    li $t8, 24
    get_pixel_address($t9, $t8)
	lw $t7, 0($v0)   # $v0 = memory address of pixel, $t3 = colour there
    bnez $t7, game_over
    
    li $t6, 18
    get_pixel_address($t6, $t8)
    lw $t7, 0($v0)   # $v0 = memory address of pixel, $t3 = colour there
    bnez $t7, game_over

    pop($ra)
    jr $ra

game_over:
    la $t0, GAME_OVER   # Load base address of game over drawing
    li $t1, 11          # Height (Y)
    li $t2, 21          # Width (X)
    push($ra)
    jal draw_words
    pop($ra)
    
    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31   # Sound syscall
    li $a0, 40   # Low frequency (deeper tone)
    li $a1, 1000  # Short duration (1000 ms)
    li $a2, 58   # Channel
    li $a3, 127 
    syscall
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)

    keyboard_restart:
        lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
        lw $t8, 0($t0)                  # Load first word from keyboard
        beq $t8, 1, restart    # If first word 1, key is pressed
        j keyboard_restart
    restart:
        lw $t8 4($t0)    # load second word into $t8
        beq $t8 114 reset # pressed r
        j restart
        reset:
            push($t5)
            push($t6)
            li $t5, 64
            li $t6, 64
            jal clear_board
            pop($t6)
            pop($t5)

            li $t0, 0
            li $t1, 0
            li $t2, 0
            sw $t0, GRAVITY_SPEED
            sw $t1, NUM_VIRUSES
            sw $t2, GRAVITY_COUNTER

            clear_bottle_grid:
                la $t0, BOTTLE_GRID      # Load the base address of BOTTLE_GRID
                li $t1, 0                # Initialize loop counter i to 0
            
            clear_bottle_loop:
                beq $t1, 450, clear_link_grid  # If counter reaches 450, exit loop
                sw $zero, 0($t0)         # Store 0 at BOTTLE_GRID[i]
                addi $t0, $t0, 4           # Move to the next word (each word = 4 bytes)
                addi $t1, $t1, 1           # Increment loop counter
                j clear_bottle_loop

            clear_link_grid:
                la $t0, LINK    # Load the base address of BOTTLE_GRID
                li $t1, 0                # Initialize loop counter i to 0
            
            clear_link_loop:
                beq $t1, 450, done_reset  # If counter reaches 450, exit loop
                sw $zero, 0($t0)         # Store 0 at BOTTLE_GRID[i]
                addi $t0, $t0, 4           # Move to the next word (each word = 4 bytes)
                addi $t1, $t1, 1           # Increment loop counter
                j clear_link_loop
            
            done_reset:
                j select_level



clear_board:
    # width to clear in $t6
    # height to clear in $t5
    lw $t0, ADDR_DSPL       # Load the starting address of the display into $t0
    li $t1, 0
    li $t2, 0 

    clear_column_start:
        beq $t1, $t5, clear_board_done 
        li $t2, 0
        add $t3, $t0, $zero      # Set $t3 to the current row start address (same as $t0 initially)
    
        clear_row_start:
            beq $t2, $t6, clear_row_end
            lw $t4, BLACK
            sw $t4, 0($t3)           # Store black pixel (0) at the current address in $t3
            addi $t3, $t3, 4         # Move to the next pixel (next word)
            addi $t2, $t2, 1         # Increment column counter
            j  clear_row_start
        
        clear_row_end:
            addi $t1, $t1, 1         # Increment row counter
            addi $t0, $t0, 256
            j clear_column_start     # Continue to the next row
        
    clear_board_done:
        jr $ra                   # Return from the function

draw_sprite:
    # start drawing at coordinate ($t5, $t6)
    add $t9, $zero, $zero               # initialize the loop variable i $t9 to zero (y)
    add $t8, $zero, $zero               # initialize the loop variable j $t8 to zero (x)
    sprite_column_draw_start:
        beq $t9, $t1, draw_sprite_end
        sprite_row_draw_start:
            beq $t8, $t2, sprite_row_draw_end
            move $a0, $t8
            move $a1, $t9
            push($a0)
            push($a1)
            add $a0, $a0, $t5
            add $a1, $a1, $t6
            lw $a2, 0($t0)                 # load colour at curr gameover array address into $t0
            push($t0)
            push($ra)
            jal draw_pixel
            pop($ra)
            pop($t0)

            pop($a1)
            pop($a0)
            addi $t8, $t8, 1     # increment loop counter (x)
            addi $t0, $t0, 4     # go to next array address
            j sprite_row_draw_start
    sprite_row_draw_end:
        addi $t9, $t9, 1     # increment loop counter (y)
        add $t8, $zero, $zero               # initialize the loop variable j $t8 to zero
        addi $t0, $t0, 4     # go to next array address    
        j sprite_column_draw_start
            
    draw_sprite_end:
        jr $ra

draw_words:
    add $t9, $zero, $zero               # initialize the loop variable i $t9 to zero (y)
    add $t8, $zero, $zero               # initialize the loop variable j $t8 to zero (x)
    column_draw_start:
        beq $t9, $t1, draw_word_end
        row_draw_start:
            beq $t8, $t2, row_draw_end
            move $a0, $t8
            move $a1, $t9
            lw $a2, 0($t0)                 # load colour at curr gameover array address into $t7
            push($t0)
            push($ra)
            jal draw_pixel
            pop($ra)
            pop($t0)
            addi $t8, $t8, 1     # increment loop counter (x)
            addi $t0, $t0, 4     # go to next array address
            j row_draw_start
    row_draw_end:
        addi $t9, $t9, 1     # increment loop counter (y)
        add $t8, $zero, $zero               # initialize the loop variable j $t8 to zero
        addi $t0, $t0, 4     # go to next array address    
        j column_draw_start
            
    draw_word_end:
        jr $ra

generate_viruses:
    push($ra)
    move $s0, $zero       # $s0 as virus counter set to 0
    lw $t3, NUM_VIRUSES             # number of viruses

    virus_loop:
        beq $s0, $t3, viruses_done
    
        li $v0, 42           # generate a random number i between 9-26, stored in $a0
        li $a0, 0
        li $a1, 18
        syscall
        addi $a0, $a0, 9
        move $t8, $a0        # x coord in $t8
    
        li $v0, 42           # generate a random number i between 38-49, stored in $a0
        li $a0, 0
        li $a1, 12
        syscall
        addi $a0, $a0, 38
        move $t9, $a0        # y coord in $t9

        move $s2, $t8
        move $s1, $t9
        
        lw $t0, ADDR_DSPL
        sll $t9, $t9, 8
        add $t7, $t0, $t9
        sll $t8, $t8, 2
        add $t7, $t7, $t8   # $t7 is current address of virus
    
        lw $t6, 0($t7)      # check if there is already a virus at this location
        beq $t6, $zero, valid_virus_location
        j virus_loop       # if so, regenerate location

        valid_virus_location:
            jal random_colour_virus  # random colour in $v0
            sw $v0, 0($t7)     # draw virus
    
            addi $s2, $s2, -9
            move $t0, $s2
            addi $s1, $s1, -25
            move $t1, $s1
            # set virus colour to int
            lw $t9, RED_VIRUS
            beq $v0, $t9, color_to_int_red
            lw $t9, YELLOW_VIRUS
            beq $v0, $t9, color_to_int_yellow
            lw $t9, BLUE_VIRUS
            beq $v0, $t9, color_to_int_blue
            j color_to_int_done
            color_to_int_red:
                li $t2, 1
                j color_to_int_done
            color_to_int_yellow:
                li $t2, 2
                j color_to_int_done
            color_to_int_blue:
                li $t2, 3
                j color_to_int_done
            color_to_int_done:
            push($t3)
            push($t2)
            push($t1)
            jal set_grid_color  # set colour in bottle grid
            pop($t1)
            pop($t2)
            pop($t3)

            li $t2, 2
            push($t3)
            jal set_link_value
            pop($t3)
            
            addi $s0, $s0, 1   # increment virus counter
            j virus_loop

    viruses_done:
        pop($ra)
        jr $ra
    
gravity:
    push($ra)

    lw $t0, GRAVITY_COUNTER
    addi $t0, $t0, 1  # increment gravity counter
    sw $t0, GRAVITY_COUNTER

    lw $t1, GRAVITY_SPEED
    div $t0, $t1
    mfhi $t2  # Get remainder, only move down every GRAVITY_SPEED cycles
    bnez $t2, skip_gravity
    
    jal move_down_gravity
    # lw $t4, NUM_GRAVITY
    # addi $t4, $t4, 1  # increment gravity counter
    # sw $t4, NUM_GRAVITY

    # beq $t4, 5, increase_gravity    # increase gravity after 50 gravity drops

    pop($ra)
    jr $ra

skip_gravity:
    jr $ra




#--------------------------handle keyboard_input--------------------------#
keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x71, quit_game    # q - quit
    beq $a0, 0x61, move_left  	# a
    beq $a0, 0x64, move_right 	# d
    beq $a0, 0x73, move_down 	# s
    beq $a0, 0x77, rotate  		# w
    beq $a0, 112, pause         # p - pause
	
    jr $ra
    li $v0, 1                      # ask system to print $a0
    syscall

    jr $ra

pause:
    la $t0, PAUSE   # Load base address of game over drawing
    li $t1, 5         # Height (Y)
    li $t2, 25      # Width (X)
    push($ra)
    jal draw_words
    pop($ra)

    keyboard_unpause:
        lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
        lw $t8, 0($t0)                  # Load first word from keyboard
        beq $t8, 1, unpause   # If first word 1, key is pressed
        j keyboard_unpause
    unpause:
        lw $t8 4($t0)    # load second word into $t8
        beq $t8 112 clear_pause # pressed p
        j unpause
    clear_pause:
        push($t5)
        push($t6)
        li $t5, 10
        li $t6, 30
        jal clear_board
        pop($t6)
        pop($t5)
        j game_loop
        
quit_game:
    li $t5, 64
    li $t6, 64
    jal clear_board
    la $t0, GAME_OVER   # Load base address of game over drawing
    li $t1, 11          # Height (Y)
    li $t2, 21          # Width (X)
    push($ra)
    jal draw_words
    pop($ra)

    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31   # Sound syscall
    li $a0, 40   # Low frequency (deeper tone)
    li $a1, 1000  # Short duration (1000 ms)
    li $a2, 58   # Channel
    li $a3, 127 
    syscall
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)
    
    li $v0, 10
    syscall
    
move_left:
	push($ra)

	#-----------check collision-----------#
	lw $t3, CAP1_X     
	lw $t4, CAP1_Y     
	addi $t3, $t3, -1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 left from original cap1, $t2 = colour there	
	bnez $t5, left_collision_found

	lw $t3, CAP1_X     
	lw $t4, CAP1_Y     
	addi $t4, $t4, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 down from original cap1, $t4 = colour there
	bnez $t5, down_collision_found
	
	#-----------move capsule----------------#
	# turn pixel1 old position black
 	lw $t0, CAP1_X     
	lw $t1, CAP1_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel1
	la $t0, CAP1_X
	lw $t1, 0($t0)
	addi $t1, $t1, -1
	sw $t1, 0($t0)

	lw $a0, CAP1_X
	lw $a1, CAP1_Y
	lw $a2, CAP1_COLOUR
	jal draw_pixel

	# turn pixel2 old position black
 	lw $t0, CAP2_X     
	lw $t1, CAP2_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel2
	la $t0, CAP2_X
	lw $t1, 0($t0)
	addi $t1, $t1, -1
	sw $t1, 0($t0)

	lw $a0, CAP2_X
	lw $a1, CAP2_Y
	lw $a2, CAP2_COLOUR
	jal draw_pixel

    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31   # capsule moving sound effect
    li $a0, 80
    li $a1, 100
    li $a2, 7
    li $a3, 100
    syscall
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)
    
	pop($ra)
    jr $ra

left_collision_found:
	jr $ra
	
move_right:
	push($ra)

	#-----------check collision-----------#
	lw $t3, CAP2_X     
	lw $t4, CAP2_Y     
	addi $t3, $t3, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 right from original cap1, $t2 = colour there	
	bnez $t5, right_collision_found

	lw $t3, CAP1_X     
	lw $t4, CAP1_Y     
	addi $t4, $t4, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 down from original cap1, $t4 = colour there
	bnez $t5, down_collision_found
	
	#-----------move capsule-----------#
	# turn pixel2 old position black
 	lw $t0, CAP2_X     
	lw $t1, CAP2_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel2
	la $t0, CAP2_X
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

	lw $a0, CAP2_X
	lw $a1, CAP2_Y
	lw $a2, CAP2_COLOUR
	jal draw_pixel
	
	# turn pixel1 old position black
 	lw $t0, CAP1_X     
	lw $t1, CAP1_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel1
	la $t0, CAP1_X
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

	lw $a0, CAP1_X
	lw $a1, CAP1_Y
	lw $a2, CAP1_COLOUR
	jal draw_pixel

    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31   # capsule moving sound effect
    li $a0, 80
    li $a1, 100
    li $a2, 7
    li $a3, 100
    syscall
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)
    
	pop($ra)
    jr $ra
	
right_collision_found:
	jr $ra

move_down:
	push($ra)

	#-----------check collision-----------#
    lw $t0, CAP_ORIENTATION
    beq $t0, 1, check_1  # if cap is vertical, only check pix1

    lw $t3, CAP2_X     
	lw $t4, CAP2_Y     
	addi $t4, $t4, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 down from original cap2, $t4 = colour there
	bnez $t5, down_collision_found
    
    check_1:
	lw $t3, CAP1_X     
	lw $t4, CAP1_Y     
	addi $t4, $t4, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 down from original cap1, $t4 = colour there
	bnez $t5, down_collision_found


	#-----------move capsule-----------#
	# turn pixel1 old position black
 	lw $t0, CAP1_X     
	lw $t1, CAP1_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel1
	la $t0, CAP1_Y
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

	lw $a0, CAP1_X
	lw $a1, CAP1_Y
	lw $a2, CAP1_COLOUR
	jal draw_pixel

	# turn pixel2 old position black
 	lw $t0, CAP2_X     
	lw $t1, CAP2_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel2
	la $t0, CAP2_Y
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

	lw $a0, CAP2_X
	lw $a1, CAP2_Y
	lw $a2, CAP2_COLOUR
	jal draw_pixel

    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31   # capsule moving sound effect
    li $a0, 80
    li $a1, 100
    li $a2, 7
    li $a3, 100
    syscall
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)
    
    pop($ra)
	jr $ra

move_down_gravity:
	push($ra)

	#-----------check collision-----------#
    lw $t0, CAP_ORIENTATION
    beq $t0, 1, check_1_gravity  # if cap is vertical, only check pix1

    lw $t3, CAP2_X     
	lw $t4, CAP2_Y     
	addi $t4, $t4, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 down from original cap2, $t4 = colour there
	bnez $t5, down_collision_found
    
    check_1_gravity:
	lw $t3, CAP1_X     
	lw $t4, CAP1_Y     
	addi $t4, $t4, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 down from original cap1, $t4 = colour there
	bnez $t5, down_collision_found


	#-----------move capsule-----------#
	# turn pixel1 old position black
 	lw $t0, CAP1_X     
	lw $t1, CAP1_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel1
	la $t0, CAP1_Y
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

	lw $a0, CAP1_X
	lw $a1, CAP1_Y
	lw $a2, CAP1_COLOUR
	jal draw_pixel

	# turn pixel2 old position black
 	lw $t0, CAP2_X     
	lw $t1, CAP2_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel2
	la $t0, CAP2_Y
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

	lw $a0, CAP2_X
	lw $a1, CAP2_Y
	lw $a2, CAP2_COLOUR
	jal draw_pixel
	
    pop($ra)
	jr $ra
    
down_collision_found:
    push($ra)
    jal check_game_over
    jal put_capsule_into_grid
    jal put_capsule_into_link
    # jal check_horizontal
    # jal check_vertical
    # jal drop
    jal cascade

	jal shift_upcoming_capsules
    pop($ra)
	jr $ra
	
rotate:
	push($ra)
	
	#-----------check collision-----------#
	lw $t3, CAP1_X     
	lw $t4, CAP1_Y     
	addi $t4, $t4, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 down from original cap1, $t4 = colour there
	bnez $t5, down_collision_found

	lw $t3, CAP2_X     
	lw $t4, CAP2_Y     
	addi $t3, $t3, 1
	get_pixel_address($t3, $t4)
	lw $t5, 0($v0)   # $v0 = memory address of 1 right from original cap1, $t4 = colour there
	lw $t6, CAP_ORIENTATION
	beq $t6, 0, keep
	beq $t6, 1, next
	next:
	bnez $t5, right_collision_found

	#-------------rotate capsule---------------#
	keep:
	# pixel1 unchanged
	
	# turn pixel2 old position black
 	lw $t0, CAP2_X     
	lw $t1, CAP2_Y     
	lw $t2, BLACK       
	move $a0, $t0          
	move $a1, $t1
	move $a2, $t2
    jal draw_pixel

	# draw pixel2
	lw $t0, CAP1_X
	lw $t1, CAP1_Y
	la $t2, CAP_ORIENTATION
	lw $t8, CAP_ORIENTATION
	beq $t8, 0, horizontal_to_vertical
	beq $t8, 1, vertical_to_horizontal
	
	horizontal_to_vertical:
	la $t3, CAP2_Y
	lw $t4, 0($t3)
	addi $t4, $t1, -1
	sw $t4, 0($t3)   # CAP2_Y = CAP1_Y - 1
	la $t5, CAP2_X
	lw $t6, 0($t5)
	addi $t6, $t0, 0
	sw $t6, 0($t5)	# CAP2_wX = CAP1_X
	lw $t7, 0($t2)
	addi $t7, $t7, 1
	sw $t7, 0($t2) # CAP_ORIENTATION = 1 (vertical)
	j draw_new_pixel
	
	vertical_to_horizontal:
	la $t3, CAP2_Y
	lw $t4, 0($t3)
	addi $t4, $t1, 0
	sw $t4, 0($t3)     # CAP2_Y = CAP1_Y
	la $t5, CAP2_X
	lw $t6, 0($t5)
	addi $t6, $t0, 1
	sw $t6, 0($t5)	# CAP2_X = CAP1_X + 1
	lw $t7, 0($t2)
	addi $t7, $t7, -1
	sw $t7, 0($t2) # CAP_ORIENTATION = 0 (horizontal)
	j draw_new_pixel
	
	draw_new_pixel:
	lw $a0, CAP2_X
	lw $a1, CAP2_Y
	lw $a2, CAP2_COLOUR
	jal draw_pixel

    push($v0)
    push($a0)
    push($a1)
    push($a2)
    push($a3)
    li $v0, 31   # capsule moving sound effect
    li $a0, 80
    li $a1, 100
    li $a2, 7
    li $a3, 100
    syscall
    pop($a3)
    pop($a2)
    pop($a1)
    pop($a0)
    pop($v0)
    
	pop($ra)
    jr $ra

    
# cascade:
#     li $t0, 0
#     sw $t0, CASCADE_FLAG # reset to 0
    
#     jal check_horizontal
#     lw $t0, CASCADE_FLAG
#     bnez $t0, do_cascade # if there is clear, drop
    
#     jal check_vertical
#     lw $t0, CASCADE_FLAG
#     bnez $t0, do_cascade # if there is clear, drop
#     beqz $t0, not_do_cascade # if there is no clear, skip
#     do_cascade:
#         li $t0, 0
#         sw $t0, CASCADE_FLAG # reset to 0
#         push($ra)
#         jal drop
#         pop($ra)
#         j cascade
#     not_do_cascade:
#     pop($ra)
#     jr $ra

cascade:
    push($ra)
    li   $t9, 0
    sw   $t9, CASCADE_FLAG
    
    jal  check_vertical
    lw   $t9, CASCADE_FLAG
    bnez $t9, here 
    j here_done
    here:
    li   $t9, 0
    sw   $t9, CASCADE_FLAG   # 重置标志
    push($ra)
    jal drop
    pop($ra)
    j cascade
    here_done:
        
    jal  check_horizontal
    lw   $t9, CASCADE_FLAG
    beqz $t9, cascade_end   # 如果 CASCADE_FLAG 为 0，则无级联，退出 cascade

    li   $t9, 0
    sw   $t9, CASCADE_FLAG   # 重置标志
    push($ra)
    # li $s3, 0
    jal  drop                # 让消除的块下落
    pop($ra)
    j    cascade

cascade_end:
    pop($ra)
    jr $ra


#---------------------------check 4 in a row/col------------------------#
put_capsule_into_link:
    push($ra)

    lw $t3, CAP_ORIENTATION
    beq $t3, 0, put_capsule_into_link_helper

    put_capsule_into_link_helper:
    # pix1
    lw $t0, CAP1_X
    addi $t0, $t0, -9
    lw $t1, CAP1_Y
    addi $t1, $t1, -25
    li $t2, 1
    jal set_link_value

    # pix2
    lw $t0, CAP2_X
    addi $t0, $t0, -9
    lw $t1, CAP2_Y
    addi $t1, $t1, -25
    li $t2, -1
    jal set_link_value

    pop($ra)
    jr $ra

# input：$t0 = x, $t1 = y, $t2 = value 1/0
set_link_value:
    push($ra)
    li $t3, 18                # 18 columns
    mul $t4, $t1, $t3         # y * 18
    add $t4, $t4, $t0         # offset = y * 18 + x
    sll $t4, $t4, 2           
    la $t5, LINK
    add $t5, $t5, $t4
    sw $t2, 0($t5)
    pop($ra)
    jr $ra

# input：$t0 = x, $t1 = y
# output：$v0 = value 1/0
get_link_value:
    push($ra)
    li $t3, 18
    mul $t6, $t1, $t3
    add $t6, $t6, $t0
    sll $t6, $t6, 2
    la $t5, LINK
    add $t5, $t5, $t6
    lw $v0, 0($t5)
    pop($ra)
    jr $ra




put_capsule_into_grid:
    push($ra)
    # pix1
    lw $t0, CAP1_X
    addi $t0, $t0, -9
    lw $t1, CAP1_Y
    addi $t1, $t1, -25
    
    lw $t3, CAP1_COLOUR
    lw $t4, RED
    beq $t3, $t4, set_grid_red
    lw $t4, YELLOW
    beq $t3, $t4, set_grid_yellow
    lw $t4, BLUE
    beq $t3, $t4, set_grid_blue
    j set_grid_done
    set_grid_red:
        li $t2, 1
        j set_grid_done
    set_grid_yellow:
        li $t2, 2
        j set_grid_done
    set_grid_blue:
        li $t2, 3
        j set_grid_done
    set_grid_done:
    push($t0)
    push($t1)
    push($t2)
    push($t3)
    push($t4)
    push($t5)
    jal set_grid_color  # set colour in bottle grid
    pop($t5)
    pop($t4)
    pop($t3)
    pop($t2)
    pop($t1)
    pop($t0)

    # pix2
    lw $t0, CAP2_X
    addi $t0, $t0, -9
    lw $t1, CAP2_Y
    addi $t1, $t1, -25
  
    lw $t3, CAP2_COLOUR
    lw $t4, RED
    beq $t3, $t4, set_grid_red_2
    lw $t4, YELLOW
    beq $t3, $t4, set_grid_yellow_2
    lw $t4, BLUE
    beq $t3, $t4, set_grid_blue_2
    j set_grid_done_2
    set_grid_red_2:
        li $t2, 1
        j set_grid_done_2
    set_grid_yellow_2:
        li $t2, 2
        j set_grid_done_2
    set_grid_blue_2:
        li $t2, 3
        j set_grid_done_2
    set_grid_done_2:
    push($t0)
    push($t1)
    push($t2)
    push($t3)
    push($t4)
    push($t5)
    jal set_grid_color  # set colour in bottle grid
    pop($t5)
    pop($t4)
    pop($t3)
    pop($t2)
    pop($t1)
    pop($t0)

    pop($ra)
    jr $ra

# input：$t0 = x, $t1 = y, $t2 = color int!!
set_grid_color:
    push($ra)
    li $t3, 18                # 18 columns
    mul $t4, $t1, $t3         # y * 18
    add $t4, $t4, $t0         # offset = y * 18 + x
    sll $t4, $t4, 2           # 
    la $t5, BOTTLE_GRID
    add $t5, $t5, $t4
    sw $t2, 0($t5)
    pop($ra)
    jr $ra

# input：$t0 = x, $t1 = y
# output：$v0 = colour int!!
get_grid_color:
    push($ra)
    li $t3, 18
    mul $t6, $t1, $t3
    add $t6, $t6, $t0
    sll $t6, $t6, 2
    la $t5, BOTTLE_GRID
    add $t5, $t5, $t6
    lw $v0, 0($t5)
    pop($ra)
    jr $ra



drop:
    push($ra)
    
    li $s2, 0    # is there a drop
    # addi $s3, $s3, 1
    li $s0, 23   # $s0 = y = row = 23 scan from bottom
    drop_row_loop:
        li $s1, 0  # $s1 = x = col = 0
        drop_col_loop:
            move $t0, $s1  # t0 = x
            move $t1, $s0  # t1 = y
            jal get_grid_color
            move $t2, $v0  # t2 = current pixel color int 0/1/2/3
            move $t0, $s1  # t0 = x
            move $t1, $s0  # t1 = y
            jal get_link_value
            move $t4, $v0  # t4 = current pixel link value 0/1/-1/2

            beqz $t2, drop_next_col # if color is black, skip

            li $t7, 2
            beq $t4, $t7, drop_next_col # if virus, skip


            move $t0, $s1  # t0 = x
            move $t1, $s0  
            addi $t1, $t1, 1 # t1 = y + 1
            jal get_grid_color
            move $t5, $v0  # t5 = color int of pixel below
            bnez $t5, drop_next_col  # if below not black, skip

            # if below black
            # if link = 0, drop
            li $t7, 0
            beq $t4, $t7, do_drop 
            # if link = 1
            li $t7, 1
            beq $t4, $t7, check_link_1
            j check_link_1_done
            check_link_1:
                move $t0, $s1
                addi $t0, $t0, 1 # t0 = x + 1
                move $t1, $s0      # t1 = y
                push($t4)
                jal get_grid_color
                pop($t4)
                bnez $v0, next_condition # if right is not black
                j next_condition_done
                next_condition:
                    move $t0, $s1
                    addi $t0, $t0, 1 # t0 = x + 1
                    move $t1, $s0      
                    addi $t1, $t1, 1 # t1 = y + 1
                    push($t4)
                    jal get_grid_color
                    pop($t4)
                    bnez $v0, drop_next_col  # right below not black, skip
                next_condition_done:
                j do_drop # if link = 1 and right is not black and both below are black  
                beq $t4, $t7, do_drop  # if link = 1 and right is black, drop
            check_link_1_done:
                
            
            # if link = -1
            li $t7, -1
            beq $t4, $t7, check_link_negtive1
            j check_link_negtive1_done
            check_link_negtive1:
            move $t0, $s1  
            addi $t0, $t0, -1 # t0 = x - 1
            move $t1, $s0      # t1 = y
            jal get_grid_color
            bnez $v0, drop_next_col  # if left is not black, skip
            beq $t4, $t7, do_drop  # if left is black, drop
            check_link_negtive1_done:
                
            do_drop:
                #-----update grid----#
                move $t0, $s1  # t0 = x
                move $t1, $s0  # t1 = y
                jal get_grid_color
                move $t3, $v0  # t3 = current pixel color int 0/1/2/3
                # update original
                move $t0, $s1    # t0 = x
                move $t1, $s0    # t1 = y
                li $t7, 0
                move $t2, $t7    # black
                push($t3)
                jal set_grid_color  # set colour in bottle grid
                pop($t3)
                # update below
                move $t0, $s1          # x
                move $t1, $s0
                addi $t1, $t1, 1       # y+1
                move $t2, $t3    
                push($t3)
                jal set_grid_color  # set colour in bottle grid
                pop($t3)
               
                
                #----don't need to update link - still 0---#
                
                #----draw bitmap-----#
                # draw original black
                li $a2, 0           # black
                move $a0, $s1   # x
                addi $a0, $a0, 9
                move $a1, $s0   # y
                addi $a1, $a1, 25
                push($a0)
                push($a1)
                push($a2)
                jal draw_pixel
                pop($a2)
                pop($a1)
                pop($a0)
                # draw below color
                move $a0, $s1   # x
                addi $a0, $a0, 9
                move $a1, $s0   # y+1
                addi $a1, $a1, 26
                beq $t3, 1, change_color_int_to_red
                beq $t3, 2, change_color_int_to_yellow
                beq $t3, 3, change_color_int_to_blue
                j change_color_int_done
                change_color_int_to_red:
                    li $a2, 0xff0000
                    j change_color_int_done
                change_color_int_to_yellow:
                    li $a2, 0xffff00
                    j change_color_int_done
                change_color_int_to_blue:
                    li $a2, 0x0000ff
                    j change_color_int_done
                change_color_int_done:  # $a2 = color
                push($a0)
                push($a1)
                push($a2)
                jal draw_pixel
                pop($a2)
                pop($a1)
                pop($a0)
                

                li $s2, 1

        drop_next_col:
            addi $s1, $s1, 1    # x++
            li $t3, 18    # t0 = i = 0
            blt $s1, $t3, drop_col_loop  # if col < 18, next col
            j drop_next_row

    drop_next_row:
        addi $s0, $s0, -1 # y--
        bgez $s0, drop_row_loop  # if row >= 0, next row
        bnez $s2, drop  # if s2!=0 that is there is a drop, keep check drop
        # li $s4, 4
        # ble $s3, $s4, drop
    

    pop($ra)
    jr $ra




# s0: row index, $s1: col index
check_horizontal:
    push($ra)
    li $s0, 0          # $s0 = y = row = 0  
    row_loop:
        li $s1, 0          # $s1 = x = col = 0
        col_loop:
            li $t3, 14
            bgt $s1, $t3, next_row  # if x > 14, check next row

            move $t0, $s1   # $t0 = x
            move $t1, $s0   # $t1 = y
            jal get_grid_color
            move $t4, $v0       # $t4 = color int at (row, col)
            beqz $t4, next_col   # if color is black, skip

            addi $t0, $s1, 1      # $t0 = x + 1, $t1 = y
            jal get_grid_color    # $v0 = color int at (row+1, col)
            bne $v0, $t4, next_col  # if color int not equal, skip

            addi $t0, $s1, 2      # $t0 = x + 2, $t1 = y
            jal get_grid_color    # $v0 = color at (row+2, col)
            bne $v0, $t4, next_col  # if color not equal, skip

            addi $t0, $s1, 3      # $t0 = x + 3, $t1 = y
            jal get_grid_color    # $v0 = color at (row+3, col)
            bne $v0, $t4, next_col  # if color not equal, skip

            # 4 in a row, clear
            li $t3, 0    # i = 0
            li $t6, 0    # black
            clear_4_loop:
                add $t0, $s1, $t3     # $t0 = x + i
                move $t1, $s0         # $t1 = y
                move $t2, $t6         # color = black
                push($t3)
                push($t1)
                push($t0)
                jal set_grid_color    # update grid
                pop($t0)
                pop($t1)
                pop($t3)

                li $t2, 0
                push($t3)
                jal set_link_value
                pop($t3)
                
                move $a0, $t0
                addi $a0, $a0, 9
                move $a1, $t1
                addi $a1, $a1, 25
                move $a2, $t6
                push($a0)
                push($a1)
                push($a2)
                jal draw_pixel
                pop($a2)
                pop($a1)
                pop($a0)    # draw this pixel black

                addi $t3, $t3, 1      # i++
                li $t9, 4
                blt $t3, $t9, clear_4_loop   # if i < 4, keep going the loop
                push($v0)
                push($a0)
                push($a1)
                push($a2)
                push($a3)
                li $v0, 31
                li $a0, 90
                li $a1, 50
                li $a2, 117
                li $a3, 127
                syscall
                pop($a3)
                pop($a2)
                pop($a1)
                pop($a0)
                pop($v0) 
                beq $t3, $t9, update_cascade
                j update_cascade_done
                update_cascade:
                    li $t2, 1
                    sw $t2, CASCADE_FLAG
                    j out
                update_cascade_done:

        next_col:
            addi $s1, $s1, 1      # x++
            li $t2, 18
            blt $s1, $t2, col_loop   # if x < 18, keep going

    next_row:
        addi $s0, $s0, 1     # y++
        li $t2, 25
        blt $s0, $t2, row_loop   # if y < 25, keep going

    li $t2, 0
    sw $t2, CASCADE_FLAG
    out:
    pop($ra)
    jr $ra

# s0: row index, $s1: col index
check_vertical:
    push($ra)
    li $s1, 0          # $s1 = x = col = 0  
    col_loop_vertical:
        li $s0, 0          # $s0 = y = row = 0
        row_loop_vertical:
            li $t3, 21
            bgt $s0, $t3, next_col_vertical  # if y > 21, check next col

            move $t0, $s1   # $t0 = x
            move $t1, $s0   # $t1 = y
            jal get_grid_color
            move $t4, $v0       # $t4 = color at (row, col)
            beqz $t4, next_row_vertical   # if color is black, skip

            addi $t1, $s0, 1      # $t0 = x, $t1 = y + 1
            jal get_grid_color    # $v0 = color at (row, col+1)
            bne $v0, $t4, next_row_vertical  # if color not equal, skip

            addi $t1, $s0, 2      # $t0 = x, $t1 = y + 2
            jal get_grid_color    # $v0 = color at (row, col+2)
            bne $v0, $t4, next_row_vertical  # if color not equal, skip

            addi $t1, $s0, 3      # $t0 = x, $t1 = y + 3
            jal get_grid_color    # $v0 = color at (row, col+3)
            bne $v0, $t4, next_row_vertical  # if color not equal, skip

            # 4 in a row, clear
            li $t3, 0    # i = 0
            li $t6, 0    # black
            clear_4_loop_vertical:

                push($t3)
                add $t1, $s0, $t3     # $t1 = y + i
                move $t0, $s1         # $t0 = x
                move $t2, $t6         # color = black
                jal set_grid_color    # update grid
                pop($t3)

                li $t2, 0
                push($t3)
                jal set_link_value
                pop($t3)
                
                move $a0, $s1
                addi $a0, $a0, 9
                move $a1, $t1
                addi $a1, $a1, 25
                move $a2, $t6
                push($a0)
                push($a1)
                push($a2)
                jal draw_pixel
                pop($a2)
                pop($a1)
                pop($a0)    # draw this pixel black

                addi $t3, $t3, 1      # i++
                li $t9, 4
                blt $t3, $t9, clear_4_loop_vertical   # if i < 4, keep going the loop
                push($v0)
                push($a0)
                push($a1)
                push($a2)
                push($a3)
                li $v0, 31
                li $a0, 90
                li $a1, 50
                li $a2, 117
                li $a3, 127
                syscall
                pop($a3)
                pop($a2)
                pop($a1)
                pop($a0)
                pop($v0) 
                beq $t3, $t9, update_cascade_2
                j update_cascade_done_2
                update_cascade_2:
                    li $t2, 1
                    sw $t2, CASCADE_FLAG
                    j out_2
                update_cascade_done_2:
                    
        next_row_vertical:
            addi $s0, $s0, 1      # y++
            li $t2, 25
            blt $s0, $t2, row_loop_vertical   # if y < 25, keep going

    next_col_vertical:
        addi $s1, $s1, 1     # x++
        li $t2, 18
        blt $s1, $t2, col_loop_vertical   # if x < 18, keep going

    li $t2, 0
    sw $t2, CASCADE_FLAG
    out_2:
    pop($ra)
    jr $ra



#-----------------------------some drawing--------------------------#
initialize_capsule:
    push($ra)
	# Set starting position: CAP1 at (17, 25), CAP2 at (18, 25) — horizontal
    li $t0, 17
    sw $t0, CAP1_X
    li $t1, 24
    sw $t1, CAP1_Y
    li $t2, 18
    sw $t2, CAP2_X
    li $t3, 24
    sw $t3, CAP2_Y

    li $t4, 0
    sw $t4, CAP_ORIENTATION

	
    # Save the return address to the stack (before calling random_colour)
    addi $sp, $sp, -4      # Adjust stack pointer to make space for the return address
    sw $ra, 0($sp)         # Store return address at the top of the stack
    
    jal random_colour      # Call random_colour to set the color
	sw $v0, CAP1_COLOUR

	# pixel1
    lw $a0, CAP1_X
    lw $a1, CAP1_Y
    move $a2, $v0
	
    addi $sp, $sp, -4               # Move the stack pointer to an empty location
    sw $ra, 0($sp)                  # Store $ra on the stack for safe keeping.
    
    push($a0)
    push($a1)
    push($a2)
    jal draw_pixel
    pop($a2)
    pop($a1)
    pop($a0)

    lw $ra, 0($sp)                  # Restore $ra from the stack.
    addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.

    jal random_colour      # Call random_colour to set the color
	sw $v0, CAP2_COLOUR

	# pixel2
    lw $a0, CAP2_X
    lw $a1, CAP2_Y
    move $a2, $v0
    
    addi $sp, $sp, -4               # Move the stack pointer to an empty location
    sw $ra, 0($sp)                  # Store $ra on the stack for safe keeping.
    
    push($a0)
    push($a1)
    push($a2)
    jal draw_pixel
    pop($a2)
    pop($a1)
    pop($a0)

    lw $ra, 0($sp)                  # Restore $ra from the stack.
    addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.

    # Restore the return address after random_colour finishes
    lw $ra, 0($sp)         # Load the return address back into $ra
    addi $sp, $sp, 4       # Restore the stack pointer

    pop($ra)
    jr $ra
    # $a1 = Y coordinate of pixel
    # $a2 = rgb colour to draw
    # draw a pixel with the color $a2 at position ($a0, $a1)
    lw $t0, ADDR_DSPL           # base address of display
    sll $a1, $a1, 8             # calculate the vertical offset 
    add $t7, $t0, $a1           # add the vertical offset to base address
    sll $a0, $a0, 2             # calculate the horizontal offset 
    add $t7, $t7, $a0           # add the horizontal offset to $t7
    sw $a2, 0( $t7 )            # paint the current bitmap location.
    pop($ra)
    jr $ra

random_colour:
    # pick random colour stored in a0
    li $v0 42       # Generating a random number i between 0 and 2, stored in $a0
    li $a0 0
    li $a1 3
    syscall
    beq $a0, 0, pick_red
    beq $a0, 1, pick_yellow
    beq $a0, 2, pick_blue
    pick_red:
        lw $v0, RED
        j pick_color_end
    pick_yellow:
        lw $v0, YELLOW
        j pick_color_end
    pick_blue:
        lw $v0, BLUE
        j pick_color_end
    pick_color_end:
        jr $ra

random_colour_virus:
    # pick random colour stored in a0
    li $v0 42       # Generating a random number i between 0 and 2, stored in $a0
    li $a0 0
    li $a1 3
    syscall
    beq $a0, 0, pick_red_virus
    beq $a0, 1, pick_yellow_virus
    beq $a0, 2, pick_blue_virus
    j pick_color_end_virus
    pick_red_virus:
        lw $v0, RED_VIRUS
        j pick_color_end_virus
    pick_yellow_virus:
        lw $v0, YELLOW_VIRUS
        j pick_color_end_virus
    pick_blue_virus:
        lw $v0, BLUE_VIRUS
        j pick_color_end_virus
    pick_color_end_virus:
    jr $ra

draw_line_horizontal:
    # $a0 = X coordinate of start of line
    # $a1 = Y coordinate of start of line
    # $a2 = rgb colour to draw
    # $a3 = length of line
    add $t9, $zero, $zero               # initialize the loop variable $t9 to zero
    horizontal_line_start:
        beq $t9, $a3, horizontal_line_end

        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $a0, 0($sp)                  # Store $a0 on the stack for safe keeping.
        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $a1, 0($sp)                  # Store $a1 on the stack for safe keeping.
        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $ra, 0($sp)                  # Store $ra on the stack for safe keeping.
        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $a3, 0($sp)                  # Store $a3 on the stack for safe keeping.
        
        jal draw_pixel

        lw $a3, 0($sp)                  # Restore $a3 from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        lw $ra, 0($sp)                  # Restore $ra from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        lw $a1, 0($sp)                  # Restore $a1 from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        lw $a0, 0($sp)                  # Restore $a0 from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        
        addi $t9, $t9, 1     # increment loop var
        addi $a0, $a0, 1     # move over 1
        j horizontal_line_start
    horizontal_line_end:
        li $t9, 0
        jr $ra

draw_line_vertical:
    # $a0 = X coordinate of start of line
    # $a1 = Y coordinate of start of line
    # $a2 = rgb colour to draw
    # $a3 = length of line
    add $t9, $zero, $zero               # initialize the loop variable $t9 to zero
    vertical_line_start:
        beq $t9, $a3, vertical_line_end

        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $a0, 0($sp)                  # Store $a0 on the stack for safe keeping.
        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $a1, 0($sp)                  # Store $a1 on the stack for safe keeping.
        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $ra, 0($sp)                  # Store $ra on the stack for safe keeping.
        addi $sp, $sp, -4               # Move the stack pointer to an empty location
        sw $a3, 0($sp)                  # Store $a3 on the stack for safe keeping.
        
        jal draw_pixel

        lw $a3, 0($sp)                  # Restore $a3 from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        lw $ra, 0($sp)                  # Restore $ra from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        lw $a1, 0($sp)                  # Restore $a1 from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        lw $a0, 0($sp)                  # Restore $a0 from the stack.
        addi $sp, $sp, 4                # move the stack pointer to the current top of the stack.
        
        addi $t9, $t9, 1     # increment loop var
        addi $a1, $a1, 1     # move down 1
        j vertical_line_start
    vertical_line_end:
        li $t9, 0
        jr $ra

draw_pixel:
    push($ra)
    # $a0 = X coordinate of pixel
    # $a1 = Y coordinate of pixel
    # $a2 = rgb colour to draw
    # draw a pixel with the color $a2 at position ($a0, $a1)
    lw $t0, ADDR_DSPL           # base address of display
    sll $a1, $a1, 8             # calculate the vertical offset 
    add $t7, $t0, $a1           # add the vertical offset to base address
    sll $a0, $a0, 2             # calculate the horizontal offset 
    add $t7, $t7, $a0           # add the horizontal offset to $t7
    sw $a2, 0( $t7 )            # paint the current bitmap location.
    pop($ra)
    jr $ra

