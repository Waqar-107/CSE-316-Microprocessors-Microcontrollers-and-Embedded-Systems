;FROM DUST I HAVE COME, DUST I WILL BE

.MODEL SMALL
    
.DATA  
    MSG1 DB 'Enter Input Array: $' 
    MSG2 DB 'Sorted Array: $'
    CNT DW 260 DUP(0) 
    F DB 0
    TEMP DW ?
.CODE  
 
READ PROC
    ;SAVE REGISTERS
    ;THE NUMBER WILL BE IN AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;BX HOLDS TOTAL
    XOR BX,BX
    XOR AX,AX
    
    REPEAT:
        ;READ A CHAR
        MOV AH,1
        INT 21H
        
        CMP AL,20H  ;IF SPACE THEN DONE
        JE RESTORE
        CMP AL,78H  ;IF X  
        JE FLAG_CHANGE  
        
        ;UPDATE TOTAL=TOTAL*10+DIGIT
        AND AX,000FH       ;CONVERT AX INTO CHAR->DIGIT
        MOV CX,AX
        
        MOV AX,10
        MUL BX
        
        MOV BX,AX           ;THE PRODUCT IS SAVED IN AX
        ADD BX,CX
        JMP REPEAT
        
    FLAG_CHANGE:
        MOV CL,1
        MOV F,CL
    RESTORE:   
    
        MOV AX,BX 
        ;RESTORE REGISTERS
        POP BX
        POP CX
        POP DX
RET
READ ENDP 


DISPLAY PROC
    PUSH AX             ;SAVE REGISTERS
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;THEN 
    ;PUSH CAUSE AX WILL GET LOST
    ;WHILE MOV AH,2 INSTRUCTION   
    
    XOR CX,CX           ;CX COUNTS DIGITS
    MOV BX,10D          ;BX=10 IN DECIMAL 
        
    REPEAT_ON:
        XOR DX,DX       ;PREPARE HIGH WORD OF DIVINENED
        DIV BX          ;AX=AX/BX,DX=AX%BX
        PUSH DX         ;SAVE DX ON STACK
        INC CX          ;CNT++
        
        ;UNTIL
        OR AX,AX        ;AX==0?
        JNE REPEAT_ON   ;NO KEEP GOING
        
    ;DONE
    MOV AH,2
    PRINT_ON:
        POP DX      ;DIGIT IN DL
        ADD DL,'0'
        INT 21H
        LOOP PRINT_ON
    
    ;RESTORE THE REGISTERS
    POP AX
    POP BX
    POP CX
    POP DX

RET       
DISPLAY ENDP

MAIN PROC
    
    ;INIT
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H
    
    CALL READ
    CALL DISPLAY

   
    
    
MAIN ENDP

END MAIN