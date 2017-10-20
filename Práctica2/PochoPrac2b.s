
.section .exceptions, "ax"
.global EXCEPTION_HANDLER
EXCEPTION_HANDLER:

				subi sp, sp, 4 /* guardar et en la pila */
				stw et, 0(sp)
				rdctl et, ctl4 /* cargar interrup pendientes */
				beq et, r0, NO_EXT /* no int externa=> finalizar*/
				subi ea, ea, 4 /*int externa => decrementar ea */
				subi sp, sp, 12 /* guardar registros en la pila */
				stw ea, 0(sp)
				stw ra, 4(sp)
				stw r2, 8(sp)
				andi r2, et, 0b10 /* existe interrup de botones? */
				beq r2, r0, FIN /* no? => deshacer y retornar */
				call BOTON /* sí? => tratarla */

FIN: 			ldw ea, 0(sp) /* recuperar TODOS regs de la pila */
				ldw ra, 4(sp)
				ldw r2, 8(sp)
				addi sp, sp, 12

NO_EXT: 		ldw et,0(sp)
				addi sp,sp,4
				eret				
.end