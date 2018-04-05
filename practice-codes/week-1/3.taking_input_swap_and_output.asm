.MODEL SMALL

.DATA
    MSG1 DB 'Enter 1st Number: $' 
    MSG2 DB 'Enter 2nd Number: $'
    MSG3 DB 'You have entered: $'
    MSG4 DB 'After swapping: $'
.CODE

MAIN PROC
           
    ;1ST
    MOV AX,@DATA
    MOV DS,AX
           
    LEA DX,MSG1
    MOV AH,9
    INT 21H 
    
    MOV AH,1
    INT 21H
    MOV CH,AL
        
    ;NEWLINE
    MOV AH,2   
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    

    ;2ND   
    
    MOV AX,@DATA
    MOV DS,AX
    
    LEA DX,MSG2
    MOV AH,9
    INT 21H
    
    MOV AH,1
    INT 21H
    MOV CL,AL 
    
    ;NEWLINE
    MOV AH,2   
    MOV DL,0AH
    INT 21H    
    MOV DL,0DH
    INT 21H  
               
    ;DISPLAY
    MOV AX,@DATA
    MOV DS,AX
    
    LEA DX,MSG3
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DL,CH
    INT 21H  
    MOV DL,20H ;20H FOR A SPACE
    INT 21H
    MOV DL,CL
    INT 21H
    
    ;NEWLINE
    MOV AH,2   
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H 
    
    ;SWAP
    XCHG CH,CL 
    
    MOV AX,@DATA
    MOV DS,AX
    
    LEA DX,MSG4
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DL,CH
    INT 21H     
    MOV DL,20H ;20H FOR A SPACE
    INT 21H
    MOV DL,CL
    INT 21H
    
MAIN ENDP

END MAIN