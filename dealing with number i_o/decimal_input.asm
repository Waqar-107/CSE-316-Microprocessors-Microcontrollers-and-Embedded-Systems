;READS A NUMBER IN RANGE -32768 TO 32767

.MODEL SMALL
    
.DATA
    
     
.CODE

;AX=BINARY EQU. OF NUMBER 
READ_NUMBER PROC
    PUSH BX         ;SAVE REGISTERS USED
    PUSH CX
    PUSH DX
    
    ;PRINT PROMT
    @BEGIN:
    MOV AH,2
    MOV DL,'?'
    INT 21H         ;PRINTS '?'
    
    ;TOTAL=0
    XOR BX,BX       ;BX HOLDS TOTAL
    
    ;NEGATIVE=FALSE
    XOR CX,CX       ;CX HOLDS SIGN
    
    ;READ A CHAR
    MOV AH,1
    INT 21H         ;CHAR IN AL
    
    ;CHECK SIGN
    CMP AL,'-'      ;YES, SET SIGN
    JE @MINUS
    CMP AL,'+'      ;PLUS SIGN
    JE @PLUS        ;YES GET ANOTHER CHAR
    JMP @REPEAT2    ;START PROCESSING CHARS
    
    @MINUS:
        MOV CX,1        ;NEGATIVE=TRUE
    
    @PLUS:
        INT 21H         ;READ A CHAR
    
    ;END CASE
    @REPEAT2:
        CMP AL,'0'
        JNGE @NOT_DIGIT
        CMP AL,'9'
        JNLE @NOT_DIGIT
        
        ;CONVERT CHAR TO DIGIT
        AND AX,000FH
        PUSH AX         ;SAVE IN STACK
        
        ;TOTAL=TOTAL*10+DIGIT
        MOV AX,10
        MUL BX          ;AX=TOTAL*10
        POP BX          ;RETRIEVE DIGIT
        ADD BX,AX       ;TOTAL=TOTAL*10+DIGIT
        
        ;READ A CHAR
        MOV AH,1
        INT 21H
        CMP AL,0DH
        JNE @REPEAT2    ;IF NOT CARRIAGE THEN CONTINUE
        
        ;UNTIL CR
        MOV AX,BX       ;STORE NUMBER IN AX
        
        ;IF NEGATIVE
        OR CX,CX        ;NEG
        
        JE @EXIT        ;NO,EXIT
        
        ;THEN
        NEG AX
        
        ;END IF
        @EXIT:
            POP DX
            POP CX
            POP BX
            RET
        @NOT_DIGIT:
            MOV AH,2    ;MOVE CURSOR TO NEWLINE
            MOV DL,0AH
            INT 21H
            MOV DL,0DH
            INT 21H
            JMP @BEGIN  ;GO TO BEGGINING
READ_NUMBER ENDP

MAIN PROC
    
    CALL READ_NUMBER
    ;newline
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H  
    
    
MAIN ENDP

END MAIN