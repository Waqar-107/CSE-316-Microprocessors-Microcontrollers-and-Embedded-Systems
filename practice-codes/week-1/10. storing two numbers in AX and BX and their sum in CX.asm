.MODEL SMALL

.DATA
      
.CODE

MAIN PROC 
     
     ;store two numbers and add
     MOV AX,9
     MOV BX,7
     ADD AX,BX  
     
     ;ascii- adjust after addition
     AAA  
       
     ;move to cx
     MOV CX,AX
     
     
     ADD CH,30H
     ADD CL,30H
     
     MOV AH,2
     MOV DL,CH
     INT 21H
     
     MOV DL,CL
     INT 21H 
        
     MOV AH,4CH
     INT 21h
                     
                
MAIN ENDP

END MAIN
