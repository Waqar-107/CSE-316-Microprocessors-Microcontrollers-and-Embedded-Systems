.MODEL SMALL
.STACK 100H

.CODE

MAIN PROC
    
    ;INPUT
    MOV AH,1
    INT 21H
    MOV BL,AL
    SUB BL,48
    
    ;NL
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    LOOP:
        MOV CX,0
        MOV CL,BL
        MOV DL,'*'
        
        TOP:
        INT 21H
        LOOP TOP
    
MAIN ENDP
    
    
END MAIN