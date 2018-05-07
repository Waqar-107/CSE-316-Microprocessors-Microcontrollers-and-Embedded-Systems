.MODEL SMALL
    
.DATA
    WELCOME_MESSAGE DB 'Welcome to Calculator v 1.0.',0AH,0DH,'Press a to add, s to subtract and m to multiply.',0AH,0DH,'$'
    OPTIONS DB 'Operation: $'
    NEWLINE DB 0AH,0DH,'$' 
    DBG DB 'IN',0AH,0DH,'$'
    
    PR1 DB 'ENTER FIRST NUMBER: $'
    PR2 DB 'ENTER SECOND NUMBER: $' 
    
    ANS_HIGH_BIT DW 0
    ANS_LOW_BIT DW 0
    
    MUL_HIGH_BIT DW 0
    MUL_LOW_BIT DW 0
    
    INPUT_A_HIGH_BIT DW 0
    INPUT_A_LOW_BIT DW 0
    INPUT_B_HIGH_BIT DW 0
    INPUT_B_LOW_BIT DW 0 
    
    BP_INPUT_A_HIGH_BIT DW 0
    BP_INPUT_A_LOW_BIT DW 0
    BP_INPUT_B_HIGH_BIT DW 0
    BP_INPUT_B_LOW_BIT DW 0
    
    INPUT_T_HIGH_BIT DW 0
    INPUT_T_LOW_BIT DW 0
    
    FLAG DW ?      ;FLAG FOR MINUS
    FLAG2 DW ?
    
    A_MINUS DW 0
    B_MINUS DW 0
    
    A_EXP DW 0
    B_EXP DW 0
    T_EXP DW 0
    
    QUOTIENT_HIGH DW ?
    QUOTIENT_LOW DW ?
    REMAINDER DW ?
    
    OUT_LOW DW 0
    OUT_HIGH DW 0 
    
    COUNT DW 0 
    OPT DB 0
    
    
.CODE

;-------------------------------------------------------------------------
;SET THE 4 REGISTERS AND CALL
;THE ANSWER WILL BE FOUND IN ANS_HIGH_BIT AND ANS_LOW_BIT 
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
;SET INPUT_A/B_HIGH/LOW
;THE ANSWER WILL BE SAVED IN ANS_VARIABLES 
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
   JE DONT_ADD_CARRY_SUB
   JMP ADD_CARRY_SUB
   
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
;SAVE A IN BX:AX, SAVE B IN CX
DIVISON PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;DX:AX=DIVINEND
    ;CX=DIVISOR
    ;DX:AX=QUOTIENT, BX=REM
    
    PUSH AX         ;SAVE LOW WORD
    MOV AX,DX       ;HIGH WORD TO AX
    SUB DX,DX       ;SET DX=0
    DIV CX          ;DIVIDE THE HIGH
    MOV BX,AX       ;BX=QUOTIENT HIGH WORD
    POP AX          ;RETRIEVE LOW 
    DIV CX          ;DIVIDE REMANDER HIGH:DIVINEND LOW
    XCHG BX,DX      ;SWAPS RESULTS INTO PLACE
    
    MOV QUOTIENT_HIGH,DX
    MOV QUOTIENT_LOW,AX
    MOV REMAINDER,BX
    
    RESTORE_DIV:
    POP DX
    POP CX
    POP BX
    POP AX
