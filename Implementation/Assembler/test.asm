; 10 + 15 = 25

START:
    MOV X, 10       ; X = 10
    ADD X, 15       ; X = X + 15
    
    ; check if result is 25
    CMP X, 25
    BRZ SUCCESS
    
ERROR:
    MOV Y, -1       ; Y = 0b111111111 (error)
    BRA STOP
    
SUCCESS:
    MOV Y, 1        ; Y = 1 (success)
    
STOP:
    BRA STOP