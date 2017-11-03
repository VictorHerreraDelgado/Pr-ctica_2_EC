/* Ejercicio 7 */



/*.section .reset, "ax"*/
.org 0x00
                      movia r2, _start
                      jmp r2


.org 0x20
/*.section.exceptions, "ax"*/

EXCEPTION_HANDLER:
                      subi sp, sp, 4 /* guardamos et en pila */
                      stw et, 0(sp)
                      rdctl et, ctl4 /*leemos el registro de control e interrupciones*/

                      beq et, r0, NO_EXT
                      subi ea, ea, 4
                      subi sp, sp, 12       /* guardamos los registros si es externa */

                      stw ea, 0(sp)
                      stw ra, 4(sp)
                      stw r2, 8(sp)

                      andi r2, et, 0b1  
                      beq r2, r0, EX_BOTON 
                      call TIMER

EX_BOTON:             andi r2, et, 0b10 /* si la interrupcion no es en los botones */
                      beq r2, r0, FIN /* deshacemos y retornamos al programa principal*/
                      call BOTON

FIN:                  ldw ea, 0(sp) /* deshacemos lo hecho anteriormente */
                      ldw ra, 4(sp)
                      ldw r2, 8(sp)
                      addi sp, sp, 12

NO_EXT:               ldw et,0(sp)
                      addi sp,sp,4
                      eret


                      
TIMER:                
                      subi sp, sp, 24 /* guardamos los registros a usar en la pila */
                      stw r2,0(sp)
                      stw r3,0(sp)
                      stw r4,0(sp)
                      stw r5,0(sp)
                      stw r6,0(sp)
                      stw r7,0(sp)

                      movia r2,0x10002000
                      
                      stw r0, 0(r2)

                      movia r3,0x10000000
                      ldw r4, SENTIDO(r0)
                      ldw r5,0(r3)
                      addi r6,r0,0x20000
                      addi r7,r0,1

                      beq r0,r4,DCHA
                      bne r6,r5,DESP1
                      add r5,r0,r7
                      br SEGUIR
DESP1:                slli r5,r5,1
                      br SEGUIR
DCHA:                 bne r7,r5,DESP2
                      add r5,r0,r6
                      br SEGUIR
DESP2:                srli r5,r5,1  

                      

                      

SEGUIR:               stw r5, 0(r3)
                      ldw r2,0(sp)
                      
                      ldw r3,0(sp)
                      ldw r4,0(sp)
                      ldw r5,0(sp)
                      ldw r6,0(sp)
                      ldw r7,0(sp)
                      addi sp,sp,24
                      ret



BOTON:
                      subi sp, sp, 24 /* guardar regs en la pila */
                      stw ra, 0(sp)
                      stw r3, 4(sp)
                      stw r4, 8(sp)
                      stw r5, 12(sp)
                      stw r6, 16(sp)
                      stw r2, 20(sp)

                      movia r2, 0x10000000 /* dir base leds */
                      movia r3, 0x10000050 /* dir base botones */
                      ldw r6, SENTIDO(r0)
                      
                      




                      ldwio r4, 0xC(r3) /* leemos el estado de los botones */

                      stwio r0, 0xC(r3) /* reiniciamos la interupción */

                      /*si el boton KEY1 se pulsa */
                      addi r5, r0, 2
                      beq r4, r5, BOTON_1

                      /*si el boton "KEY" se pulsa*/
                      addi r5, r0, 4
                      beq r4, r5, BOTON_2

                      br FINAL  /*si no es niguno de los dos no se hace nada*/

BOTON_1:              addi r5, r0, 1
                      stw r5, SENTIDO(r0)
                      br FINAL

BOTON_2:              stw r0, SENTIDO(r6)

FINAL:                ldw ra, 0(sp) /* recuperar registros de la pila */
                      ldw r3, 4(sp)
                      ldw r4, 8(sp)
                      ldw r5, 12(sp)
                      ldw r6, 16(sp)
                      ldw r2, 20(sp)


                      addi sp, sp, 24
                      ret


                      .org 0x400
.global _start
_start:
                      movia sp, 0x007FFFFC /*inicializamos la pila*/

                      movia r2, 0x10000050 /*inicializamos la máscara de interrupciones*/
                      movi r3, 0b1110
                      stwio r3, 8(r2)

                      movia r2,0x10002000
                      movia r3,50000000

                      stw r3,8(r2)
                      srli r3,r3,16
                      stw r3,0xC(r2)
                      addi r3,r0,0b0111
                      stw r3,4(r2)

                      movi r2, 0b011  /* habilitamos las instrucciones en los botones y el timer*/
                      wrctl ienable, r2

                      movi r2, 1 /*habilitamos las interrupciones en el procesador*/
                      wrctl status, r2

                      movia r2, 0x10000000
                      addi r3,r0,1
                      stw r3,0(r2)
                      


IDLE:                 br IDLE


.data
SENTIDO:
                      .word 0

.end
