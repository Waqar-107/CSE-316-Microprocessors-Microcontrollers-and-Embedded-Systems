.MODEL SMALL
    
.DATA
     
.CODE

MAIN PROC
            
    ;A
    MOV AH,1
    INT 21H  
    MOV BL,AL 
       
    ;A NEWLINE
    MOV AH,2
    MOV DL,0DH
    INT 21h
    MOV DL,0AH
    INT 21h  
      
    ;B
    MOV AH,1
    INT 21H  
    MOV CL,AL 
    
    ;subtraction, BL=BL-CL
    SUB BL,CL 
     
    ;ANOTHER NEWLINE
    MOV AH,2 
    MOV DL,0DH
    INT 21h
    MOV DL,0AH
    INT 21h  
    
    ADD BL,48
    MOV DL,BL
    INT 21H
    
MAIN ENDP

END MAIN