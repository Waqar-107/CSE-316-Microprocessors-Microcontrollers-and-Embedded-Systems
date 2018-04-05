.MODEL SMALL

.DATA
    
.CODE

MAIN PROC
    
    ;A       
    MOV AH,1
    INT 21H
    MOV BH,AL    
    
    ;SPACE
    MOV AH,2
    MOV DL,20H
    INT 21H        
       
    ;B
    MOV AH,1     
    INT 21H
    MOV BL,AL
    
    ;OPERATIONS TO SWAP
    SUB BH,BL
    ADD BL,BH  
    
    MOV CL,BL
    SUB CL,BH
    MOV BH,CL
    
    ;NEWLINE
    MOV AH,2
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
      
    ;OUTPUT
    MOV AH,2 
  
    MOV DL,BH
    INT 21H  
    
    MOV DL,20H
    INT 21H   
    
    MOV DL,BL
    INT 21H

    
MAIN ENDP

END MAIN