RET
DIVISON ENDP
;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;CALL INPUT, IT WILL STORE THE NUMBER IN INPUT_T_HIGH,LOW
INPUT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;SAVE THE INPUT IN BACKUP COPIES, COPY THEM TO NORMALS INPUT-(A,B)-(HIGH,LOW)
    ;TO WORK
    ;TOTAL=TOTAL*10, FIRST CHECK FOR MINUS, WHEN THE POINT(.) IS FOUND, START COUNTING
    
    MOV T_EXP,0
    MOV FLAG,0  ;NOT NEGATIVE
    MOV FLAG2,0 ;FLOATING POINT NOT FOUND, WHEN FOUND WE DO INC T_EXP++
    MOV AH,1    ;FOR '-'
    INT 21H
    
    CMP AL,'-'
    JNE NOT_SET_MINUS
    MOV FLAG,1
    
    MOV INPUT_T_LOW_BIT,0
    MOV INPUT_T_HIGH_BIT,0
    JMP WHILE_INPUT
    
    ;IF NOT MINUS, THEN THE FIRST DIGIT IS IN AL 
    NOT_SET_MINUS:    
        SUB AL,'0'
        MOV AH,0;
        
        MOV INPUT_T_LOW_BIT,AX
        MOV INPUT_T_HIGH_BIT,0 
    
    WHILE_INPUT:
        ;KEEP TAKING INPUT TILL WE GET SPACE OR CARRIAGE
        MOV AH,1
        INT 21H
        
        ;TERMINATE IF SPACE,CR OR NEWLINE FOUND
        CMP AL,20H
        JE  RESTORE_INPUT
        CMP AL,0AH
        JE  RESTORE_INPUT
        CMP AL,0DH
        JE  RESTORE_INPUT 
        
        ;IS IT .
        CMP AL,'.'
        JE SET_FLAG_OP
        JMP NORMAL_OP
        
        SET_FLAG_OP:
            MOV FLAG2,1
            JMP WHILE_INPUT
        
        NORMAL_OP:
        SUB AL,'0' 
        
        ;THERE IS A DIGIT FOUND, TAKE IT AND ADD IT WITH TOTAL*10
        
        MOV INPUT_B_LOW_BIT,10
        MOV INPUT_B_HIGH_BIT,0
        MOV BX,INPUT_T_LOW_BIT
        MOV INPUT_A_LOW_BIT,BX
        MOV BX,INPUT_T_HIGH_BIT
        MOV INPUT_A_HIGH_BIT,BX
        
        ;NOW MULTILY
        CALL MULTIPLICATION
        
        ;NOW MUL_VARIABLES HAVE THE ANSWERS, MOVE THEM IN TOTAL
        MOV BX,MUL_HIGH_BIT
        MOV INPUT_T_HIGH_BIT,BX
        MOV BX,MUL_LOW_BIT
        MOV INPUT_T_LOW_BIT,BX
        
        ;NOW ADD INPUT_T WITH THE DIGIT
        MOV DX,0 
        MOV AH,0
        MOV CX,AX
        
        MOV BX,INPUT_T_HIGH_BIT
        MOV AX,INPUT_T_LOW_BIT

        CALL ADDITION
        
        ;NOW ANS VARS ARE THE NEW TOTAL
        MOV BX,ANS_HIGH_BIT
        MOV INPUT_T_HIGH_BIT,BX
        MOV BX,ANS_LOW_BIT
        MOV INPUT_T_LOW_BIT,BX
        
        CMP FLAG2,1
        JNE WHILE_INPUT
        INC T_EXP
        
        JMP WHILE_INPUT
    
    RESTORE_INPUT:
        POP DX
        POP CX
        POP BX
        POP AX
RET
INPUT ENDP
;-------------------------------------------------------------------------

;-------------------------------------------------------------------------
;SET OUT_HIGH AND LOW, AND CALL
OUTPUT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;COUNT VARIABLE COUNTS DIGITS
    MOV COUNT,0
 
    REPEAT_OP:
        ;DX:AX,CX
        ;DX:AX=Q, BX=REM
        MOV DX,OUT_HIGH
        MOV AX,OUT_LOW
        MOV CX,10
        
        CALL DIVISON
        
        ;NOW THE VARIABLES HAS THE ANSWERS
        ;SO WE UPDATE THEM
        MOV BX,QUOTIENT_HIGH
        MOV OUT_HIGH,BX
        MOV BX,QUOTIENT_LOW
        MOV OUT_LOW,BX
        
        MOV DX,REMAINDER
        PUSH DX
        INC COUNT
        
        ;COMPARE QUOTIENT HIGH AND LOW
        CMP QUOTIENT_LOW,0
        JNE REPEAT_OP
        CMP QUOTIENT_HIGH,0
        JE  READY_OUPUT_MODE
        JMP REPEAT_OP
    
    
    READY_OUPUT_MODE:
        MOV CX,COUNT
        MOV AH,2    
    SHOW_OUTPUT:
        POP DX
        MOV BX,DX
         
        MOV DL,BL
        ADD DL,'0'
        INT 21H 
        LOOP SHOW_OUTPUT
    
    ;NEWINE
    MOV DL,0AH
    INT 21H
    MOV DL,0DH
    INT 21H
    
    RESTORE_OUTPUT:
    POP DX
    POP CX
    POP BX
    POP AX
