/******************************************************************************
* file: part1.s
* author: Arunpreetham.
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/
/*
 * Implemented a ASCII string comparision in assembly language
 * START1 and START2 are input strings which are to be compared and 
 * GREATER is the output variable where we store the result 
 * START1 >= START2 the greater is 0x0 and viceversa  */
  @ BSS section
      .bss

  @ DATA SECTION
      .data
@Strings are expected to be of same length
LENGTH: .word 0x3

@Input strings START 1 and START 2, both of same length LENGTH.
string1: .word 0x43, 0x41, 0x54
string2: .word 0x43, 0x55, 0x54
START1:  .word string1
START2:  .word string2 


@Output variables:
GREATER: .word 0xFFFFFFFF 
            
/* 
Output: 
*/
  @ TEXT section
      .text

.globl _main


_main:
    LDR r2, =LENGTH @address of "length" variable
    LDR r2, [r2] @get the length 
    LDR r3, =START1 @ Get the address of string1
    LDR r3, [r3]

    LDR r4, =START2 @ Get the address of string2
    LDR r4, [r4]
    MOV r5, #0 @count variable for the loop

    loop: @loop for all the elements of the array

    LDR r6, [r3] @string 1 
    LDR r7, [r4] @string 2

    CMP r6, r7
    BEQ equal @compare and proceed if they are equal
    B not_equal @ if they are unequal then branch and see which is greater.

    equal:
    ADD r5, r5, #1

    CMP r5, r2
    BEQ same_str
    
    ADD r3, r3, #4 @fetch the next chars
    ADD r4, r4, #4 @fetch the next chars
    B loop

    not_equal: @Strings are unequal
        CMP r6, r7 @start1 < start2 so no change.
        BLT end
    same_str: @start1 >= start2 so update
        LDR r8, =GREATER @storage for the maximum weight.
        MOV r5, #0
        STR r5, [r8]
    end: