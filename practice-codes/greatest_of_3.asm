.MODEL SMALL
.STACK 100H

.DATA
 
.CODE

MAIN PROC
    
    ;INPUT
    MOV AH,1
    
    INT 21H
    MOV BL,AL
    
    INT 21H
    MOV BH,AL
    
    INT 21H
    MOV CL,AL
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    CMP BL,BH
    JGE L1       ;IF BL>=BH IT WON'T EXECUTE JMP L2
    JMP L2
          
    ;BL>=BH
    ;CHECK IF BL>=CL
    ;IF YES THEN BL IS THE GREATEST, ELSE CL
    L1:
    CMP BL,CL
    JGE PRINT_BL      
    
    JMP PRINT_CL
    
    ;BH>=BL
    ;CHECK BH>=CL
    ;IF YES THEN BH IS THE GREATEST, ELSE CL
    L2:
    CMP BH,CL   
    JL  PRINT_CL
    JMP PRINT_BH
    
    PRINT_BL: 
    MOV DL,BL
    INT 21H
    JMP EXIT
    
    PRINT_BH:
    MOV DL,BH
    INT 21H
    JMP EXIT
    
    PRINT_CL:   
    MOV DL,CL
    INT 21H
    
    EXIT:
    MOV AH,4CH
    INT 21H
    
MAIN ENDP
END MAIN