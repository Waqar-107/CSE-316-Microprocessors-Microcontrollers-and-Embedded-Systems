.MODEL SMALL
.STACK 100H

.CODE

MAIN PROC
     
    MOV AH,1
    INT 21H
    MOV BL,AL
    SUB AL,48
    
    MOV CX,0
    MOV CL,AL
    
    TOP:
    MOV AH,2
    MOV DL,BL
    INT 21H
    DEC BL
    LOOP TOP 
     
    EXIT:
    MOV AH,4CH
    INT 21H
    
MAIN ENDP
END MAIN