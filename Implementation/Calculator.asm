; adrese:
; A: 100
; B: 101
; CMD: 102
; RES: 103

start:
    LOAD X, 102 ; CMD
    CMP X, 0
    BRZ do_add
    
    CMP X, 1
    BRZ do_sub
    
    CMP X, 2
    BRZ do_mul
    
    CMP X, 3
    BRZ do_div

    CMP X, 4
    BRZ do_mod
    
    JMP start 

do_add:
    LOAD X, 100 ; A
    ADD  X, 101 ; B
    STORE X, 103
    JMP done

do_sub:
    LOAD X, 100
    SUB  X, 101
    STORE X, 103
    JMP done

do_mul:
    LOAD X, 100
    MUL  X, 101
    STORE X, 103
    JMP done

do_div:
    LOAD X, 100
    DIV  X, 101
    STORE X, 103
    JMP done

do_mod:
    LOAD X, 100
    MOD  X, 101
    STORE X, 103
    JMP done

done:
    RET
