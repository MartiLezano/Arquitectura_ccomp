.data
array: .word 5, 2, 8, 12, 1, 6    # Array de ejemplo
size: .word 6                     # Tama�o del array
newline: .asciiz "\n"
space: .asciiz " "
before_msg: .asciiz "Array antes de ordenar: "
after_msg: .asciiz "Array despues de ordenar (de maximo a minimo): "
step_msg: .asciiz "Estado del array despues de la iteracion "

.text
.globl main

main:
    la $a0, array    # Carga la direcci�n del array
    lw $a1, size     # Carga el tama�o del array

    # Imprime el array antes de ordenar
    la $a0, before_msg
    li $v0, 4
    syscall
    la $a0, array
    lw $a1, size
    jal print_array

    la $a0, array    # Recarga la direcci�n del array
    lw $a1, size     # Recarga el tama�o del array
    jal sort_reverse # Llama a la funci�n de ordenaci�n reversa
    
    # Imprime el array despu�s de ordenar
    la $a0, after_msg
    li $v0, 4
    syscall
    la $a0, array
    lw $a1, size
    jal print_array

    li $v0, 10       # C�digo de salida del programa
    syscall

sort_reverse:
    addi $sp, $sp, -16   # Reserva espacio en la pila
    sw $ra, 0($sp)       # Guarda la direcci�n de retorno
    sw $s0, 4($sp)       # Guarda $s0
    sw $s1, 8($sp)       # Guarda $s1
    sw $s2, 12($sp)      # Guarda $s2 (para el contador de iteraciones)
    
    move $s0, $a0        # $s0 = direcci�n del array
    move $s1, $a1        # $s1 = tama�o del array
    li $s2, 0            # $s2 = contador de iteraciones

sort_loop:
    beq $s1, 1, sort_done # Si el tama�o es 1, hemos terminado
    
    move $a0, $s0        # Prepara argumentos para min
    move $a1, $s1
    jal min              # Llama a min
    
    # Intercambia el m�nimo con el primer elemento de la parte no ordenada
    lw $t1, ($s0)        # $t1 = primer elemento de la parte no ordenada
    lw $t2, ($v0)        # $t2 = elemento m�nimo
    sw $t2, ($s0)        # Coloca el m�nimo al principio
    sw $t1, ($v0)        # Coloca el primer elemento donde estaba el m�nimo
    
    addi $s0, $s0, 4     # Avanza al siguiente elemento
    addi $s1, $s1, -1    # Decrementa el tama�o
    addi $s2, $s2, 1     # Incrementa el contador de iteraciones

    # Imprime el estado actual del array
    la $a0, step_msg
    li $v0, 4
    syscall
    move $a0, $s2
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    la $a0, array
    lw $a1, size
    jal print_array

    j sort_loop          # Siguiente iteraci�n

sort_done:
    lw $ra, 0($sp)       # Restaura la direcci�n de retorno
    lw $s0, 4($sp)       # Restaura $s0
    lw $s1, 8($sp)       # Restaura $s1
    lw $s2, 12($sp)      # Restaura $s2
    addi $sp, $sp, 16    # Libera espacio en la pila
    jr $ra               # Retorna

min:
    move $v0, $a0        # Inicializa $v0 con la direcci�n del primer elemento
    lw $t0, ($v0)        # $t0 = valor m�nimo actual
    move $t1, $a1        # $t1 = contador

min_loop:
    addi $a0, $a0, 4     # Avanza al siguiente elemento
    addi $t1, $t1, -1    # Decrementa el contador
    beqz $t1, min_done   # Si el contador es 0, hemos terminado
    
    lw $t2, ($a0)        # Carga el siguiente elemento
    bge $t2, $t0, min_loop # Si es mayor o igual, contin�a el bucle
    
    move $v0, $a0        # Actualiza la direcci�n del m�nimo
    move $t0, $t2        # Actualiza el valor m�nimo
    j min_loop

min_done:
    jr $ra               # Retorna

print_array:
    move $t0, $a0        # $t0 = direcci�n del array
    move $t1, $a1        # $t1 = tama�o del array

print_loop:
    lw $a0, ($t0)        # Carga el elemento actual
    li $v0, 1            # C�digo para imprimir entero
    syscall

    la $a0, space        # Imprime un espacio
    li $v0, 4
    syscall

    addi $t0, $t0, 4     # Avanza al siguiente elemento
    addi $t1, $t1, -1    # Decrementa el contador
    bnez $t1, print_loop # Si no hemos terminado, contin�a el bucle

    la $a0, newline      # Imprime una nueva l�nea al final
    li $v0, 4
    syscall

    jr $ra               # Retorna