RET
OUTPUT ENDP    
;-------------------------------------------------------------------------
    
MAIN PROC
              
    ;INITIALIZE DATA SEGMENT
    MOV AX,@DATA
    MOV DS,AX
    
    ;SHOW WELCOME MESSAGE
    LEA DX,WELCOME_MESSAGE
    MOV AH,9
    INT 21H 
    
    WHILE_MAIN:
        LEA DX,OPTIONS
        MOV AH,9
        INT 21H
        
        MOV AH,1
        INT 21H
        
        ;OPT HAS THE OPTION, a,s, or m
        MOV OPT,AL
        
        ;NEWLINE
        LEA DX,NEWLINE
        MOV AH,9
        INT 21H
        
        ;ENTER FIRST NUMBER
        LEA DX,PR1
        MOV AH,9
        INT 21H
        
        ;CALL INPUT
        ;INPUT NUMBER WILL BE IN INPUT_T
        ;IF NEGATIVE, FLAG=1
        CALL INPUT
        MOV BX,INPUT_T_HIGH_BIT
        MOV BP_INPUT_A_HIGH_BIT,BX
        MOV BX,INPUT_T_LOW_BIT
        MOV BP_INPUT_A_LOW_BIT,BX
        MOV BX,FLAG
        MOV A_MINUS,BX
        MOV BX,T_EXP 
        MOV A_EXP,BX
        
        ;NEWLINE
        LEA DX,NEWLINE
        MOV AH,9
        INT 21H
        
        ;ENTER FIRST NUMBER
        LEA DX,PR2
        MOV AH,9
        INT 21H
        
        ;CALL INPUT
        ;INPUT NUMBER WILL BE IN INPUT_T
        ;IF NEGATIVE, FLAG=1
        CALL INPUT
        MOV BX,INPUT_T_HIGH_BIT
        MOV BP_INPUT_B_HIGH_BIT,BX
        MOV BX,INPUT_T_LOW_BIT
        MOV BP_INPUT_B_LOW_BIT,BX
        MOV BX,FLAG
        MOV B_MINUS,BX
        MOV BX,T_EXP 
        MOV B_EXP,BX
        
        ;NEWLINE
        LEA DX,NEWLINE
        MOV AH,9
        INT 21H
        
        ;NEGATE IF NECESSARY
        
        
        ;FINAL CALCULATIONS
        ;FIRST FIX THE EXP, TAKE THE DIFFERENCE OF EXP
        ;THEN MULTIPLY POW(10,DIFF) WITH THE ONE WITH LESS EXP
        MOV AX,A_EXP
        
        CMP AX,B_EXP
        JG EXP_A_g_B
        CMP AX,B_EXP
        JL EXP_B_g_A
        
        EXP_EQU:
        JMP FINAL_CALC  
        
        EXP_A_g_B:
        JMP FINAL_CALC
        
        EXP_B_g_A:    
        JMP FINAL_CALC
        
        FINAL_CALC:
        
        MOV AL,OPT
        CMP AL,'a'
        JE ADD_NUM
        CMP AL,'s'
        JE SUB_NUM
        JMP MUL_NUM
        
        ADD_NUM:
        ;SAVE IN 4 REGISTERS AND GET THE ANSWERS IN ANS
        BP_INPUT_A_HIGH_BIT DW 0
        BP_INPUT_A_LOW_BIT DW 0
        BP_INPUT_B_HIGH_BIT DW 0
        BP_INPUT_B_LOW_BIT DW 0 
        JMP WHILE_MAIN
        
        SUB_NUM:
        JMP WHILE_MAIN
        MUL_NUM:
        JMP WHILE_MAIN   
    EXIT:
        MOV AH,4CH
        INT 21H
    
MAIN ENDP

END MAIN 
