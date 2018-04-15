.MODEL SMALL

.CODE

MAIN PROC
    
    MOV CX,4 ;ROW
    MOV BX,2 ;COLUMN,FORMS A NESTED LOOP
    
    TOP:
    MOV AH,2
    MOV DL,'*'
    INT 21H
    DEC BX
    
    CMP BX,0
    JE EXIT
    
    JMP TOP
    
    EXIT:
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    MOV BX,2
    LOOP TOP ;CORRESPONDING TO CX
    
    MOV AH,4CH
    INT 21H                  
MAIN ENDP

END MAIN