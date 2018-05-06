.MODEL SMALL
    
.DATA
    WELCOME_MESSAGE DB 'Welcome to Calculator v 1.0.',0AH,0DH,'Press a to add, s to subtract and m to multiply.',0AH,0DH,'$'
    OPTIONS DB 'Operation: $'
    NEWLINE DB 0AH,0DH,'$' 
    DBG DB 'IN',0AH,0DH,'$' 
    
    ANS_HIGH_BIT DW 0
    ANS_LOW_BIT DW 0
    
    MUL_HIGH_BIT DW 0
    MUL_LOW_BIT DW 0
    
.CODE

ADDITION PROC
    ;LET BX:AX HIGH:LOW BITS
    ;    DX:CX WILL BE ADDED WITH BX,AX 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ADD BX,DX
    ADD AX,CX
    JC ADD_CARRY
    JMP DONT_ADD_CARRY
    
    ADD_CARRY:
        ADD BX,1
    
    DONT_ADD_CARRY:
        MOV ANS_HIGH_BIT,BX
        MOV ANS_LOW_BIT, AX
        
        POP DX
        POP CX
        POP BX
        POP AX    
RET    
ADDITION ENDP 


SUBTRACTION PROC
    
RET    
SUBTRACTION ENDP 
   
   
MULTIPLICATION PROC
     
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
    
    
    
    
   
    EXIT:
        MOV AH,4CH
        INT 21H
    
MAIN ENDP

END MAIN 
