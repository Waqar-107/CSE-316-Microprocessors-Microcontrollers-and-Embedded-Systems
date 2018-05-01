.MODEL SMALL
    
.DATA
    
     
.CODE

MAIN PROC
    

    ;newline
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H  
    
    
MAIN ENDP

END MAIN