.global BOTON
BOTON: 			subi sp, sp, 24 /* guardar regs en la pila */
                stw ra, 0(sp)
				stw r3, 4(sp)
				stw r4, 8(sp)
				stw r5, 12(sp)
				stw r6, 16(sp)
				stw r2, 20(sp)
				movia r2, 0x10000020 /* dir base displays */
				movia r3, 0x10000050 /* dir base botones */
				ldwio r4, 0xC(r3) /*leer estado botones. OJO: 0xC */
				stwio r0, 0xC(r3) /* reiniciar la interrupción */

				addi r5, r0, 2 /* hay botón pulsado ?*/
				beq r4, r5, BOTON_1

				slli r5, r5, 1
				beq r4, r5, BOTON_2

				slli r5, r5, 1
				beq r4, r5, BOTON_3

				br MOSTRAR /* Si todo va bien por aquí no pasa nunca*/				

BOTON_1: 		addi r6, r0, 0x6 /* r6=valor a mostrar */
				br MOSTRAR

BOTON_2: 		addi r6, r0, 0x5B
				br MOSTRAR

BOTON_3: 		addi r6, r0, 0x4F

MOSTRAR: 		stwio r6, 0(r2)  /* mostrar en el display */
				ldw ra, 0(sp)    /* recuperar regs de la pila */
				ldw r3, 4(sp)
				ldw r4, 8(sp)
				ldw r5, 12(sp)
				ldw r6, 16(sp)
				ldw r2, 20(sp)
				addi sp, sp, 24
				ret
.end				