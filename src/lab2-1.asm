.dseg 
.org 0x200
mass: .BYTE 8
BIG: .BYTE 16

.cseg 
.def numA = r16
.def powX = r17
.def modP = r18
.def zero = r30


LDI numA, 5
LDI powX, 197
LDI modP, 203
LDI zero, 0x0
;LDI r21, 0x99 ;lower
;LDI r22, 0x12 ;higher
;LDI r23, 0x8b ;mod
;mov r16, powX
;andi r16, 1


;LDI R29, 0x29
;STS mass, R29
;STS mass, R29
;LDS R28, mass+1



.MACRO PUTNMASS
	ldi r26,low(@2)
	ldi r27,high(@2)
	mov r22, @0
	add r26, r22           
	ldi r22, 0
	adc r27, r22  
	
	st X, @1 
	ld r22, X
	;sts 0x108, r22
.ENDM


.MACRO GETNMASS
	ldi r26,low(mass)
	ldi r27,high(mass)
	ldi r22, @0
	add r26, r22           
	ldi r22, 0
	adc r27, r22  
	
	;st X, @1 
	ld r22, X
	
.ENDM

.MACRO MOD		; Start macro definition 0:1

	mod:
		cp @1, @3
		cpc @0, @2
		BRLO done

		add @3, @4
		adc @2, zero

		jmp mod

	done:
		sub @3, @4
		sbc @2, zero
 
		sub @1, @3
		sbc @0, @2

.ENDM                ; End macro definition


mov r23, numA
LDI r31, 0
PUTNMASS r31, numA, mass
INC r31
loop:
	MUL r23,r23
	mov r22, r1
	mov r21, r0
	mov r20, zero
	mov r19, zero
	MOD	r22, r21, r20, r19, modP
	mov r23, r21
	PUTNMASS r31, r23, mass

	;STS mass, r31
	;LDS R28, mass
	;NMASS r31
	
	INC r31
	CPI r31, 8
	BRNE loop


lds r16, mass+0
lds r17, mass+2
MUL r16, r17
MOVW r17:r16, r1:r0

lds r18, mass+6
lds r19, mass+7
MUL r18, r19
MOVW r19:r18, r1:r0


.DEF ANS1 = R20              ;To hold 32 bit answer
.DEF ANS2 = R21
.DEF ANS3 = R22
.DEF ANS4 = R23

MUL16x16:
        CLR zero             ;Set R2 to zero
        MUL R17,R19            ;Multiply high bytes AHxBH
        MOVW ANS4:ANS3,R1:R0 ;Move two-byte result into answer

        MUL R16,R18            ;Multiply low bytes ALxBL
        MOVW ANS2:ANS1,R1:R0 ;Move two-byte result into answer

        MUL R17,R18            ;Multiply AHxBL
        ADD ANS2,R0          ;Add result to answer
        ADC ANS3,R1          ;
        ADC ANS4,zero        ;Add the Carry Bit

        MUL R19,R16            ;Multiply BHxAL
        ADD ANS2,R0          ;Add result to answer
        ADC ANS3,R1          ;
        ADC ANS4,zero        ;Add the Carry Bit


sts 0x100, r23
sts 0x101, r22
sts 0x102, r21
sts 0x103, r20


.MACRO BIGMOD		; Start macro definition 0:1

	mod:
		cp @3, @7
		cpc @2, @6
		cpc @1, @5
		cpc @0, @4
		BRLO done

		add @7, @8
		adc @6, zero
		adc @5, zero
		adc @4, zero

		jmp mod

	done:
		sub @7, @8
		sbc @6, zero
		sbc @5, zero
		sbc @4, zero
 
		sub @3, @7
		sbc @2, @6
		sbc @1, @5
		sbc @0, @4

.ENDM 
mov r24, zero
mov r25, zero
mov r26, zero
mov r27, zero
LDI modP, 203


	


BIGMOD r23, r22, r21, r20, r24, r25, r26, r27, modP
nop

.MACRO CLEAR
	cli
	clt
	cls
	clv
	clh
	cln
	clz
	clc
.ENDM

;MOD	r22, r21, r20, r19, r23




nop
