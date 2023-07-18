
.data
	#Os valores encontrados no .data NÃO devem ser alterados;
	#Foi utilizada uma estrutura de repetição para considerar todos
	#os casos possíveis de b1 e b2, que são:
	#b1 = 0, b2 = 0;
	#b1 = 1 e b2 = 0 (o inverso é a mesma coisa, por isso nao foi testado)
	#b1 = 1 e b2 = 1
	#O valor de vaiUm não é alterado pois na soma de BITS não se espera
	# vaium = 1
	#Durante o programa é utilizada a pilha (stackpointer)
	#para atualizar os valores de vaium e soma (os retorna a zero)
	#O resultado da soma dos bits é impresso durante o programa
	#Assim como o valor de vaiUm e o valor dos Bits da soma
	#A saída esperada é composta por:
	
	#O valor binário a ser somado é: b1 + b2
	#O resultado da soma é: valorDaSoma
	#O resultado vai um é: valorDoVaiUm
	
	b1: .byte 0 #byte 1
	b2: .byte 0 #byte 2 
	vaiUm: .byte 0 #vai um da soma
	soma: .byte 0 #resultado da soma
	resSoma: .asciiz "\nO resultado da soma é: "
	resVaiUm: .asciiz "\nO resultado vai um é: "
	valorSer: .asciiz "\nO valor binário a ser somado é: "
	espacoSoma: .asciiz " + "
.text 
.globl main
	main:
	#TODO: fazer um for que altera o valor das variaveis
	
	lb, $a0, b1 #carrega b1
	lb, $a1, b2 #carrega b2
	move $s3, $a0 #salva b1 para ser comparado e alterado dentro do loop
	move $s4, $a1 # alva b2 para ser comparado e alterado dentro do loop
	#ambos em $a pois serão passados como argumentos
	loop:
	#começo da rotina de impressao do loop
	la $a0, valorSer
	li $v0, 4
	syscall
	
	move $a0, $s3
	li $v0, 1
	syscall
	
	la $a0, espacoSoma 
	li $v0, 4
	syscall
	
	move $a0, $s4
	li $v0, 1 
	syscall
	#fim da rotina de impressao do loop
	lb $t2, soma #pega a soma do .data
	lb $t3, vaiUm #pega o vaium do .data
	addiu $sp, $sp, -8 #aloca duas palavras no stack
	sw $t2, 4($sp) #salva a soma
	sw $t3, 0($sp) #salva o vai um
	
	move $a0, $s3 #carrega os valores, atualizados pelo loop, de b1 e b2
	move $a1, $s4 #
	
	jal somabit #mesma coisa que passar em C
	#somabit(b1, b2, &soma, &vaium)
	#como esta sendo pedido no enunciado
	#lembrando que, como é uma função void, os registradores de resultado($v0) não são utilizados
	
	lw $t0, 4($sp) #soma
	lw $t1, 0($sp) #vaium
	#pega os valores salvos no stack
	#a seguinte rotina imprime os valores da Soma e do VaiUm
	la, $a0, resSoma
	li, $v0, 4
	syscall
	
	move $a0, $t0	
	li $v0, 1
	syscall 
	
	la $a0, resVaiUm
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	beq $s3, $zero, b1zero #altera  b1 para o valor 1
	beq $s4, $zero, b2zero #altera b2 para o valor 1
	beq $s3, $s4, continue #ao chegar nesse ponto do codigo, b1 e b2 serão iguais e serão
	#necessariamente 1. Portanto, todas as possibilidades de soma de bit foram atendida
	j loop
	continue:
	
	addiu $sp, $sp, +8 #encerra/desaloca o espaço no stackpointer
	
	end:
	li $v0, 10 #rotina que encerra o programa
	syscall
	
	b1zero:
	li $s3, 1 #altera o valor de b1 e reinicia o loop
	j loop
	
	b2zero:
	li $s4, 1 #altera o valor de b2 e reinicia o loop
	j loop 
	somabit:
	
	# $s0 SOMA
	# $s1 VAIUM
	move $t1, $a0 #salva os argumentos nos registradores temporarios
	move $t2, $a1
		
	lw $s0, 4($sp) #soma
	lw $s1, 0($sp) #vaium
	# ^ pega os valors de soma e vaium do stackpointer,
	
	xor $t0, $t1, $t2 #(b1 ^b2) = t0
	xor $t0, $t0, $s0 #t0 ^ vaium
	move $s0, $t0 #salva o valor em s0
	
	and $t0, $t1, $t2 #(b1 & b2) = $t0
	xor $t3, $t1, $t2 #(b1 ^ b2) = $t3
	and $t3, $t3, $s1 #($t3 & vaium) = $t3 
	or $s1, $t0, $t3 #($t0 | $t3)

	#salva os valores atualizados de soma e vaium no stack
	sw $s0 4($sp) #salva a soma
	sw $s1, 0($sp) #salva o vai um

	
	jr $ra
	 