.MODEL SMALL

.CODE

MAIN PROC
    
    MOV AH,2    ;DISPLAY CHAR FUNCTION
    MOV DL,'?'  ;CHAR IS '?'
    INT 21h     ;DISPLAY CHAR                       
    
MAIN ENDP

END MAIN