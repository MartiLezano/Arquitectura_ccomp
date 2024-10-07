.data
array: .word 5, 2, 8, 12, 1, 6    # Array de ejemplo
size: .word 6                     # Tamaño del array
newline: .asciiz "\n"
space: .asciiz " "
before_msg: .asciiz "Array antes de ordenar: "
after_msg: .asciiz "Array despues de ordenar: "
step_msg: .asciiz "Estado del array despues de la iteracion "

.text
.globl main

main:
    la $a0, array    # Carga la dirección del array
    lw $a1, size     # Carga el tamaño del array

    # Imprime el array antes de ordenar
    la $a0, before_msg
    li $v0, 4
    syscall
    la $a0, array
    lw $a1, size
    jal print_array

    la $a0, array    # Recarga la dirección del array
    lw $a1, size     # Recarga el tamaño del array
    jal sort         # Llama a la función de ordenación
    
    # Imprime el array después de ordenar
    la $a0, after_msg
    li $v0, 4
    syscall
    la $a0, array
    lw $a1, size
    jal print_array

    li $v0, 10       # Código de salida del programa
    syscall

sort:
    addi $sp, $sp, -16   # Reserva espacio en la pila
    sw $ra, 0($sp)       # Guarda la dirección de retorno
    sw $s0, 4($sp)       # Guarda $s0
    sw $s1, 8($sp)       # Guarda $s1
    sw $s2, 12($sp)      # Guarda $s2 (para el contador de iteraciones)
    
    move $s0, $a0        # $s0 = dirección del array
    move $s1, $a1        # $s1 = tamaño del array
    li $s2, 0            # $s2 = contador de iteraciones

sort_loop:
    beq $s1, 1, sort_done # Si el tamaño es 1, hemos terminado
    
    move $a0, $s0        # Prepara argumentos para max
    move $a1, $s1
    jal max              # Llama a max
    
    sll $t0, $s1, 2      # $t0 = 4 * size
    addi $t0, $t0, -4    # $t0 = 4 * (size - 1)
    add $t0, $s0, $t0    # $t0 = dirección del último elemento
    
    lw $t1, ($t0)        # $t1 = último elemento
    sw $t1, ($v0)        # Intercambia el máximo con el último
    lw $t1, ($v1)
    sw $t1, ($t0)
    
    addi $s1, $s1, -1    # Decrementa el tamaño
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
    move $a0, $s0
    lw $a1, size
    jal print_array

    j sort_loop          # Siguiente iteración

sort_done:
    lw $ra, 0($sp)       # Restaura la dirección de retorno
    lw $s0, 4($sp)       # Restaura $s0
    lw $s1, 8($sp)       # Restaura $s1
    lw $s2, 12($sp)      # Restaura $s2
    addi $sp, $sp, 16    # Libera espacio en la pila
    jr $ra               # Retorna

max:
    move $v0, $a0        # Inicializa $v0 con la dirección del primer elemento
    move $v1, $a0        # Inicializa $v1 con la dirección del primer elemento
    lw $t0, ($v0)        # $t0 = valor máximo actual
    move $t1, $a1        # $t1 = contador

max_loop:
    addi $a0, $a0, 4     # Avanza al siguiente elemento
    addi $t1, $t1, -1    # Decrementa el contador
    beqz $t1, max_done   # Si el contador es 0, hemos terminado
    
    lw $t2, ($a0)        # Carga el siguiente elemento
    ble $t2, $t0, max_loop # Si es menor o igual, continúa el bucle
    
    move $v0, $a0        # Actualiza la dirección del máximo
    move $t0, $t2        # Actualiza el valor máximo
    j max_loop

max_done:
    jr $ra               # Retorna

print_array:
    move $t0, $a0        # $t0 = dirección del array
    move $t1, $a1        # $t1 = tamaño del array

print_loop:
    lw $a0, ($t0)        # Carga el elemento actual
    li $v0, 1            # Código para imprimir entero
    syscall

    la $a0, space        # Imprime un espacio
    li $v0, 4
    syscall

    addi $t0, $t0, 4     # Avanza al siguiente elemento
    addi $t1, $t1, -1    # Decrementa el contador
    bnez $t1, print_loop # Si no hemos terminado, continúa el bucle

    la $a0, newline      # Imprime una nueva línea al final
    li $v0, 4
    syscall

    jr $ra               # Retorna