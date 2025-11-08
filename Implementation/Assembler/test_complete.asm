START:
    LOAD X, 100
    LOAD Y, 200
    STORE X, 50
    STORE Y, 75

ARITH_TEST:
    ADD X, 10
    ADD Y, 20
    SUB X, 5
    SUB Y, 3
    MUL X, 4
    MUL Y, 2
    DIV X, 8
    DIV Y, 4
    MOD X, 7
    MOD Y, 3

SHIFT_TEST:
    LSR X, 1
    LSR Y, 2
    LSL X, 3
    LSL Y, 4
    RSR X, 1
    RSR Y, 2
    RSL X, 1
    RSL Y, 3

LOGIC_TEST:
    AND X, 255
    AND Y, 15
    OR X, 128
    OR Y, 64
    XOR X, 170
    XOR Y, 85
    NOT X, 0
    NOT Y, 0

MISC_TEST:
    MOV X, 42
    MOV Y, 99
    CMP X, 42
    CMP Y, 100
    TST X, 1
    TST Y, 128
    INC X, 0
    INC Y, 0
    DEC X, 0
    DEC Y, 0

    BRA COND_TEST

; this should raise an exception
; SKIP_SECTION:
;    MOV X, 999
;    MOV Y, 999

COND_TEST:
    MOV X, 0
    CMP X, 0
    BRZ ZERO_BRANCH
    MOV Y, 111

ZERO_BRANCH:
    MOV X, -5
    CMP X, 0
    BRN NEG_BRANCH
    MOV Y, 222

NEG_BRANCH:
    ADD X, 500
    BRC CARRY_BRANCH
    MOV Y, 5

CARRY_BRANCH:
    ADD X, 256
    BRO OVERFLOW_BRANCH
    MOV Y, 10

OVERFLOW_BRANCH:
    JMP MY_PROC
    MOV X, 77
    BRA END_TEST

MY_PROC:
    MOV Y, 55
    ADD Y, 10
    RET

EDGE_CASES:
    MOV X, 511
    ADD X, 511
    MOV Y, -1
    MOV X, -256
    ADD Y, -10
    SUB X, -5
    LOAD X, 0
    LOAD Y, 1
    STORE X, 2
    STORE Y, 3
    BRA FORWARD_LABEL
    MOV X, 123

FORWARD_LABEL:
    MOV Y, 321

END_TEST:
    MOV X, 255
    MOV Y, 255
    BRA END_TEST