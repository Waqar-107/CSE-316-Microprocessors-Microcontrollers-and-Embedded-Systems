.MODEL SMALL
    
.DATA
     
.CODE

MAIN PROC
              
    ;A
    MOV AH,1
    INT 21H
    MOV BL,AL
    
    ;newline
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    ;B    
    MOV AH,1
    INT 21H
    MOV CL,AL
    
    ;newline
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H 
    
    ;ADDITION, BL=BL+CL
    ADD BL,CL 
    
    MOV AH,2
    SUB BL,48
    MOV DL,BL
    INT 21H
    
MAIN ENDP

END MAIN