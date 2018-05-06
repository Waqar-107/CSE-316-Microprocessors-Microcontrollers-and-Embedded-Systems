.MODEL SMALL
    
.DATA
    WELCOME_MESSAGE DB 'Welcome to Calculator v 1.0.',0AH,0DH,'Press a to add, s to subtract and m to multiply.',0AH,0DH,'$'
    OPTIONS DB 'Operation: $'
    NEWLINE DB 0AH,0DH,'$' 
    DBG DB 'IN',0AH,0DH,'$' 
    
    ANS_HIGH_BIT DW 0
    ANS_LOW_BIT DW 0
    
    MUL_HIGH_BIT DW 0
    MUL_LOW_BIT DW 0
    
    INPUT_A_HIGH_BIT DW 0
    INPUT_A_LOW_BIT DW 0
    INPUT_B_HIGH_BIT DW 0
    INPUT_B_LOW_BIT DW 0
    
    FLAG DW ?
    
.CODE

;-------------------------------------------------------------------------
ADDITION PROC
    ;LET BX:AX HIGH:LOW BITS
    ;    DX:CX WILL BE ADDED WITH BX,AX 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ADD BX,DX
    ADD AX,CX
    JC ADD_CARRY
    JMP DONT_ADD_CARRY
    
    ADD_CARRY:
        ADD BX,1
    
    DONT_ADD_CARRY:
        MOV ANS_HIGH_BIT,BX
        MOV ANS_LOW_BIT, AX
        
        POP DX
        POP CX
        POP BX
        POP AX    
RET    
ADDITION ENDP 
;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
SUBTRACTION PROC
   ; a-b= a+(2's compliment of b)
   PUSH AX
   PUSH BX
   PUSH CX
   PUSH DX
   
   MOV AX,INPUT_A_LOW_BIT
   MOV BX,INPUT_A_HIGH_BIT
   MOV CX,INPUT_B_LOW_BIT
   MOV DX,INPUT_B_HIGH_BIT
   
   ;1'S COMPLIMENT OF B
   NEG DX
   NEG CX
   
   CMP CX,0
   JE ADD_CARRY_SUB
   JMP DONT_ADD_CARRY_SUB
   
   ADD_CARRY_SUB:
        ADD DX,1
   
   DONT_ADD_CARRY_SUB:
   ;NEGATION DONE
   ;NOW THE VALUES ARE ALREADY SET IN THE REGISTER
   CALL ADDITION
   
   POP DX
   POP CX
   POP BX
   POP AX     
RET    
SUBTRACTION ENDP 
;-------------------------------------------------------------------------   
 

;-------------------------------------------------------------------------   
MULTIPLICATION PROC   
    
  PUSH AX
  PUSH BX
  PUSH CX
  PUSH DX 
  
  ;A*B IF LSB(B)=1, MULT HAS THE TOTAL, MULT=MULT+A
  ;FOR BOTH 0 AND 1 LSB, RIGHT SHIFT B, LEFT SHIFT A
  
  ;MUL_HIGH_BIT AND MUL_LOW_BIT HAS THE TOTAL
  ;MOVE THEM TO BX:AX IN EACH ITERATION
  ;MOV INPUT A IN DX:CX
  
  MOV AX,0              ;TOTAL=0
  MOV MUL_HIGH_BIT,AX
  MOV MUL_LOW_BIT,AX 
  
  WHILE_MULT: 
  
      ;CHECK IF HIGH AND LOW BITS OF B ARE 0, OR THEM TO CHECK
      MOV AX,INPUT_B_LOW_BIT
      OR AX,AX
      JNZ CALC_MUL
      
      MOV AX,INPUT_B_HIGH_BIT
      OR AX,AX
      JZ RESTORE_MULT           ;HIGH IS 0, AND AS LOW=0, IT MADE IT TO THIS INSTRUCTION
      
      
      CALC_MUL:
      ;CHECK LSB OF B HERE AND SHIFT
      MOV AX,INPUT_B_LOW_BIT
      MOV BX,INPUT_B_HIGH_BIT
      
      ;SHIFHT HIGH, NOW CF HAS THE LAST BIT OF HIGH
      SHR BX,1
      RCR AX,1                  ;B HAS SHIFTED RIGHT, CF HAS THE LSB NOW, CHECK
      
      ;SAVE B
      MOV INPUT_B_LOW_BIT,AX
      MOV INPUT_B_HIGH_BIT,BX 
      
      ;COMPARE CF
      ;JUMP CARRY, IF CARRY=1, TOTAL+=A; MULT+=A
      JC UPDATE_TOTAL
      JMP SHIFT_BIT_A
      
      ;CALCULATE
      UPDATE_TOTAL:
        MOV BX,MUL_HIGH_BIT
        MOV AX,MUL_LOW_BIT
               
        MOV DX,INPUT_A_HIGH_BIT
        MOV CX,INPUT_A_LOW_BIT
      
        CALL ADDITION
        
        ;NOW ANS HAS THE SUM, MOV IT TO MULT
        MOV AX,ANS_HIGH_BIT
        MOV MUL_HIGH_BIT,AX
        
        MOV AX,ANS_LOW_BIT
        MOV MUL_LOW_BIT,AX
        
      SHIFT_BIT_A:
        
        ;NOW MUL HAS THE TOTAL, SO WE CAN LEFT SHIFT A
        MOV CX,INPUT_A_LOW_BIT
        MOV DX,INPUT_A_HIGH_BIT
        
        SHL CX,1
        RCL DX,1
        
        MOV INPUT_A_LOW_BIT,CX
        MOV INPUT_A_HIGH_BIT,DX
        
        JMP WHILE_MULT
               
  RESTORE_MULT:
      POP DX
      POP CX
      POP BX
      POP AX   
RET    
MULTIPLICATION ENDP
;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
DIVISON PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    RESTORE_DIV:
    POP DX
    POP CX
    POP BX
    POP AX
DIVISON ENDP
;-------------------------------------------------------------------------

MAIN PROC
              
    ;INITIALIZE DATA SEGMENT
    MOV AX,@DATA
    MOV DS,AX
    
    ;SHOW WELCOME MESSAGE
    LEA DX,WELCOME_MESSAGE
    MOV AH,9
    INT 21H 
    
    
    
    MOV INPUT_A_HIGH_BIT,0H
    MOV INPUT_A_LOW_BIT,3H
    MOV INPUT_B_HIGH_BIT,0H
    MOV INPUT_B_LOW_BIT,5EH
    
    CALL SUBTRACTION
   
    EXIT:
        MOV AH,4CH
        INT 21H
    
MAIN ENDP

END MAIN 
