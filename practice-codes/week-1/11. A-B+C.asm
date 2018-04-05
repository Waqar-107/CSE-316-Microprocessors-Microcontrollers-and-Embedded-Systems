.MODEL SMALL

.DATA
    
.CODE

MAIN PROC
    
    ;a
    MOV AH,1
    INT 21H
    MOV BL,AL
    
    ;SPACE
    MOV AH,2
    MOV DL,20H
    INT 21H
     
    ;b
    MOV AH,1
    INT 21H
    SUB BL,AL
     
    ;SPACE
    MOV AH,2
    MOV DL,20H
    INT 21H
    
    ;c
    MOV AH,1
    INT 21H
    ADD BL,AL
    
    MOV CL,BL
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    MOV DL,CL
    INT 21H
    
MAIN ENDP

END MAIN