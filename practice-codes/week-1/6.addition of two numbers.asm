.MODEL SMALL

.DATA
    
.CODE

MAIN PROC
    
    ;UNO
    MOV AH,1
    INT 21H
    MOV BH,AL
            
    ;SPACE
    MOV AH,2
    MOV DL,20H
    INT 21H        
            
    ;DOS
    MOV AH,1
    INT 21H
    MOV BL,AL
    
    ;NEWLINE
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H 
    
    ADD BH,BL
    SUB BH,48
    MOV DL,BH
    INT 21H

    
MAIN ENDP

END MAIN