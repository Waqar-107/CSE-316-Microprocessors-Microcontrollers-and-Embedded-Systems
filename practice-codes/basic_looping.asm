.MODEL SMALL                                 

.STACK 100H    ;RESERVES 100H BYTES FOR STACK

.DATA
    
.CODE

MAIN PROC
       
    REPEAT:
        ;INPUT
        MOV AH,1
        INT 21H
        MOV BL,AL
          
        ;OUTPUT
        MOV AH,2
        MOV DL,20H
        INT 21H
        
        MOV DL,BL
        INT 21H
        
        ;NEWLINE
        MOV AH,2
        MOV DL,0AH
        INT 21H
        MOV DL,0DH
        INT 21H 
        
        CMP BL,'5'
        JE  EXIT
        JMP REPEAT
    EXIT:      
        MOV AH,4CH
        INT 21H
    
MAIN ENDP           

END MAIN