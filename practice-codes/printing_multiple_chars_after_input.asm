.MODEL SMALL

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
    INT 21H
    
    MOV CH,AL
    INT 21H 
      
    ;OUTPUT   
    ;NEWLINE  
    MOV AH,2    
    
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    
    MOV DL,BL
    INT 21H  
    
    MOV DL,BH 
    INT 21H  
    
    MOV DL,CL 
    INT 21H  
    
    MOV DL,CH 
    INT 21H  
    
MAIN ENDP

END MAIN