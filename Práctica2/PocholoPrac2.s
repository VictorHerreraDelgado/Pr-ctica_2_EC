.global _start
_start:
                movia sp, 0x007FFFFC /* inicializar pila */
				movia r2, 0x10000050 /* inic máscara de interrup botones */
				movi r3, 0b1110
				stwio r3, 8(r2)
				movi r2, 0b010 /* habilitar interrupciones de los botones*/
				wrctl ienable, r2
				movi r2, 1 /* habilitar interrupciones del procesador */
				wrctl status, r2
				movia r2, 0x10000020 /* dir base displays */
				addi r6, r0, 0x3F /* valor inicial 0 del display */
				stwio r6, 0(r2) /* mostrar en el display */

				IDLE: br IDLE /* el prog no hace nada más */

.end



