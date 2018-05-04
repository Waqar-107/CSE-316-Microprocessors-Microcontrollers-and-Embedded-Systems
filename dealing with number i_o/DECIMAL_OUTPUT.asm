.MODEL SMALL
    
.DATA
     
.CODE

OUTPUT_NUMBER PROC
    PUSH AX         ;SAVE REGISTERS
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;IF AX<0
    OR AX,AX        ;AX<0?
    JGE END_IF_ON   ;NO,>=0
    
    ;THEN 
    ;PUSH CAUSE AX WILL GET LOST
    ;WHILE MOV AH,2 INSTRUCTION
    PUSH AX
    
    MOV DL,'-'
    MOV AH,2
    INT 21H         ;AX=-AX
                    
    POP AX
    NEG AX
    
    END_IF_ON:
        XOR CX,CX   ;CX COUNTS DIGITS
        MOV BX,10D  ;BX=10 IN DECIMAL 
        
    REPEAT_ON:
        XOR DX,DX   ;PREPARE HIGH WORD OF DIVINENED
        DIV BX      ;AX=AX/BX,DX=AX%BX
        PUSH DX     ;SAVE DX ON STACK
        INC CX      ;CNT++
        
        ;UNTIL
        OR AX,AX      ;AX==0?
        JNE REPEAT_ON ;NO KEEP GOING
        
    ;DONE
    MOV AH,2
    PRINT_ON:
        POP DX      ;DIGIT IN DL
        ADD DL,'0'
        INT 21H
        LOOP PRINT_LOOP 
    
    ;RESTORE THE REGISTERS
    POP AX
    POP BX
    POP CX
    POP DX

RET       
OUTPUT_NUMBER ENDP

MAIN PROC
    
    
    
    
    ;newline
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H  
    
    
MAIN ENDP

END MAIN