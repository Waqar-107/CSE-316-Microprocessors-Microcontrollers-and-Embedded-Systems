.MODEL SMALL

.DATA
    
.CODE

MAIN PROC
    
    ;UNO
    MOV AH,1
    INT 21H
    MOV CL,AL
            
    ;SPACE
    MOV AH,2
    MOV DL,20H
    INT 21H        
            
    ;DOS
    MOV AH,1
    INT 21H
    ADD CL,AL      
    
    ;SPACE
    MOV AH,2
    MOV DL,20H
    INT 21H   
    
    ;tres
    MOV AH,1
    INT 21H
    ADD CL,AL
    
MAIN ENDP

END MAIN