/******************************************************************************
* file: part2.s
* author: Arunpreetham.
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/
/*
 * A simple bruteforce string search algorith is used inorder to find the 
 * smallest string from the larget. i.e from string we search for substr.
 *
 * data is stored in STRING and SUBSTR as pointers of string1 and string 2 respectively. 
 * End of string is marked by NUL char - (\0)
 * PRESENT variable shows the position of the substr in string if present. 
 * it will be 0 if it is not present. 
 */
  @ BSS section
      .bss

  @ DATA SECTION
      .data

@input stings
string1: .word 0x43, 0x53, 0x36, 0x36, 0x32, 0x30, '\0'
string2: .word 0x36, 0x36, '\0'

STRING:  .word string1
SUBSTR:  .word string2 

@Output variables:
PRESENT: .word 0x0 
  
@ TEXT section
    .text

.globl _main

_main:
    LDR r2, =STRING @address of "STRING" variable
    LDR r2, [r2] @get it from pointer 

    LDR r3, =SUBSTR @ Get the address of SUB STRING
    LDR r3, [r3]  @get it from pointer

    MOV r7, #0 @NULL Char - \0

    @Consider r8 is a temporary variable

    @Block to find the length of STRING
    MOV r5, #0 @length of STRING
    loop1: @loop till we reach nul char
    LDR r8, [r2]
    CMP r8, r7 @compare against nul
    BEQ next1
    ADD r2,r2,#4 @fetch the next char
    ADD r5, r5, #1 @add one to the strlen
    B loop1

    next1:
    @Block to find the length of SUBSTR
    MOV r6, #0 @length of SUBSTR
    loop2:@loop till we reach nul char
    LDR r8, [r3]
    CMP r8, r7@compare against nul
    BEQ next2
    ADD r3,r3,#4@fetch the next char
    ADD r6, r6, #1 @add one to the strlen
    B loop2

    next2:
    @ block to search for the substr in string.

    SUB r8, r5, r6 @ R8 has the difference of the strlens
    @r5 is not valid for length of string anymore. it will store a constant 0x4
    MOV r5, #4

    MOV r9, #0 @i = 0 , index variable for outer loop, This will run till the string has len(substr) char which is the minimum.
    outer_loop:
    @{
        MOV r1, #0 @j = 0 @index variable for inner loop, It will check for the length of the substr from the current position of string
        @{
        inner_loop:

            @fetch the string char of index i + j
            ADD r4, r9, r1 @i + j
            MUL r7, r4, r5
            MOV r4, r7

            LDR r3, =STRING @ Get the address of STRING
            LDR r3, [r3]
            ADD r3, r3, r4
            LDR r3, [r3]

            @fetch the SUBSTR char of index j
            MUL r7, r1, r5
            MOV r4, r7
            LDR r2, =SUBSTR @address of "SUBSTR" variable
            LDR r2, [r2] @get 
            ADD r2, r2, r4
            LDR r2, [r2]

            ADD r1, r1, #1 @j  increment the index of j 

            CMP r3,r2 @ compare the strings see if they are equal.
            BNE inner_loop_exit @if they are not equal then get the next char from string and search for substr
            CMP r1, r6 @j < substrlen
                BEQ inner_loop_exit

            B inner_loop
        @} 

        inner_loop_exit: @ we will reach here if there is a match or a missmatch
        CMP r1, r6
        BEQ compare_the_last_cmd @we compare if the last char was a match and then branch as success orelse increment string and search again.
        B next3
        compare_the_last_cmd:
        CMP r3,r2
        BEQ match_found

        next3:
        ADD r9,r9,#1
        CMP r9, r8
            BGT end
        B outer_loop

    @}
    match_found: @ match is found so udpate the present variable
        LDR r4, =PRESENT @ Present variable
        ADD r9, r9, #1 @array index is 0 based so add 1 and then update for readability.
        STR r9, [r4]

    end: