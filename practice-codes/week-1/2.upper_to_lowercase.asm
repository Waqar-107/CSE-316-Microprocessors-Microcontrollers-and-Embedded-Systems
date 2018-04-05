.MODEL SMALL

.DATA
        
.CODE

MAIN PROC
        
   ;input
   MOV AH,1
   INT 21H
   MOV BL,AL
   
   ;newine
   MOV AH,2
   MOV DL,0AH
   INT 21H
   MOV DL,0DH
   INT 21H
    
   ;add and output
   ADD BL,32
   MOV DL,BL
   INT 21H
    
    
MAIN ENDP

END MAIN