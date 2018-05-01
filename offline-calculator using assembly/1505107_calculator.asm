.MODEL SMALL
    
.DATA
    WELCOME_MESSAGE DB 'Welcome to Calculator v 1.0.',0AH,0DH,'Press a to add, s to subtract and m to multiply.',0AH,0DH,'$'
    OPTIONS DB 'Operation: $'
    NEWLINE DB 0AH,0DH,'$' 
    DBG DB 'IN',0AH,0DH,'$'
.CODE

ADDITION PROC
    MOV AH,2
    MOV DL,'A'
    INT 21H
RET    
ADDITION ENDP 


SUBTRACTION PROC
    MOV AH,2
    MOV DL,'S'
    INT 21H
RET    
SUBTRACTION ENDP 
   
   
MULTIPLICATION PROC
    MOV AH,2
    MOV DL,'M'
    INT 21H  
RET    
MULTIPLICATION ENDP

MAIN PROC
              
    ;INITIALIZE DATA SEGMENT
    MOV AX,@DATA
    MOV DS,AX
    
    ;SHOW WELCOME MESSAGE
    LEA DX,WELCOME_MESSAGE
    MOV AH,9
    INT 21H
    
    WHILE:      
        
        LEA DX,OPTIONS
        MOV AH,9
        INT 21H
    
        MOV AH,1
        INT 21H 
        MOV BL,AL
        
        ;NEWLINE
        MOV AH,9
        LEA DX,NEWLINE
        INT 21H
        
        ;END WHILE LOOP
        CMP BL,'X'
        JE EXIT
        
        ;CHECK
        CMP BL,'a'
        JE ADD_
        CMP BL,'s'
        JE SUB_
        CMP BL,'m'
        JE MUL_ 
        
        
        ;IF ANYTHING OTHER THAN 'X','a','s' OR 'm' GIVEN
        JMP WHILE
        
        ADD_:
            ;CALL ADDITION
            CALL ADDITION
            JMP WHILE
        SUB_:
            CALL SUBTRACTION
            JMP WHILE
        MUL_:
            CALL MULTIPLICATION
        JMP WHILE
     
    EXIT:
        MOV AH,4CH
        INT 21H
    
MAIN ENDP

END MAIN 
